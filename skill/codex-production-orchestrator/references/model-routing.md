# Model Routing

The selected primary model remains the coordinator.

## Recommended patterns

- Sol xhigh: normal engineering coordination.
- Terra Max: read-heavy exploration, forensics, artifact analysis, and cost-efficient coordination.
- Sol Max: highly ambiguous, central, or high-risk work.
- Sol Ultra: large work with genuinely independent branches; one orchestration layer only.
- Future models: keep the same coordinator-neutral contract and route by capability, not hard-coded family name.

## CTF toolchain patterns

- Sol xhigh: normal tool architecture, integration, and release coordination.
- Terra Max: read-heavy coverage audits, large fixture/corpus mapping, and forensic parser review.
- Sol Max: difficult solver design, ambiguous algorithm choices, or critical boundary review.
- Luna Max: bounded implementation, fixtures, adapters, and focused tests.

## Leaves

Pinned leaves:

- Luna Max for clear bounded throughput.
- Terra Max for purposeful read-heavy exploration.
- Sol Max aliases only when explicitly requested.

Unpinned `parent_*` leaves are intended to use the current coordinator's model and effort. Exact resolution can be affected by Codex configuration precedence, so pass the current model/effort explicitly when the runtime supports it and exact inheritance matters.

Escalate because new judgment is needed, not merely because a task has been running for a while.
