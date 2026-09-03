#!/usr/bin/env sh
# Nativum verify — executable supply-chain attack surface の検査
#
# 検査目的は package manager の存在検出ではなく、
# Nativum Core に第三者の実行可能な依存グラフが存在しないことの検証。
#
# 注意: このスクリプトは dist/ を再ビルドしない (書き込まない)。
# コミット済み dist/ と src/ の整合は「一時ディレクトリへビルドして cmp」で検査する
# (CI では ./tools/build.sh && git diff --exit-code -- dist/ && ./tools/verify.sh)。
#
# JS 探索は .git / .direnv / .opencode を prune する (.opencode は agent 実行環境)。
# HTML 検査は examples/ と skills/ の *.html のみ。docs/ の markdown は対象外。
#
# POSIX shell + 標準Unix toolのみ。正規表現は POSIX ERE (\b や \s は使わない)。
set -eu

cd "$(dirname "$0")/.."

fail() {
  echo "VERIFY FAIL: $1" >&2
  exit 1
}

# 1. Nativum Core は HTML+CSS only — JS/TS runtime file が存在しない
#    (.git / .direnv / .opencode は Core の成果物ではないため除外)
#    -iname で拡張子の大小文字を無視し、mjs/cjs/mts/cts も含める
if find . \( -path ./.git -o -path ./.direnv -o -path ./.opencode \) -prune -o \
    -type f \( \
      -iname '*.js' -o -iname '*.jsx' -o -iname '*.ts' -o -iname '*.tsx' \
      -o -iname '*.mjs' -o -iname '*.cjs' -o -iname '*.mts' -o -iname '*.cts' \
    \) -print | grep -q .; then
  fail "JavaScript/TypeScript runtime file found (CoreはHTML+CSS only)"
fi

# 2. install artifacts / 依存グラフの痕跡が存在しない
if find . \( -path ./.git -o -path ./.direnv -o -path ./.opencode \) -prune -o \
    -type d -name node_modules -print | grep -q .; then
  fail "node_modules directory found (installが実行されている)"
fi

for f in package-lock.json pnpm-lock.yaml yarn.lock npm-shrinkwrap.json; do
  if find . \( -path ./.git -o -path ./.direnv -o -path ./.opencode \) -prune -o \
      -name "$f" -print | grep -q .; then
    fail "package manager install artifact found: $f (Nativum Coreは依存を持たない)"
  fi
done

# 3. Nativum Core は Node-based build を採用しない
for f in vite.config.* webpack.config.* postcss.config.*; do
  if [ -f "$f" ]; then
    fail "Node build config found: $f"
  fi
done

# 4. package.json が存在する場合、passive artifact metadata であること
#    (将来の npm 配布用。dependencies が空・install hook が無いことを検査する)
if [ -f package.json ]; then
  echo "  package.json を検査 (passive artifact metadata)..."

  for key in dependencies optionalDependencies peerDependencies; do
    if grep -Eq "\"$key\"" package.json; then
      if ! grep -Eq "\"$key\"[[:space:]]*:[[:space:]]*\{\}" package.json; then
        fail "package.json の $key が空ではありません (third-party runtime dependency)"
      fi
    fi
  done

  for hook in preinstall install postinstall prepare prepublish; do
    if grep -Eq "\"$hook\"" package.json; then
      fail "install lifecycle script ($hook) が package.json に存在します (executable install hook)"
    fi
  done

  # runtime JavaScript entry point の禁止 (main は nativum.css のみ許可)
  if grep -Eq '"(main|module|exports|bin)"[[:space:]]*:[[:space:]]*"[^"]*\.(js|mjs|cjs|ts|tsx)"' package.json; then
    fail "package.json に runtime JavaScript entry point が存在します"
  fi

  echo "  package.json: passive artifact metadata OK"
fi

# 5. コミット済み dist/ と src/ の整合性 (dist drift の検出)
#    dist/ を破壊せず、一時ディレクトリへビルドして比較する
TMPDIR_CHECK="$(mktemp -d)"
trap 'rm -r "$TMPDIR_CHECK"' EXIT HUP INT TERM

NATIVUM_DIST="$TMPDIR_CHECK" ./tools/build.sh > /dev/null

if ! cmp -s "$TMPDIR_CHECK/nativum.css" dist/nativum.css; then
  fail "dist/nativum.css が src/ と一致しません (tools/build.sh で再生成し、dist/ をコミットしてください)"
fi

if ! cmp -s "$TMPDIR_CHECK/SHA256SUMS" dist/SHA256SUMS; then
  fail "dist/SHA256SUMS が nativum.css と一致しません"
fi

