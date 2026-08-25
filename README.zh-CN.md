# Codex Production Orchestrator v1.1

这套工作流同时安装两套可以共存的 Skill：

- `codex-production-orchestrator`：普通开发、修 Bug、重构、集成、任务恢复和最小有效验证；
- `codex-ctf-orchestrator`：CTF 工具链开发、能力评测，以及明确授权的比赛解题。

## 这次最重要的变化

CTF 不再只有“解题模式”。现在会自动区分三种工作流：

```text
TOOLCHAIN  赛前开发自己的 CTF / DFIR / 数据安全 / AI 安全工具
EVAL       用合成 fixture、公开历史题、盲测集做能力验证
CHALLENGE  比赛中分析某一道明确授权的题目或目标
```

日常不需要输入模式参数。Codex 会根据“是在改仓库代码，还是在分析具体题目”自动选择。

## 安装或升级

```bash
cd codex-production-orchestrator
git pull
bash install.sh
bash scripts/doctor.sh user
```

然后彻底退出 Codex，再重新打开。

## 开发 ctf-workbench、cryptomaster、qzmaster、diskmaster、aimaster 等工具

这是 **TOOLCHAIN**，不是 CHALLENGE。

推荐主控：

```text
一般架构、编码、跨仓库集成：GPT-5.6 Sol xhigh
大量阅读、能力盘点、fixture/覆盖率分析：GPT-5.6 Terra Max
很难的算法、根因或关键设计：GPT-5.6 Sol Max
真正可拆成多个独立模块的大任务：GPT-5.6 Sol Ultra
```

明确编码、测试、解析器、适配器和 fixture 默认交给 Luna Max。

你只需要正常说：

```text
继续开发当前 CTF 工具仓库，完成剩余验收条件，不要扩大范围。
```

Skill 会把它理解成：

```text
当前主模型 = 唯一主控
Production Skill = 拆任务、分 ownership、少重复验证
CTF Skill / TOOLCHAIN = 保持本地、离线、合成/历史题测试和仓库安全边界
Luna Max = 做明确的实现、fixture 和局部验证
```

### 建议每个工具仓库只初始化一次

在 `ctf-workbench`、`cryptomaster`、`qzmaster`、`diskmaster`、`aimaster` 等仓库根目录运行：

```bash
bash ~/codex-production-orchestrator/scripts/init-ctf-tool-repo.sh
```

会生成：

```text
CTF_TOOL_SCOPE.md
.codex/toolchain-state.md
```

`CTF_TOOL_SCOPE.md` 只需要填写一次，说明：

- 仓库是谁维护的、用于什么比赛/教学/DFIR；
- 允许的本地文件、合成 fixture、公开历史题；
- 网络默认是否关闭、是否只允许 localhost/local Docker；
- 允许的解析、解码、求解、只读取证、适配器等能力；
- 明确禁止真实第三方目标、凭证窃取、隐蔽、持久化、破坏、外传和任意 shell；
- 测试语料来源、资源上限和“不假报 SUCCESS”的规则。

这会让父 Agent 和所有子 Agent 都拿到同一份准确背景，减少“父线程知道是比赛工具，子线程只看到 exploit/flag/SQLi 字样”的上下文丢失。

## TOOLCHAIN 默认边界

允许的典型工作：

- 解析器、解码器、密码求解器处理用户提供的本地数据；
- PCAP/日志/磁盘/内存/Office/模型导出等只读分析；
- sibling adapter、safe argv、契约、证据链和 verifier；
- 本地 CLI/GUI/loopback API；
- 合成 fixture、公开历史题回归、盲测和 false-positive gate；
- 包装、安装、跨平台、资源限制和稳定性修复。

默认不能悄悄扩成：

- 未列明远程目标扫描或利用；
- 从不可信输入执行任意 shell / plugin / `eval` / `exec`；
- 凭证窃取或使用、隐蔽、持久化、自传播；
- 破坏、拒绝服务、真实数据外传；
- 为了通过安全检查而改写、编码、拆分或隐藏真实意图。

一个新功能如果会突破仓库边界，Worker 应返回 `SCOPE_REVIEW_REQUIRED`，而不是偷偷实现。

## 具体比赛解题

这是 **CHALLENGE**。

推荐主控：

```text
一般题、取证、大量附件：Terra Max
特别模糊、跨领域难题：Sol Max
大型可并行题：Sol Ultra
```

直接说：

```text
这是主办方明确授权的 CTF，只分析提供的题目文件、本地环境和我列出的比赛目标。请使用 CTF orchestrator，并保留阶段状态。
```

涉及远程比赛目标时，在题目目录运行：

```bash
bash ~/codex-production-orchestrator/scripts/init-ctf-workspace.sh
```

填写 `CTF_SCOPE.md` 中的精确域名/IP/端口、比赛时间和禁止范围。

## 工具能力评测

这是 **EVAL**。

优先顺序：

1. 小型合成 fixture；
2. 公开且已经结束的历史赛题；
3. 独立盲测集；
4. 可选本地依赖 smoke。

必须区分 mock/scripted、NOT_RUN、PARTIAL 和真实 E2E；solver 不得读取 oracle/答案文件，也不要把真实密钥、PII 或生产日志放进测试集。

## 安全预警能不能彻底避免

不能保证。Skill 的作用是：

- 准确区分“开发自己仓库”和“对具体目标操作”；
- 把本地/离线/fixture/网络边界传给每个子 Agent；
- 遇到阻断时保存进度，而不是让 Sol 整个调度树报废；
- 不通过换词、编码、拆分或换 Agent 去绕过检查。

如果一项明确的本地、授权开发工作仍然被反复误拦，应记录准确提示、模型、Codex/ChatGPT/API 界面、时间和 request ID，通过官方反馈/Support 处理。个人也可以申请 Trusted Access for Cyber，但获批并不代表所有安全检查都会消失。

## 长上下文与暂停

```text
普通开发：.codex/task-state.md
工具链开发：.codex/toolchain-state.md
具体解题：.codex/ctf-state.md
```

只在大阶段完成、切模型、准备暂停、上下文压缩、安全/范围中断和最终集成前更新；不每改一行就写状态。

## 更新

```bash
cd codex-production-orchestrator
git pull
bash install.sh
bash scripts/doctor.sh user
```

然后重启 Codex。
