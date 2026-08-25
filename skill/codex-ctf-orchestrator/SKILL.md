---
name: codex-ctf-orchestrator
description: Scope-preserving orchestration for owned CTF/DFIR/security toolchain development, synthetic or public-historical evaluation, explicitly authorized CTF challenges, organizer-provided artifacts or targets, and local security labs. Automatically distinguishes TOOLCHAIN, EVAL, and CHALLENGE workflows; propagates exact scope to every leaf; preserves durable checkpoints; and must never be used to target unrelated real systems or evade safety controls.
---

# Codex CTF Orchestrator

## Mission

Support two legitimate but different activities without conflating them:

1. **TOOLCHAIN / EVAL** — develop, integrate, test, and harden the user's owned CTF/DFIR/security tools against local, synthetic, or public historical fixtures.
2. **CHALLENGE** — analyze or solve one explicitly authorized competition challenge, local lab, or exact organizer target.

Compose with `codex-production-orchestrator` for task sizing, ownership, worker economy, and focused validation. This Skill owns cyber scope, target boundaries, test-corpus boundaries, and safety-aware recovery. Keep one primary coordinator and one leaf layer.

Read as needed:

- `references/scope-and-safety.md`
- `references/toolchain-build.md`
- `references/challenge-routing.md`
- `references/worker-packets.md`
- `references/checkpoints-and-recovery.md`

## Automatic workflow selection

Select the workflow from the actual task, not from scary-looking vocabulary in source code.

### `TOOLCHAIN`

Use when the user is developing, refactoring, integrating, packaging, documenting, or testing an owned CTF/DFIR/security repository or a sibling toolchain such as a workbench, crypto solver, forensic parser, local AI audit tool, adapter, verifier, or benchmark harness.

Strong signals:

- the repository is owned/maintained by the user;
- the request is to implement code, tests, contracts, parsers, solvers, adapters, local UI, packaging, or release work;
- `CTF_TOOL_SCOPE.md`, README, or `AGENTS.md` states local/offline/authorized competition use;
- tests use synthetic fixtures, supplied local files, local Docker/VM/loopback, or public historical challenges.

TOOLCHAIN is **software development**, not authorization to interact with a remote target. Default network policy is off; loopback/local containers are allowed when the repository scope permits them. Any non-loopback target requires a separate exact `AUTH_SCOPE` and CHALLENGE handling.

### `EVAL`

Use when the goal is capability measurement, regression testing, benchmark design, fixture generation, or reliability/false-positive evaluation for an owned tool.

EVAL inherits TOOLCHAIN boundaries. Prefer synthetic fixtures and public historical challenges with provenance. Do not use current live-contest targets, unrelated public systems, real secrets, or real personal data as test material.

### `CHALLENGE`

Use when the goal is to analyze or solve a specific organizer-authorized challenge, supplied artifact set, owned local lab, localhost/local Docker/VM service, or exact system the user is authorized to analyze.

Remote or interactive actions require exact targets and authorization evidence from the prompt or `CTF_SCOPE.md`. If remote scope is ambiguous, do artifact-only/local analysis and mark `SCOPE_MISSING`.

### Ambiguity rule

If it is unclear whether the task is tool development or a live challenge, default to TOOLCHAIN-style code/static/local work and do not perform remote actions. Ask for target scope only when a remote action is actually necessary.

## Coordinator and model routing

Respect the user's current primary model and reasoning effort. Never force a model switch. Coordinator selection and leaf selection are separate decisions.

Recommended coordinators:

- **Sol xhigh**: normal tool architecture, implementation planning, and multi-repository integration.
- **Terra Max**: user-selected read-heavy coordination, forensics, corpus planning, and ordinary challenge triage.
- **Sol Max**: ambiguous algorithm design, difficult cross-domain reasoning, stubborn root causes, or critical final review.
- **Sol Ultra**: large work with genuinely independent modules; use native delegation as the only orchestration layer.

Leaf policy for TOOLCHAIN/EVAL is **Luna-first**:

