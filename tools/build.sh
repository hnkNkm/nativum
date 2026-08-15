#!/usr/bin/env sh
# Nativum build — POSIX shell + 標準Unix toolのみ。Node等は不要。
set -eu

cd "$(dirname "$0")/.."

VERSION="$(tr -d '[:space:]' < .release/version)"
# 出力先は NATIVUM_DIST で上書き可能 (verify.sh が一時ディレクトリへビルドして比較するため)
DIST="${NATIVUM_DIST:-dist}"
FILES="src/00-layer.css src/10-reset.css src/20-tokens.css src/30-base.css src/40-layout.css src/50-forms.css src/60-components.css src/70-motion.css"

mkdir -p "$DIST"

{
  echo "/*"
  echo " * Nativum Native Web UI System — v$VERSION"
  echo " *"
  echo " * Passive, zero-JavaScript. HTML + CSS only."
  echo " * No third-party runtime dependencies."
  echo " * Built directly on the modern Web Platform."
  echo " * Modern UI, by the Web Platform."
  echo " *"
  echo " * License: MIT — see LICENSE"
  echo " */"
  for f in $FILES; do
    echo ""
    cat "$f"
  done
} > "$DIST/nativum.css"

# SHA256SUMS 生成 (Linux=coreutils / macOS=shasum で分岐)
if command -v sha256sum > /dev/null 2>&1; then
  SHA="sha256sum"
else
  SHA="shasum -a 256"
fi
(cd "$DIST" && $SHA nativum.css > SHA256SUMS)

echo "built: $DIST/nativum.css ($(wc -c < "$DIST/nativum.css" | tr -d ' ') bytes)"
