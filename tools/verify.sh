#!/usr/bin/env sh
# Nativum verify — executable supply-chain attack surface の検査
#
# 検査目的は package manager の存在検出ではなく、
# Nativum Core に第三者の実行可能な依存グラフが存在しないことの検証。
#
# 注意: このスクリプトは dist/ を再ビルドしない。
# コミット済み dist/ と src/ の整合は「一時ディレクトリへビルドして比較」で検査する
# (CI では ./tools/build.sh && git diff --exit-code -- dist/ && ./tools/verify.sh)。
#
# POSIX shell + 標準Unix toolのみ。
set -eu

cd "$(dirname "$0")/.."

fail() {
  echo "VERIFY FAIL: $1" >&2
  exit 1
}

# 1. Nativum Core は HTML+CSS only — JS/TS runtime file が存在しない
#    (.opencode/ は agent ツールの実行環境であり Core の成果物ではないため除外)
if find . -path ./.git -prune -o -path ./.opencode -prune -o \( -name '*.js' -o -name '*.jsx' -o -name '*.ts' -o -name '*.tsx' \) -print | grep -q .; then
  fail "JavaScript/TypeScript runtime file found (CoreはHTML+CSS only)"
fi

# 2. install artifacts / 依存グラフの痕跡が存在しない
if find . -path ./.git -prune -o -path ./.opencode -prune -o -type d -name node_modules -print | grep -q .; then
  fail "node_modules directory found (installが実行されている)"
fi

for f in package-lock.json pnpm-lock.yaml yarn.lock npm-shrinkwrap.json; do
  if find . -path ./.git -prune -o -path ./.opencode -prune -o -name "$f" -print | grep -q .; then
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
if grep -rnE '(@import|url\()["'"'"']?https?://' src/ | grep -v 'data:image/svg+xml' | grep -q .; then
  fail "remote URL found in CSS (implicit remote resource loading)"
fi

if grep -rnE 'font-family:[^;]*(url\()|@font-face[^{]*\{[^}]*url\(' src/ > /dev/null 2>&1; then
  fail "remote font found"
fi

# 7. remote リソースが存在しない (HTML側 — 全公式exampleを走査)
#    <script src="http..."> <link rel=stylesheet href="http..."> <img src="http...">
#    <iframe src> <video poster> <source srcset> など
#    正規表現は POSIX ERE のみを使用する (\b や \s は使わない)
HTML_FILES="$(find examples skills -name '*.html' 2>/dev/null || true)"
if [ -z "$HTML_FILES" ]; then
  fail "official example HTML が見つかりません"
fi

# src / href / data / srcset / poster 属性の http(s):// 参照
if grep -rEn '(script|link|img|iframe|video|audio|source|embed|object|input)[^>]*[[:space:]](src|href|data|srcset|poster)[[:space:]]*=[[:space:]]*["'"'"']https?://' $HTML_FILES > /dev/null 2>&1; then
  fail "remote resource attribute found in official examples"
fi

# inline style 内の url(https://...) 参照
if grep -rEn 'style=["'"'"'][^"'"'"']*url\([[:space:]]*["'"'"']?https?://' $HTML_FILES > /dev/null 2>&1; then
  fail "remote url() found in inline style of official examples"
fi

if grep -rn '<script' $HTML_FILES > /dev/null 2>&1; then
  fail "<script> found in official examples"
fi

# 8. ネイティブ要素の div 再実装が存在しない
if grep -rnE '<(div|span)[^>]*role="button"' $HTML_FILES > /dev/null 2>&1; then
  fail 'role="button" reimplementation found in official examples'
fi

echo "VERIFY OK — executable supply-chain attack surface は検出されませんでした"