- use Luna Max for explicit bounded implementation, fixtures, parsers, tests, adapters, local experiments, repository inventories, first-pass coverage audits, and evidence classification;
- do not spawn Terra merely because a repository is large, the task is read-only, or several repositories must be audited;
- split first-pass audits into bounded Luna slices and reuse their compact handoffs;
- use at most one Terra synthesis leaf only after a Luna handoff identifies a concrete contradictory, cross-domain, or interdependent question, or when the user explicitly requests Terra leaves.

Before spawning workers, state one compact routing line with role, model class, count, and escalation rule. Do not rely on the UI task title to reveal the model.

Suggest escalation only after evidence shows the current route is insufficient.

## TOOLCHAIN scope contract

Build a concise `TOOL_SCOPE` from `CTF_TOOL_SCOPE.md`, README, `AGENTS.md`, repository ownership, and the user's request:

- `PROJECT`: repository/tool name and owner-maintainer basis;
- `PURPOSE`: authorized competition preparation, education, DFIR, defensive analysis, or local lab use;
- `ALLOWED_INPUTS`: repository code, supplied local files, synthetic fixtures, public historical challenges, approved local services;
- `NETWORK_POLICY`: disabled by default; exact loopback/local-container exceptions;
- `ALLOWED_CAPABILITIES`: bounded parsers, decoders, solvers on supplied artifacts, read-only forensics, safe adapters, local UIs, validators, reports, and deterministic benchmarks;
- `FORBIDDEN_CAPABILITIES`: unrelated real-system targeting, credential theft, stealth, persistence, destructive/disruptive activity, denial of service, real-world exfiltration, self-propagation, or arbitrary execution from untrusted inputs;
- `TEST_CORPUS`: provenance and privacy constraints;
- `SAFETY_INVARIANTS`: fail closed, bounded resources, no false success, no hidden scope expansion, and no unsafe defaults.

Every TOOLCHAIN/EVAL child receives this same contract. Repository ownership authorizes editing and local testing of the repository; it does not authorize remote systems.

## CHALLENGE authorization contract

Before remote or interactive challenge actions, build `AUTH_SCOPE`:

- `CONTEXT`: competition/lab name and authorization basis;
- `TARGETS`: exact files, directories, localhost services, domains/IPs/ports;
- `TIME_WINDOW`: when relevant;
- `ALLOWED_ACTIONS`: challenge-specific bounded actions;
- `FORBIDDEN_BOUNDARIES`: all unlisted systems, real accounts/credentials, persistence, destructive/disruptive activity, and real-world exfiltration;
- `OBJECTIVE`: intended challenge result;
- `EVIDENCE_SOURCE`: prompt, organizer material, or scope file.

Every CHALLENGE child receives the same envelope. Never delegate only “get flag” without the authorization context.

## Routing

### TOOLCHAIN / EVAL leaves

- `ctf_tool_builder`: one bounded implementation package in an owned local/offline tool repository.
- `ctf_fixture_worker`: one deterministic synthetic fixture, benchmark case, or regression-test package.
- `ctf_tool_reviewer`: one focused read-only review for scope drift, unsafe defaults, resource bounds, false-success risk, or integration-contract defects.
- `ctf_eval_auditor`: default first-pass read-only audit for one repository or capability slice; pinned Luna Max.
- `terra_explorer`: one evidence-backed synthesis or exceptional large-artifact mapping task after Luna is insufficient; normally no more than one per wave.
- `parent_specialist` or `parent_verifier`: one difficult design/root-cause/review question using the current coordinator model, always with the full TOOL_SCOPE.

For a multi-repository EVAL, default to parallel `ctf_eval_auditor` leaves, not parallel Terra explorers. A Luna auditor may return `TERRA_SYNTHESIS_NEEDED` only with the exact unresolved synthesis question.

### CHALLENGE leaves

