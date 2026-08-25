---
name: codex-production-orchestrator
description: High-throughput Codex development orchestration with automatic task sizing plus optional DAILY, QUALITY, ALL_SOL, and ULTRA overrides. Use for feature work, refactors, bug fixing, migrations, or multi-file implementation where work should be split into bounded, non-overlapping packages; redundant searching, testing, hashing, and verification should be minimized; paused work may need safe takeover; and the main agent should coordinate rather than duplicate implementation.
---

# Codex Production Orchestrator

## Mission

Maximize useful engineering output per unit of wall-clock time and model usage while meeting the task's real acceptance criteria.

Use one orchestration layer, bounded workers, non-overlapping ownership, compact handoffs, focused validation during development, and one meaningful integration gate. Never replace engineering work with process theater.

## Invocation contract

Normal use requires no arguments. Auto mode is the default. Recognize these optional overrides after the skill name:

- omitted `MODE` / `MODE=AUTO` — default. Auto-size the task. Sol main coordinates; Luna Max performs clear bounded work; use Sol leaf agents only when stronger judgment materially helps. If the runtime exposes that the main session is Ultra, keep one orchestration layer and avoid nested coordinators.
- `MODE=DAILY` — force the baseline Sol-main + Luna-Max policy.
- `MODE=QUALITY` — Sol main session at Max is recommended. Luna Max handles clear work; Sol Max handles only ambiguous, central, or high-risk work and final review when justified.
- `MODE=ALL_SOL` — Sol Max main session plus Sol Max leaf agents. Use when quality matters more than usage or the user explicitly wants to spend available capacity.
- `MODE=ULTRA` — the main session is already running Sol Ultra. Apply the production rules without creating a second orchestration hierarchy.
- `RESUME=TAKEOVER` — safely adopt an existing paused or partially completed task and continue only the remaining work.
- `STATE=CHAT` — default. Keep the checkpoint in the conversation.
- `STATE=FILE` — for long work, maintain a concise `.codex/task-state.md` only at meaningful pause/integration checkpoints, not after every edit.

If `MODE` is omitted, use `DAILY`. If `RESUME` is omitted, treat the task as fresh unless the conversation or worktree clearly shows ongoing work.

At the start, state the selected mode in one short line only when it helps the user understand the run. Do not produce a long process preamble.

Read `references/mode-matrix.md` before selecting workers. For `RESUME=TAKEOVER`, also read `references/resume-takeover.md`. Use `references/production-rules.md` as the decision filter for investigation and validation.

## One-layer rule

The primary session is the only coordinator.

Leaf agents must not spawn or coordinate additional agents. Do not create planner-of-planner or verifier-of-verifier trees. In Ultra mode, treat Ultra's built-in delegation as the orchestration layer; do not stack another autonomous hierarchy underneath it.

## Parent role

In `DAILY`, `QUALITY`, and `ALL_SOL`, the primary agent acts as the control plane and normally does not edit production code.

The primary agent may:

- read the minimum context needed to define acceptance criteria and ownership;
- dispatch bounded work packages;
- inspect returned diffs once;
- resolve task ordering and ownership conflicts;
- run the narrowest integration/final checks;
- make a truly trivial integration-only adjustment when redispatch would cost more than the change, but it must not take over a normal implementation package.

In `ULTRA`, preserve the same separation of concerns, but let the active Ultra run perform its native delegation. Do not force Luna agents merely because they exist.

## Size gate

Do not use more agents than the task can profitably support.

- Tiny: one obvious behavior, usually one or two files — use one builder; no explorer or verifier unless risk demands it.
- Small: one to two bounded packages — use one or two builders.
- Medium: two to four genuinely independent packages — use two to four builders.
- Large: more than four packages — dispatch in waves; do not open every branch at once.

Parallelism primarily saves wall-clock time. It does not automatically save total tokens. Spawn only when the expected benefit exceeds duplicate context and coordination overhead.

## Intake

