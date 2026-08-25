# CTF Worker Packet

Every delegated task must contain:

```text
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

Keep the packet compact but never omit the authorization envelope. Separate independent hypotheses; do not send multiple workers to rediscover the same file map.
