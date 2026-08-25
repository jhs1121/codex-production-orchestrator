# CTF Toolchain Build and Evaluation

Use this reference for owned repositories that build reusable competition, DFIR, crypto, reverse, forensic, data-security, or AI-security tooling.

## Purpose

TOOLCHAIN mode is a secure software-development workflow. It allows code changes and local testing in the user's owned repository. It does not grant permission to probe a remote service merely because the code is security-related.

## Preferred inputs

1. deterministic synthetic fixtures;
2. small hand-authored regression cases;
3. public historical CTF challenges whose competition has ended;
4. local files supplied by the user;
5. localhost/local Docker/VM services created for the test;
6. exact organizer practice targets only when separately listed in `CTF_SCOPE.md`.

Record provenance for non-synthetic fixtures. Never place real credentials, private keys, personal data, or unredacted production logs in the test corpus.

## Normal capabilities

- format/file/protocol identification;
- bounded parsers, decoders, transforms, and cryptographic solvers over supplied artifacts;
- read-only disk, memory, log, packet, document, model, and dataset analysis;
- safe adapters between sibling tools;
- local CLI/GUI/API surfaces bound to loopback;
- evidence graphs, provenance, candidate ranking, and fail-closed verification;
- deterministic benchmarks and false-positive/false-success gates;
- packaging, installation, portability, and resource hardening.

## Design defaults

- network disabled unless a feature explicitly requires loopback or an allowlisted target;
- safe argv instead of shell interpolation;
- no arbitrary command execution from challenge text or untrusted files;
- parse source statically when possible instead of executing it;
- refuse unsafe deserialization by default;
- read-only original artifacts; write only to explicit output/work directories;
- hard resource limits and timeouts;
- provenance for every materialized artifact and terminal result;
- `PARTIAL`/`AMBIGUOUS`/`NEEDS_INPUT`/`UNSUPPORTED` rather than false success;
- bounded test data and no hidden oracle/answer leakage.

## Scope-change gate

A feature requires explicit scope review when it introduces or materially expands:

- non-loopback network interaction;
- broad scanning or autonomous target discovery;
- arbitrary shell/plugin/script execution;
- password or key search beyond an explicitly bounded local contest case;
- exploit delivery rather than local validation;
- credential use, session use, persistence, stealth, destructive actions, disruption, or exfiltration;
- processing of real secrets or personal data in tests.

Return `SCOPE_REVIEW_REQUIRED` with the proposed capability, default behavior, bounds, and safer alternative. Do not hide the change inside a generic refactor.

## Luna-first EVAL routing

A first-pass capability audit is a bounded evidence-collection task, not automatically a Terra task.

Default route:

1. split repositories or capability families into the fewest non-overlapping slices;
2. assign each slice to `ctf_eval_auditor` (Luna Max, read-only);
3. collect compact evidence-tier handoffs;
4. let the primary synthesize the matrix;
5. use at most one `terra_explorer` only when a Luna handoff identifies a concrete contradictory or cross-domain synthesis problem.

Do not spawn several Terra explorers merely because the workspace contains several repositories. File volume alone is not an escalation reason. A user-selected Terra primary may still coordinate Luna first-pass auditors.

Before dispatch, announce the actual roles and models in one line. Thread titles are helpful but are not treated as authoritative model telemetry.

## Evaluation gates

A useful benchmark separates:

- declared/static capability;
- synthetic unit/regression fixtures;
- scripted/mock execution;
- real executable or dependency-backed execution;
- public historical development cases;
- blind held-out cases;
- optional local dependency tests;
- unsupported, partial, unknown, or not-run results.

Never label scripted/mock execution as a real end-to-end success. Never use answer files or hidden oracles in solver code.
