#!/usr/bin/env sh
# Nativum skill example check — Skillのexampleが src/ の実在APIのみ参照しているかを検査
#
# Agent Skill と CSS 実装の乖離 (stale reference) を CI で検出するための検査。
# 対象: skills/nativum-ui/examples/*.html の class="..." と var(--nv-...)。
# (md内の散文は対象外。anti-pattern 記述が「存在しないクラス」を
#   禁止例として言及することを許容するため)
#
# POSIX shell + 標準Unix toolのみ。
set -eu

cd "$(dirname "$0")/.."

fail() {
  echo "EXAMPLES FAIL: $1" >&2
  exit 1
}

SRC_DIR="src"
SKILL_EXAMPLES="skills/nativum-ui/examples"

# src/ の実在クラス・トークン一覧 (クラスは .nv- で始まるもののみ)
SRC_CLASSES="$(grep -hoE '\.nv-[a-z0-9-]+' "$SRC_DIR"/*.css | sed 's/^\.//' | sort -u)"
SRC_TOKENS="$(grep -hoE -- '--nv-[a-z0-9-]+' "$SRC_DIR"/*.css | sort -u)"

if [ -z "$(ls "$SKILL_EXAMPLES"/*.html 2>/dev/null)" ]; then
  fail "skill example HTML が見つかりません: $SKILL_EXAMPLES"
fi

for f in "$SKILL_EXAMPLES"/*.html; do
  # class 属性から nv- クラスを抽出
  for cls in $(grep -hoE 'class="[^"]+"' "$f" | grep -oE 'nv-[a-z0-9-]+' | sort -u); do
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

echo "EXAMPLES OK — skill examples のクラス・トークンは src/ と整合しています"
