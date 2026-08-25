---
name: codex-production-orchestrator
description: Coordinator-neutral, high-throughput Codex orchestration for non-trivial feature work, bug fixing, refactors, migrations, tool development, and paused-task takeover. Use when work benefits from bounded agents, non-overlapping ownership, durable checkpoints, focused validation, and suppression of redundant searching, testing, hashing, or nested orchestration. May compose with codex-ctf-orchestrator for explicitly authorized CTF work.
---

# Codex Production Orchestrator

## Mission

Maximize useful completed engineering work while meeting real acceptance criteria. The user's currently selected primary model and effort are the only coordinator. Never force Sol, Terra, or any other model.

Read these references as needed:

- `references/model-routing.md`
- `references/execution-rules.md`
- `references/resume-and-checkpoints.md`
- `references/composition.md`

## One coordinator

The primary session is the only coordinator. Every custom agent is a leaf and must not spawn agents.

When the primary is Ultra, treat Ultra's native delegation as the orchestration layer. Do not place another autonomous planner/coordinator beneath it.

## Automatic task sizing

- Tiny: primary may implement directly, or use one builder if delegation is cheaper.
- Small: one bounded builder; optional narrow explorer.
- Medium: two or three independent writers with non-overlapping ownership.
- Large: dispatch in waves of at most three writers; integrate before the next wave.
- Central-file or tightly coupled work: serialize it even when many agents are available.

Parallelism saves wall-clock time only when ownership and context are genuinely independent. It does not inherently save tokens.

## Intake

1. Read the user request and nearest applicable `AGENTS.md`.
2. Read only task documents explicitly named or directly required.
3. Inspect the minimum repository structure needed to define observable acceptance criteria.
4. Check existing worktree state before editing or delegating.
5. Split the remaining work into the fewest independently shippable packages.
6. Assign exact file/module ownership and one focused validation path per package.
7. Give workers a compact context packet; do not make each worker rediscover the repository.

## Routing

Use the smallest capable leaf:

- `luna_builder`: clear bounded implementation.
- `luna_explorer`: narrow read-only lookup.
- `luna_verifier`: one focused low/medium-risk verification.
- `terra_explorer`: purposeful read-heavy exploration or large-artifact mapping.
- `parent_builder`, `parent_specialist`, `parent_verifier`: only when coordinator-level judgment materially helps.
- explicit `sol_*`: only for backward compatibility or an explicit all-Sol request.

Parent-model agents intentionally do not pin a model. When exact inheritance matters, spawn them explicitly with the current primary model and effort so user-level agent defaults cannot silently change the route.

## Execution

The primary normally coordinates, integrates, and validates rather than duplicating worker implementation. It may make a trivial integration edit when redispatch would cost more than the change.

A worker must return:

- owned files or evidence;
- completed behavior/result;
- exact validation performed;
- unresolved blocker;
- integration risk.

Inspect a returned diff once for its acceptance criteria. Do not rerun a worker's successful focused check unless relevant code/config/environment changed.

## Verification

Use the lowest rung that can falsify the change:

1. static/local sanity;
2. nearest focused test;
3. affected package/module test;
4. changed-boundary integration test;
5. full suite/build only when risk or repository policy justifies it.

No ritual checksums. No unchanged test loops. No review swarm.

## Resume and long context

When the conversation or worktree shows existing work, automatically perform safe takeover. Preserve all dirty files and prior evidence. Never reset, restore, checkout, stash, discard, or rewrite from zero.

Maintain `.codex/task-state.md` only at meaningful pause, model-switch, compaction, milestone, safety interruption, or pre-integration boundaries. Record facts and evidence, not hidden reasoning.

## Composition with CTF

For an explicitly authorized CTF, `codex-ctf-orchestrator` owns scope, target boundaries, challenge hypotheses, and safety-aware recovery. This Skill owns sizing, ownership, worker economy, and validation. The CTF constraints always narrow what Production orchestration may do.
