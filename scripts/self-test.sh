#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for script in "$ROOT/install.sh" "$ROOT/uninstall.sh" "$ROOT/scripts/"*.sh; do bash -n "$script"; done
printf 'Shell syntax OK\n'
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME"' EXIT
HOME="$TMP_HOME" bash "$ROOT/install.sh"
HOME="$TMP_HOME" bash "$ROOT/scripts/doctor.sh" user
HOME="$TMP_HOME" bash "$ROOT/install.sh" >/dev/null
count="$(grep -c '^<!-- BEGIN CPO V1 MANAGED DEFAULTS -->$' "$TMP_HOME/.codex/AGENTS.md")"
[[ "$count" -eq 1 ]] || { printf 'Managed block is not idempotent\n' >&2; exit 1; }
mkdir -p "$TMP_HOME/challenge"
bash "$ROOT/scripts/init-ctf-workspace.sh" "$TMP_HOME/challenge" >/dev/null
[[ -f "$TMP_HOME/challenge/CTF_SCOPE.md" && -f "$TMP_HOME/challenge/.codex/ctf-state.md" ]]
HOME="$TMP_HOME" bash "$ROOT/uninstall.sh" >/dev/null
[[ ! -d "$TMP_HOME/.agents/skills/codex-production-orchestrator" && ! -d "$TMP_HOME/.agents/skills/codex-ctf-orchestrator" ]]
printf 'Self-test OK\n'
