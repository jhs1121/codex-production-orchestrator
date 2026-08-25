# Codex Production Orchestrator v1.1.1

A coordinator-neutral Codex workflow with two composable Skills:

- `codex-production-orchestrator` for engineering execution;
- `codex-ctf-orchestrator` for owned CTF/DFIR toolchain development, evaluation, and explicitly authorized challenge work.

Chinese guide: [README.zh-CN.md](README.zh-CN.md)

## CTF workflows

The CTF Skill automatically distinguishes:

- `TOOLCHAIN`: develop, integrate, package, and harden an owned local/offline CTF or defensive-security tool;
- `EVAL`: synthetic/public-historical fixtures, regression gates, blind evaluation, and capability measurement;
- `CHALLENGE`: one explicitly authorized organizer challenge, local lab, supplied artifact set, or exact target.

No mode flag is required for normal use.

## Install / upgrade

Upgrading from v1.1 does not require rerunning `init-ctf-tool-repo.sh`; existing scope and state files are preserved.

```bash
git clone https://github.com/jhs1121/codex-production-orchestrator.git
cd codex-production-orchestrator
bash install.sh
bash scripts/doctor.sh user
```

Restart Codex after installation.

## Toolchain development

Recommended coordinators:

- Sol xhigh: normal architecture, coding, and multi-repository integration;
- Terra Max: user-selected read-heavy coordination, forensics, and corpus planning;
- Sol Max: difficult algorithm or root-cause work;
- Sol Ultra: large work with genuinely independent modules.

Leaf routing is Luna-first. Pinned Luna Max leaves handle bounded implementation, fixtures, focused review, repository inventories, and first-pass capability audits. Large file count or read-only work alone no longer triggers Terra leaves. Normally at most one Terra synthesis leaf is used after a Luna handoff identifies a concrete contradictory or cross-domain question, or when the user explicitly requests Terra leaves.

Initialize an owned tool repository once:

```bash
bash ~/codex-production-orchestrator/scripts/init-ctf-tool-repo.sh
```

This creates `CTF_TOOL_SCOPE.md` and `.codex/toolchain-state.md`. Repository ownership authorizes code changes and local tests; it does not authorize remote systems. Network access is off by default, with explicit loopback/local-container exceptions. A non-loopback target requires a separate exact `CTF_SCOPE.md` and CHALLENGE workflow.

## Luna-first evaluation

For EVAL, use `ctf_eval_auditor` (Luna Max, read-only) for bounded repository/capability slices. The coordinator must announce the intended role/model count before dispatch. Use a Terra leaf only after a Luna handoff reports a concrete synthesis blocker or when the user explicitly requests it; do not fan out several Terra explorers for an ordinary coverage audit.

## Challenge work

```text
This is an organizer-authorized CTF. Work only on the supplied artifacts, local lab, and the exact competition targets I list. Use the CTF orchestrator and keep durable checkpoints.
```

For remote targets:

```bash
bash ~/codex-production-orchestrator/scripts/init-ctf-workspace.sh
```

A safety/scope block is checkpointed and is not retried through euphemism, rewording, encoding, fragmentation, obfuscation, or another agent.

## Update

```bash
git pull
bash install.sh
bash scripts/doctor.sh user
```
