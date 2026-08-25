#!/usr/bin/env bash
set -euo pipefail
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$(pwd)}"
TARGET="$(cd "$TARGET" && pwd)"
mkdir -p "$TARGET/.codex"
if [[ ! -e "$TARGET/CTF_TOOL_SCOPE.md" ]]; then
  cp "$SRC_DIR/skill/codex-ctf-orchestrator/assets/CTF_TOOL_SCOPE.template.md" "$TARGET/CTF_TOOL_SCOPE.md"
  printf 'Created: %s\n' "$TARGET/CTF_TOOL_SCOPE.md"
else
  printf 'Kept existing: %s\n' "$TARGET/CTF_TOOL_SCOPE.md"
fi
if [[ ! -e "$TARGET/.codex/toolchain-state.md" ]]; then
  cp "$SRC_DIR/skill/codex-ctf-orchestrator/assets/toolchain-state.template.md" "$TARGET/.codex/toolchain-state.md"
  printf 'Created: %s\n' "$TARGET/.codex/toolchain-state.md"
else
  printf 'Kept existing: %s\n' "$TARGET/.codex/toolchain-state.md"
fi
printf '\nFill CTF_TOOL_SCOPE.md once for this repository. It authorizes local tool development, not remote targets.\n'
