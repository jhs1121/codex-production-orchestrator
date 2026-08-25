#!/usr/bin/env bash
set -euo pipefail
SCOPE="${1:-user}"
case "$SCOPE" in
  user) SKILL_ROOT="$HOME/.agents/skills"; AGENT_DIR="$HOME/.codex/agents"; PROFILE_DIR="$HOME/.codex" ;;
  project) REPO="${2:-$(pwd)}"; REPO="$(cd "$REPO" && pwd)"; SKILL_ROOT="$REPO/.agents/skills"; AGENT_DIR="$REPO/.codex/agents"; PROFILE_DIR="" ;;
  *) printf 'Usage: bash scripts/doctor.sh [user|project [repo-path]]\n' >&2; exit 2 ;;
esac
required=("$SKILL_ROOT/codex-production-orchestrator/SKILL.md" "$SKILL_ROOT/codex-production-orchestrator/references/model-routing.md" "$SKILL_ROOT/codex-production-orchestrator/references/execution-rules.md" "$SKILL_ROOT/codex-production-orchestrator/references/resume-and-checkpoints.md" "$SKILL_ROOT/codex-ctf-orchestrator/SKILL.md" "$SKILL_ROOT/codex-ctf-orchestrator/references/scope-and-safety.md" "$SKILL_ROOT/codex-ctf-orchestrator/references/challenge-routing.md" "$SKILL_ROOT/codex-ctf-orchestrator/references/worker-packets.md" "$SKILL_ROOT/codex-ctf-orchestrator/references/checkpoints-and-recovery.md")
agents=(luna-builder.toml luna-explorer.toml luna-verifier.toml terra-explorer.toml parent-builder.toml parent-specialist.toml parent-verifier.toml sol-builder.toml sol-specialist.toml sol-verifier.toml ctf-luna-worker.toml ctf-terra-triage.toml ctf-parent-specialist.toml ctf-parent-verifier.toml)
for name in "${agents[@]}"; do required+=("$AGENT_DIR/$name"); done
missing=0
for path in "${required[@]}"; do if [[ ! -f "$path" ]]; then printf 'MISSING %s\n' "$path"; missing=1; fi; done
[[ "$missing" -eq 0 ]] || exit 1
grep -q '^name: codex-production-orchestrator$' "$SKILL_ROOT/codex-production-orchestrator/SKILL.md"
grep -q '^name: codex-ctf-orchestrator$' "$SKILL_ROOT/codex-ctf-orchestrator/SKILL.md"
printf 'Skills OK\n'
python3 - "$AGENT_DIR" "$PROFILE_DIR" <<'PY_CHECK'
from pathlib import Path
import sys
try:
    import tomllib
except ModuleNotFoundError:
    print("TOML parser unavailable in this Python; structural checks passed")
    raise SystemExit(0)
agent_dir = Path(sys.argv[1]); profile_dir = Path(sys.argv[2]) if sys.argv[2] else None
pinned = {
 "luna-builder.toml": ("gpt-5.6-luna","max","workspace-write"), "luna-explorer.toml": ("gpt-5.6-luna","max","read-only"), "luna-verifier.toml": ("gpt-5.6-luna","max","read-only"), "terra-explorer.toml": ("gpt-5.6-terra","max","read-only"), "sol-builder.toml": ("gpt-5.6-sol","max","workspace-write"), "sol-specialist.toml": ("gpt-5.6-sol","max","read-only"), "sol-verifier.toml": ("gpt-5.6-sol","max","read-only"), "ctf-luna-worker.toml": ("gpt-5.6-luna","max","workspace-write"), "ctf-terra-triage.toml": ("gpt-5.6-terra","max","read-only")}
unpinned = {"parent-builder.toml":"workspace-write", "parent-specialist.toml":"read-only", "parent-verifier.toml":"read-only", "ctf-parent-specialist.toml":"read-only", "ctf-parent-verifier.toml":"read-only"}
for name, expected in pinned.items():
 data=tomllib.loads((agent_dir/name).read_text()); actual=(data.get("model"),data.get("model_reasoning_effort"),data.get("sandbox_mode"));
 if actual != expected or not data.get("developer_instructions"): raise SystemExit(f"INVALID {name}: {actual}")
for name, sandbox in unpinned.items():
 data=tomllib.loads((agent_dir/name).read_text());
 if "model" in data or "model_reasoning_effort" in data or data.get("sandbox_mode") != sandbox or not data.get("developer_instructions"): raise SystemExit(f"INVALID {name}")
if profile_dir:
 expected_profiles={"cpo-daily.config.toml":("gpt-5.6-sol","xhigh"),"cpo-terra.config.toml":("gpt-5.6-terra","max"),"cpo-quality.config.toml":("gpt-5.6-sol","max"),"cpo-ultra.config.toml":("gpt-5.6-sol","ultra")}
 for name, expected in expected_profiles.items():
  data=tomllib.loads((profile_dir/name).read_text());
  if (data.get("model"),data.get("model_reasoning_effort")) != expected: raise SystemExit(f"INVALID profile {name}")
print("TOML OK")
PY_CHECK
printf 'Installation OK\nSkills: %s\nAgents: %s\n' "$SKILL_ROOT" "$AGENT_DIR"
