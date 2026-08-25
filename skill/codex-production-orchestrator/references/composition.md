# Skill Composition

Multiple Skills may be active when their responsibilities do not conflict.

For CTF-related work:

1. CTF Skill selects TOOLCHAIN, EVAL, or CHALLENGE.
2. TOOLCHAIN/EVAL defines `TOOL_SCOPE`, repository purpose, local/default network policy, test corpus, allowed capabilities, forbidden capabilities, and safety invariants.
3. CHALLENGE defines `AUTH_SCOPE`, exact target boundaries, hypotheses, evidence, and recovery codes.
4. Production Skill sizes packages, assigns ownership, chooses leaves, and limits redundant work.
5. Every leaf receives the complete relevant scope packet.
6. If a Production rule would broaden the CTF scope, the CTF scope wins.
7. Repository ownership permits code changes and local tests; it does not authorize remote systems.
8. There is still exactly one primary coordinator.
