#!/usr/bin/env bash
set -euo pipefail
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$(pwd)}"
TARGET="$(cd "$TARGET" && pwd)"
mkdir -p "$TARGET/.codex"
if [[ ! -e "$TARGET/CTF_SCOPE.md" ]]; then
  cp "$SRC_DIR/skill/codex-ctf-orchestrator/assets/CTF_SCOPE.template.md" "$TARGET/CTF_SCOPE.md"
  printf 'Created: %s\n' "$TARGET/CTF_SCOPE.md"
else
  printf 'Kept existing: %s\n' "$TARGET/CTF_SCOPE.md"
fi
if [[ ! -e "$TARGET/.codex/ctf-state.md" ]]; then
  cp "$SRC_DIR/skill/codex-ctf-orchestrator/assets/ctf-state.template.md" "$TARGET/.codex/ctf-state.md"
  printf 'Created: %s\n' "$TARGET/.codex/ctf-state.md"
else
  printf 'Kept existing: %s\n' "$TARGET/.codex/ctf-state.md"
fi
printf '\nFill CTF_SCOPE.md before remote organizer-target actions.\n'
