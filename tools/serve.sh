#!/usr/bin/env sh
# Nativum example server — Pythonの標準http.serverを使用する
# 使用法: tools/serve.sh [port]  →  http://localhost:8080/examples/
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
PORT="${1:-8080}"

if ! command -v python3 > /dev/null 2>&1; then
  echo "ERROR: python3 が見つかりません (nix develop で入ります)" >&2
  exit 1
fi

STAGE=$(mktemp -d "${TMPDIR:-/tmp}/nativum-serve.XXXXXX")
trap 'rm -rf "$STAGE"' EXIT

ln -s "$ROOT/examples" "$STAGE/examples"
ln -s "$ROOT/dist" "$STAGE/dist"

echo "Nativum examples → http://localhost:$PORT/examples/"
cd "$STAGE"
python3 -m http.server --bind 127.0.0.1 "$PORT"
