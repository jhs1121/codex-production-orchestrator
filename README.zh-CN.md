# Codex Production Orchestrator

让 Codex **少折腾、多产出**：主线程负责理解、拆分、派工和验收，Luna Max 负责大部分实际编码；禁止例行 SHA、重复全量测试、重复搜索和无意义验证。

## 你只需要这样安装

```bash
git clone git@github.com:jhs1121/codex-production-orchestrator.git
cd codex-production-orchestrator
./install.sh
```

安装完成后 **重启 Codex**。

以后正常打开 Codex、选择你想用的主模型，然后直接说开发任务即可。默认不需要输入任何 `MODE=` 参数。

## 平时怎么工作

最推荐：

```text
主线程：GPT-5.6 Sol xhigh
实际开发：GPT-5.6 Luna Max 子代理
```

Skill 会自动按任务大小处理：

- 很小任务：只派 1 个 Luna Builder，不开一堆 Agent；
- 可并行任务：按文件/模块 ownership 派 2～3 个 Luna Builder；
- 复杂疑难点：必要时才调用 Sol Max specialist；
- 高风险改动：必要时才做一次独立 verifier；
- 最终只做真正需要的集成验证。

主线程尽量不和 worker 重复写同一份代码，也不会为了“证明完成”反复跑 SHA、全量测试和重复搜索。

## 以前做到一半的任务

恢复旧会话后直接说：

```text
继续这个任务，用 production orchestrator 接管，保留现在的改动，不要从头做。
```

它会先看当前目标、`git status`、相关 diff 和已有验证，只继续剩余工作。它不会追溯改变暂停之前已经发生的动作，也不会自动接管一个仍在运行的旧子 Agent。

## 如果我主线程选 Sol Max 呢？

照常用，不需要改命令。

默认策略仍然是：机械、清晰的开发交给 Luna Max；真正需要更强判断的架构、并发、安全、迁移、复杂根因等才升级给 Sol Max 子代理。这样通常比“所有活都让 Sol 做”更划算。

如果你明确想把额度花掉，可以直接告诉 Codex：

```text
这个任务全部使用 Sol Max 子代理，不要降级到 Luna。
```

Skill 仍会限制重复探索、重复测试和无意义并发。

## 如果主线程选 Sol Ultra 呢？

也正常用。

Ultra 自己已经会主动使用子代理，因此 Skill 的重点会变成：

- 不再叠第二套总调度器；
- 子代理不继续套娃派子代理；
- 不让多个 Agent 重复调查同一个问题；
- 按 ownership 并行；
- 最后只做一次有意义的集成 Gate。

## 更新

以后仓库有新版本，只需要：

```bash
cd codex-production-orchestrator
git pull
./install.sh
```

然后重启 Codex。

## 检查安装

```bash
./scripts/doctor.sh user
```

看到：

```text
TOML OK
Installation OK
```

说明 Skill 和自定义 Agent 文件已经安装到预期位置。

## 高级用法

如果你确实想手动控制，还保留：

- `MODE=DAILY`
- `MODE=QUALITY`
- `MODE=ALL_SOL`
- `MODE=ULTRA`
- `RESUME=TAKEOVER`

但这些都属于高级覆盖项，**日常不用记**。详见英文 README 与 `skill/.../references/`。

## 核心原则

每次搜索、测试、构建、review、重试之前先问：

> 这个动作要回答哪个尚未解决的问题？结果会改变下一步吗？

如果答案是否定的，就不要做。
