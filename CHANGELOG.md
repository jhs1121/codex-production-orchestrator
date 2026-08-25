# Changelog

## 1.1.1 — 2026-08-25

- Made TOOLCHAIN/EVAL leaf routing Luna-first, including first-pass read-only capability audits.
- Added `ctf_eval_auditor`, a pinned Luna Max read-only evidence auditor.
- Added an evidence gate for Terra escalation and limited ordinary EVAL waves to at most one Terra synthesis leaf.
- Required a compact routing disclosure before worker dispatch so intended role/model/count is visible without relying on UI titles.
- Clarified that upgrading does not require reinitializing existing CTF tool workspaces.

## 1.1.0 — 2026-08-25

- Added automatic CTF workflows: `TOOLCHAIN`, `EVAL`, and `CHALLENGE`.
- Distinguished owned CTF/DFIR tool development from solving a specific challenge.
- Added `CTF_TOOL_SCOPE.md` and `.codex/toolchain-state.md` templates plus an initializer.
- Added bounded Luna Max leaves for tool implementation, synthetic fixtures, and scope-focused review.
- Made toolchain development local/offline by default; remote target interaction still requires exact challenge scope.
- Added scope-preserving worker packets for security-tool development without safety-evasion retries.
- Updated installer, doctor, self-test, uninstall, and documentation for the new workflow.

## 1.0.0 — 2026-08-25

- Added composable Production and authorized CTF Skills.
- Removed the hard-coded Sol coordinator assumption.
- Added first-class Terra Max coordinator support.
- Added pinned Luna leaves and unpinned parent-model specialists.
- Added single-layer Ultra behavior.
- Added durable task and CTF checkpoints.
- Added authorization envelopes for every CTF leaf.
- Added safety-aware interruption recovery without evasion retries.
- Added CTF workspace initialization and scope templates.
- Hardened installer, doctor, self-test, update, and uninstall flows.
