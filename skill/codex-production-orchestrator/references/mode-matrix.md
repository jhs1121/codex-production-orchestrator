# Mode Matrix

Use the selected mode to choose leaf agents. The user's selected main model and reasoning effort are not automatically inherited by agents whose TOML files pin their own model and effort.

| Mode | Recommended main session | Clear implementation | Ambiguous / central work | Verification | Typical use |
|---|---|---|---|---|---|
| DAILY | GPT-5.6 Sol, Extra High/xhigh | `luna_builder` Max | one `luna_explorer`; escalate only after evidence | `luna_verifier` only when risk warrants | normal production work; best throughput/usage balance |
| QUALITY | GPT-5.6 Sol, Max | `luna_builder` Max | `sol_specialist` or `sol_builder` Max on the critical path | one `sol_verifier` Max for high-risk final review | hard tasks where extra capacity should improve judgment, not duplicate routine work |
| ALL_SOL | GPT-5.6 Sol, Max | `sol_builder` Max | `sol_specialist` Max | `sol_verifier` Max | user explicitly wants all-Sol execution or has capacity to spend |
| ULTRA | GPT-5.6 Sol, Ultra | Ultra's native leaf delegation; optional explicit leaf roles | handled by the Ultra coordinator | one focused final gate | large work that genuinely decomposes into parallel branches |

## Selection rules

- Omitted mode means AUTO; AUTO starts from DAILY behavior and adapts to task size/risk.
- Switching the main session to Sol Max does not change `luna_builder`; its TOML remains authoritative.
- Use QUALITY before ALL_SOL. It spends Sol where it changes decisions and leaves mechanical work to Luna.
- Ultra is not simply “more Max.” Do not stack another autonomous coordinator under it.
- Tiny tasks should use one worker regardless of mode.
- Parallelism is for independent ownership. If packages touch the same central files, serialize them.
