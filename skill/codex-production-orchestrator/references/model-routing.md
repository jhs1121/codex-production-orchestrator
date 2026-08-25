# Model Routing

The selected primary model remains the only coordinator. A coordinator choice and a leaf-agent choice are separate decisions: selecting Sol or Terra as the primary does not justify spawning the same expensive model for every leaf.

## Recommended coordinators

- Sol xhigh: normal engineering coordination, architecture, integration, and delivery.
- Terra Max: user-selected read-heavy coordination, forensics, artifact analysis, and corpus planning.
- Sol Max: highly ambiguous, central, or high-risk work.
- Sol Ultra: large work with genuinely independent branches; one orchestration layer only.
- Future models: keep the coordinator-neutral contract and route by capability rather than family name.

## Luna-first leaf policy

For TOOLCHAIN and EVAL, use Luna Max for the first bounded pass whenever the objective is explicit, even when the pass is read-only or spans many files.

Default Luna leaves include:

- bounded implementation, fixtures, adapters, and focused tests;
- repository inventories and capability matrices;
- locating source/tests/benchmarks/contracts;
- first-pass coverage audits and evidence classification;
- focused scope, resource, and false-success review.

Do not choose Terra merely because a repository is large, the task says “audit,” or several repositories must be read. Split the work into bounded Luna slices and reuse their compact handoffs.

## Terra escalation gate

Use `terra_explorer` only when at least one of these is true:

- the user explicitly requests a Terra leaf;
- a Luna audit returns `TERRA_SYNTHESIS_NEEDED` with a concrete unresolved question;
- evidence is materially contradictory across domains or repositories;
- a cross-cutting synthesis cannot be answered from one bounded slice;
- a very large artifact cannot be mapped effectively by a bounded Luna pass.

Normally use at most one Terra synthesis leaf after Luna first-pass audits. Do not fan out several Terra explorers for an ordinary coverage audit. Pass Luna's compact evidence to Terra rather than making Terra repeat the repository tour.

## Parent-model leaves

Unpinned `parent_*` leaves are intended to use the current coordinator's model and effort for one difficult question. Exact resolution can be affected by Codex configuration precedence, so pass the current model/effort explicitly when the runtime supports it and exact inheritance matters.

## Routing disclosure

Before spawning workers, the coordinator must state one compact line such as:

```text
Routing: 3 × ctf_eval_auditor (Luna Max, read-only); Terra escalation disabled unless a Luna handoff justifies it.
```

If escalation occurs, state the exact evidence-backed reason. Do not rely on the UI thread title to reveal the model.
