#!/bin/bash
# Snapshot current VS Code config into this repo.
#  - extensions list  -> vscode-extensions.txt
#  - settings.json    -> vscode/settings.json
#  - keybindings.json -> vscode/keybindings.json
# Run whenever you want to capture changes before committing.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
EXT_FILE="$SCRIPT_DIR/vscode-extensions.txt"
VSCODE_REPO_DIR="$SCRIPT_DIR/vscode"

mkdir -p "$VSCODE_REPO_DIR"

echo "==> Exporting VS Code extensions"
code --list-extensions | sort > "$EXT_FILE"
echo "    ✓ Wrote $(wc -l < "$EXT_FILE" | tr -d ' ') extensions to $EXT_FILE"

echo "==> Exporting settings.json"
if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
  cp "$VSCODE_USER_DIR/settings.json" "$VSCODE_REPO_DIR/settings.json"
  echo "    ✓ Copied to $VSCODE_REPO_DIR/settings.json"
else
  echo "    ⚠ No settings.json found, skipping"
fi

echo "==> Exporting keybindings.json"
if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
  cp "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_REPO_DIR/keybindings.json"
  echo "    ✓ Copied to $VSCODE_REPO_DIR/keybindings.json"
else
  echo "    ⚠ No keybindings.json found, skipping"
fi
