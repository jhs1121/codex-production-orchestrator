# CTF Checkpoints and Recovery

Maintain `.codex/ctf-state.md` at triage completion, major hypothesis changes, model switches, pause/compaction, safety/scope blocks, and final verification.

Suggested structure:

```markdown
# CTF State
Authorization scope summary:
Challenge objective:
Artifacts / exact targets:
Current classification:
Confirmed facts:
Ranked hypotheses:
Experiments completed and results:
Scripts / outputs created:
Rejected paths / do not repeat:
Current blocker code:
Remaining next actions:
Last updated:
```

Record facts, commands/results, and confidence. Do not record hidden chain-of-thought.

After `SAFETY_OR_SCOPE_BLOCKED`, never erase the blocker and silently retry through another agent. Preserve state and continue only safe in-scope work.
