# Codex Production Orchestrator v0.3

A high-throughput Codex Skill designed to maximize useful engineering output while suppressing redundant searching, repeated full-suite testing, checksum ceremony, duplicated agent work, and unnecessary orchestration overhead.

Chinese quick start: [README.zh-CN.md](README.zh-CN.md)

## Quick start

```bash
git clone git@github.com:jhs1121/codex-production-orchestrator.git
cd codex-production-orchestrator
./install.sh
```

Restart Codex after installation. Then use Codex normally; no mode flag is required for day-to-day work.

Recommended baseline:

```text
Main session: GPT-5.6 Sol xhigh
Leaf implementation: GPT-5.6 Luna Max
```

The Skill auto-sizes orchestration, keeps ownership non-overlapping, escalates to Sol only when stronger judgment is useful, reuses existing evidence, and uses the narrowest validation that can falsify a change.

## Resume existing work

After reopening an old task, say:

```text
Continue this task using production orchestrator. Preserve the current changes and do not restart from zero.
```

The takeover workflow inventories the current worktree and continues only remaining acceptance criteria.

## Main session on Sol Max or Ultra

No special command is required. Auto mode adapts its policy:

- Sol Max: keep clear implementation on Luna; use Sol leaf agents only on the critical path.
- Sol Ultra: do not build a second autonomous coordinator hierarchy; keep delegation one layer deep and ownership-based.

To explicitly force all-Sol execution, ask for it or invoke `MODE=ALL_SOL`.

## Update

```bash
git pull
./install.sh
```

Then restart Codex.

## Validate

```bash
./scripts/doctor.sh user
```

Advanced explicit overrides remain available: `MODE=DAILY`, `MODE=QUALITY`, `MODE=ALL_SOL`, `MODE=ULTRA`, and `RESUME=TAKEOVER`, but they are not required for normal use.