# 6. remote リソースが存在しない (CSS側)
#    url() / @import の直後 (任意の空白・引用符のあと) が http(s):// または //
#    data: URI は :// が url( の直後に来ないためマッチしない。
#    行全体を data:image で除外しない (同一行の remote url を隠すため)。
if grep -rinE '(@import|url\()[[:space:]]*["'"'"']?https?://' src/; then
  fail "remote URL found in CSS (implicit remote resource loading)"
fi

if grep -rinE '(@import|url\()[[:space:]]*["'"'"']?//' src/; then
  fail "protocol-relative URL found in CSS (implicit remote resource loading)"
fi

if grep -rnE 'font-family:[^;]*(url\()|@font-face[^{]*\{[^}]*url\(' src/ > /dev/null 2>&1; then
  fail "remote font found"
fi

# 7. remote / 実行可能 markup が存在しない (HTML — examples/ と skills/ の全HTML)
#    docs/ は走査しない。相対・同一文書の form action ("#", "/login") は許可。
#    通常の <a href="https://..."> はランタイム資源とはみなさない。
#    正規表現は POSIX ERE のみを使用する (\b や \s は使わない)
HTML_FILES="$(find examples skills -type f -iname '*.html' 2>/dev/null || true)"
if [ -z "$HTML_FILES" ]; then
  fail "official example HTML が見つかりません"
fi

# ランタイム資源タグ: script/link/img/iframe/video/audio/source/embed/object/input/form/button/base/meta
# 属性: src/href/data/srcset/poster/action/formaction/content
RES_TAGS='script|link|img|iframe|video|audio|source|embed|object|input|form|button|base|meta'
RES_ATTRS='src|href|data|srcset|poster|action|formaction|content'

if grep -rEin "<($RES_TAGS)[^>]*[[:space:]]($RES_ATTRS)[[:space:]]*=[[:space:]]*[\"']https?://" $HTML_FILES > /dev/null 2>&1; then
  fail "remote resource attribute found in official examples"
fi

if grep -rEin "<($RES_TAGS)[^>]*[[:space:]]($RES_ATTRS)[[:space:]]*=[[:space:]]*[\"']//" $HTML_FILES > /dev/null 2>&1; then
  fail "protocol-relative resource attribute found in official examples"
fi

# meta refresh の content="0;url=https://..." (属性値が https で始まらない場合)
if grep -rEin '<meta[^>]*content[[:space:]]*=[[:space:]]*["'"'"'][^"'"'"']*https?://' $HTML_FILES > /dev/null 2>&1; then
  fail "remote URL found in meta content of official examples"
fi

# inline style 内の url(https://...) / url(//...)
if grep -rEin 'style=["'"'"'][^"'"'"']*url\([[:space:]]*["'"'"']?https?://' $HTML_FILES > /dev/null 2>&1; then
  fail "remote url() found in inline style of official examples"
fi

if grep -rEin 'style=["'"'"'][^"'"'"']*url\([[:space:]]*["'"'"']?//' $HTML_FILES > /dev/null 2>&1; then
  fail "protocol-relative url() found in inline style of official examples"
fi

if grep -rn '<script' $HTML_FILES > /dev/null 2>&1; then
  fail "<script> found in official examples"
fi

if grep -rn '<style' $HTML_FILES > /dev/null 2>&1; then
  fail "<style> found in official examples"
fi

if grep -rEin 'javascript:' $HTML_FILES > /dev/null 2>&1; then
  fail "javascript: URL found in official examples"
fi

if grep -rEn '[[:space:]]on[a-z]+=["'"'"']' $HTML_FILES > /dev/null 2>&1; then
  fail "inline event handler (on*=) found in official examples"
fi

# 8. ネイティブ要素の div 再実装が存在しない (単一・二重引用符)
if grep -rEn '<(div|span)[^>]*role[[:space:]]*=[[:space:]]*["'"'"']button["'"'"']' $HTML_FILES > /dev/null 2>&1; then
  fail 'role="button" reimplementation found in official examples'
fi

# 9. src/50-forms.css の text-field :where() リストは重複箇所で同一内容に保つ
#    (2箇所更新ルール。更新漏れはここで検出する。仕様は同ファイルのコメント参照)
if ! awk '/^[[:space:]]*:where\(/{n++;capture=1;buf="";next} /^[[:space:]]*\)/{if(capture){capture=0;if(n==1){first=buf}else if(buf!=first){exit 1}};next} capture{buf=buf $0 "\n"} END{if(n<2){exit 1}}' src/50-forms.css; then
  fail "src/50-forms.css の :where() リストが重複箇所で不一致です (全箇所を同一に更新してください)"
fi

echo "VERIFY OK — executable supply-chain attack surface は検出されませんでした"
