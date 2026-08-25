# Resume Takeover

Use this workflow when `RESUME=TAKEOVER` is specified or the task clearly resumes paused/partial work.

## Principle

Adopt the existing state. Do not restart the task, rewrite the plan from zero, or treat uncommitted work as disposable.

## State inventory

Use the minimum commands needed, normally:

1. inspect the current objective and prior conversation checkpoint;
2. read the nearest `AGENTS.md` and any task file explicitly named by the user, such as `NEXT_AGENT_TASK.md`, `PLANS.md`, or a current issue specification;
3. inspect `git status --short`;
4. inspect `git diff --stat` and `git diff --name-only`;
5. inspect specific diffs only for files relevant to the remaining acceptance criteria;
6. inspect recent commits only when the task involved commits or the working tree does not explain current progress.

Do not run hashes. Do not immediately run the full suite. Do not scan the whole repository to “rebuild confidence.”

## Reconstruct a compact ledger

Classify each acceptance criterion as:

- complete and evidenced;
- implemented but not yet validated;
- in progress;
- not started;
- blocked;
- uncertain because context is missing.

For each existing change, identify likely ownership and whether touching it would collide with another package.

## Continue safely

- Preserve the current branch, worktree, and all dirty files.
- Never reset, restore, checkout, stash, delete, or overwrite existing changes without explicit user instruction.
- Delegate only remaining or unverified work.
- Reuse prior validation evidence when relevant files have not changed.
- If a previous worker was stopped, do not repeat its entire investigation; use the recorded blocker and evidence.
- If the current transcript is unavailable, use the task file, git state, and a compact user-provided handoff rather than guessing.

## Best handoff format

At pause time, record:

- objective;
- exact done criteria;
- current branch/worktree;
- completed changes;
- dirty files and ownership;
- validation commands/results;
- remaining packages;
- blocker and next action.

`STATE=CHAT` keeps this in the conversation. `STATE=FILE` stores it in `.codex/task-state.md` at meaningful checkpoints only.
