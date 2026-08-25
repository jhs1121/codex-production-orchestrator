#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_ROOT="$HOME/.agents/skills"
AGENT_DST="$HOME/.codex/agents"
PROFILE_DST="$HOME/.codex"
DEFAULT_AUTO=false

for arg in "$@"; do
  case "$arg" in
    --default-auto|--default-daily) DEFAULT_AUTO=true ;;
    -h|--help)
      printf 'Usage: bash scripts/install-user.sh [--default-auto]\n'
      exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

check_broken_symlink() {
  local path="$1"
  if [[ -L "$path" && ! -e "$path" ]]; then
    printf 'Install blocked: %s is a broken symbolic link.\n' "$path" >&2
    printf 'Inspect: ls -ld %q\n' "$path" >&2
    printf 'If obsolete, remove only the link: rm %q\n' "$path" >&2
    exit 1
  fi
}

for path in "$HOME/.agents" "$SKILL_ROOT" "$HOME/.codex" "$AGENT_DST"; do
  check_broken_symlink "$path"
done

mkdir -p "$SKILL_ROOT" "$AGENT_DST" "$PROFILE_DST"

for skill in codex-production-orchestrator codex-ctf-orchestrator; do
  src="$SRC_DIR/skill/$skill"
  dst="$SKILL_ROOT/$skill"
  [[ -f "$src/SKILL.md" ]] || { printf 'Missing source Skill: %s\n' "$src" >&2; exit 1; }
  rm -rf "$dst"
  mkdir -p "$dst"
  cp -R "$src/." "$dst/"
done

# Remove only legacy files owned by earlier releases, then install the current set.
owned_agents=(
  luna-builder.toml luna-explorer.toml luna-verifier.toml terra-explorer.toml
  parent-builder.toml parent-specialist.toml parent-verifier.toml
  sol-builder.toml sol-specialist.toml sol-verifier.toml
  ctf-luna-worker.toml ctf-terra-triage.toml ctf-parent-specialist.toml ctf-parent-verifier.toml
  ctf-tool-builder.toml ctf-fixture-worker.toml ctf-tool-reviewer.toml
)
for name in "${owned_agents[@]}"; do rm -f "$AGENT_DST/$name"; done
cp "$SRC_DIR/agents/"*.toml "$AGENT_DST/"

owned_profiles=(cpo-daily.config.toml cpo-terra.config.toml cpo-quality.config.toml cpo-ultra.config.toml)
for name in "${owned_profiles[@]}"; do rm -f "$PROFILE_DST/$name"; done
cp "$SRC_DIR/profiles/"*.config.toml "$PROFILE_DST/"
tr -d '\n' < "$SRC_DIR/VERSION" > "$PROFILE_DST/cpo-version"
printf '\n' >> "$PROFILE_DST/cpo-version"

if "$DEFAULT_AUTO"; then
  AGENTS_FILE="$HOME/.codex/AGENTS.md"
  TMP_FILE="$(mktemp)"
  trap 'rm -f "$TMP_FILE"' EXIT

  if [[ -f "$AGENTS_FILE" ]]; then
    awk '
      $0 == "<!-- BEGIN CODEX PRODUCTION ORCHESTRATOR DEFAULT -->" {skip=1; next}
      $0 == "<!-- END CODEX PRODUCTION ORCHESTRATOR DEFAULT -->" {skip=0; next}
      $0 == "<!-- BEGIN CPO V1 MANAGED DEFAULTS -->" {skip=1; next}
      $0 == "<!-- END CPO V1 MANAGED DEFAULTS -->" {skip=0; next}
      !skip {print}
    ' "$AGENTS_FILE" > "$TMP_FILE"
  else
    : > "$TMP_FILE"
  fi

  cat >> "$TMP_FILE" <<'CPO_MANAGED'

<!-- BEGIN CPO V1 MANAGED DEFAULTS -->
For non-trivial engineering work, use codex-production-orchestrator. Respect the user's current primary model and reasoning effort; never force Sol or another model. Use pinned Luna Max leaves for clear bounded work, Terra Max for purposeful read-heavy exploration, and parent-model leaves only when stronger coordinator-level judgment materially helps. Keep one coordinator layer; Ultra uses native delegation without a nested coordinator. Preserve existing work, assign non-overlapping ownership, avoid ritual SHA/checksum and unchanged test loops, and checkpoint only at meaningful boundaries.

For an owned CTF/DFIR/security tool repository, also use codex-ctf-orchestrator in TOOLCHAIN or EVAL workflow. Treat this as local/offline software development: derive TOOL_SCOPE from CTF_TOOL_SCOPE.md, README, AGENTS.md, repository ownership, and the request; use synthetic, supplied local, or public historical fixtures; default network access off except explicit loopback/local-container tests; and do not infer remote-target authorization from repository ownership.

For a specific organizer-authorized CTF challenge, supplied artifact/target, localhost, or owned local Docker/VM lab, use CHALLENGE workflow. The CTF Skill owns AUTH_SCOPE and exact target boundaries; Production owns execution discipline. Propagate the complete relevant scope packet to every child. Never evade a safety/scope block through euphemism, rewording, encoding, fragmentation, obfuscation, or another agent; checkpoint and continue only safe in-scope work.
<!-- END CPO V1 MANAGED DEFAULTS -->
CPO_MANAGED

  mkdir -p "$(dirname "$AGENTS_FILE")"
  mv "$TMP_FILE" "$AGENTS_FILE"
  trap - EXIT
fi

printf 'Installed version: %s\n' "$(cat "$PROFILE_DST/cpo-version")"
printf 'Installed Skills:\n  %s\n  %s\n' \
  "$SKILL_ROOT/codex-production-orchestrator" \
  "$SKILL_ROOT/codex-ctf-orchestrator"
printf 'Installed agents: %s\n' "$AGENT_DST"
printf 'Installed profiles: cpo-daily, cpo-terra, cpo-quality, cpo-ultra\n'
if "$DEFAULT_AUTO"; then
  printf 'Enabled managed defaults in: %s\n' "$HOME/.codex/AGENTS.md"
fi
printf '\nRestart Codex before using this version.\n'
