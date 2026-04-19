#!/bin/bash
# Snapshot Claude Code + Claude Desktop config into this repo.
#  - ~/.claude/settings.json                           -> claude/settings.json
#  - ~/.claude/projects/*/memory/                      -> claude/projects/*/memory/
#  - ~/Library/.../Claude/claude_desktop_config.json   -> claude/desktop_config.json
# Run whenever you want to capture changes before committing.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
REPO_CLAUDE="$SCRIPT_DIR/claude"

mkdir -p "$REPO_CLAUDE/projects"

echo "==> Exporting ~/.claude/settings.json"
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  cp "$CLAUDE_DIR/settings.json" "$REPO_CLAUDE/settings.json"
  echo "    ✓ Copied to $REPO_CLAUDE/settings.json"
else
  echo "    ⚠ Not found, skipping"
fi

echo "==> Exporting Claude Desktop config"
if [ -f "$DESKTOP_CONFIG" ]; then
  cp "$DESKTOP_CONFIG" "$REPO_CLAUDE/desktop_config.json"
  echo "    ✓ Copied to $REPO_CLAUDE/desktop_config.json"
else
  echo "    ⚠ Not found, skipping"
fi

echo "==> Exporting per-project memory"
# Wipe existing repo copies so deleted memories are reflected on re-export
rm -rf "$REPO_CLAUDE/projects"
mkdir -p "$REPO_CLAUDE/projects"
count=0
for src in "$CLAUDE_DIR"/projects/*/memory; do
  [ -d "$src" ] || continue
  name=$(basename "$(dirname "$src")")
  dest="$REPO_CLAUDE/projects/$name/memory"
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  count=$((count + 1))
done
echo "    ✓ Copied memory for $count projects"
