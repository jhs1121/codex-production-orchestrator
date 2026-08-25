#!/usr/bin/env bash
set -euo pipefail

SCOPE="${1:-user}"
case "$SCOPE" in
  user)
    SKILL_DIR="$HOME/.agents/skills/codex-production-orchestrator"
    AGENT_DIR="$HOME/.codex/agents"
    ;;
  project)
    REPO="${2:-$(pwd)}"
    REPO="$(cd "$REPO" && pwd)"
    SKILL_DIR="$REPO/.agents/skills/codex-production-orchestrator"
    AGENT_DIR="$REPO/.codex/agents"
    ;;
  *)
    printf 'Usage: %s [user|project [repo-path]]\n' "$0" >&2
    exit 2
    ;;
esac

required=(
  "$SKILL_DIR/SKILL.md"
  "$SKILL_DIR/references/mode-matrix.md"
  "$SKILL_DIR/references/resume-takeover.md"
  "$SKILL_DIR/references/production-rules.md"
  "$SKILL_DIR/agents/openai.yaml"
  "$AGENT_DIR/luna-builder.toml"
  "$AGENT_DIR/luna-explorer.toml"
  "$AGENT_DIR/luna-verifier.toml"
  "$AGENT_DIR/sol-builder.toml"
  "$AGENT_DIR/sol-specialist.toml"
  "$AGENT_DIR/sol-verifier.toml"
)

missing=0
for path in "${required[@]}"; do
  if [[ ! -f "$path" ]]; then
    printf 'MISSING %s\n' "$path"
    missing=1
  fi
done
[[ "$missing" -eq 0 ]] || exit 1

python3 - "$AGENT_DIR" <<'PY'
import pathlib, sys, tomllib
agent_dir = pathlib.Path(sys.argv[1])
expected = {
    "luna-builder.toml": ("gpt-5.6-luna", "max", "workspace-write"),
    "luna-explorer.toml": ("gpt-5.6-luna", "max", "read-only"),
    "luna-verifier.toml": ("gpt-5.6-luna", "max", "read-only"),
    "sol-builder.toml": ("gpt-5.6-sol", "max", "workspace-write"),
    "sol-specialist.toml": ("gpt-5.6-sol", "max", "read-only"),
    "sol-verifier.toml": ("gpt-5.6-sol", "max", "read-only"),
}
for name, values in expected.items():
    data = tomllib.loads((agent_dir / name).read_text(encoding="utf-8"))
    actual = (data.get("model"), data.get("model_reasoning_effort"), data.get("sandbox_mode"))
    if actual != values:
        raise SystemExit(f"INVALID {name}: expected {values}, got {actual}")
    if not data.get("developer_instructions"):
        raise SystemExit(f"INVALID {name}: missing developer_instructions")
print("TOML OK")
PY

if ! grep -q '^name: codex-production-orchestrator$' "$SKILL_DIR/SKILL.md"; then
  printf 'INVALID SKILL.md front matter\n' >&2
  exit 1
fi
printf 'Installation OK\nSkill: %s\nAgents: %s\n' "$SKILL_DIR" "$AGENT_DIR"
