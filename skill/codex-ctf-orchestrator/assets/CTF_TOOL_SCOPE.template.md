# CTF Tool Development Scope

## Project identity

- Project/repository:
- Owner/maintainer:
- Purpose: reusable local/offline tooling for authorized CTF competition preparation, education, DFIR, or defensive analysis
- Intended users: repository owner and explicitly authorized teammates
- Evidence of ownership/authorization:

## Workflow

- Default workflow: `TOOLCHAIN`
- Optional evaluation workflow: `EVAL`
- This file does **not** authorize any remote target. Use a separate `CTF_SCOPE.md` for an exact organizer target.

## Allowed inputs

- repository source, tests, and documentation;
- local files supplied by the owner;
- deterministic synthetic fixtures;
- public historical CTF challenges with provenance;
- localhost/local Docker/VM services listed below.

Local services allowed for tests:

- 

## Network policy

- Default: disabled
- Loopback/local-container exceptions:
- Non-loopback behavior: prohibited unless an exact `CTF_SCOPE.md` authorizes the target and action

## Allowed capabilities

- 

Examples: bounded parsers/decoders/solvers over supplied artifacts, read-only forensics, safe sibling adapters, local UI/API, deterministic benchmarks, validation and reporting.

## Forbidden capabilities and boundaries

- unrelated real-system targeting;
- credential theft/use, stealth, persistence, self-propagation;
- destructive/disruptive actions or denial of service;
- real-world data exfiltration;
- arbitrary shell/plugin execution from untrusted inputs;
- hidden remote access or scope expansion;
- attempts to bypass platform safeguards.

Project-specific forbidden items:

- 

## Test corpus and privacy

- Synthetic fixtures:
- Public historical fixtures and source:
- Blind/held-out fixtures:
- Real secrets/PII: prohibited unless explicitly redacted and authorized
- Hidden oracle/answer access from solver code: prohibited

## Safety and quality invariants

- fail closed;
- bounded CPU/memory/time/output;
- read-only original inputs;
- explicit output directories;
- provenance for materialized artifacts and terminal results;
- no false `SUCCESS`/`VERIFIED`;
- preserve `PARTIAL`/`AMBIGUOUS`/`NEEDS_INPUT`/`UNSUPPORTED` honestly;
- no unrestricted network or arbitrary execution by default.
