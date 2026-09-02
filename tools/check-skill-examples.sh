#!/usr/bin/env sh
# Nativum skill example check — Skillが src/ の実在APIのみ参照しているかを検査
#
# Agent Skill と CSS 実装の乖離 (stale reference) を CI で検出するための検査。
# 対象:
#   - skills/nativum-ui/examples/*.html         の class="..." / class='...' と var(--nv-...)
#   - skills/nativum-ui/references/**/*.md      のコード例の class="..." / class='...' と var(--nv-...)
#   - skills/nativum-ui/examples/popover.html   の存在 (file-set。日英バイト一致は要求しない)
# 非対象 (誤検出を避けるため):
#   - md 内の散文 (anti-pattern 記述が「存在しないクラス」を禁止例として
#     言及することを許容する。class 属性構文のみを検査するため、
#     散文の言及はマッチしない)
#   - コマンド・属性・説明の意味論 (実ブラウザでの動作確認と手動レビューで担保)
#   - 公式 examples/ と skill examples/ のバイト一致
#
# POSIX shell + 標準Unix toolのみ。
set -eu

cd "$(dirname "$0")/.."

fail() {
  echo "EXAMPLES FAIL: $1" >&2
  exit 1
}

SRC_DIR="src"
SKILL_DIR="skills/nativum-ui"

# src/ の実在クラス・トークン一覧 (クラスは .nv- で始まるもののみ)
SRC_CLASSES="$(grep -hoE '\.nv-[a-z0-9-]+' "$SRC_DIR"/*.css | sed 's/^\.//' | sort -u)"
SRC_TOKENS="$(grep -hoE -- '--nv-[a-z0-9-]+' "$SRC_DIR"/*.css | sort -u)"

if [ -z "$(ls "$SKILL_DIR"/examples/*.html 2>/dev/null)" ]; then
  fail "skill example HTML が見つかりません: $SKILL_DIR/examples"
fi

if [ ! -f "$SKILL_DIR/examples/popover.html" ]; then
  fail "skill examples に popover.html がありません"
fi

# 検査対象ファイル: examples/*.html と references/**/*.md
FILES="$(find "$SKILL_DIR/examples" "$SKILL_DIR/references" \( -name '*.html' -o -name '*.md' \) 2>/dev/null || true)"
if [ -z "$FILES" ]; then
  fail "検査対象ファイルが見つかりません"
fi

for f in $FILES; do
  # class="..." と class='...' の両方から nv- クラスを抽出 (散文の nv-* は対象外)
  for cls in $(
    { grep -hoE 'class="[^"]+"' "$f" || true
      grep -hoE "class='[^']+'" "$f" || true
    } | grep -oE 'nv-[a-z0-9-]+' | sort -u
  ); do
    if ! echo "$SRC_CLASSES" | grep -qx "$cls"; then
      fail "$f が存在しないクラスを参照しています: $cls"
    fi
  done

  # var() からトークンを抽出
  for tok in $(grep -hoE 'var\(--nv-[a-z0-9-]+\)' "$f" | grep -oE -- '--nv-[a-z0-9-]+' | sort -u); do
    if ! echo "$SRC_TOKENS" | grep -qx -- "$tok"; then
      fail "$f が存在しないトークンを参照しています: $tok"
    fi
  done
done

echo "EXAMPLES OK — skill の examples / references のクラス・トークンは src/ と整合しています"