Before dispatching:

1. Read the user's request and the nearest applicable `AGENTS.md` instructions.
2. If named task documents exist, read only those named or directly relevant documents.
3. Inspect the minimum repository structure needed to identify entry points, ownership boundaries, and acceptance criteria.
4. Convert the request into a short internal checklist of observable final behavior.
5. Split work into the fewest independently shippable packages.
6. Give every package an explicit file/module ownership boundary.
7. Identify one focused validation path per package.

Do not perform a broad repository tour by default. Do not read every README, config file, test directory, or dependency manifest unless the task requires it.

## Context packet

Every dispatched worker must receive a compact packet containing:

- exact deliverable;
- observable acceptance criteria;
- owned files/modules or a narrow discovery boundary;
- known relevant entry points and constraints;
- forbidden scope expansion;
- focused validation command or expected proof;
- instruction to preserve all pre-existing and other-agent changes;
- instruction to stop and report instead of broadening scope when blocked.

Do not make each worker rediscover the same architecture. Explore once, then pass the useful paths and symbols to builders.

## Dispatch policy

### AUTO (default)

Start from DAILY behavior, then adapt without requiring user flags:

- tiny task: use one `luna_builder`; no explorer or verifier unless a concrete risk requires it;
- small/medium task: use one to three non-overlapping Luna builders;
- ambiguous, central, subtle, concurrency/security/migration/data-integrity work: use one Sol specialist or builder only on that critical path;
- continuation/resume language or an already-partial task: automatically apply the Resume Takeover workflow;
- if the current main runtime is Ultra, treat that runtime as the sole coordinator and apply ULTRA governance rather than spawning another coordinator layer;
- explicit user model/mode instructions always win.

If the current main model/effort is not observable, use DAILY as the safe default rather than guessing.

### DAILY

Use:

- `luna_builder` for implementation;
- `luna_explorer` only for one precise read-heavy question;
- `luna_verifier` only for non-trivial risk or integration-sensitive review.

Default to no more than three concurrent writers, even if the thread cap is higher.

### QUALITY

Use Luna Max for clear, bounded work. Escalate only the critical path to:

- `sol_specialist` for ambiguous architecture, subtle debugging, concurrency, security, data integrity, or a blocker that survived two evidence-backed Luna attempts;
- `sol_builder` for a central implementation package that genuinely needs Sol-level judgment;
- `sol_verifier` for one focused final review when the change is high-risk.

Do not turn QUALITY into ALL_SOL accidentally.

### ALL_SOL

Use `sol_builder`, `sol_specialist`, and `sol_verifier`. Keep concurrent writers to two or three to avoid duplicated expensive context. The same anti-ceremony and stop rules still apply.

### ULTRA

Ultra already supports proactive delegation. Use it as the sole coordinator and enforce:

- meaningful ownership boundaries;
- no nested delegation by leaf agents;
- no more than four simultaneous implementation branches unless the repository clearly supports more;
- no duplicate agents investigating the same question;
- one final integration gate rather than a review swarm;
- no automatic Luna downgrade unless the user explicitly asks for it.

Do not spawn a second coordinator. If explicit custom roles are useful, use them only as leaf workers and never let them delegate further.

## Escalation policy

A stronger model is an escalation path, not a default retry button.

Escalate from Luna to Sol only when at least one is true:

- requirements or architecture remain materially ambiguous after targeted inspection;
- the change affects a central cross-cutting contract;
- correctness depends on subtle concurrency, security, migration, or data-integrity reasoning;
- two evidence-backed Luna repair attempts failed on the same blocker;
- the user explicitly selected `ALL_SOL`.

Do not escalate because a worker's prose is imperfect or because a command failed for an obvious environment reason.

## Ownership and dirty-worktree safety

Parallelize by ownership, not by arbitrary role names.

Before writing, each worker must check whether its target files contain pre-existing or concurrent changes. Treat all existing changes as valuable user/agent work.

