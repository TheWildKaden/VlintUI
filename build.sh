#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

INPUT="src/init.lua"
OUTPUT="dist/library.lua"

mkdir -p dist

if ! command -v darklua >/dev/null 2>&1; then
  echo "Error: darklua is not installed or available on PATH." >&2
  exit 1
fi

# Bundle the library with the internal module loader and preserve readable formatting
darklua process "$INPUT" "$OUTPUT" --config darklua.json

echo "Build complete: $OUTPUT"