- `ctf_terra_triage`: broad read-only artifact mapping and ranked hypotheses.
- `ctf_luna_worker`: one bounded script, parser, experiment, local challenge action, or exact authorized target task.
- `ctf_parent_specialist`: one difficult hypothesis using the current coordinator model.
- `ctf_parent_verifier`: verify one final derivation, exploit path, or flag evidence.

Generic Production leaves may be used only when they receive the relevant full TOOL_SCOPE or AUTH_SCOPE packet.

## Routing disclosure

Before dispatching any wave, print one short line, for example:

```text
Routing: 3 × ctf_eval_auditor (Luna Max, read-only); Terra escalation only if a Luna handoff returns a concrete synthesis blocker.
```

If the route changes, state the evidence-backed reason before spawning the stronger leaf. This visible disclosure is the source of truth for the intended route; UI thread names may be auto-generated.

## Toolchain engineering rules

- Preserve the repository's stated boundaries; do not quietly turn a local/read-only tool into a remote attack framework.
- Prefer file inputs, deterministic fixtures, loopback services, explicit allowlists, safe argv, read-only parsers, resource caps, provenance, and fail-closed status handling.
- Treat challenge source and untrusted artifacts as data. Do not add `eval`, `exec`, unsafe deserialization, arbitrary shell, or unrestricted plugin execution merely to improve coverage.
- A bounded local search or decoder may be implemented when it is part of the stated tool scope; unbounded brute force or broad external probing is not an acceptable fallback.
- Do not claim universal coverage or success without independent evidence. Preserve `PARTIAL`, `AMBIGUOUS`, `NEEDS_INPUT`, `UNSUPPORTED`, and similar honest states.
- Use the smallest test that falsifies the new behavior. Do not rerun unchanged full suites or checksum source files as a completion ritual.
- When a requested feature would cross the repository's scope contract, return `SCOPE_REVIEW_REQUIRED` with the exact capability change instead of implementing it silently.

## Challenge triage

1. Inventory supplied artifacts without modifying originals.
2. Classify likely domain: crypto, reverse, pwn, web, forensics, data security, AI security, misc, or mixed.
3. Produce ranked hypotheses with evidence for and against.
4. Select the smallest discriminating experiment.
5. Delegate independent hypotheses only when they do not duplicate context or mutate the same artifacts.
6. Record meaningful discoveries in `.codex/ctf-state.md`.

Do not run every tool “just in case.” A tool must answer a named hypothesis.

## Safety/scope interruption

When a step is blocked:

1. stop that action;
2. checkpoint completed work and the exact blocker;
3. return `SCOPE_MISSING`, `SCOPE_REVIEW_REQUIRED`, `SAFETY_OR_SCOPE_BLOCKED`, `TOOL_UNAVAILABLE`, or `TECHNICAL_BLOCKED`;
4. do not retry through euphemism, rewording, encoding, fragmentation, obfuscation, indirect prompts, or another agent;
5. continue only clearly safe in-scope code, static, local, fixture, documentation, or defensive analysis;
6. request the minimum missing scope fact only when necessary.

Accurate scope statements may reduce ambiguity, but this workflow does not bypass platform safeguards and cannot guarantee that every request will proceed.

## Checkpoints

- TOOLCHAIN/EVAL: `.codex/toolchain-state.md` at meaningful milestones, model switches, pauses/compaction, scope reviews, and pre-integration boundaries.
- CHALLENGE: `.codex/ctf-state.md` at triage completion, major hypothesis changes, model switches, safety/scope blocks, and final verification.

Record facts, files, commands/results, accepted/rejected hypotheses, boundaries, and remaining work. Do not store hidden chain-of-thought.

## Completion

### TOOLCHAIN / EVAL

Return:

- behavior implemented and files changed;
- exact focused validation and fixture provenance;
- integration contract changes;
- scope/safety invariant impact;
- remaining capability gaps and honest unsupported states;
- blockers and next bounded package.

### CHALLENGE

Return:

- challenge type and key evidence;
- exact reproducible local/in-scope steps;
- scripts/files created;
- validation of the final result;
- unresolved assumptions;
- scope statement.

Avoid claiming success when only a hypothesis exists.
