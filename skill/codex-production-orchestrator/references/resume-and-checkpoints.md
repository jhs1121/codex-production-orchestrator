# Resume and Checkpoints

## Safe takeover

1. Read the current objective and latest compact checkpoint.
2. Inspect `git status --short`, `git diff --stat`, and relevant file diffs.
3. Classify acceptance criteria: complete/evidenced, implemented/unverified, in progress, not started, blocked, or uncertain.
4. Reuse valid evidence where relevant inputs have not changed.
5. Delegate only remaining or unverified work.

Never reset, restore, checkout, stash, delete, or overwrite existing work without explicit user instruction.

## `.codex/task-state.md`

Write or refresh only at meaningful boundaries:

```markdown
# Task State
Objective:
Acceptance criteria:
Completed:
In progress:
Remaining:
Changed files / ownership:
Validation already completed:
Known blockers:
Next exact action:
Last updated:
```

Keep it short, factual, and disposable. Do not record chain-of-thought. Do not update after every edit.
