# Production Rules

Use this reference whenever an action may be redundant.

## Evidence question

Before a tool call, ask:

> What unresolved question will this action answer, and will its result change what I do next?

If there is no concrete answer, skip it.

## Verification ladder

Use the lowest rung that can reasonably falsify the change:

1. static/local sanity check;
2. nearest unit or focused test;
3. affected package/module test;
4. integration test covering changed boundaries;
5. full suite or full build.

Climb only when scope, risk, or repository policy warrants it.

## Repeat-action rule

Do not repeat a search, test, build, check, or review because the previous result is merely a few minutes old.

Repeat only when:

- relevant code or configuration changed;
- environment state changed;
- the first result was inconclusive;
- one retry is justified for a known flaky operation;
- a concrete suspected defect requires independent confirmation.

## Context duplication rule

Do not send multiple workers to rediscover the same architecture. Use one targeted exploration, then pass paths, symbols, constraints, and ownership to the implementation workers.

## Scope discipline

A useful action advances an acceptance criterion.

Avoid:

- opportunistic refactors;
- unrelated dependency upgrades;
- whole-repository formatting;
- speculative compatibility layers;
- generic abstractions for a single use;
- duplicate tests that add no confidence;
- proof artifacts nobody consumes;
- review swarms without distinct questions.

## Hash/checksum rule

Use a checksum only when byte identity or integrity is evidence the task actually needs.

Valid examples:

- downloaded release archive verification;
- matching a published digest;
- reproducible artifact identity;
- cryptographic test vectors;
- explicit user or repository requirement.

Invalid examples:

- proving a source file changed;
- proving tests ran;
- proving an agent finished;
- routine end-of-turn ceremony.

## Escalation rule

After two evidence-backed failed repairs on one blocker, return:

- exact failure;
- minimal reproduction;
- evidence gathered;
- suspected cause;
- recommended next action.

The primary then chooses re-scope, stronger model, serial integration, or missing input. Do not perform an unbounded third loop.
