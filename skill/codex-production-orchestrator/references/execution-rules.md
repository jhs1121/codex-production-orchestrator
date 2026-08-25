# Execution Rules

Before any tool call ask:

> What unresolved question will this answer, and will the result change the next action?

Skip the action when there is no concrete answer.

## Ownership

- One writer owns a file at a time.
- Shared central files are integrated serially by the primary or one designated owner.
- Existing dirty changes are valuable and must be preserved.
- Stop and report an ownership collision instead of overwriting.

## Evidence reuse

Do not repeat search, build, test, review, or benchmark merely because time passed. Repeat only after relevant code/config/environment changed, the first result was inconclusive, a bounded flaky retry is justified, or a new concrete defect hypothesis exists.

## Scope

Avoid unrelated cleanup, dependency upgrades, broad formatting, speculative abstractions, duplicate tests, proof artifacts nobody consumes, and verifier swarms.

## Hashes

Checksums are valid only when byte identity/integrity is an actual acceptance criterion: published digest, release artifact, reproducibility, cryptographic vector, or explicit requirement. They are invalid as proof that an agent finished.

## Loop bound

After two evidence-backed failed repairs for the same blocker, return the exact failure, reproduction, evidence, suspected cause, and next route. Do not perform an unbounded third loop.
