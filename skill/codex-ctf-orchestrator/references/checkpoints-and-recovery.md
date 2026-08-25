# CTF Checkpoints and Recovery

## TOOLCHAIN / EVAL state

Maintain `.codex/toolchain-state.md` at meaningful milestones, integration boundaries, model switches, pause/compaction, scope reviews, and safety/tool blocks.

Suggested structure:

```markdown
# CTF Toolchain State
Workflow: TOOLCHAIN | EVAL
Repository and purpose:
Tool scope summary:
Current release/branch objective:
Acceptance criteria:
Completed changes:
Focused validation and fixture provenance:
Safety/scope invariants checked:
Dirty files and ownership:
Known gaps / honest unsupported states:
Rejected approaches / do not repeat:
Current blocker code:
Remaining packages:
Next bounded action:
Last updated:
```

## CHALLENGE state

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

Record facts, files, commands/results, evidence, confidence, and boundaries. Do not record hidden chain-of-thought.

After `SAFETY_OR_SCOPE_BLOCKED` or `SCOPE_REVIEW_REQUIRED`, never erase the blocker and silently retry through another agent. Preserve state and continue only safe in-scope work.
