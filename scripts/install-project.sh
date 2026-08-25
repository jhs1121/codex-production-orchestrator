#!/usr/bin/env bash
set -euo pipefail
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${1:-$(pwd)}"
REPO="$(cd "$REPO" && pwd)"
mkdir -p "$REPO/.agents/skills" "$REPO/.codex/agents"
for skill in codex-production-orchestrator codex-ctf-orchestrator; do
  rm -rf "$REPO/.agents/skills/$skill"
  mkdir -p "$REPO/.agents/skills/$skill"
  cp -R "$SRC_DIR/skill/$skill/." "$REPO/.agents/skills/$skill/"
done
cp "$SRC_DIR/agents/"*.toml "$REPO/.codex/agents/"
printf 'Installed project Skills and agents into: %s\n' "$REPO"
