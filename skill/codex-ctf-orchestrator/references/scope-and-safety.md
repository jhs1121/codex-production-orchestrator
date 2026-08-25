# Scope and Safety

Valid scope evidence includes an explicit user statement that this is an organizer-provided CTF, a local owned lab, challenge documentation, or a completed `CTF_SCOPE.md`.

Remote actions require exact targets. “The challenge website” is not enough when multiple hosts are visible.

Allowed examples:

- supplied archives, binaries, documents, captures, dumps, source code;
- localhost and local Docker/VM services;
- exact organizer domains/IPs/ports listed in scope;
- bounded interaction necessary for the challenge objective.

Out of scope:

- unlisted third-party systems;
- real credentials or accounts;
- persistence outside the challenge;
- destructive/disruptive behavior;
- denial of service;
- real-world data exfiltration;
- lateral movement beyond the stated lab;
- attempts to bypass safety controls.

When in doubt, freeze remote action and continue artifact-only analysis.
