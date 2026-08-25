#!/usr/bin/env bash
set -euo pipefail

SKILL_ROOT="$HOME/.agents/skills"
AGENT_DST="$HOME/.codex/agents"
PROFILE_DST="$HOME/.codex"

rm -rf "$SKILL_ROOT/codex-production-orchestrator" "$SKILL_ROOT/codex-ctf-orchestrator"

owned_agents=(
  luna-builder.toml luna-explorer.toml luna-verifier.toml terra-explorer.toml
  parent-builder.toml parent-specialist.toml parent-verifier.toml
  sol-builder.toml sol-specialist.toml sol-verifier.toml
  ctf-luna-worker.toml ctf-terra-triage.toml ctf-parent-specialist.toml ctf-parent-verifier.toml
  ctf-tool-builder.toml ctf-fixture-worker.toml ctf-tool-reviewer.toml ctf-eval-auditor.toml
)
for name in "${owned_agents[@]}"; do rm -f "$AGENT_DST/$name"; done

for name in cpo-daily.config.toml cpo-terra.config.toml cpo-quality.config.toml cpo-ultra.config.toml cpo-version; do
  rm -f "$PROFILE_DST/$name"
done

AGENTS_FILE="$HOME/.codex/AGENTS.md"
if [[ -f "$AGENTS_FILE" ]]; then
  TMP_FILE="$(mktemp)"
  trap 'rm -f "$TMP_FILE"' EXIT
  awk '
    $0 == "<!-- BEGIN CODEX PRODUCTION ORCHESTRATOR DEFAULT -->" {skip=1; next}
    $0 == "<!-- END CODEX PRODUCTION ORCHESTRATOR DEFAULT -->" {skip=0; next}
    $0 == "<!-- BEGIN CPO V1 MANAGED DEFAULTS -->" {skip=1; next}
    $0 == "<!-- END CPO V1 MANAGED DEFAULTS -->" {skip=0; next}
    !skip {print}
  ' "$AGENTS_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$AGENTS_FILE"
  trap - EXIT
fi

printf 'Removed files installed by Codex Production Orchestrator v1.x.\n'
printf 'Other Codex configuration was left unchanged.\n'
