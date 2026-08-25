# Codex Production Orchestrator v1.1.1

这套工作流同时安装两套可以共存的 Skill：

- `codex-production-orchestrator`：普通开发、修 Bug、重构、集成、任务恢复和最小有效验证；
- `codex-ctf-orchestrator`：CTF 工具链开发、能力评测，以及明确授权的比赛解题。

## 本次修复：EVAL 改为 Luna-first

TOOLCHAIN / EVAL 的普通子任务现在默认是：

```text
第一轮仓库/能力盘点  → ctf_eval_auditor（Luna Max，只读）
明确编码和适配器    → Luna Max
fixture / benchmark  → Luna Max
聚焦审查             → Luna Max
Terra 子代理          → 仅证据触发的综合升级
```

仓库多、文件多、任务是只读盘点，都不再自动等于 Terra。只有 Luna 已返回具体冲突或跨领域综合问题，或者你明确要求 Terra 子代理时，才会追加 Terra；普通一轮最多一个 Terra 综合任务。

主控仍由你自己选择。Sol xhigh、Terra Max、Sol Max 或 Sol Ultra 都可以当主控；即使主控是 Terra，明确子任务仍默认交给 Luna。

## 子代理模型怎么确认

主代理派发前必须输出类似：

```text
Routing: 3 × ctf_eval_auditor (Luna Max, read-only); Terra 仅在 Luna 证据表明需要综合时升级。
```

这行是预期路由的依据，不再依赖 UI 自动生成的子线程名称猜模型。

## 升级方式

```bash
cd ~/codex-production-orchestrator
git pull
bash install.sh
bash scripts/doctor.sh user
```

然后彻底退出 Codex，再重新打开。

## 不需要重新初始化“任务继续”目录

你已经生成的：

```text
CTF_TOOL_SCOPE.md
.codex/toolchain-state.md
```

继续有效。升级后**不需要**再次运行 `init-ctf-tool-repo.sh`。该脚本只在新的工具仓库或新的多仓库父工作区第一次使用时运行一次。

## 已暂停的旧 Terra 子代理

暂停的子代理不会因为升级自动变成 Luna。升级后不要继续恢复旧的 Terra-first EVAL 线程；已返回的证据可以复用，只把仍缺失的盘点包重新派给 `ctf_eval_auditor`。

可直接对主代理说：

```text
继续当前 EVAL。不要恢复旧的 Terra-first 子线程。
复用已有证据，只把仍缺失的仓库/能力切片派给 ctf_eval_auditor（Luna Max，只读）。
不要从头重扫，不读取 oracle/答案/题解，不访问网络。
```

## 三种 CTF 工作流

```text
TOOLCHAIN  开发自己的 CTF / DFIR / 数据安全 / AI 安全工具
EVAL       合成 fixture、公开历史题、盲测和真实能力验证
CHALLENGE  分析某一道明确授权的比赛题目或目标
```

## 主模型建议

```text
一般工具开发、跨仓库集成：Sol xhigh
你明确希望 Terra 负责主控综合：Terra Max
困难算法、根因、关键设计：Sol Max
真正可拆成独立模块的大任务：Sol Ultra
```

无论主控选谁，普通 Builder、EVAL auditor、fixture 和 reviewer 都默认 Luna Max。

## 安全边界

TOOLCHAIN / EVAL 默认只使用你维护的代码、本地文件、合成 fixture、已结束的公开历史题，以及明确允许的 localhost / 本地 Docker / VM。仓库所有权只授权代码修改和本地测试，不授权任何未列明远程目标，也不会通过换词、编码、拆分或换 Agent 绕过安全检查。
