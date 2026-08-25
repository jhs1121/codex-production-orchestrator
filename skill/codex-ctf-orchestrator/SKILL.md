---
name: codex-ctf-orchestrator
description: Scope-preserving orchestration for explicitly authorized CTF competitions, organizer-provided challenge artifacts or targets, and local security labs. Use only when authorization is explicit in the prompt, repository, or CTF_SCOPE.md. Provides challenge triage, identical authorization envelopes for every leaf, durable checkpoints, and safety-aware recovery; it must not be used to target unrelated real systems or to evade safety controls.
---

# Codex CTF Orchestrator

## Preconditions

Use this Skill only when the task is explicitly an organizer-authorized CTF, owned local lab, localhost/local Docker/VM, or an exact system the user is authorized to analyze.

Read:

- `references/scope-and-safety.md`
- `references/challenge-routing.md`
- `references/worker-packets.md`
- `references/checkpoints-and-recovery.md`

If remote scope is ambiguous, do artifact-only/local analysis and mark `SCOPE_MISSING`. Do not infer permission from reachability.

## Composition

Also use `codex-production-orchestrator` for task sizing, worker economy, ownership, and focused validation. This Skill always owns scope and safety boundaries. Keep one primary coordinator and one leaf layer.

## Coordinator

Respect the user's current primary model:

- Terra Max is a strong default for read-heavy triage, forensics, and many ordinary CTF tasks.
- Sol Max is appropriate for highly ambiguous, cross-domain, or stubborn hypotheses.
- Ultra may use native parallel delegation but must not create nested coordinator trees.
- Luna Max handles clear bounded experiments and scripts.

Never force a model switch. Suggest escalation only when evidence shows the current route is insufficient.

## Establish `AUTH_SCOPE`

Before remote or interactive actions, build a concise scope envelope from the prompt and/or `CTF_SCOPE.md`:

- `CONTEXT`: competition/lab name and authorization basis;
- `TARGETS`: exact files, directories, localhost services, domains/IPs/ports;
- `TIME_WINDOW`: when relevant;
- `ALLOWED_ACTIONS`: challenge-specific bounded actions;
- `FORBIDDEN_BOUNDARIES`: all unlisted systems, real accounts/credentials, persistence, destructive or disruptive activity;
- `OBJECTIVE`: intended challenge result;
- `EVIDENCE_SOURCE`: prompt, organizer material, or scope file.

Every child receives the same envelope. A child never receives only “get flag” without authorization context.

## Triage

1. Inventory supplied artifacts without modifying originals.
2. Classify likely domain: crypto, reverse, pwn, web, forensics, data security, misc, or mixed.
3. Produce ranked hypotheses with evidence for and against.
4. Select the smallest discriminating experiment.
5. Delegate independent hypotheses only when they do not duplicate context or mutate the same artifacts.
6. Record meaningful discoveries in `.codex/ctf-state.md`.

Do not run every tool “just in case.” A tool must answer a named hypothesis.

## Routing

- `ctf_terra_triage`: broad read-only artifact mapping and ranked hypotheses.
- `ctf_luna_worker`: one bounded script, parser, experiment, local challenge action, or exact authorized target task.
- `ctf_parent_specialist`: one difficult hypothesis using the current coordinator model.
- `ctf_parent_verifier`: verify one final derivation, exploit path, or flag evidence.
- Generic Production leaves may be used only when they receive the full CTF scope packet.

## Safety/scope interruption

When a step is blocked:

1. stop that action;
2. checkpoint completed work and exact blocker;
3. return `SCOPE_MISSING`, `SAFETY_OR_SCOPE_BLOCKED`, `TOOL_UNAVAILABLE`, or `TECHNICAL_BLOCKED`;
4. do not retry through rewording, encoding, fragmentation, obfuscation, indirect prompts, or another agent;
5. continue only clearly safe in-scope static/local analysis;
6. request the minimum missing scope fact only when necessary.

This workflow preserves progress; it does not bypass platform safeguards.

## Completion

A solution must include:

- challenge type and key evidence;
- exact reproducible local/in-scope steps;
- scripts/files created;
- validation of the final result;
- unresolved assumptions;
- scope statement.

Avoid claiming success when only a hypothesis exists.