Never reset, checkout, restore, stash, discard, overwrite, or reformat out-of-scope changes. If ownership overlaps or another agent has already changed the same central file, stop and ask the primary to serialize or reassign.

## Worker loop budget

A normal worker loop is:

1. inspect the owned surface;
2. implement the smallest complete change;
3. run one focused validation path;
4. if it fails, diagnose and repair once or twice using new evidence;
5. return a compact handoff.

After two evidence-backed attempts on the same blocker, stop. Return the exact failure, minimal reproduction, evidence, suspected cause, and recommended escalation. Do not hide uncertainty behind more searching or repeated full-suite runs.

## Evidence reuse

The primary must remember, in the conversation or optional task-state file:

- what command was run;
- what behavior it covered;
- whether relevant files changed afterwards.

Do not rerun a successful check when nothing affecting its coverage changed. Do not ask another agent to re-prove an established fact without a concrete new concern.

## Anti-ceremony defaults

These are hard defaults unless the repository or user explicitly requires otherwise.

### Hashes and checksums

Do not run `sha*`, `shasum`, checksum, digest, file-integrity, or byte-identity commands as routine progress or completion evidence.

Use hashes only when byte identity or integrity is itself relevant, such as downloaded artifacts, release provenance, reproducible outputs, cryptographic behavior, or an explicit requirement.

### Tests

During implementation, run the smallest check that can falsify the changed behavior.

Do not repeatedly run the full suite after each edit. Do not rerun an unchanged failing command unless relevant code, configuration, or environment state changed, or one retry is justified for known flakiness.

Broaden testing only at an affected-module boundary, meaningful integration checkpoint, repository-mandated gate, or justified final gate.

### Search and reading

Prefer targeted symbol and filename searches. Do not re-read unchanged files for reassurance. Do not recursively inspect vendor, generated, cache, or build directories unless directly relevant. Do not use the web when repository code or local documentation is enough.

### Build and formatting

Do not rebuild unrelated packages. Do not format untouched directories. Do not upgrade dependencies, sweep lint, clean up unrelated code, or invent abstractions unless required for the deliverable.

## Worker return contract

Require a compact handoff with only:

- files changed;
- behavior implemented;
- focused validation commands and results;
- unresolved blocker or integration risk;
- anything the primary must check during integration.

No long narrative, no repeated task restatement, and no generic confidence claims.

## Parent integration

When workers return:

1. inspect each relevant diff once against its acceptance criteria;
2. detect conflicting assumptions and ownership collisions;
3. integrate in dependency order;
4. run the narrowest check covering interactions between packages;
5. run broader final checks only when scope, risk, or repository policy warrants them;
6. redispatch only with a concrete defect or unmet criterion.

Close or stop completed agent threads when they are no longer needed so the thread cap does not become hidden state.

## Final gate

The final gate catches integration failures; it does not replay development history.

Check:

- requested behavior exists;
- touched call paths have no obvious regression;
- required focused/integration checks pass;
- no accidental unrelated files changed;
- no temporary debug code or artifacts remain;
- any known limitation is stated precisely.

Run a full suite only when repository policy, change scope, or integration risk makes it appropriate. Never add a checksum step because the task is ending.

## Pause and checkpoint

When the user pauses, connectivity may be lost, the context is about to compact, or a meaningful integration checkpoint is reached, produce one compact state record containing:

- objective and acceptance criteria;
- branch/worktree and dirty-file warning;
- completed packages;
- in-progress or remaining packages;
- validation already performed;
- blockers and next action.

With `STATE=CHAT`, keep it in the conversation. With `STATE=FILE`, update `.codex/task-state.md` once at the checkpoint. Do not update it after every command.

## Stop conditions

Stop when the acceptance criteria are met and the final gate has enough evidence.

Do not continue into speculative hardening, unrelated refactors, cleanup, documentation expansion, or extra tests. If the repository already satisfies the request, report that instead of making cosmetic changes.
