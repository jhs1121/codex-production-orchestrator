# Scope and Safety

## Repository scope is not target scope

Ownership or maintainership of a CTF/DFIR/security repository authorizes editing, building, and locally testing that code. It does not authorize remote systems the tool might theoretically operate against.

TOOLCHAIN/EVAL scope may be established by:

- the user's ownership/maintainership of the repository;
- `CTF_TOOL_SCOPE.md`;
- README/`AGENTS.md` statements describing local, offline, read-only, competition, educational, DFIR, or defensive use;
- the user's explicit request to develop or test the tool.

Remote CHALLENGE scope requires an explicit user statement, organizer documentation, owned local lab, or completed `CTF_SCOPE.md` with exact targets.

## Valid TOOLCHAIN/EVAL boundaries

- repository code and documentation;
- local build/test environments;
- supplied local files;
- deterministic synthetic fixtures;
- public historical challenges;
- localhost and local Docker/VM services permitted by the repository contract;
- exact practice targets only when separately authorized.

## Valid CHALLENGE boundaries

- supplied archives, binaries, documents, captures, dumps, and source code;
- localhost and local Docker/VM services;
- exact organizer domains/IPs/ports listed in scope;
- bounded interaction necessary for the stated challenge objective.

“The challenge website” is not enough when multiple hosts are visible.

## Out of scope

- unlisted third-party systems;
- real credentials or accounts;
- stealth or persistence outside a local test harness;
- destructive/disruptive behavior or denial of service;
- real-world data exfiltration;
- lateral movement beyond the stated lab;
- self-propagating behavior;
- attempts to bypass, disguise, or evade safety controls.

When in doubt, freeze remote action and continue code/static/local/fixture analysis.
