# Codex Production Orchestrator v1.0

这是给你自己长期使用的 **Codex 高产工作流最终稳定版**。它同时安装两套可以共存、职责不冲突的 Skill：

- `codex-production-orchestrator`：普通开发、修 Bug、重构、迁移和工具开发；
- `codex-ctf-orchestrator`：明确授权的 CTF、主办方题目、本地 Docker/VM 和列明范围的比赛靶场。

CTF Skill 管 **授权范围、题型路由和中断恢复**；Production Skill 管 **任务拆分、Agent 调度、文件 ownership 和最小有效验证**。

## 安装或升级

你已经 clone 过仓库：

```bash
cd codex-production-orchestrator
git pull
bash install.sh
bash scripts/doctor.sh user
```

然后彻底退出 Codex，再重新打开。

首次安装：

```bash
git clone https://github.com/jhs1121/codex-production-orchestrator.git
cd codex-production-orchestrator
bash install.sh
```

## 你只需要记住这些

### 普通开发

推荐主控：`GPT-5.6 Sol xhigh`。直接说：

```text
继续开发当前项目，完成剩余验收条件，不要扩大范围。
```

### 一般 CTF、取证、大量文件分析

推荐主控：`GPT-5.6 Terra Max`。直接说：

```text
这是主办方明确授权的 CTF，只分析提供的题目文件、本地环境和我列出的比赛目标。
请使用 CTF orchestrator 分析，并保留阶段状态。
```

### 特别难、线索高度模糊的题

把当前主控切成 `GPT-5.6 Sol Max`，然后继续原会话即可。Skill 不会把你强制切回别的模型。

### 大型、能真正并行拆分的任务

选择 `GPT-5.6 Sol Ultra`。Ultra 自己负责原生多 Agent 调度；Skill 只约束 ownership、重复工作和最终验收，不再套第二层总调度器。

### 恢复暂停任务

```text
继续当前任务，保留现有改动、已有结论和验证证据，不要从头研究。
```

## Terra Max + Luna Max 怎么工作

```text
Terra Max（当前主控）
    ├─ Luna Max：明确脚本、解析器、局部实验
    ├─ Luna Max：独立题目线索或文件分析
    ├─ Terra Max explorer：宽范围只读探索
    └─ parent specialist：继承当前主控模型处理真正难点
```

`parent-*` Agent 不固定模型；通常继承当前主控。为了避免你自己的全局 Agent 默认值改变继承结果，Skill 在需要时会要求显式使用当前主控模型和思考强度启动它。

## CLI 快捷启动（可选）

```bash
codex --profile cpo-daily    # Sol xhigh
codex --profile cpo-terra    # Terra Max
codex --profile cpo-quality  # Sol Max
codex --profile cpo-ultra    # Sol Ultra
```

在 Codex 界面手动选模型同样有效，不必使用 profile。

## 长上下文与暂停恢复

Skill 本体保存在磁盘，不依赖几十万 Token 之前的聊天内容。真正容易变模糊的是“项目做到哪里”。因此只在大阶段完成、准备暂停或切模型、上下文压缩、安全中断和最终集成前写轻量 checkpoint：

- 普通开发：`.codex/task-state.md`
- CTF：`.codex/ctf-state.md`

只记录目标、事实、证据、剩余工作和下一步，不记录冗长思考过程，也不会每改一行就更新。

## CTF 范围文件

纯本地题目可以只在提示里明确授权。涉及远程比赛目标时，建议在题目目录运行：

```bash
bash scripts/init-ctf-workspace.sh
```

然后填写生成的 `CTF_SCOPE.md`：比赛/平台、主办方说明、精确域名/IP/端口、时间窗口和禁止范围。

所有 CTF 子代理必须收到同一份精简 `AUTH_SCOPE`，防止父 Agent 知道是 CTF、子 Agent 却只看到“拿 flag”而失去授权上下文。

## 安全中断怎么处理

这套 Skill **不会绕过安全检查**。如果某一步被范围或安全系统阻断，它会：

1. 保存已经完成的安全工作和证据；
2. 标记 `SAFETY_OR_SCOPE_BLOCKED`；
3. 不通过改写、编码、拆分、换 Agent 等方式重试同一受阻动作；
4. 继续做仍然安全且在范围内的静态分析；
5. 只有在确实缺少范围信息时才要求补充。

这不能保证平台永不阻断，但能避免一次 Worker 中断让整个题目的进度丢失。

## 默认禁止

- 例行 SHA/checksum 完成仪式；
- 相关代码没变却重复跑同一测试；
- 每改一点就跑全量测试；
- 多个 Agent 重复扫描同一仓库；
- 多个 Writer 抢同一批文件；
- 小任务启动一群 Agent；
- Planner 套 Planner、Verifier 套 Verifier；
- 同一阻塞无限循环；
- 为了通过安全检查而重写或隐藏真实意图。

## 更新

```bash
cd codex-production-orchestrator
git pull
bash install.sh
```

然后重启 Codex。

## 卸载

```bash
bash uninstall.sh
```

只删除本仓库安装的 Skill、Agent、profiles 和托管规则，不动其他 Codex 配置。
