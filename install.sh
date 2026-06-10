#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$REPO_ROOT/.claude/skills"
SKILLS_DST="$HOME/.claude/skills"

if [ ! -d "$SKILLS_SRC" ]; then
  echo "Error: skills directory not found at $SKILLS_SRC" >&2
  exit 1
fi

mkdir -p "$SKILLS_DST"

installed=0
updated=0

for skill_dir in "$SKILLS_SRC"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  dst="$SKILLS_DST/$skill_name"

  if [ -d "$dst" ]; then
    rm -rf "$dst"
    cp -r "$skill_dir" "$dst"
    echo "  updated  $skill_name"
    updated=$((updated + 1))
  else
    cp -r "$skill_dir" "$dst"
    echo "  installed  $skill_name"
    installed=$((installed + 1))
  fi
done

echo ""
echo "$installed installed, $updated updated."
echo "Restart Claude Code to activate the skills."
