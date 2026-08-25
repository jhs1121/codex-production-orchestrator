# CTF Worker Packets

Every delegated task must use exactly one of these scope envelopes.

## Routing header

Every packet begins with:

```text
AGENT_ROLE:
MODEL_CLASS:
ROUTING_REASON:
```

The coordinator must also announce the selected role/model count before dispatch. `MODEL_CLASS` records the intended route (for example `Luna Max pinned`, `Terra Max pinned`, or `current-primary inherited`); it does not claim that a UI title is authoritative telemetry.

## TOOLCHAIN / EVAL packet

```text
AGENT_ROLE:
MODEL_CLASS:
ROUTING_REASON:
WORKFLOW: TOOLCHAIN | EVAL
TOOL_SCOPE:
PROJECT:
OWNER_AUTHORIZATION:
PURPOSE:
ALLOWED_INPUTS:
NETWORK_POLICY:
ALLOWED_CAPABILITIES:
FORBIDDEN_CAPABILITIES:
TEST_CORPUS_PROVENANCE:
SAFETY_INVARIANTS:
OBJECTIVE:
INPUT_PATHS:
OWNERSHIP:
ALREADY_KNOWN:
DO_NOT_REPEAT:
FOCUSED_VALIDATION:
OUTPUT_CONTRACT:
```

A tool-development child must not receive only “build an auto-exploit tool” or another capability label without the repository purpose, local/default network boundary, test corpus, and forbidden capabilities.

For EVAL first-pass repository/capability audits, default to `ctf_eval_auditor` (Luna Max, read-only). Use Terra only after a concrete evidence-backed escalation or explicit user request.

## CHALLENGE packet

```text
AGENT_ROLE:
MODEL_CLASS:
ROUTING_REASON:
WORKFLOW: CHALLENGE
AUTH_SCOPE:
CONTEXT:
TARGETS:
TIME_WINDOW:
ALLOWED_ACTIONS:
FORBIDDEN_BOUNDARIES:
OBJECTIVE:
HYPOTHESIS:
INPUT_PATHS_OR_ENDPOINTS:
OWNERSHIP:
ALREADY_KNOWN:
DO_NOT_REPEAT:
FOCUSED_EXPERIMENT:
OUTPUT_CONTRACT:
```

Keep packets compact but never omit the relevant scope envelope. Separate independent packages or hypotheses; do not send multiple workers to rediscover the same repository or artifact map.
