#!/bin/bash
# Export currently installed VS Code extensions to vscode-extensions.txt
# Run this whenever you want to snapshot your current extension list.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="$SCRIPT_DIR/vscode-extensions.txt"

echo "==> Exporting VS Code extensions to $OUTPUT"
code --list-extensions | sort > "$OUTPUT"
echo "    ✓ Wrote $(wc -l < "$OUTPUT" | tr -d ' ') extensions"
