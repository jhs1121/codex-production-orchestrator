# Codex Production Orchestrator v1.0

A stable, coordinator-neutral Codex workflow with two composable Skills:

- `codex-production-orchestrator` for engineering execution;
- `codex-ctf-orchestrator` for explicitly authorized CTF challenges and local labs.

The CTF Skill owns authorization scope, challenge routing, and interruption recovery. The Production Skill owns task sizing, non-overlapping ownership, agent routing, and focused validation.

Chinese guide: [README.zh-CN.md](README.zh-CN.md)

## Install / upgrade

```bash
git clone https://github.com/jhs1121/codex-production-orchestrator.git
cd codex-production-orchestrator
bash install.sh
bash scripts/doctor.sh user
```

Restart Codex after installation.

## Normal use

No mode flag is required. The user's currently selected primary model remains the sole coordinator.

Recommended starting points:

- normal engineering: GPT-5.6 Sol xhigh;
- read-heavy CTF, forensics, artifact triage: GPT-5.6 Terra Max;
- highly ambiguous or difficult work: GPT-5.6 Sol Max;
- genuinely decomposable large work: GPT-5.6 Sol Ultra.

Pinned Luna Max leaves handle clear bounded work. Parent-model leaves are unpinned and are used only when stronger coordinator-level judgment materially helps. Ultra uses one orchestration layer.

## Resume

```text
Continue the current task. Preserve existing changes, conclusions, and validation evidence. Do not restart from zero.
```

## Authorized CTF

```text
This is an organizer-authorized CTF. Work only on the supplied artifacts, local lab, and the exact competition targets I list. Use the CTF orchestrator and keep durable checkpoints.
```

For remote targets, initialize and fill `CTF_SCOPE.md`:

```bash
bash scripts/init-ctf-workspace.sh
```

A safety or scope block is checkpointed and not retried through rewording, encoding, fragmentation, or another agent.

## Optional profiles

```bash
codex --profile cpo-daily
codex --profile cpo-terra
codex --profile cpo-quality
codex --profile cpo-ultra
```

## Update

```bash
git pull
bash install.sh
```
