#!/usr/bin/env sh
# Nativum example server — Pythonの標準http.serverを使用する
# 使用法: tools/serve.sh [port]  →  http://localhost:8080/examples/
set -eu

cd "$(dirname "$0")/.."
PORT="${1:-8080}"

if ! command -v python3 > /dev/null 2>&1; then
  echo "ERROR: python3 が見つかりません (nix develop で入ります)" >&2
  exit 1
fi

echo "Nativum examples → http://localhost:$PORT/examples/"
exec python3 -m http.server "$PORT"
