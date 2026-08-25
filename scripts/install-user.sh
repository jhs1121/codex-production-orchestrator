#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_ROOT="$HOME/.agents/skills"
SKILL_DST="$SKILL_ROOT/codex-production-orchestrator"
AGENT_DST="$HOME/.codex/agents"
PROFILE_DST="$HOME/.codex"
DEFAULT_AUTO=false

usage() {
  cat <<'USAGE'
Usage: bash scripts/install-user.sh [--default-auto|--default-daily]

Installs the Skill, custom agents, and optional CLI profiles.
--default-auto adds an idempotent managed block to ~/.codex/AGENTS.md so
non-trivial coding tasks automatically use the orchestrator. --default-daily is
kept as a backwards-compatible alias.
USAGE
}

for arg in "$@"; do
  case "$arg" in
    --default-auto|--default-daily) DEFAULT_AUTO=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

check_broken_symlink() {
  local path="$1"
  if [[ -L "$path" && ! -e "$path" ]]; then
    printf 'Install blocked: %s is a broken symbolic link.\n' "$path" >&2
    printf 'Inspect it with: ls -ld %q\n' "$path" >&2
    printf 'If you no longer need that link, remove it with: rm %q\n' "$path" >&2
    printf 'Then run: bash install.sh\n' >&2
    exit 1
  fi
}

# mkdir -p normally creates all missing parents. Explicitly detect broken links,
# because a dangling ~/.agents or ~/.agents/skills makes mkdir report a confusing
# "No such file or directory" error on macOS.
check_broken_symlink "$HOME/.agents"
check_broken_symlink "$SKILL_ROOT"
check_broken_symlink "$HOME/.codex"
check_broken_symlink "$AGENT_DST"

mkdir -p "$SKILL_ROOT" "$SKILL_DST" "$AGENT_DST" "$PROFILE_DST"

cp -R "$SRC_DIR/skill/codex-production-orchestrator/." "$SKILL_DST/"
cp "$SRC_DIR/agents/"*.toml "$AGENT_DST/"
cp "$SRC_DIR/profiles/"*.config.toml "$PROFILE_DST/"

if "$DEFAULT_AUTO"; then
  AGENTS_FILE="$HOME/.codex/AGENTS.md"
  BEGIN_MARKER='<!-- BEGIN CODEX PRODUCTION ORCHESTRATOR DEFAULT -->'
  END_MARKER='<!-- END CODEX PRODUCTION ORCHESTRATOR DEFAULT -->'
  TMP_FILE="$(mktemp)"
  trap 'rm -f "$TMP_FILE"' EXIT

  if [[ -f "$AGENTS_FILE" ]]; then
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
      $0 == begin {skip=1; next}
      $0 == end {skip=0; next}
      !skip {print}
    ' "$AGENTS_FILE" > "$TMP_FILE"
  fi

  cat >> "$TMP_FILE" <<EOF_BLOCK

$BEGIN_MARKER
For non-trivial feature work, refactors, bug fixes, migrations, or multi-file implementation, use the codex-production-orchestrator Skill automatically. No MODE argument is required: default to the high-throughput policy (Sol main coordinates; Luna Max handles clear bounded implementation), auto-size the number of workers, and escalate to Sol leaf agents only when stronger judgment materially helps. If the user is continuing or resuming existing work, automatically apply the safe takeover workflow: preserve the worktree, inspect only relevant status/diffs/evidence, and continue remaining acceptance criteria instead of restarting. If the current main session is Ultra, keep a single orchestration layer and avoid nested coordinator trees. Explicit user requests such as MODE=ALL_SOL or not to orchestrate take precedence.
$END_MARKER
EOF_BLOCK
  mkdir -p "$(dirname "$AGENTS_FILE")"
  mv "$TMP_FILE" "$AGENTS_FILE"
  trap - EXIT
fi

printf 'Installed Skill: %s\n' "$SKILL_DST"
printf 'Installed agents: %s\n' "$AGENT_DST"
printf 'Installed CLI profiles: %s/{cpo-daily,cpo-quality,cpo-ultra}.config.toml\n' "$PROFILE_DST"
if "$DEFAULT_AUTO"; then
  printf 'Enabled automatic production-orchestrator guidance in: %s\n' "$HOME/.codex/AGENTS.md"
fi
printf '\nRestart Codex if the Skill or new agents do not appear.\n'
printf 'Normal use: restart Codex and give your coding task normally.\n'
