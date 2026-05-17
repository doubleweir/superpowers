# Changelogs

> **真源位置**：与 `CLAUDE.md` 同目录，**`superpowers/5.0.7/changelogs.md`**。自迁移后起在此路径维护；旧路径 `superpowers/changelogs.md` 仅作跳转。

## 目录

**阅读方式**：下表**自上而下 = 新 → 旧**。「**这版解决什么**」用一句话写清，便于对照看要不要升级/对齐；**技术标签与 commit** 只在各节**正文开头**用一行标注，不占用标题。首条是**本文件与发版怎么同步**的说明。

| 这版在解决什么 | 点入正文 |
| --- | --- |
| **宿主接线（wire）**：`full-sync` 第三步把 fork `hooks.json` 写入项目 settings；overlay 优先 resolver；No.18 hotfix Stop 自动生效 | [→ 打开](#sec-20260517-host-wire) |
| **CWS 发布链（No.19）**：main 上 rebuild+commit `.output` 再 tag/CWS；`cws-artifact-sync-guard`；finishing Step 2.55b | [→ 打开](#sec-20260517-cws-artifact-sync) |
| **已发布子产品 hotfix（R1/R2/H7）**：与常规 PR 同形；brainstorming 三选一；`hotfix-flow` 薄编排；并行下一版本 Stop 双 hook | [→ 打开](#sec-20260517-published-hotfix-flow) |
| **ChatGPT 真机 Chrome 验证**：独立调试 Profile + DevTools MCP workflow + `launch-chatbobi-chrome.sh` + debug bridge 诊断命令 | [→ 打开](#sec-20260515-chatgpt-chrome-verify) |
| 本 **changelog** 与 **发版 tag** 怎么写、新条目往哪插 | [→ 打开](#sec-how-to-maint) |
| **ChatBobi 仓库**：Runtime Sync **首次落盘**（`MANAGED_FILES.txt` / `capture`→overlay / `deploy latest`）、`.gitignore` 放行清单；根 `changelogs.md` 写明 **「完整 Runtime Sync」** 默认口径（含落盘 ChatBobi，非仅 fork 发版） | [→ 打开](#sec-20260515-chatbobi-runtime-sync) |
| **2026-05-15 发版**：工作区归并 — `test-acceptance-gate` 平台验收路径、evolution closure 脚本、`using-superpowers` 增补、fork `LESSONS.md`、Clockworkman 内稿、模板与回归测试 | [→ 打开](#sec-20260515-release-wip) |
| **main 上 UserPromptSubmit 门禁纠偏 + 阶段自动化**：不误拦 brainstorming/布局话术；`workflow-phase-auto` 写 `.superpowers/workflow-phase`；`feat/pv|wv|chatbobi-v…` 与 docs 版本根对齐 | [→ 打开](#sec-20260514-main-workflow-gates) |
| **Spec「Superpowers pipeline」**：`Full extension acceptance pipeline` Yes/No；`No` 豁免三测顺序 / manifest 报告 / 包版本漂移；Figma 仍按 plan | [→ 打开](#sec-20260507-superpowers-pipeline-spec) |
| **SessionStart evolution**：候选计数与 `Status` 对齐；keeper / `using-superpowers` no-op 呈现约定；`test-check-evolution` 回归 | [→ 打开](#sec-20260507-evolution-hook-count) |
| `/figma-read`：**官方 `figma`（远程）** 与 **`figma-desktop`（本机 3845）** 双 MCP 命名、推荐配置与仅装插件时的备选 | [→ 打开](#sec-20260430-figma-read-mcp-dual) |
| **Runtime Sync 真源、缓存防误改、SessionStart 反馈索引兼容一起补齐**：补 manual、补远端清理、阻止直接改 runtime cache，并修复 `check-evolution` 对表格格式 feedback index 的兼容 | [→ 打开](#sec-20260430-runtime-sync-hardening) |
| **验收顺序 hook 不再误拦普通对话**：只在明确启动 `autotest/mocktest/devicetest` 时拦截，讨论测试和引用历史报错不再被 `UserPromptSubmit` 误判 | [→ 打开](#sec-20260428-acceptance-false-positive) |
| **Superpowers 维护任务先走 Runtime Sync**：在 fork / overlay / installed cache 三层之间建立固定路由，并用 submit hook 主动提醒 | [→ 打开](#sec-20260428-runtime-sync-route) |
| **确认门误报**、**重复催促** 与 **本地/云端治理**：`Acceptance status` 状态回写不再误触发 spec confirm；user-owned stop block 只提醒一次后静默等待；补齐本地库/云端库的回滚、拉取、合并模型 | [→ 打开](#sec-20260428-confirm-gate) |
| **Figma URL 读回** 与 **Live Design Sync** 闭环：Design Draft 先 `/figma-read`，UI 计划尾部 PR 升级为 `Figma Live Design Sync` | [→ 打开](#sec-20260426-figma-live-sync) |
| **三验收** 只以版本文件里 **`## Acceptance status (hooks)`** 为准；**Stop** 不允许「只写 autotest/mocktest 单词、无 pass/fail」混过去 | [→ 打开](#sec-20260423-acceptance) |
| **Hook/测试** 更稳：nullglob、多语言状态、**spec 路径**；脚本的 **run_with_timeout / PIPESTATUS** 等 | [→ 打开](#sec-20260423-hooks) |
| 在业务里**没调 skill** 仍被 **Stop/Submit 打断**：是 **Hook 在跑**，不是「坏了」；怎么关/怎么满足 | [→ 打开](#sec-20260423-skill-myth) |
| **演化闭环 + spec 变更** 相关门禁；**test-evolution / spec-gate** 等测试补齐 | [→ 打开](#sec-20260422-evo) |
| **Git 回退/分支/合并** 怎么操作：只**读文档**、不带动插件逻辑 | [→ 打开](#sec-20260422-git) |
| 外部规则 **单条注入**、Review 硬基线、条件 **发布前隐私** 小门 | [→ 打开](#sec-20260421-inject) |
| **进化结果** 落到根目录 **LESSONS.md**，与 feedback 五层对账 | [→ 打开](#sec-20260421-lessons) |
| **Brainstorming** 多材料、Figma、对话边界 | [→ 打开](#sec-20260421-brain) |
| 测试用例级 **Test Point/Expected/Assertion** 等 **Stop 强拦** | [→ 打开](#sec-20260421-qa-fields) |
| **Stop 阻断** 输出可解析 JSON、负向用例 | [→ 打开](#sec-20260421-stop-json) |
| 契约**逐用例**检测、防**口径回退** | [→ 打开](#sec-20260421-contract-breadth) |
| **混合兜底**、一揽子**测试加锁** | [→ 打开](#sec-20260421-bulk) |
| 多 **PR** 时 **active PR 上下文**、**PRn 回归** 怎么绑 | [→ 打开](#sec-20260421-prloop) |
| **环境变量/标记** 写哪、**契约测试** 防回退 | [→ 打开](#sec-20260421-prpaste) |
| 中英文/称谓等 **二轮** 小尾项 | [→ 打开](#sec-20260420-pass2) |
| **七步** canonical、hook **非零**、**worktree=基础设施** | [→ 打开](#sec-20260420-seven) |
| **Brainstorming** 材料分流、**版本容量**、**Visual** 策略 | [→ 打开](#sec-20260420-brain-mat) |
| 重要过程都要写进**同版本 changelog** | [→ 打开](#sec-20260420-chlog-rule) |
| 审阅/设计稿等 **文件命名** 与 **中/EN 分层** | [→ 打开](#sec-20260420-names) |
| 进化**闭环** 迁到 **LESSONS + feedback** | [→ 打开](#sec-20260420-evo-migrate) |
| **生产化** 与澄清、进化**前序** | [→ 打开](#sec-20260420-prod) |
| **evolution-keeper** 角色**落地** | [→ 打开](#sec-20260420-keeper) |
| 测试**证据**、**门禁**试点、用例可**机器**判 | [→ 打开](#sec-20260420-testgate) |
| 起版 **5.0.7**：**版本/PR/Task 文档** + **七步** **硬**约束 | [→ 打开](#sec-20260420-507) |

<a id="sec-20260517-host-wire"></a>
## 宿主接线：fork 改完 hook 须在项目 settings 自动挂上（No.18 wire）

> **发版**：与 hotfix / CWS 同批 `sp-v5.0.7-xia-*` tag；ChatBobi `full-sync latest` 已含 wire 步骤。

### 结论

`capture` + `deploy` 只把脚本放进 overlay/cache；**Claude 项目**仍读 `.claude/settings.local.json`。新增 **`scripts/wire-host-project-hooks.sh`**（apply / verify / smoke / install-runner）与 **`scripts/run-superpowers-hook-host.sh`**（overlay → cache → backup 仅 host-only）。宿主提供 **`host-hook-wiring.json`**（ChatBobi 专属 hook 与插入点）。`full-sync` 末尾应执行 wire，使 No.18 **`hotfix-parallel-sync-guard`**、**`next-minor-behind-main-guard`** 等在 Stop 链生效。

### 模块

| 路径 | 说明 |
|------|------|
| `scripts/wire-host-project-hooks.sh` | 合并 overlay `hooks.json` + 宿主 wiring → settings |
| `scripts/run-superpowers-hook-host.sh` | 安装到宿主 `hooks-backup/run-superpowers-hook` |
| `docs/host-integration.md` | 三步流水线说明 |
| `skills/hotfix-flow/SKILL.md` | Host deployment（wire）小节 |
| `hooks/superpowers-runtime-sync-reminder` | UserPromptSubmit 提醒改为 **full-sync latest**（含 wire+verify），与三步流水线一致 |

### 验证

- `bash tests/claude-code/test-superpowers-runtime-sync-reminder.sh`
- ChatBobi：`wire-host-project-hooks.sh verify` + `smoke`（含 `test-hotfix-parallel-sync.sh`）
- 勿在 `hooks-backup/` 长期保留与 overlay 同名的托管 hook 副本

<a id="sec-20260517-cws-artifact-sync"></a>
## CWS 发布必须与 git `.output` 一致（No.19 / project2feedback）

> **发版**：待下一枚 `sp-v5.0.7-xia-*` tag；与 hotfix § 同批 sync。

### 结论

常规版本与 hotfix **共用**发布纪律：禁止 worktree 临时 build 直传 CWS。在 **`main`** 上 `npm run build` → **commit** `app/plugin/.output/` → 再打 `plugin/pv*` / `*-hf*` tag → CWS 只从该 commit 的 `.output/` 打包。

### 模块

| 路径 | 说明 |
|------|------|
| `skills/finishing-a-development-branch` Step **2.55b** | rebuild + commit 产物（S1/S2） |
| `skills/devicetest`, `mocktest`, `autotest` | 报告 **build path**（main vs worktree） |
| `hooks/cws-artifact-sync-guard` | Stop：main 上源码新于 `.output` commit 则 block（S3） |
| `hooks/acceptance-order-common` | `plugin_output_covers_source_tip` 等辅助函数 |

### 验证

- `tests/claude-code/test-cws-artifact-sync.sh`
- 回归：仅改 `app/plugin` 源码不 commit `.output` → main Stop block

<a id="sec-20260517-published-hotfix-flow"></a>
## 已发布子产品 hotfix 流程（No.18 / project2feedback）

> **发版**：待下一枚 `sp-v5.0.7-xia-*` tag；ChatBobi 侧 `docs/scripts/sync-superpowers-fork.sh full-sync latest`。

### 结论

当 **已发布** plugin/webapp 版本（如 `pv0.1.14`）必须立即修复且不能等下个小版本时：**流程与制品与常规版本相同**（完整 brainstorming → writing-plans → 版本集 + `PRn` + 七步验收）。**`hotfix-flow`** 仅负责 Git tag 基线、CWS/`plugin/pv*-hf*` 发布与并行下一版本合入说明。分支 `feat/pv0.1.14-hotfix-<topic>` 从 **`plugin/pv0.1.14`** tag 起飞；文档根 `docs/plugin/pv0.1.14-hotfix-<topic>/` + `*-PRn/`；CWS 仍 `0.1.14.N`，靠 **`plugin/pv0.1.14-hf{n}`** tag 区分。

**2026-05-17 修订（夏老板 R1/R2/H7）**：回退「lite + 无 PRn」实验；brainstorming Step 2 三选一（含「线上已发布」+ Bug/紧急功能第二问）；新增 Stop hook `hotfix-parallel-sync-guard`、`next-minor-behind-main-guard`。

**2026-05-17 修补（自检 H7）**：hotfix Stop 仅校验并行 **plan**（`strategy` + `target_branch`），**不要求**开发期 `evidence`；真实合入由 `next-minor-behind-main-guard` 用 git 强制；`list_in_flight` 过滤已 merge 分支与 semver ≤ hotfix 基线；hotfix 开工前校验 `plugin/pv*` 基线 tag；waiver 须含 `reason:` 行。

### 模块

| 路径 | 说明 |
|------|------|
| `skills/hotfix-flow/SKILL.md` | 薄 Git/发布/并行合入清单（不替代 brainstorming/writing-plans） |
| `skills/brainstorming/SKILL.md` | Step 2 三选一 + Published 第二问 |
| `skills/writing-plans/SKILL.md` | hotfix 同 PR 形状 + finalize-log `## Parallel next minor sync` |
| `skills/using-superpowers`, `finishing-a-development-branch` | 入口说明 + Step 2.65 并行合入 |
| `hooks/acceptance-order-common` | `is_hotfix_*`, `list_in_flight_pv_feature_branches`, `parallel_sync_section_valid` |
| `hooks/hotfix-parallel-sync-guard` | hotfix Stop：有进行中 `feat/pv*` 时要求 finalize-log 并行节 |
| `hooks/next-minor-behind-main-guard` | 下一版本 Stop：`HEAD..main` 在 `app/plugin/` 非空则 block |
| `hooks/test-acceptance-gate`, `enforce-acceptance-order` | **已恢复**常规 PR+版本 gate（无 hotfix 无 PRn 旁路） |
| `hooks/hooks.json`, `hooks/hooks-cursor.json` | 注册上述 Stop hook |

### 验证

- `tests/claude-code/test-active-pr-resolution.sh` 用例 10（hotfix 分支绑定目录）
- `tests/claude-code/test-hotfix-parallel-sync.sh`（H7 辅助函数 + Stop guard）
- ChatBobi 宿主：`.superpowers/issues.md` 工单 + `full-sync latest`（含 **wire**）后 overlay 与 Stop 链含本变更

<a id="sec-20260515-chatgpt-chrome-verify"></a>
## ChatGPT 真机 Chrome 验证（No.12 / project2feedback）

> **发版**：待下一枚 `sp-v5.0.7-xia-*` tag；本机 overlay deploy 见 ChatBobi `docs/superpowers-local/LOCAL_RELEASES.md`。

### 结论

新增 **`chatgpt-chrome-verify`** skill 与 **`/chatgpt-chrome-verify`** command，让 agent 在 ChatBobi + ChatGPT 场景下用**可视化真实 Chrome**（非无头）完成 Console 读取、诊断命令、滚动观察与结构化汇报；主路径为 **Chrome DevTools MCP** + 独立 `--user-data-dir` profile。提供 **`scripts/launch-chatbobi-chrome.sh`** 启动专用 Chrome 并加载 `app/plugin/.output/chrome-mv3`。ChatBobi 侧最小改动：`shared/debug/debug-bridge.ts`（`ChatBobiDebug` postMessage → `[ChatBobi][DEBUG]` 日志）、`docs/scripts/launch-chatbobi-chrome.sh` 包装器、`.claude/commands/chatgpt-chrome-verify.md`。

### 模块

| 路径 | 说明 |
|------|------|
| `skills/chatgpt-chrome-verify/SKILL.md` | Agent workflow、安全边界、汇报字段 |
| `commands/chatgpt-chrome-verify.md` | 分步命令（构建、MCP、诊断、汇报） |
| `scripts/launch-chatbobi-chrome.sh` | 独立 profile + debug port + 扩展加载 |

### 验证

- `docs/scripts/launch-chatbobi-chrome.sh --check` 解析 extension 与 manifest version
- ChatGPT 页：`localStorage.setItem('chatbobi:debug','1')` 后 postMessage 诊断类型，Console 出现 `[ChatBobi][DEBUG]`
- `claude mcp list` 显示 `chrome-devtools` 且会话可调用其工具
- `scripts/install-chatgpt-chrome-verify-global.sh` 写入 `~/.cursor/skills/` 与 `~/.claude/skills/`（Cursor + Claude Code 全局）

### 安全

- 不复用日常 Chrome profile；不自动发送 ChatGPT 消息（除非用户明确确认）

<a id="sec-how-to-maint"></a>
## 本文件怎么维护（changelog 与发版）

将 **superpowers/5.0.7** 的重要变更 **推送到 GitHub** 并打标签（`sp-v5.0.7-xia-YYYY-MM-DD-序号`）时，在正文里**新写一节**（或补充一节）：**标题用「这版在解决什么」人话**（见上表体例），**不要**整节都叫「工作报告」。插入位置：本**维护说明** 的**紧后**、所有「按发版/专题」小节的**最上**；并把上表**加一行**速览。正文里建议首行用引用块写 **发版** `tag` 与 `commit`（短 hash）。正文章节**至少**包含：结论一句、改动了哪些**模块**、怎么**验证**、有无**审查/风险**。

> 新小节标题请与上表**「这版在解决什么」**列**同一套说法**，这样目录与正文互相找得到。

<a id="sec-20260515-chatbobi-runtime-sync"></a>
## 2026-05-15 ChatBobi：Runtime Sync 首次落盘 +「完整 Runtime Sync」书面约定

> **关联**：夏 fork 发版线 **`sp-v5.0.7-xia-2026-05-15-01`**；ChatBobi 侧为 **消费真源** 的落地与文档，**非** fork 内代码变更。详细长文与 Agent 默认口径见 ChatBobi 根目录 **`changelogs.md`**（路径：`/Users/harry/Documents/chatbobi/changelogs.md`）。

### 结论

在 **ChatBobi** 仓库内首次接通 **Superpowers Runtime Sync**：建立 `docs/superpowers-local/MANAGED_FILES.txt`（82 条受管路径，覆盖 `hooks/`、`skills/`、`commands/`、`agents/`、`scripts/`），执行 **`capture` → `status` → `backup latest` → `deploy latest` → `status`**，使 overlay 与已装 **`~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.7/`** 全量 **IN_SYNC**；修正 `.gitignore` 使 **`MANAGED_FILES.txt`** 与 **`LOCAL_RELEASES.md`** 可入库，**overlay** 与 **`backups/*.tar.gz`** 不入库。另在 ChatBobi 根 **`changelogs.md`** 写入本次操作留痕，并单立 **「完整 Superpowers Runtime Sync」** 约定：以后口头「跑完 Runtime Sync」**默认包含** ChatBobi 内 **落盘（capture）** 与 **deploy 到本机缓存**，**不等同于**「仅在 fork 上 push/tag」。

### ChatBobi 变更要点（路径）

| 路径 | 说明 |
|------|------|
| `docs/superpowers-local/MANAGED_FILES.txt` | 受管列表；由真源 fork 扫描生成（排除 `.DS_Store`）。 |
| `docs/superpowers-local/LOCAL_RELEASES.md` | 本地操作留痕；内链 ChatBobi 根 `changelogs.md`。 |
| `docs/superpowers-local/overlay/` | `capture` 产物；**git 忽略**。 |
| `docs/superpowers-local/backups/*.tar.gz` | `backup` 产物；**git 忽略**。 |
| `.gitignore` | `docs/superpowers-local/*` + 例外放行上述两个 md。 |
| `changelogs.md`（ChatBobi 根） | 仓库级叙事 + **完整 Runtime Sync** 步骤表与「仅 fork」对照。 |
| `docs/CHANGELOG.md` | 增加指向根 `changelogs.md` 的导航。 |

### Git（ChatBobi / `feat/pv0.1.13-dom-adapt`）

- `42a41dd` — `chore(superpowers): add MANAGED_FILES + LOCAL_RELEASES; gitignore overlay only`
- `a21c610` — `docs: add repo changelogs.md — Runtime Sync 2026-05-15 + full-sync policy`
- `da30db5` — `docs(superpowers-local): LOCAL_RELEASES link to repo changelogs`
- 已 `git push origin feat/pv0.1.13-dom-adapt`

### 验证

- `cd /Users/harry/Documents/chatbobi && docs/scripts/sync-superpowers-fork.sh status` — 受管文件均为 **IN_SYNC**。

### 审查 / 风险

- **受管范围**当前未含 fork 侧 `tests/`；若需缓存与 fork 测试脚本完全一致，须在 `MANAGED_FILES.txt` 增补后再 `capture` + `deploy`。
- **术语**：夏 fork 本文件继续记 **真源** 发版；ChatBobi 根 `changelogs.md` 记 **消费侧** 同步与约定，避免两处抢同一叙事。

---

<a id="sec-20260515-release-wip"></a>
## 2026-05-15 发版：工作区归并 — 平台级验收、evolution closure、技能与文档

> **发版** `sp-v5.0.7-xia-2026-05-15-01`（提交短 hash 以该 tag 指向对象为准）

### 结论

把 `xia/cache-package-5.0.7` 上积压的未提交改动一次性纳入版本控制并合入 **main**：强化 **Stop** 侧 `test-acceptance-gate`（含平台发版路径）、`workflow-bootstrap-gate` 与相关 hook 小修、`check-evolution` / `evolution-index-common` / `check-evolution-closure.sh`；`skills/using-superpowers` 等与阶段门禁对齐的增补；新增 **平台版本** `version-test-template` 片段与 `test-platform-release-acceptance.sh`；根目录 **fork 级复盘** `LESSONS.md` 与 **Clockworkman** 内稿 `docs/clockworkman-product-launch.md`；删除冗余根 `CHANGELOG.md`（以 `changelogs.md` 为真源）。

### 验证

- `bash tests/claude-code/test-workflow-bootstrap-gate.sh`
- `bash tests/claude-code/test-workflow-phase-auto.sh`
- `bash tests/claude-code/test-spec-gate-precheck.sh`
- `bash tests/claude-code/test-check-evolution.sh`
- `bash tests/claude-code/test-version-pr-doc-contract.sh`
- `bash tests/claude-code/test-active-pr-resolution.sh`
- `bash tests/claude-code/test-platform-release-acceptance.sh`

### 审查 / 风险

- `docs/clockworkman-product-launch.md` 为内部产品叙事稿，对外 fork 若需精简可后续单 PR 移入 `docs/private/` 或拆库。

---

<a id="sec-20260514-main-workflow-gates"></a>
## 2026-05-14 **main** 上 UserPromptSubmit 门禁纠偏 + 阶段自动化：`workflow-bootstrap-gate` / `workflow-phase-auto`；`feat/pv|wv|chatbobi-v…` 与 docs 版本根对齐

> **Changelog 补录** — 工作区记录 `commit` **`d560dcd`**（发版打 `sp-v5.0.7-xia-*` 时可把本行改成正式 **发版** 引用块并合并叙述）。

### 结论

解决 ChatBobi 等业务仓库在 **`main`** 上、**需求沟通 / brainstorming** 阶段仍被 **`workflow-bootstrap-gate`** 当成「要写实现」而 **误拦 Submit** 的问题：改为 **多条件放行**（窄意图、布局/体验话术、`.superpowers/workflow-phase` 早期阶段 token、`git` 白名单路径等），并保留对 **`src/`、`app/`** 等硬实现话术的拦截；**功能分支**命名与 **`docs/` 版本目录**解析与 `acceptance-order-common` 一致（支持 **`feat/pv…`、`feat/wv…`、`feat/chatbobi-v…`**）。另增 **`workflow-phase-auto`**：按用户提示 **自动创建/更新** `.superpowers/workflow-phase`（含防误降、**仅 phase 文件** 不触发「白名单工作区」短路），夏老板无需手敲 `mkdir`/`echo`。

### 变更范围

- **hooks**
  - `hooks/workflow-bootstrap-gate`（**新增**；ChatBobi 原 `hooks-backup` 副本逻辑迁入真源并增强）
  - `hooks/workflow-phase-auto`（**新增**；UserPromptSubmit 侧效、不输出、不阻断）
  - `hooks/acceptance-order-common` — 新增 `resolve_version_dir_from_branch`（分支后缀与 `docs/` 版本根 **大小写不敏感** basename 对齐）
- **skills**
  - `skills/using-superpowers/SKILL.md` — Project 根、`workflow-phase` 自动化与手改兜底说明
  - `skills/brainstorming/SKILL.md`、`skills/writing-plans/SKILL.md` — 与阶段 hook 对齐的一小段
- **tests**
  - `tests/claude-code/test-workflow-bootstrap-gate.sh`
  - `tests/claude-code/test-workflow-phase-auto.sh`
- **仓库卫生**
  - `.gitignore` — `.tmp-wf-bootstrap-tests/`（测试临时目录）
- **ChatBobi 部署面（Runtime Sync 受管；真源仍在 fork）**
  - `docs/superpowers-local/MANAGED_FILES.txt` — 纳入 `hooks/workflow-bootstrap-gate`、`hooks/workflow-phase-auto`
  - `.claude/settings.local.json` — `workflow-bootstrap-gate` 经 `run-superpowers-hook`；**新增** `workflow-phase-auto` 且排在 bootstrap **之前**；删除 `docs/scripts/hooks-backup/workflow-bootstrap-gate` 重复副本以免优先命中旧脚本

### 验证

- `bash -n hooks/workflow-bootstrap-gate hooks/workflow-phase-auto`
- `bash tests/claude-code/test-workflow-bootstrap-gate.sh`
- `bash tests/claude-code/test-workflow-phase-auto.sh`
- `docs/scripts/sync-superpowers-fork.sh status latest`（overlay 与 installed cache **IN_SYNC**）

### 审查 / 风险

- **`workflow-phase-auto`** 依赖提示词 **正则命中**；未命中时仍可 **手改** `.superpowers/workflow-phase`。
- **阶段性放行**与 **布局话术放行** 过宽可能削弱「禁止 main 写实现」纪律；已通过 **硬实现** 子串与 **白名单路径** 规则收敛；若线上仍有误拦/误放，继续收紧正则或补测试夹具。

---

<a id="sec-20260430-figma-read-mcp-dual"></a>
## 2026-04-30 `/figma-read`：官方 `figma` 与 `figma-desktop` 双 MCP（文档）

> **文档增补** — 可与下一枚 `sp-v5.0.7-xia-*` 发版条目合并记入 tag/commit。

### 结论

在 `commands/figma-read.md` 的 Step 2 增加 **§2.0**：对照 [Figma MCP Server Guide](https://github.com/figma/mcp-server-guide)，说明官方默认服务名 **`figma`**（`https://mcp.figma.com/mcp`，工具前缀 **`mcp__figma__*`**）与 Superpowers 约定的 **`figma-desktop`**（本机 `http://127.0.0.1:3845/mcp`，工具前缀 **`mcp__figma-desktop__*`**）；推荐并行理解两者；读取路径以本机 Desktop 连通为优先依据之一；提示勿泄露令牌。`LOCAL_RELEASES` / `MANAGED_FILES` 纳入 `commands/figma-read.md` 与 `changelogs.md` 以便 Runtime Sync deploy。

### 变更范围

- `commands/figma-read.md`
- `changelogs.md`（本条目）
- ChatBobi `docs/superpowers-local/MANAGED_FILES.txt`（新增上述两路径，参与 capture/deploy）

### 验证

- 通读 `commands/figma-read.md` Step 2：`2.0` → `2.1` → `2.2` 衔接一致
- `docs/scripts/sync-superpowers-fork.sh status` → 受管文件 `IN_SYNC`

### 审查 / 风险

- 无行为层 hook/skill 逻辑变更；仅文档与 deploy 覆盖面扩展。

---

<a id="sec-20260430-runtime-sync-hardening"></a>
## 2026-04-30 Runtime Sync 真源、缓存防误改、SessionStart 反馈索引兼容一起补齐

> **发版** `sp-v5.0.7-xia-2026-04-30-01` — 核心：把 `Runtime Sync` 补到可发布状态，覆盖三块此前只在本机落地、未正式发版的改动：维护手册、runtime cache 编辑防线，以及 `check-evolution` 对表格格式 feedback index 的兼容修复。

### 结论

这一版把 Xia 本地已经在用、但还没正式发版的 Runtime Sync 相关能力集中补齐到 GitHub 发布线：

1. **维护路径更清楚**：新增 `SUPERPOWERS_RUNTIME_SYNC_MANUAL.md`，把 `fork -> overlay -> installed cache` 的职责、发布顺序、回滚和 tag 规范写成可执行说明。
2. **收尾动作更完整**：`finishing-a-development-branch` 现在会显式处理 remote branch cleanup 和最终验证，减少“本地删了、远端还留着”的脏尾巴。
3. **runtime cache 不再能被误当真源直接改**：新增 `superpowers-cache-edit-guard`，在 fork 未对齐时阻止直接改 installed cache。
4. **SessionStart 不再被 feedback index 表格格式搞崩**：`check-evolution` 现在能正确读取 Markdown 表格版 `FEEDBACK-INDEX.md`，并对 `rg` 0 命中做安全处理，不再在 `set -euo pipefail` 下静默 `exit 1`。

### 变更范围

- **runtime docs**
  - `SUPERPOWERS_RUNTIME_SYNC_MANUAL.md`
    - 固化 Runtime Sync 的真源顺序、部署命令、发布与回滚规范

- **skills**
  - `skills/finishing-a-development-branch/SKILL.md`
    - 加入 remote branch cleanup
    - 把末尾步骤提升为 final verification

- **hooks**
  - `hooks/superpowers-cache-edit-guard`
    - 阻止在 fork 未对齐时直接改 runtime cache
  - `hooks/hooks.json`
  - `hooks/hooks-cursor.json`
    - 注册 runtime cache edit guard
  - `hooks/check-evolution`
    - 兼容表格格式 `.claude/feedback/FEEDBACK-INDEX.md`
    - 为 legacy `rg` 计数加 0 命中安全兜底

- **tests**
  - `tests/claude-code/test-check-evolution.sh`
    - 覆盖表格格式 feedback index 与 SessionStart payload 回归

### 验证

- fork 侧本地 shell tests
  - `bash tests/claude-code/test-active-pr-resolution.sh`
  - `bash tests/claude-code/test-check-evolution.sh`
  - `bash tests/claude-code/test-enforce-acceptance-order-trigger.sh`
  - `bash tests/claude-code/test-mark-test-acceptance-needed.sh`
  - `bash tests/claude-code/test-superpowers-runtime-sync-reminder.sh`
  - `bash tests/claude-code/test-stop-gate-quality-fields.sh`
  - `bash tests/claude-code/test-stop-gate-user-confirm-reminder.sh`

- Runtime Sync 链路
  - `docs/scripts/sync-superpowers-fork.sh capture`
  - `docs/scripts/sync-superpowers-fork.sh status`
  - `docs/scripts/sync-superpowers-fork.sh deploy latest`

- installed cache smoke test
  - `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.7/hooks/run-hook.cmd check-evolution`

### 审查 / 风险

- 这次发布把此前已在 Xia 本机部署、但还未进入 `sp-v5.0.7-xia-*` tag 线的 Runtime Sync 相关改动一起纳入正式版本；因此正文刻意按“发布补齐”而不是“单点热修”来记。
- 在当前 Codex 沙箱里，无法完成真正带登录态的 Claude CLI 黑盒发版验证：`claude --print` 会受 `session-env` 目录权限和 `/login` 状态影响。
- 但 hook 本体已经在 installed cache 路径下直接 smoke test 通过，且 Xia 侧已确认真实 Claude Code CLI 的 `SessionStart:startup hook error` 现象消失。

<a id="sec-20260428-acceptance-false-positive"></a>
## 2026-04-28 验收顺序 hook 不再误拦普通对话

> **发版** `sp-v5.0.7-xia-2026-04-28-03` — 核心：`UserPromptSubmit` 的 `enforce-acceptance-order` 不再把“讨论测试 / 引用 AutoTest / 反馈被 hook 拦截”的普通聊天误判成真的测试启动请求。

### 结论

这批修复解决的是一个 submit hook 误判问题：

1. 旧规则只要在同一段输入里同时看到 `autotest` / `mocktest` / `devicetest` 和“测试 / 执行 / 启动”之类词，就可能把普通对话误判成“要启动测试”。
2. 结果是用户在描述问题、粘贴历史对话、讨论回归用例，甚至只是提到 `AutoTest` 技能时，也会被 `UserPromptSubmit operation blocked by hook` 拦住。
3. 现在 hook 只在更明确的启动意图上触发：如 `/autotest`、`请执行 autotest`、`start mocktest` 这类请求；普通讨论不会再被拦。

### 变更范围

- **hooks**
  - `hooks/enforce-acceptance-order`
    - 收紧 `is_run_request` 识别逻辑
    - 保留真正测试启动请求的顺序门禁
    - 放过包含测试名词但不构成命令的普通讨论

- **tests**
  - 新增 `tests/claude-code/test-enforce-acceptance-order-trigger.sh`
    - 校验提到 `AutoTest` 的讨论不误拦
    - 校验引用 `mocktest` / `devicetest` 的反馈描述不误拦
    - 校验 `/autotest` 和 `请执行 autotest` 这类显式请求仍会按顺序被拦

### 验证

- `bash tests/claude-code/test-enforce-acceptance-order-trigger.sh`
- `bash tests/claude-code/test-enforce-acceptance-next-expected.sh`
- ChatBobi 侧正式同步链路：
  - `docs/scripts/sync-superpowers-fork.sh capture`
  - `docs/scripts/sync-superpowers-fork.sh deploy latest`
  - `docs/scripts/manage-superpowers-local.sh status 5.0.7`

### 审查 / 风险

- 这次修复刻意把触发条件从“宽匹配测试词”收紧到“更像真的启动命令”，优先解决普通聊天被封口的问题。
- 当前规则仍是正则启发式匹配；如果后续出现新的中文命令表达误漏判，需要继续补回归测试，而不是再放宽到讨论语境。

<a id="sec-20260428-runtime-sync-route"></a>
## 2026-04-28 Superpowers 维护任务先走 Runtime Sync

> **发版** `sp-v5.0.7-xia-2026-04-28-02` — 核心：把 `superpowers` 的维护任务显式路由到 `fork -> overlay -> installed cache`，并通过新的 `UserPromptSubmit` reminder hook 主动提醒不要直接在 ChatBobi overlay 或 runtime cache 上起手改。

### 结论

这批修复解决的是一个“流程能做，但入口不显眼”的问题：

1. `Superpowers Runtime Sync` 以前主要藏在 skill / command 里，用户一旦在 ChatBobi 仓库里直接提「改 hook / 改流程 / 发版部署」，会很容易绕过真源路径，先改 overlay 或 cache。
2. 现在 fork 与 runtime docs 都明确写出三层真源顺序：`fork -> overlay -> installed cache`。
3. 新增 `superpowers-runtime-sync-reminder` 后，只要用户在维护语境里提到 `superpowers`、`hook`、`fork`、`cache`、`deploy`、`release` 等关键词，submit hook 就会主动注入 routing 提醒。

### 变更范围

- **runtime docs**
  - `CLAUDE.md`
  - `CLAUDE_zh.md`
    - 新增 `Superpowers Runtime Sync Routing` 章节
    - 明确要求：先 fork，后 overlay，再 runtime cache

- **hooks**
  - `hooks/hooks.json`
  - `hooks/hooks-cursor.json`
    - `UserPromptSubmit` 链路最前面接入 `superpowers-runtime-sync-reminder`
  - `hooks/superpowers-runtime-sync-reminder`
    - 检测 `superpowers` 维护类 prompt
    - 注入 `fork -> capture -> status -> deploy -> verify -> LOCAL_RELEASES -> commit/push/tag/changelogs` 提醒

- **tests**
  - 新增 `tests/claude-code/test-superpowers-runtime-sync-reminder.sh`
    - 校验维护类 prompt 会注入提醒
    - 校验普通业务 prompt 不会误报

### 验证

- `bash tests/claude-code/test-superpowers-runtime-sync-reminder.sh`
- `bash hooks/superpowers-runtime-sync-reminder <<< '{"prompt":"帮我改一下 superpowers 的 hook 和本地发版流程"}'`
- ChatBobi 侧：
  - `docs/scripts/sync-superpowers-fork.sh capture`
  - `docs/scripts/sync-superpowers-fork.sh status`
  - `docs/scripts/sync-superpowers-fork.sh deploy latest`
- 部署后对 installed cache 再跑一次：
  - `bash ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.7/tests/claude-code/test-superpowers-runtime-sync-reminder.sh`

### 审查 / 风险

- 该 reminder 只负责**路由提醒**，不直接阻断会话，因此不会像 stop gate 一样引入硬拦截噪声。
- 关键词匹配仍有边界；后续若出现过宽或过窄的触发，再沿同一路径补测试和规则。

<a id="sec-20260428-confirm-gate"></a>
## 2026-04-28 确认门误报与重复催促治理

> **发版** `sp-v5.0.7-xia-2026-04-28-01` — 核心：`Vx.y.z-test.md` 的 `## Acceptance status (hooks)` 状态回写不再误触发 spec/test 确认门；同一 user-owned stop block 仅提醒一次，随后静默等待用户输入。

### 结论

这批修复解决了两个高频、强干扰的 workflow 问题：

1. **状态回写误报**  
   版本级 `Vx.y.z-test.md` 的 `## Acceptance status (hooks)` 是运行时验收状态真源，但之前只要改到 `test.md`，就容易被 `mark-test-acceptance-needed` 重新打成 `needs_confirm`。现在 hook 会区分：
   - 真正的断言/用例修改：继续要求确认
   - 纯状态回写：不再要求确认

2. **重复催促**  
   当 stop gate 已明确是 `needs_user_confirmation` 时，旧行为会在同一回合里不断重复“等待 confirm spec change”。现在同一阻塞只会提示一次；若再次触发，会直接静默结束当前回合，等待用户输入，不再刷屏。

### 变更范围

- **hooks**
  - `hooks/mark-test-acceptance-needed`
    - 增加 `Acceptance status` 状态行豁免
    - 兼容整行状态回写与 token 级状态回写（如 `pending -> pass`）
  - `hooks/test-acceptance-gate`
    - user-owned block 改为“一次提醒后静默等待”
  - `hooks/acceptance-order-common`
    - 增加用户确认阻塞状态记忆/清理辅助函数
  - `hooks/spec-change-confirm`
    - 用户确认成功后清理等待标记

- **runtime docs**
  - `CLAUDE.md`
  - `CLAUDE_zh.md`
    - 明确写入：
      - `Acceptance status` 纯状态回写不应重开确认门
      - user-owned stop block 只能提醒一次，之后静默等待

- **tests**
  - 新增 `tests/claude-code/test-mark-test-acceptance-needed.sh`
  - 新增 `tests/claude-code/test-spec-change-confirm.sh`
  - 新增 `tests/claude-code/test-stop-gate-user-confirm-reminder.sh`
  - 更新 `tests/claude-code/test-enforce-acceptance-next-expected.sh`

### 验证

- `bash tests/claude-code/test-mark-test-acceptance-needed.sh`
- `bash tests/claude-code/test-spec-change-confirm.sh`
- `bash tests/claude-code/test-stop-gate-user-confirm-reminder.sh`
- `bash tests/claude-code/test-enforce-acceptance-next-expected.sh`
- `bash tests/claude-code/test-stop-gate-quality-fields.sh`

### 审查 / 风险

- 这批修复优先面向 **Claude Code stop hook / submit hook 交互噪声**，不会放宽真实断言变更的确认要求。
- `Acceptance status` 豁免逻辑现在兼容 token 级替换，但仍依赖工具上报的 `old_string/new_string` 语义；若未来宿主工具更换事件载荷格式，需要复测该分支。

### 本地库 / 云端库治理模型

这次还把 `superpowers` 的维护边界从“直接改 cache”提升成了三层结构，便于 **回滚**、**拉取**、**合并**：

1. **本机运行层：installed cache**
   - 位置：`~/.claude/plugins/cache/claude-plugins-official/superpowers/5.0.7/`
   - 作用：Claude Code 实际执行的 hook / skill / command 就在这里
   - 风险：宿主升级或刷新 cache 后，这一层可能被覆盖

2. **工作区受管层：local managed overlay**
   - 位置：
     - `docs/superpowers-local/overlay/`
     - `docs/superpowers-local/MANAGED_FILES.txt`
     - `docs/scripts/manage-superpowers-local.sh`
   - 作用：
     - 记录“夏老板本机真正要保留的改动文件”
     - 提供本地整包备份与覆盖式重放
   - 对应能力：
     - **本地回滚**：`manage-superpowers-local.sh restore <backup.tar.gz>`
     - **本地重放**：`manage-superpowers-local.sh deploy latest`
     - **本地状态检查**：`manage-superpowers-local.sh status`

3. **云端版本层：GitHub fork / snapshot branch**
   - 仓库：`https://github.com/hxiawen/superpowers.git`（`hxiawen/superpowers`）
   - 官方上游：`obra/superpowers`
   - 本地快照分支：`xia/cache-package-5.0.7`
   - 快照 tag：
     - `xia-local-cache-5.0.7-2026-04-28-01`
     - 本次正式发版 tag：`sp-v5.0.7-xia-2026-04-28-01`
   - 作用：
     - 让“当前本机在跑的 package 形态”可被 GitHub 保存、拉取、对照、回滚
     - 让后续 merge 官方更新时，不必再从 cache 目录反向猜补丁

### 可回滚

- **机器本地回滚**
  - 用 `docs/superpowers-local/backups/*.tar.gz` 恢复某个完整安装快照
  - 适合：cache 被覆盖、hook 改坏、想回到某次本机可运行状态

- **Git 级回滚**
  - 在 `reference/superpowers-fork` 中：
    - 切回分支：`xia/cache-package-5.0.7`
    - 或 checkout 指定 tag：`xia-local-cache-5.0.7-2026-04-28-01` / `sp-v5.0.7-xia-2026-04-28-01`
  - 适合：需要恢复到某次已记录、已推送的版本线

### 可拉取

- 新机器或新环境上，可以：
  - `git clone https://github.com/hxiawen/superpowers.git` / `git pull`（远端 `origin` 同上）
  - checkout `xia/cache-package-5.0.7` 或指定 tag
  - 再把对应文件部署到本地 installed cache
- 这意味着恢复不再依赖“当前这台机器还留着旧 cache”

### 可合并

- **官方线**
  - `main` / `upstream/main` 继续代表官方仓库语义

- **夏老板自维护线**
  - `xia/cache-package-5.0.7` 代表“当前本机 package 形态 + 夏老板本地治理修复”

- **后续合并策略**
  1. `git fetch upstream`
  2. 评估官方更新是否要吸收进夏老板维护线
  3. 在受控分支里 merge / cherry-pick 官方变更
  4. 重新跑 hook / tests 回归
  5. 通过后再打新的 `sp-v5.0.7-xia-*` tag

换句话说：  
从这版开始，`superpowers` 不再只是“cache 里的一坨临时修改”，而是有了：
- **本地可恢复**
- **云端可拉取**
- **官方可合并**
- **发版可追溯**

<a id="sec-20260426-figma-live-sync"></a>
## 2026-04-26 Figma URL 读回与 Live Design Sync 闭环

> **发版** `sp-v5.0.7-xia-2026-04-26-01` · `8630492` — 核心：新增 `figma-url-readiness` / `/figma-read`，把 Figma Design URL 读取从项目本地规则升级为 Superpowers 全局能力；新增 `figma-live-design-sync`，将 UI 变更计划尾部 PR 从 legacy `codetofigma`-only 升级为可读回、可 diff、可限轮迭代的 live sync 闭环。

### 结论

Figma 相关流程拆成两层并全局化：

1. **读取层**：`figma-url-readiness` / `/figma-read` 负责解析 Figma URL、检查 `figma-desktop` MCP server 与当前会话工具暴露、读取 metadata / screenshot / design context。UserPromptSubmit hook 只注入上下文提醒，不再硬阻断 Figma URL 输入。
2. **闭环层**：`figma-live-design-sync` 作为高阶编排技能，包装 `codetofigma`、一次性人工 bootstrap、hot reload / assisted rerun、`figma-read` 读回、视觉/结构/token diff 与插件脚本修复循环。

新的 planning 规则：版本涉及 UI / visual design / CSS token / component layout / Figma-facing 变更时，`writing-plans` 自动追加 `PRn: Figma Live Design Sync`。`codetofigma` 不再作为新计划的独立尾部 PR，而是该 PR 内的子步骤。

### 变更范围

- **skills**：新增 `skills/figma-url-readiness`、`skills/figma-live-design-sync`；更新 `skills/brainstorming` 的 Design Draft / Figma interaction intake；更新 `skills/writing-plans` 的 UI 尾部 PR 规则。
- **commands**：新增 `commands/figma-read.md`、`commands/figma-live-design-sync.md`。
- **hooks**：新增 `hooks/figma-url-readiness-gate` 并接入 `hooks.json` / `hooks-cursor.json`；更新 acceptance order 逻辑，使新计划要求 `figma-live-sync`，同时兼容旧 `codetofigma`。
- **runtime docs / templates**：更新 `CLAUDE.md`、`CLAUDE_zh.md`、`version-test-template.md`，说明 `autotest -> mocktest -> devicetest -> figma-live-sync(按计划)`。
- **tests**：扩展 `test-enforce-acceptance-next-expected.sh`，覆盖新 `figma-live-sync` 与 legacy `codetofigma`。

### 验证

- `bash -n superpowers/5.0.7/hooks/acceptance-order-common superpowers/5.0.7/hooks/enforce-acceptance-order superpowers/5.0.7/hooks/test-acceptance-gate superpowers/5.0.7/hooks/figma-url-readiness-gate`
- `bash superpowers/5.0.7/tests/claude-code/test-enforce-acceptance-next-expected.sh`
- 手动验证 `figma-url-readiness-gate`：Figma URL 输入返回 additional context 且 exit 0；显式 `/figma-read <url>` 与普通请求放行。

### 审查 / 风险

- Live loop 默认 `max_rounds = 3`，硬上限 `max_rounds = 5`，超过需人类明确批准，避免无限迭代。
- Hot reload 不是无条件承诺；每轮必须通过 build label 读回验证。失败时降级到 assisted rerun。
- 旧计划中的 `codetofigma: pass` 仍被 hooks 接受，避免破坏历史项目。

---

<a id="sec-20260423-acceptance"></a>
## 2026-04-23 三验收只认「版本文件 + Acceptance 门」；Stop 必带状态行

> **发版** `sp-v5.0.7-xia-2026-04-23-02` · `19e0987` — 核心：**三层验收状态** 只进 **`Vx.y.z-test.md` → `## Acceptance status (hooks)`**；`enforce` / `test-acceptance-gate` 只解析该段；`validate_order_…` **状态词不可或缺**；补 **`test-stop-gate-acceptance-status-required`**

### 结论

三层环境验收（`autotest` / `mocktest` / `devicetest`）**收敛为版本级唯一真源**：仅 `Vx.y.z-test.md` 中固定标题 **`## Acceptance status (hooks)`** 供 hooks 解析；PR `tdd-log` 只保留 TDD 三字段与用例，**不**再作为该三层带状态行的来源。配套文档、技能、`enforce-acceptance-order` / `test-acceptance-gate`、模板与合约束测试已对齐；版本根「必备文件」与 **6 份版本级文件（含 `Vx.y.z-test.md`）** 的表述已统一。  
Codex 审查后续修复：**Stop 门顺序校验**不得允许「仅关键字、无 `pass`/`fail`/… 状态词」通过 —— `acceptance-order-common` 中已去掉对状态分组的**可选**匹配，并新增 `test-stop-gate-acceptance-status-required.sh`。

### 变更范围（摘要）

- **hooks**：`acceptance-order-common`（节区抽取、`validate_order_in_acceptance_section`、`next_expected_test_from_version`）、`enforce-acceptance-order`、`test-acceptance-gate` 等
- **文档**：`CLAUDE.md`、`README.md`、**`CALUDE_zh.md` → `CLAUDE_zh.md`（更名）**、`AGENTS.md` 与现实现一致
- **skills**：`autotest` / `mocktest` / `devicetest`、`subagent-driven-development` 等
- **模板**：`version-test-template.md`、`pr-folder-template.md`、`tdd-report-template.md`、`version-folder-template.md` 等
- **测试**：`test-version-pr-doc-contract.sh`、`test-enforce-acceptance-next-expected.sh`、`test-stop-gate-acceptance-status-required.sh` 等
- **其他**：`superpowers/v0.1.6-*` 反思与 changelog 文件整理；`docs/me/` 内计划/调整笔记（随仓库一并提交，属个人工作区备查）

### 验证

- `bash tests/claude-code/test-version-pr-doc-contract.sh`
- `bash tests/claude-code/test-stop-gate-acceptance-status-required.sh`
- 及相关 stop / enforce / 模板用例（见上条 commit message）

### 审查 / 备注

- 交付前已确认 `CLAUDE_zh` 更名在 Git 中**增删/改名**完整入库，避免 CI 与下游断链。

---

<a id="sec-20260423-hooks"></a>
## 2026-04-23 Hook 与测试稳健化：nullglob、多语言状态、spec 路径

> **发版** `sp-v5.0.7-xia-2026-04-23-01` · `44e3f54`

### 结论

加强 **nullglob** 下版本/PR 路径解析、**i18n 状态**与 **spec 路径**相关门禁；统一测试辅助 **`run_with_timeout`** 与 **`PIPESTATUS`** 处理；hook 主调在 `resolve_*` 失败时**可区分错误**；`run-skill-tests` 等脚本与跨平台超时可读性提升。

### 变更范围

- 修改：`hooks/acceptance-order-common`、`enforce-acceptance-order`、`mark-test-acceptance-needed`、`spec-gate-precheck`、`test-acceptance-gate`
- 修改/新增：`tests/claude-code/test-helpers.sh`、`run-skill-tests.sh`、`test-document-review-system.sh`、`test-subagent-driven-development-integration.sh` 等

### 验证

- 以该批脚本与 hook 的回归为准（见 commit `44e3f54` 说明）

---

<a id="sec-20260423-skill-myth"></a>
## 2026-04-23 没调 skill 也会被打断？── Hook 与业务对话（Claude Code）

### 背景

在业务仓库中讨论产品时，即使**未显式调用** Superpowers 的 skill，仍可能被 **Stop / UserPromptSubmit / PostToolUse** 等事件 hook 打断。本条记录原因与规避方式，避免误认为是「随机故障」或「改 CLAUDE.md 即可」。

### 要点

1. **Hook 与 skill 无关**  
   插件启用后，`superpowers/5.0.7/hooks/hooks.json` 中配置的事件会随 Claude Code 生命周期**自动执行**，不依赖是否调用某个 skill。

2. **常见打断原因**  
   - **Stop**（`test-acceptance-gate`）：收口时验收制品/顺序/字段不满足。  
   - **UserPromptSubmit**（如 `spec-gate-precheck`、`enforce-acceptance-order` 等）：提示内容或阶段触发脚本内 matcher 时拦截。  
   - **版本根路径**：曾存在仅匹配大写 `V` 的假设；当前实现已支持 `docs/vx.y.z-*` 与 `docs/Vx.y.z-*`（以仓库内 `acceptance-order-common` / `VERSION_PREFIX` sed / `mark-test-acceptance-needed` 为准）。新项目仍**推荐**大写 `V`，旧仓库保持一种写法即可。  
   - **验收顺序（Stop / 顺序引导）**：三层 `autotest` / `mocktest` / `devicetest` 的**带状态结果**仅写在 **版本级** `Vx.y.z-test.md` 的 **`## Acceptance status (hooks)`** 小节；`validate_order_in_acceptance_section`（兼容名 `validate_order_in_file`）**只在该 H2 至下一 `##` 之间**判断行号顺序；**不**从 PR `tdd-log` 读取该三层状态。每行须含 `pass`/`fail`/… 等状态词，**三行分立**（见 `version-test-template.md`）。UserPromptSubmit 的 `next_expected_test_from_version` 读**同一段**正文。若仍见旧文档写「PR 与版本双份顺序」，以 [三验收与 Acceptance 门](#sec-20260423-acceptance) 一节为准。

3. **规避「纯聊产品、不要门禁」**（Claude Code 侧）  
   - 用 **`/plugin`** 对该环境 **禁用/卸载** Superpowers；或  
   - 在该项目 `.claude/settings.json`（或 `settings.local.json`）设 **`"disableAllHooks": true`**（会关闭**所有** hook，不仅是 Superpowers）。  
   官方文档：**不能**依赖「只关掉某一条插件 hook」作为稳定能力；以 [Settings](https://code.claude.com/docs/en/settings)、[Hooks](https://code.claude.com/docs/en/hooks) 为准。

4. **文档边界**  
   仅修改项目内 `CLAUDE.md` **不会**改变 Superpowers hook 行为；解除阻断需满足制品契约或调整插件/设置。

### 变更范围

- 本条为 **运维与用户须知** 记录；对应实现与模板说明已落在 `superpowers/5.0.7` 各次提交（hook、模板、测试）中，此处不重复文件清单。

<a id="sec-20260422-evo"></a>
## 2026-04-22 演化闭环与 spec 变更门；反馈与 Stop 系门禁强化

> **发版** `sp-v5.0.7-xia-2026-04-22-02` · `38b3d0f`

### 结论

**门禁与演化闭环**加固：`check-evolution-closure`、spec 门控（`spec-gate-precheck`、`spec-change-confirm`）、Stop 与反馈相关 hook；补充 **test-evolution-lessons-gate**、**test-spec-gate-precheck**、**test-version-source-gate** 等；模板与 README/CLAUDE/技能/`CALUDE_zh` 同步；测试超时与可移植性（`test-helpers`）改进。

### 变更范围

- hooks：`test-acceptance-gate`、`check-evolution`、`detect-feedback-signal`、`mark-test-acceptance-needed`、`hooks.json` / `hooks-cursor.json` 等
- `scripts/check-evolution-closure.sh`；多份 `skills/*`；`docs/.../version-test-template.md`、`pr-folder-template.md` 等
- 测试：上述新增/扩展的 `tests/claude-code/*.sh`

### 验证

- 以该 tag 上集成测试与 hook 用例为准（见 `38b3d0f` 文件列表）

---

<a id="sec-20260422-git"></a>
## 2026-04-22 Git 回退与工作流速查（只读说明）

> **发版** `sp-v5.0.7-xia-2026-04-22-01` · `429e134`

### 结论

新增 **Git 回滚/工作流**说明与**速查表**，便于在 Superpowers 文档体系内查阅分支与回退操作，不改变运行时逻辑。

### 变更范围

- 新增：`superpowers/5.0.7/docs/superpowers/git-workflow-rules.md`
- 新增：`superpowers/5.0.7/docs/superpowers/git-quick-reference.md`

### 验证

- 文档审阅与链接自检（无自动化测试要求）

---

<a id="sec-20260421-inject"></a>
## 2026-04-21 外部规则「单条注入」+ Review 硬基线 + 条件发布前隐私门

### 文件变更明细

1. **修改** `superpowers/5.0.7/AGENTS.md`
   - 类型：修改
   - 变更摘要：新增 `Minimal External Rule Injection Protocol (Mandatory)`，包含注入前置条件、`Gap Evidence` 记录模板、注入后验证与回滚门
   - 变更原因：确保外部规则仅以“单条最小注入”方式进入 Superpowers，防止并行流程污染
   - 主逻辑影响：中（流程治理增强，运行时主流程不变）

2. **修改** `superpowers/5.0.7/skills/requesting-code-review/SKILL.md`
   - 类型：修改
   - 变更摘要：在 Stage 2 增加代码规范硬基线（TypeScript strict 语境、无未审查 `any`、命名规范），并扩展最小安全清单（密钥模式、危险执行/注入、拼接注入、绝对路径泄露）
   - 变更原因：补齐代码质量与安全审查的最小必要检查点
   - 主逻辑影响：中（Review 质量门增强）

3. **修改** `superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
   - 类型：修改
   - 变更摘要：新增 `Step 2.75: Conditional Release Privacy Audit Gate`，仅在明确发布/部署/打包场景触发隐私审计，不影响普通收尾流程
   - 变更原因：在不改变七步主流程的前提下增加发布前隐私防护
   - 主逻辑影响：低到中（发布路径门禁增强）

4. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：补充 `Minimal Rule Injection Discipline`，明确 Superpowers 为唯一运行框架、外部规则注入的证据与回滚要求
   - 变更原因：将最小注入策略同步到入口文档，降低执行偏差
   - 主逻辑影响：低（文档契约增强）

### 约束一致性检查

- 七步主流程保持不变：`Brainstorm -> Spec -> Plan -> TDD -> Subagent Development -> Review -> Finalize`
- 本次仅做单点最小注入，未引入外部并行角色/流程命名
- 注入策略具备可验证与可回滚约束，符合“主库优先、外部仅参考”原则
<a id="sec-20260421-lessons"></a>
## 2026-04-21 进化落盘 `docs/LESSONS.md`（与 `.claude/feedback` 对账）

### 变更范围

- 修改：`superpowers/5.0.7`（运行时契约、`evolution-keeper`、相关 skills）

### 文件变更明细

1. **修改** `superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/CALUDE_zh.md`
   - 类型：修改
   - 变更摘要：在 `docs/` 契约中增加 `LESSONS.md`；反馈进化契约明确 **进化建议** 须追加写入该文件，`.claude/feedback/` 仍为索引与去重来源
   - 变更原因：团队可在版本目录旁统一阅读进化候选与决议，无需翻 `.claude`
   - 主逻辑影响：低（落盘位置扩展）

2. **修改** `superpowers/5.0.7/agents/evolution-keeper.md`
   - 类型：修改
   - 变更摘要：新增职责 **docs/LESSONS.md** 追加规则、条目字段与 append-only 语义；结果块增加 `lessons_md` 字段
   - 变更原因：与编排层契约一致，避免只写反馈目录
   - 主逻辑影响：中（keeper 行为面）

3. **修改** `superpowers/5.0.7/skills/using-superpowers/SKILL.md`、`superpowers/5.0.7/skills/writing-plans/SKILL.md`、`superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：在进化/反馈相关步骤中引用 `docs/LESSONS.md` 追加义务
   - 变更原因：技能链路与 CLAUDE 契约对齐
   - 主逻辑影响：低

4. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：Evolution loop 一句中补充 `docs/LESSONS.md` 可读摘要落盘
   - 变更原因：对外说明与运行时契约一致
   - 主逻辑影响：低

5. **修改** `superpowers/5.0.7/agents/evolution-keeper.md`、`superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/CALUDE_zh.md`、`superpowers/5.0.7/skills/using-superpowers/SKILL.md`、`superpowers/5.0.7/skills/writing-plans/SKILL.md`、`superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：`docs/LESSONS.md` 每条进化建议须包含 **建议是否被采纳**：`pending`（待决议）→ `adopted`（已采纳，`confirm`）或 `not_adopted`（未采纳，`skip`）；keeper 结果块增加 `lessons_adoption`；附示例条目块
   - 变更原因：可读日志一眼区分候选与最终是否采纳
   - 主逻辑影响：低

6. **修改** `superpowers/zh/5.0.7/agents/evolution-keeper.md`
   - 类型：修改
   - 变更摘要：与 5.0.7 英文 keeper 对齐（LESSONS、`建议是否被采纳`、输出字段）；修复原稿破损代码块
   - 变更原因：中文路径与主契约一致
   - 主逻辑影响：低

<a id="sec-20260421-brain"></a>
## 2026-04-21 Brainstorming 材料多选、Figma MCP 与对话边界（第3轮材料）

### 变更范围

- 修改：`superpowers/5.0.7/skills/brainstorming`、`superpowers/skills_zh`
- 明确未修改：`superpowers/demo`

### 文件变更明细

1. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：在「版本模式 + 材料多选」之后增加 **Round 3 — Material-triggered intake**：按固定顺序（Interactive Demo → Design Draft → PRD）对多选材料逐项完成「问位置 → 读/检视（含可用时的 Figma MCP）→ 记缺口」；`Idea` 不增加文件/MCP 接入；补充 Step 4 开场模板、流程图节点、检查清单顺延；明确 **多选时先完成全部接入与 Material intake summary，再进入深度澄清**，且 **接入阶段允许轻量对话**（路径、确认、简短对齐），与「主澄清回合」区分
   - 变更原因：材料有则先接地再推敲，减少空转；多选时行为可预期；与宿主 Figma MCP 能力对齐
   - 主逻辑影响：中（头脑风暴入口与前置加载策略增强）

2. **修改** `superpowers/5.0.7/skills/brainstorming/visual-companion.md`
   - 类型：修改
   - 变更摘要：新增 **Figma MCP vs Visual Companion**：Figma 用于已有设计稿检视，浏览器伴侣用于会话内 HTML 迭代与对比，二者可配合
   - 变更原因：避免与第3轮 Figma 接地职责混淆
   - 主逻辑影响：低（说明性增强）

3. **修改** `superpowers/skills_zh/brainstorming_skill_zh.md`
   - 类型：修改
   - 变更摘要：与 5.0.7 英文流程对齐；中文撰写第3轮四条分支、多选顺序、**夏老板**话术（PRD/设计稿/Demo 路径由负责人提供）；写明接入与深度澄清的对话边界
   - 变更原因：中文执行面与主规范一致，便于团队直接使用
   - 主逻辑影响：低（中文镜像与话术）

<a id="sec-20260421-qa-fields"></a>
## 2026-04-21 用例级质量字段 + Stop 强挡（TDD 三字段、版本三矩阵）

### 变更范围

- 修改：`superpowers/5.0.7/hooks`、`superpowers/5.0.7/tests/claude-code`、`superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`

### 文件变更明细

1. **修改** `superpowers/5.0.7/hooks/acceptance-order-common`
   - 类型：修改
   - 变更摘要：新增 `require_pattern_in_file` 共享函数，用于可复用的字段/章节阻断校验
   - 变更原因：减少 hook 规则重复实现，避免门禁逻辑漂移
   - 主逻辑影响：低（公共函数补充）

2. **修改** `superpowers/5.0.7/hooks/test-acceptance-gate`
   - 类型：修改
   - 变更摘要：在 Stop 阶段新增 6 项模板质量字段强制阻断：PR 级 `Test Point/Expected Result/Assertion Target`，版本级 `Coverage Matrix/Expectation Index/Known Blind Spots`
   - 变更原因：修复“文档存在但质量字段缺失仍可通过”的漏洞
   - 主逻辑影响：中（Stop 门禁更严格）

3. **修改** `superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：修改
   - 变更摘要：新增对 Stop gate 6 项字段阻断与共享函数存在性的契约断言
   - 变更原因：防止 hook 强阻断规则在后续迭代中回退
   - 主逻辑影响：低（测试侧）

4. **修改** `superpowers/5.0.7/tests/claude-code/test-tdd-report-template.sh`
   - 类型：修改
   - 变更摘要：新增 `Test Point`、`Expected Result`、`Assertion Target` 字段断言
   - 变更原因：锁定 PR 级模板质量最小字段集
   - 主逻辑影响：低（测试侧）

5. **新增** `superpowers/5.0.7/tests/claude-code/test-version-test-template.sh`
   - 类型：新增
   - 变更摘要：新增版本模板质量字段断言脚本，覆盖 `Coverage Matrix`、`Expectation Index`、`Known Blind Spots`
   - 变更原因：锁定版本级模板质量字段，补齐自动化回归防线
   - 主逻辑影响：低（测试侧）

6. **修改** `superpowers/5.0.7/tests/claude-code/run-skill-tests.sh`
   - 类型：修改
   - 变更摘要：将 `test-version-test-template.sh` 纳入统一测试入口并更新帮助信息
   - 变更原因：确保新契约断言进入常规测试流程
   - 主逻辑影响：低（测试入口补充）

7. **修改** `superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`
   - 类型：修改
   - 变更摘要：明确 Stop gate 对 6 项模板质量字段执行强阻断
   - 变更原因：统一文档口径与实际 hook 执行语义
   - 主逻辑影响：低（文档契约对齐）

<a id="sec-20260421-stop-json"></a>
## 2026-04-21 Stop 门结构化 `missing_fields` 输出与负向用例

### 变更范围

- 修改：`superpowers/5.0.7/hooks`、`superpowers/5.0.7/tests/claude-code`、`superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`

### 文件变更明细

1. **修改** `superpowers/5.0.7/hooks/test-acceptance-gate`
   - 类型：修改
   - 变更摘要：新增 `block_missing_fields_and_exit`，当质量字段缺失时输出结构化 JSON：`decision` + `reason` + `missing_fields`
   - 变更原因：便于脚本/UI 解析具体缺失项，提升门禁可诊断性
   - 主逻辑影响：低到中（输出结构增强，不放宽门禁）

2. **新增** `superpowers/5.0.7/tests/claude-code/test-stop-gate-quality-fields.sh`
   - 类型：新增
   - 变更摘要：新增负向测试，逐项验证 6 个质量字段任一缺失都会被 Stop gate 拦截，并校验 `missing_fields` 输出
   - 变更原因：防止“文档改了但门禁行为回退”与“错误信息不可解析”
   - 主逻辑影响：低（测试覆盖增强）

3. **修改** `superpowers/5.0.7/tests/claude-code/run-skill-tests.sh`
   - 类型：修改
   - 变更摘要：接入 `test-stop-gate-quality-fields.sh` 到统一测试入口
   - 变更原因：将负向回归测试纳入常规执行
   - 主逻辑影响：低

4. **修改** `superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：修改
   - 变更摘要：新增对 `block_missing_fields_and_exit`、`missing_fields` 输出以及负向测试脚本存在性的断言
   - 变更原因：锁定结构化输出契约，避免后续漂移
   - 主逻辑影响：低

5. **修改** `superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`
   - 类型：修改
   - 变更摘要：补充 Stop gate 缺字段时返回结构化 JSON 的规则说明
   - 变更原因：保证文档口径与 hook 实际行为一致
   - 主逻辑影响：低

<a id="sec-20260421-contract-breadth"></a>
## 2026-04-21 全面契约与逐用例门禁（防口径回退）

### 变更范围

- 修改：`superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/README.md`
- 修改：`superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
- 修改：`superpowers/5.0.7/skills/autotest/SKILL.md`、`superpowers/5.0.7/skills/mocktest/SKILL.md`、`superpowers/5.0.7/skills/devicetest/SKILL.md`
- 修改：`superpowers/5.0.7/hooks/enforce-acceptance-order`、`superpowers/5.0.7/hooks/test-acceptance-gate`
- 修改：`superpowers/5.0.7/docs/superpowers/templates/tdd-report-template.md`
- 修改：`superpowers/5.0.7/tests/claude-code/test-tdd-report-template.sh`、`superpowers/5.0.7/tests/claude-code/test-stop-gate-quality-fields.sh`、`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`

### 文件变更明细

1. **修改** `superpowers/5.0.7/CLAUDE.md`
   - 类型：修改
   - 变更摘要：统一为版本前缀命名（`Vx.y.z-design/spec/plan/changelog/decisions.md`），并与 README 对齐七阶段顺序（TDD 在 Subagent Development 之前，`using-git-worktrees` 作为基础设施）
   - 变更原因：消除 README/CLAUDE 口径冲突导致的落盘路径与流程漂移
   - 主逻辑影响：低（契约说明统一）

2. **修改** `superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
   - 类型：修改
   - 变更摘要：版本级测试日志要求改为包含三项测试汇总（`autotest/mocktest/devicetest`）
   - 变更原因：对齐 Stop gate 实际校验口径，避免“按技能执行仍被 Stop 拦截”
   - 主逻辑影响：低

3. **修改** `superpowers/5.0.7/hooks/test-acceptance-gate`
   - 类型：修改
   - 变更摘要：PR 级质量字段校验由“文件级关键词出现”升级为“逐用例块校验”；每个 `T-xxx/TC-xxx` 必须包含 `Test Point/Expected Result/Assertion Target`
   - 变更原因：堵住“文档某处写一次字段名即可绕过”的缺口
   - 主逻辑影响：中（门禁更严格）

4. **修改** `superpowers/5.0.7/skills/autotest/SKILL.md`、`superpowers/5.0.7/skills/mocktest/SKILL.md`、`superpowers/5.0.7/skills/devicetest/SKILL.md`、`superpowers/5.0.7/hooks/enforce-acceptance-order`、`superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`
   - 类型：修改
   - 变更摘要：明确 preflight 策略：启动前 gate 只校验文档存在与用例编号；6 项质量字段由 Stop gate 严格阻断
   - 变更原因：消除“技能文案写启动前硬拦，但实际只在 Stop 拦”的执行歧义
   - 主逻辑影响：低（策略显式化）

5. **修改** `superpowers/5.0.7/docs/superpowers/templates/tdd-report-template.md`、`superpowers/5.0.7/tests/claude-code/test-tdd-report-template.sh`
   - 类型：修改
   - 变更摘要：修复 `Mapping Matrix` 表头/分隔列数不一致问题（6 列对齐），并加入列数断言
   - 变更原因：补齐模板结构缺陷的自动化防回退
   - 主逻辑影响：低（模板质量增强）

6. **修改** `superpowers/5.0.7/tests/claude-code/test-stop-gate-quality-fields.sh`、`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：修改
   - 变更摘要：新增“多用例防绕过”负向场景（`T-001` 完整但 `T-002` 缺字段必须阻断），并将逐用例校验与 preflight 策略声明纳入契约断言
   - 变更原因：锁定关键防绕过行为，防止回退为文件级关键词检查
   - 主逻辑影响：低（测试覆盖增强）

<a id="sec-20260421-bulk"></a>
## 2026-04-21 全量契约 + 混合兜底 + 测锁

### 变更范围

- 修改：`superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`
- 修改：`superpowers/5.0.7/skills/executing-plans/SKILL.md`、`superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`、`superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
- 修改：`superpowers/5.0.7/hooks/acceptance-order-common`、`superpowers/5.0.7/hooks/enforce-acceptance-order`、`superpowers/5.0.7/hooks/test-acceptance-gate`、`superpowers/5.0.7/hooks/hooks.json`、`superpowers/5.0.7/hooks/hooks-cursor.json`
- 修改：`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`、`superpowers/5.0.7/tests/claude-code/test-stop-gate-quality-fields.sh`、`superpowers/5.0.7/tests/skill-triggering/run-test.sh`、`superpowers/5.0.7/tests/skill-triggering/run-all.sh`、`superpowers/5.0.7/tests/subagent-driven-dev/run-test.sh`
- 新增：`superpowers/5.0.7/tests/skill-triggering/prompts/subagent-driven-development.txt`

### 文件变更明细

1. **修改** `superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/skills/executing-plans/SKILL.md`、`superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`、`superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
   - 类型：修改
   - 变更摘要：统一版本级测试汇总口径为三测齐全（`autotest/mocktest/devicetest`），统一 Review 阶段与 SDD reviewer loop 关系描述，修正命令来源列表顺序与流程图中的 RED/GREEN 证据表述
   - 变更原因：修复 README/CLAUDE/skills 之间的执行语义漂移
   - 主逻辑影响：中（契约口径收敛）

2. **修改** `superpowers/5.0.7/hooks/acceptance-order-common`、`superpowers/5.0.7/hooks/enforce-acceptance-order`、`superpowers/5.0.7/hooks/test-acceptance-gate`
   - 类型：修改
   - 变更摘要：新增共享 JSON block 输出器（统一 `decision/reason/missing_fields/status_fallback`），Stop gate 实现 hybrid fallback（状态缺失/异常时执行保守检查并标记 `status_fallback=true`），并保持逐用例质量字段阻断
   - 变更原因：堵住状态文件绕过面，提升门禁可观测性与输出一致性
   - 主逻辑影响：中到高（Stop 门禁行为增强）

3. **修改** `superpowers/5.0.7/hooks/hooks.json`、`superpowers/5.0.7/hooks/hooks-cursor.json`
   - 类型：修改
   - 变更摘要：扩展 PostToolUse matcher（`Edit|Write|MultiEdit|EditNotebook|NotebookEdit|ApplyPatch`），提高“需验收”状态打标覆盖
   - 变更原因：降低仅靠单一工具名匹配造成的静默漏标
   - 主逻辑影响：中（触发覆盖增强）

4. **修改** `superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`、`superpowers/5.0.7/tests/claude-code/test-stop-gate-quality-fields.sh`
   - 类型：修改
   - 变更摘要：新增 fallback 行为断言、共享 JSON 输出结构断言、systematic-debugging 关键契约断言、hooks matcher 扩展断言，并补充缺状态/异常状态下的门禁拦截测试
   - 变更原因：锁定本轮门禁与契约修复，防止回退
   - 主逻辑影响：低（测试补锁）

5. **修改** `superpowers/5.0.7/tests/skill-triggering/run-test.sh`、`superpowers/5.0.7/tests/skill-triggering/run-all.sh`、`superpowers/5.0.7/tests/subagent-driven-dev/run-test.sh`，**新增** `superpowers/5.0.7/tests/skill-triggering/prompts/subagent-driven-development.txt`
   - 类型：测试增强
   - 变更摘要：触发测试从“仅触发”扩展到核心行为短语断言（systematic-debugging/test-driven-development/executing-plans），纳入 subagent-driven-development naive prompt，用例执行脚本从日志采集改为可判定 PASS/FAIL
   - 变更原因：提升技能行为验证能力，减少“触发了但行为跑偏”漏检
   - 主逻辑影响：中（测试质量增强）

<a id="sec-20260421-prloop"></a>
## 2026-04-21 PR 主链、active PR 上下文与 PRn 聚合（文档与 hook 口径）

### 变更范围

- 修改：`superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/CALUDE_zh.md`
- 修改：`superpowers/5.0.7/skills/brainstorming/SKILL.md`、`superpowers/5.0.7/skills/writing-plans/SKILL.md`、`superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`、`superpowers/5.0.7/skills/executing-plans/SKILL.md`、`superpowers/5.0.7/skills/requesting-code-review/SKILL.md`、`superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
- 修改：`superpowers/5.0.7/hooks/acceptance-order-common`、`superpowers/5.0.7/hooks/enforce-acceptance-order`、`superpowers/5.0.7/hooks/test-acceptance-gate`
- 修改：`superpowers/5.0.7/docs/superpowers/templates/tdd-report-template.md`、`superpowers/5.0.7/docs/superpowers/templates/versioning/version-test-template.md`
- 修改：`circle_run_case.md`
- 新增：`superpowers/5.0.7/tests/claude-code/test-active-pr-resolution.sh`
- 修改：`superpowers/5.0.7/tests/claude-code/run-skill-tests.sh`、`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`

### 文件变更明细

1. **修改** `README.md`、`CLAUDE.md`、`CALUDE_zh.md`
   - 类型：修改
   - 变更摘要：统一 `PR1..PRn` 循环语义，明确 Finalize 为 active PR 收口；补充“PR切换需显式切换 active PR 上下文”与“PRn 聚合回归仍绑定 active PR”口径
   - 变更原因：修复多 PR 场景下“版本回归与门禁绑定对象”描述不清
   - 主逻辑影响：中（执行口径更硬）

2. **修改** `skills/writing-plans/SKILL.md`、`skills/subagent-driven-development/SKILL.md`、`skills/executing-plans/SKILL.md`、`skills/finishing-a-development-branch/SKILL.md`、`skills/requesting-code-review/SKILL.md`、`skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：将 PR 循环从“描述性规则”升级为“执行动作约束”，补齐 PR 过渡动作（active PR 切换）、PRn 聚合回归上下文、Review 上下游准入边界；并在 brainstorming 明确 design-gate/spec-gate 双门
   - 变更原因：避免执行时凭经验补全上下文，降低门禁错绑 PR 的概率
   - 主逻辑影响：中到高（流程执行更可验证）

3. **修改** `hooks/acceptance-order-common`、`hooks/enforce-acceptance-order`、`hooks/test-acceptance-gate`
   - 类型：修改
   - 变更摘要：active PR 解析优先级增强（`SUPERPOWERS_ACTIVE_PR_DIR` > `SUPERPOWERS_ACTIVE_PR` > `SUPERPOWERS_ACTIVE_PR_CONTEXT` > `.claude/.active-pr` > prompt hint > latest fallback）；`.active-pr` 支持绝对路径
   - 变更原因：修复多 PR 并存场景中“按 latest 误判 active PR”风险
   - 主逻辑影响：高（门禁对象绑定更准确）

4. **修改** `docs/superpowers/templates/tdd-report-template.md`、`docs/superpowers/templates/versioning/version-test-template.md`、`circle_run_case.md`
   - 类型：修改
   - 变更摘要：模板新增“前置创建 + 循环维护 + PR切换时显式上下文切换”说明；案例文档补齐 PR2..PRn 过渡动作、PRn 聚合回归上下文、Finalize 边界说明
   - 变更原因：消除使用层误解，确保案例与主库契约一致
   - 主逻辑影响：中（落地指导更清晰）

5. **新增/修改** `tests/claude-code/test-active-pr-resolution.sh`、`tests/claude-code/run-skill-tests.sh`、`tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：测试增强
   - 变更摘要：新增 active PR 解析优先级测试；将新测试接入统一测试入口；补充契约断言（active context env、marker 文件、测试文件存在）
   - 变更原因：防止 active PR 解析逻辑和文档语义回退
   - 主逻辑影响：低（测试覆盖增强）

<a id="sec-20260421-prpaste"></a>
## 2026-04-21 Active PR：可复制 `bash` 片段与契约测试

### 变更范围

- 修改：`superpowers/5.0.7/README.md`、`superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/CALUDE_zh.md`、`circle_run_case.md`
- 修改：`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`

### 文件变更明细

1. **修改** `README.md`、`CLAUDE.md`、`CALUDE_zh.md`
   - 类型：修改
   - 变更摘要：在 README 增加 **Active PR context (hooks)** 小节，列出与 `acceptance-order-common` 一致的优先级，并提供 `.claude/.active-pr` 与各环境变量的可复制 `bash` 示例；CLAUDE 增加一行解析顺序指针指向 README；CALUDE_zh 增加对应中文小节与示例。
   - 变更原因：降低多 PR 场景下误绑门禁对象的操作成本，并与 hook 实现字面一致。
   - 主逻辑影响：低（文档与可复制片段）

2. **修改** `circle_run_case.md`
   - 类型：修改
   - 变更摘要：在 PR2..PRn 步骤中嵌入与主库一致的 active PR 切换代码片段。
   - 变更原因：案例与 README 操作口径对齐。

3. **修改** `tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：测试增强
   - 变更摘要：为 README/CALUDE/CALUDE_zh 的 active PR 文档增加契约断言，防止回退。
   - 主逻辑影响：低

<a id="sec-20260420-pass2"></a>
## 2026-04-20 二轮复检：英文称谓、your human partner 等口径

### 文件变更明细

1. **修改** `superpowers/5.0.7/CALUDE_zh.md`
   - 类型：修改
   - 变更摘要：中文文档七阶段流程改为 Canonical 口径，并补齐技能映射说明
   - 变更原因：消除中英文流程描述不一致
   - 主逻辑影响：低

2. **修改** `superpowers/5.0.7/skills/executing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：将 `using-git-worktrees` 从 executing 流程中的“REQUIRED”改为基础设施说明，明确其主要属于 Stage 5 子代理开发启动
   - 变更原因：收敛职责边界，避免调用方歧义
   - 主逻辑影响：低

3. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：在技能清单中将 `using-git-worktrees` 改写为“Subagent Development 基础设施”
   - 变更原因：减少被误读为独立业务阶段
   - 主逻辑影响：低

<a id="sec-20260420-seven"></a>
## 2026-04-20 七步 Orchestrator 口径、hook `exit 2` 与 worktree=基础设施

### 文件变更明细

1. **修改** `superpowers/5.0.7/CLAUDE.md`
   - 类型：修改
   - 变更摘要：将运行时七步改为 Canonical 命名（Brainstorm/Spec/Plan/TDD/Subagent Development/Review/Finalize），并补充技能映射
   - 变更原因：与最新七步定义统一，消除 `using-git-worktrees` 独立阶段歧义
   - 主逻辑影响：低（口径统一）

2. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：基础流程改为七步 Canonical 口径，明确 `using-git-worktrees` 为 Stage 5 子代理开发内部基础设施
   - 变更原因：保持用户入口文档与主契约一致
   - 主逻辑影响：低

3. **修改** `superpowers/5.0.7/skills/using-git-worktrees/SKILL.md`
   - 类型：修改
   - 变更摘要：重定义为基础设施技能；调用方收敛为 `subagent-driven-development`；明确不产出 `.md`，只产出隔离 worktree
   - 变更原因：对齐“非独立阶段”的定位
   - 主逻辑影响：中（角色边界更清晰）

4. **修改** `superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`
   - 类型：修改
   - 变更摘要：在流程图中加入启动时先调用 `using-git-worktrees` 的基础设施步骤，并标注为 Stage 5
   - 变更原因：固化切入时机，避免遗漏 worktree 初始化
   - 主逻辑影响：中

5. **修改** `superpowers/5.0.7/skills/writing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：修正 worktree 来源描述，不再归因于 brainstorming，改为 Stage 5 启动时由 `using-git-worktrees` 提供
   - 变更原因：消除跨技能职责冲突
   - 主逻辑影响：低

6. **修改** `superpowers/5.0.7/hooks/enforce-acceptance-order`
   - 类型：修改
   - 变更摘要：新增 `block_and_exit`，block 分支统一改为非零退出（`exit 2`）
   - 变更原因：降低“只输出 block JSON 但进程成功退出”导致的门禁失效风险
   - 主逻辑影响：中（门禁更硬）

7. **修改** `superpowers/5.0.7/hooks/test-acceptance-gate`
   - 类型：修改
   - 变更摘要：新增 `block_and_exit`，所有 block 分支及顺序校验失败改为 `exit 2`
   - 变更原因：统一 Stop 门禁阻断语义
   - 主逻辑影响：中

8. **修改** `superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：修改
   - 变更摘要：新增七步 Canonical 口径、`Vx.y.z-test.md`、worktree 基础设施定位、hook 非零阻断语义的断言
   - 变更原因：防止后续回退与文案漂移
   - 主逻辑影响：低（测试侧）

<a id="sec-20260420-brain-mat"></a>
## 2026-04-20 Brainstorming 材料分流、版本容量与 Visual Companion 策略

### 文件变更明细

1. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：调整为“第2步版本模式决策（新版本/当前版本；若新版本则新功能/小优化）+ 第3步材料多选（Idea/PRD/Design Draft/Interactive Demo）”，并补齐材料驱动子流程、无材料补问分支、版本容量质疑、Visual Companion 非强制触发与拒绝后不重复提示规则
   - 变更原因：让 Brainstorming 更有针对性，减少空转追问与过早视觉化
   - 主逻辑影响：中（需求澄清入口策略增强）

2. **修改** `superpowers/5.0.7/skills/brainstorming/spec-document-reviewer-prompt.md`
   - 类型：修改
   - 变更摘要：新增 Material Traceability / Version Capacity / Testable Acceptance 检查项，补充 Blocking Issues、Material Coverage Check、Version Capacity Check 输出块
   - 变更原因：把“材料不足或容量超载”显式转为可阻断审查信号
   - 主逻辑影响：低（审查提示增强）

3. **修改** `superpowers/5.0.7/skills/brainstorming/visual-companion.md`
   - 类型：修改
   - 变更摘要：明确 Visual Companion “可用但非强制”，补充触发条件与已发布产品对照演示流程（Current vs Option A/B）
   - 变更原因：支持真实场景可视化，不再因默认弹窗造成干扰
   - 主逻辑影响：低（流程策略增强）

4. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：同步 Brainstorming 新入口顺序（第2步版本模式，第3步材料多选）
   - 变更原因：保持 README 与 SKILL 主流程口径一致
   - 主逻辑影响：低

5. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：新增可直接复用的固定提问模板（Step 2 版本模式 + Step 3 材料多选）
   - 变更原因：降低执行偏差，避免重复口头解释导致流程漂移
   - 主逻辑影响：低

<a id="sec-20260420-chlog-rule"></a>
## 2026-04-20 同版本 `changelog` 更正记录硬规则

### 文件变更明细

1. **修改** `superpowers/5.0.7/CLAUDE.md`（`AGENTS.md` 软链接同步）
   - 类型：修改
   - 变更摘要：新增明确规则：设计、开发、测试、发布阶段的所有重要更正必须写入同版本 `Vx.y.z-changelog.md`
   - 变更原因：将“更正记录”从建议提升为全流程硬契约
   - 主逻辑影响：低（文档约束增强）

2. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：在文档契约与运行时摘要中增加版本级更正记录硬规则
   - 变更原因：保持用户入口文档与主契约一致
   - 主逻辑影响：低

3. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：补充设计阶段更正时必须更新版本 `changelog` 的要求
   - 变更原因：覆盖“设计阶段”更正记录
   - 主逻辑影响：低

4. **修改** `superpowers/5.0.7/skills/executing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：补充开发/测试过程中重要更正需即时写入版本 `changelog`
   - 变更原因：覆盖“开发与测试阶段”更正记录
   - 主逻辑影响：低

5. **修改** `superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
   - 类型：修改
   - 变更摘要：在收尾门禁增加“发布前确认版本 `changelog` 已包含全阶段重要更正”
   - 变更原因：覆盖“发布阶段”更正记录
   - 主逻辑影响：低

6. **修改** `superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：修改
   - 变更摘要：新增更正记录硬规则断言（CLAUDE/README/关键 skills）
   - 变更原因：防止后续规则回退
   - 主逻辑影响：低（测试侧）

<a id="sec-20260420-names"></a>
## 2026-04-20 审阅/设计文档命名与「中文说明 / EN 主文」分层

### 变更范围

- 修改：`superpowers/5.0.7`
- 修改：`superpowers/5.0.7/changelogs.md`（本文件；此前在 `superpowers/changelogs.md`）

### 文件变更明细

1. **修改** `superpowers/5.0.7/CLAUDE.md`（`AGENTS.md` 为其软链接同步）
   - 类型：修改
   - 变更摘要：将新增的“角色/任务/文件结构”块统一为英文；版本根文档名统一为 `Vx.y.z-*.md` 风格；补充 `<topic>` 两关键词命名规则与示例 `v0.1.4-scroll-highlight`、`v0.1.5-panel-ui`
   - 变更原因：统一命名契约并降低运行时歧义
   - 主逻辑影响：低（文档约束增强）

2. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：同步版本根文件名为 `Vx.y.z-design/spec/plan/changelog/decisions.md` 并补充 `<topic>` 命名规则
   - 变更原因：保持 README 与主契约文档一致
   - 主逻辑影响：低

3. **修改** `superpowers/5.0.7/skills/*` 与 `docs/superpowers/templates/*`（相关契约文件）
   - 类型：修改
   - 变更摘要：将 `docs/Vx.y.z-<topic>/design.md|spec.md|plan.md|changelog.md|decisions.md` 全部迁移为对应 `Vx.y.z-*.md` 路径
   - 变更原因：全链路对齐新命名
   - 主逻辑影响：低

4. **修改** `superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
   - 类型：修改
   - 变更摘要：断言更新为新命名路径，并新增 `<topic>` 命名示例断言
   - 变更原因：避免旧断言误报
   - 主逻辑影响：低（测试侧）

5. **新增** `superpowers/5.0.7/CALUDE_zh.md`
   - 类型：新增
   - 变更摘要：新增 `CLAUDE.md` 中文翻译版本（按用户指定文件名）
   - 变更原因：保留英文主契约的同时提供中文阅读版本
   - 主逻辑影响：无

<a id="sec-20260420-evo-migrate"></a>
## 2026-04-20 进化闭环迁到 `LESSONS` + `feedback`（不新增第二套角色名）

### 变更范围

- 仅修改：`superpowers/5.0.7`
- 明确未修改：`superpowers/demo`

### 文件变更明细

1. **修改** `superpowers/5.0.7/hooks/hooks.json`
   - 类型：修改
   - 变更摘要：新增 `UserPromptSubmit` 触发 `detect-feedback-signal`，并在 `SessionStart` 增加 `check-evolution`
   - 变更原因：补齐信号检测与会话启动进化提醒链路
   - 主逻辑影响：低（新增提醒链路，不替代原门禁）

2. **修改** `superpowers/5.0.7/hooks/hooks-cursor.json`
   - 类型：修改
   - 变更摘要：新增 `userPromptSubmit` 与 `sessionStart` 的进化脚本触发
   - 变更原因：Cursor 侧事件对齐
   - 主逻辑影响：低

3. **新增** `superpowers/5.0.7/hooks/detect-feedback-signal`
   - 类型：新增
   - 变更摘要：检测修正/不满/改进信号，注入 `additionalContext` 提醒反馈记录
   - 变更原因：替代 pmskills detect 能力（不新增角色）
   - 主逻辑影响：低（提醒型）

4. **新增** `superpowers/5.0.7/hooks/check-evolution`
   - 类型：新增
   - 变更摘要：SessionStart 扫描 `.claude/feedback/FEEDBACK-INDEX.md` 并注入进化检查提醒
   - 变更原因：替代 pmskills check-evolution 能力（不新增角色）
   - 主逻辑影响：低（提醒型）

5. **新增** `superpowers/5.0.7/feedback/templates/feedback-topic-template.md`
   - 类型：新增
   - 变更摘要：统一单条反馈模板，包含 `status`/`occurrences`/确认规则字段
   - 变更原因：补齐数据层资产
   - 主逻辑影响：无

6. **新增** `superpowers/5.0.7/feedback/templates/feedback-index-template.md`
   - 类型：新增
   - 变更摘要：统一索引格式与运行时路径说明
   - 变更原因：补齐索引规范
   - 主逻辑影响：无

7. **修改** `superpowers/5.0.7/skills/using-superpowers/SKILL.md`
   - 类型：修改
   - 变更摘要：新增“Feedback Evolution Responsibility (No Extra Roles)”职责定义
   - 变更原因：将 observer/runner 责任内化到主 Agent
   - 主逻辑影响：低（职责补充）

8. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：新增命中反馈信号后的记录责任说明
   - 变更原因：把反馈记录动作接入现有流程节点
   - 主逻辑影响：低

9. **修改** `superpowers/5.0.7/skills/writing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：新增 evolution reminder 处理规则（候选提议与 confirm/skip）
   - 变更原因：将进化检查动作接入计划阶段
   - 主逻辑影响：低

10. **修改** `superpowers/5.0.7/SUPERPOWERS_PMSKILLS_FUSION_GUIDE.md`
    - 类型：修改
    - 变更摘要：补齐状态流转、去重计数、提议输出格式与 confirm/skip 规则
    - 变更原因：统一阈值 `occurrences >= 2` 与闭环语义
    - 主逻辑影响：低

### 可用性验证摘要（只读）

- Hook 触发点验证：`hooks.json/hooks-cursor.json` 中已存在 `UserPromptSubmit/userPromptSubmit` 与 `check-evolution` 绑定。
- 规则验证：融合指南包含 `occurrences >= 2`、`candidate/graduated/skipped`、`confirm/skip`。
- 边界验证：本次改动目标均在 `superpowers/5.0.7` 与本 changelog 文件路径内，未触及 `superpowers/demo` 内容。

<a id="sec-20260420-prod"></a>
## 2026-04-20 生产化增强：澄清 + 进化落盘前序

### 变更范围

- 仅修改：`superpowers/5.0.7`
- 明确未修改：`superpowers/demo`

### 文件变更明细

1. **修改** `superpowers/5.0.7/SUPERPOWERS_PMSKILLS_FUSION_GUIDE.md`
   - 类型：修改
   - 变更摘要：
     - 固化单框架定位（Superpowers 唯一主流程）
     - 明确“直接用于实际开发，不走试点”
     - 增加“能力评估关键点”（澄清能力、进化能力）
     - 将“两周试点”改为“生产启用方式”
   - 变更原因：按生产化增强要求，保留主逻辑、直接落地
   - 主逻辑影响：低（增强说明层，不改核心执行门禁）

2. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：
     - 新增 `Clarification quality checkpoints (minimum bar)` 小节
     - 加入四类澄清检查点（价值真实性、路径闭合、MVP裁剪、AI增强）
   - 变更原因：最小化注入 pmskills 澄清能力
   - 主逻辑影响：低（不改原流程，仅加质量检查）

3. **修改** `superpowers/5.0.7/skills/writing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：
     - 新增 `Task Boundary Clarity Check` 小节
     - 增加任务边界与歧义扫描要求
   - 变更原因：强化计划任务可执行性，减少歧义返工
   - 主逻辑影响：低（不改原流程，仅加清晰度门槛）

4. **新增** `superpowers/5.0.7/changelogs.md`（初版曾置于 `superpowers/changelogs.md`，后迁此）
   - 类型：新增
   - 变更摘要：记录本次全部修改与边界约束
   - 变更原因：满足“记录所有修改和增删”的要求
   - 主逻辑影响：无

<a id="sec-20260420-keeper"></a>
## 2026-04-20 进化「专员」与 `evolution-keeper` 角色

### 变更范围

- 仅修改：`superpowers/5.0.7`
- 明确未修改：`superpowers/demo`

### 文件变更明细

1. **新增** `superpowers/5.0.7/agents/evolution-keeper.md`
   - 类型：新增
   - 变更摘要：定义单一 `evolution-keeper` 角色，覆盖记录、聚合提议、人工确认闭环
   - 变更原因：将“主 Agent 全责”改为“单角色专责”，提升执行稳定性
   - 主逻辑影响：低（职责重分配，不改核心门禁）

2. **修改** `superpowers/5.0.7/skills/using-superpowers/SKILL.md`
   - 类型：修改
   - 变更摘要：将 `Feedback Evolution Responsibility (No Extra Roles)` 改为 `Feedback Evolution Responsibility (Evolution Keeper)`
   - 变更原因：统一职责落点为 `evolution-keeper`
   - 主逻辑影响：低

3. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：反馈信号命中后改为派发 `evolution-keeper` 执行记录/索引更新
   - 变更原因：避免主 Agent 漏执行记录动作
   - 主逻辑影响：低

4. **修改** `superpowers/5.0.7/skills/writing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：SessionStart 进化提醒改为派发 `evolution-keeper` 执行候选识别与提议
   - 变更原因：统一进化提议执行方
   - 主逻辑影响：低

5. **修改** `superpowers/5.0.7/hooks/detect-feedback-signal`
   - 类型：修改
   - 变更摘要：提醒文案改为明确“派发 evolution-keeper”
   - 变更原因：对齐 hook 文案与技能职责
   - 主逻辑影响：低（提醒型）

6. **修改** `superpowers/5.0.7/hooks/check-evolution`
   - 类型：修改
   - 变更摘要：SessionStart 提醒文案改为明确“派发 evolution-keeper”
   - 变更原因：对齐 hook 文案与角色化改造
   - 主逻辑影响：低（提醒型）

7. **修改** `superpowers/5.0.7/SUPERPOWERS_PMSKILLS_FUSION_GUIDE.md`
   - 类型：修改
   - 变更摘要：补充“单角色归属”与上线动作中的角色派发要求
   - 变更原因：同步治理文档，避免执行责任歧义
   - 主逻辑影响：低（文档治理层）

8. **补充修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`、`superpowers/5.0.7/skills/writing-plans/SKILL.md`、`superpowers/5.0.7/SUPERPOWERS_PMSKILLS_FUSION_GUIDE.md`
   - 类型：补充修改
   - 变更摘要：增加“派发后回传结构化结果”要求，明确主 Agent 负责转述与确认收口
   - 变更原因：对齐方案中“派发并回传结果”的执行细节
   - 主逻辑影响：低（执行接口补完，不改门禁）

9. **补充修改** `superpowers/5.0.7/agents/evolution-keeper.md`、`superpowers/5.0.7/skills/using-superpowers/SKILL.md`
   - 类型：补充修改
   - 变更摘要：固化 `Evolution Keeper Result` 输出模板，并要求命中提醒后主 Agent 必须回显该结果块
   - 变更原因：减少“执行了但未可见”的链路不透明问题
   - 主逻辑影响：低（可观测性增强）

10. **新增** `superpowers/5.0.7/feedback/templates/evolution-keeper-acceptance-checklist.md`
    - 类型：新增
    - 变更摘要：提供 3 个端到端验收场景（反馈命中、SessionStart 候选、confirm/skip 落账）
    - 变更原因：一次性交付可操作验收标准，降低回归沟通成本
    - 主逻辑影响：无

11. **新增** `superpowers/5.0.7/docs/superpowers/reports/2026-04-20-toxic-pm-injection-check.md`
    - 类型：新增
    - 变更摘要：新增“毒舌 PM 注入跑通检查”报告，包含静态通过项、运行阻塞项与复跑步骤
    - 变更原因：沉淀本次 brainstorming/writing-plans 节点跑通验证证据
    - 主逻辑影响：无（验证文档）

<a id="sec-20260420-testgate"></a>
## 2026-04-20 测试证据化与 Stop 等门禁试点

### 变更范围

- 仅修改：`superpowers/5.0.7`
- 明确未修改：`superpowers/demo`

### 文件变更明细

1. **新增** `superpowers/5.0.7/docs/superpowers/reports/2026-04-20-testing-closure-gap-matrix.md`
   - 类型：新增
   - 变更摘要：补齐“规则 vs 产物/门禁”差距矩阵
   - 变更原因：将问题诊断沉淀为可执行补强清单
   - 主逻辑影响：无（分析文档）

2. **修改** `superpowers/5.0.7/skills/writing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：新增测试证据产物要求（TDD 报告、RED/GREEN、重跑规则、header 引用）
   - 变更原因：解决“仅有 plan 无测试证据”的缺口
   - 主逻辑影响：低（流程约束增强）

3. **修改** `superpowers/5.0.7/skills/executing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：新增每任务证据门禁、完成前 verification gate、重跑规则
   - 变更原因：把验证从建议升级为任务级强约束
   - 主逻辑影响：低（执行门禁增强）

4. **修改** `superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`
   - 类型：修改
   - 变更摘要：新增 Evidence Gate Per Task，补充完成声明与 TDD 证据红线
   - 变更原因：降低“子代理说完成但无证据”的风险
   - 主逻辑影响：低

5. **修改** `superpowers/5.0.7/skills/subagent-driven-development/implementer-prompt.md`
   - 类型：修改
   - 变更摘要：将 TDD 从“条件执行”改为默认要求，并强制回传 RED/GREEN 证据
   - 变更原因：统一 TDD 执行语义，减少可选化
   - 主逻辑影响：低

6. **修改** `superpowers/5.0.7/skills/verification-before-completion/SKILL.md`
   - 类型：修改
   - 变更摘要：新增 `## Verification Evidence` 输出 schema 与缺失拦截红线
   - 变更原因：标准化完成声明证据格式
   - 主逻辑影响：低

7. **修改** `superpowers/5.0.7/skills/requesting-code-review/SKILL.md`
   - 类型：修改
   - 变更摘要：内化 Stage1/Stage2 审查顺序、Spec Drift、安全最小扫描
   - 变更原因：提升真实问题发现率
   - 主逻辑影响：低

8. **修改** `superpowers/5.0.7/skills/subagent-driven-development/spec-reviewer-prompt.md`
   - 类型：修改
   - 变更摘要：补充 Spec Drift 检查与专门输出项
   - 变更原因：避免超规格功能静默混入
   - 主逻辑影响：低

9. **修改** `superpowers/5.0.7/skills/subagent-driven-development/code-quality-reviewer-prompt.md`
   - 类型：修改
   - 变更摘要：新增安全最小扫描项（密钥/插值/路径）
   - 变更原因：补齐代码审查的安全维度
   - 主逻辑影响：低

10. **新增** `superpowers/5.0.7/docs/superpowers/templates/tdd-report-template.md`
    - 类型：新增
    - 变更摘要：提供标准化 TDD 报告模板（spec-plan-test 映射）
    - 变更原因：固化测试证据产物
    - 主逻辑影响：无

11. **修改** `superpowers/5.0.7/tests/skill-triggering/run-all.sh`
    - 类型：修改
    - 变更摘要：新增 `verification-before-completion` 触发测试
    - 变更原因：扩大技能触发覆盖面
    - 主逻辑影响：低（测试侧）

12. **新增** `superpowers/5.0.7/tests/skill-triggering/prompts/verification-before-completion.txt`
    - 类型：新增
    - 变更摘要：新增完成前验证场景提示词
    - 变更原因：支持触发测试扩展
    - 主逻辑影响：无

13. **修改** `superpowers/5.0.7/tests/skill-triggering/run-test.sh`
    - 类型：修改
    - 变更摘要：为 `verification-before-completion` 增加证据语义断言
    - 变更原因：从“触发了”升级到“触发后语义有效”
    - 主逻辑影响：低

14. **新增** `superpowers/5.0.7/tests/claude-code/test-verification-before-completion.sh`
    - 类型：新增
    - 变更摘要：新增完成声明证据技能测试
    - 变更原因：补齐 Claude Code 测试矩阵
    - 主逻辑影响：低（测试侧）

15. **新增** `superpowers/5.0.7/tests/claude-code/test-tdd-report-template.sh`
    - 类型：新增
    - 变更摘要：新增 TDD 报告模板字段自动断言
    - 变更原因：自动检查证据产物基础完整性
    - 主逻辑影响：低（测试侧）

16. **修改** `superpowers/5.0.7/tests/claude-code/run-skill-tests.sh`
    - 类型：修改
    - 变更摘要：接入新增测试脚本
    - 变更原因：把新断言纳入统一测试入口
    - 主逻辑影响：低（测试侧）

17. **新增** `superpowers/5.0.7/docs/superpowers/pilots/project-hook-gate-pilot.md`
    - 类型：新增
    - 变更摘要：项目层 hook 门禁试点方案与评估标准
    - 变更原因：支持非核心路径试点落地
    - 主逻辑影响：无

18. **新增** `superpowers/5.0.7/docs/superpowers/templates/project-hooks/pre-commit-check.sh`
19. **新增** `superpowers/5.0.7/docs/superpowers/templates/project-hooks/mark-review-needed.sh`
20. **新增** `superpowers/5.0.7/docs/superpowers/templates/project-hooks/stop-gate.sh`
21. **新增** `superpowers/5.0.7/docs/superpowers/templates/project-hooks/hook-gate-pilot-metrics-template.md`
    - 类型：新增
    - 变更摘要：提供项目层 hook 试点脚本模板与指标模板
    - 变更原因：降低试点接入成本，便于量化评估
    - 主逻辑影响：无

<a id="sec-20260420-507"></a>
## 2026-04-20 5.0.7 起：版本 / PR / Task 文档 + 七步流硬规

### 变更范围

- 仅修改：`superpowers/5.0.7`
- 明确未修改：`superpowers/demo`

### 文件变更明细

1. **修改** `superpowers/5.0.7/skills/brainstorming/SKILL.md`
   - 类型：修改
   - 变更摘要：将文档落盘改为版本目录模式，要求初始化 `design/spec/changelog/decisions`
   - 变更原因：把需求阶段产物统一到版本根目录
   - 主逻辑影响：中（产物路径与契约升级）

2. **修改** `superpowers/5.0.7/skills/writing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：计划路径切换到 `docs/Vx.y.z-<topic>/plan.md`；新增 PR 分组策略与版本治理产物要求
   - 变更原因：实现版本驱动 + 任务到 PR 的硬映射
   - 主逻辑影响：中

3. **修改** `superpowers/5.0.7/skills/executing-plans/SKILL.md`
   - 类型：修改
   - 变更摘要：执行中强制更新 PR 日志包，并在完成前同步版本 `changelog/decisions`
   - 变更原因：防止执行证据散落在会话文本
   - 主逻辑影响：中

4. **修改** `superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`
   - 类型：修改
   - 变更摘要：新增 PR Doc Pack Gate 与 finalize-log 红线
   - 变更原因：把子代理执行结果沉淀为可审计 PR 资产
   - 主逻辑影响：中

5. **修改** `superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
   - 类型：修改
   - 变更摘要：新增 finalize-log 必填门禁（缺失则不能进入完成选项）
   - 变更原因：确保收尾阶段文档完整闭环
   - 主逻辑影响：中

6. **新增** `superpowers/5.0.7/docs/superpowers/templates/versioning/version-folder-template.md`
7. **新增** `superpowers/5.0.7/docs/superpowers/templates/versioning/pr-folder-template.md`
8. **新增** `superpowers/5.0.7/docs/superpowers/templates/versioning/plan-pr-splitting-rules.md`
   - 类型：新增
   - 变更摘要：补齐版本目录、PR目录、PR切分规则模板
   - 变更原因：提供硬规则化落地模板
   - 主逻辑影响：无（模板资产）

9. **修改** `superpowers/5.0.7/docs/superpowers/templates/tdd-report-template.md`
   - 类型：修改
   - 变更摘要：对齐版本树与 PR 级 `tdd-log` 路径
   - 变更原因：统一测试证据与版本/PR契约
   - 主逻辑影响：低

10. **修改** `superpowers/5.0.7/tests/skill-triggering/run-all.sh`
11. **新增** `superpowers/5.0.7/tests/skill-triggering/prompts/brainstorming.txt`
12. **新增** `superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
13. **修改** `superpowers/5.0.7/tests/claude-code/run-skill-tests.sh`
   - 类型：测试增强
   - 变更摘要：扩展版本/PR文档契约测试覆盖
   - 变更原因：让硬规则有自动化断言
   - 主逻辑影响：低（测试侧）

14. **修改** `superpowers/5.0.7/README.md`
   - 类型：修改
   - 变更摘要：七阶段说明升级为版本/PR/Task硬规则流程
   - 变更原因：对外文档与技能行为保持一致
   - 主逻辑影响：低

15. **修改** `superpowers/5.0.7/skills/brainstorming/spec-document-reviewer-prompt.md`
    - 类型：修改
    - 变更摘要：Spec reviewer 调用路径改为版本根 `docs/Vx.y.z-<topic>/spec.md`
    - 变更原因：清理旧路径引用，保持硬规则一致
    - 主逻辑影响：低

16. **新增** `superpowers/5.0.7/skills/autotest/SKILL.md`、`superpowers/5.0.7/skills/devicetest/SKILL.md`、`superpowers/5.0.7/skills/mocktest/SKILL.md`
    - 类型：新增
    - 变更摘要：新增三项最终测试验收技能，并纳入 PR/版本完成前必跑要求
    - 变更原因：强化真实问题发现能力，突出自动化测试优先级
    - 主逻辑影响：中

17. **修改** `superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`
    - 类型：修改
    - 变更摘要：新增 Step 1.5，强制执行 `autotest/devicetest/mocktest` 并定义日志落点
    - 变更原因：把最终测试验收变成收尾硬门禁
    - 主逻辑影响：中

18. **新增** `superpowers/5.0.7/docs/superpowers/templates/versioning/version-test-template.md`
    - 类型：新增
    - 变更摘要：新增版本级 `Vx.y.z-test.md` 模板
    - 变更原因：承接版本整体测试汇总需求
    - 主逻辑影响：无

19. **新增** `superpowers/5.0.7/hooks/mark-test-acceptance-needed`、`superpowers/5.0.7/hooks/test-acceptance-gate`
    - 类型：新增
    - 变更摘要：新增测试验收状态标记与 Stop 阶段阻断门禁
    - 变更原因：通过 hook 机制强制测试验收闭环
    - 主逻辑影响：中

20. **修改** `superpowers/5.0.7/hooks/hooks.json`、`superpowers/5.0.7/hooks/hooks-cursor.json`
    - 类型：修改
    - 变更摘要：接入 `PostToolUse(Edit|Write)` 标记和 `Stop` 阶段测试验收门禁
    - 变更原因：统一 Claude/Cursor 的测试验收调控
    - 主逻辑影响：中

21. **修改** `superpowers/5.0.7/README.md`、`superpowers/5.0.7/docs/superpowers/templates/versioning/pr-folder-template.md`
    - 类型：修改
    - 变更摘要：明确三项强制验收测试及 PR/版本日志写入规则
    - 变更原因：对外文档与执行规则一致化
    - 主逻辑影响：低

22. **补充修改** `superpowers/5.0.7/skills/autotest/SKILL.md`、`superpowers/5.0.7/skills/devicetest/SKILL.md`、`superpowers/5.0.7/skills/mocktest/SKILL.md`
    - 类型：补充修改
    - 变更摘要：将三项验收测试明确绑定到 ChatBobi 项目命令路径，并规范结果字段包含 command source path
    - 变更原因：对齐夏老板现有测试技能来源，避免插件内语义漂移
    - 主逻辑影响：低

23. **补充修改** `superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`、`superpowers/5.0.7/docs/superpowers/templates/versioning/version-test-template.md`、`superpowers/5.0.7/README.md`
    - 类型：补充修改
    - 变更摘要：在收尾门禁、版本测试模板和总说明中明确三项命令来源路径，并细化 PR 级/版本级写入边界
    - 变更原因：落实“PR测试写入PRn，版本整体测试写入 test.md”的执行细则
    - 主逻辑影响：低

24. **补充修改** `superpowers/5.0.7/skills/autotest/SKILL.md`、`superpowers/5.0.7/skills/devicetest/SKILL.md`、`superpowers/5.0.7/skills/mocktest/SKILL.md`、`superpowers/5.0.7/hooks/test-acceptance-gate`、`superpowers/5.0.7/docs/superpowers/templates/versioning/version-test-template.md`
    - 类型：补充修改
    - 变更摘要：三项测试技能新增启动前硬门禁：强制检测 PR级 `PRn-tdd-log.md` 与版本级 `Vx.y.z-test.md`，且两者必须包含详细测试用例；缺失即 BLOCKED 打回
    - 变更原因：落实“无详细测试用例，不启动，打回”的强约束
    - 主逻辑影响：中（门禁更严格）

25. **补充修改** `superpowers/5.0.7/README.md`、`superpowers/5.0.7/skills/executing-plans/SKILL.md`、`superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`、`superpowers/5.0.7/skills/requesting-code-review/SKILL.md`、`superpowers/5.0.7/docs/superpowers/templates/versioning/pr-folder-template.md`、`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
    - 类型：补充修改
    - 变更摘要：将审查文档全局统一为 `Vx.y.z-PRn-review-report.md`，并补充迁移规则：若仅存在旧 `Vx.y.z-PRn-code-review.md`，则先重命名为 `review-report.md` 再继续写入
    - 变更原因：满足“统一命名但兼容历史存量文档”的实际场景，避免误删或断档
    - 主逻辑影响：中（文档契约与迁移语义收敛）

26. **补充修改** `superpowers/5.0.7/skills/test-driven-development/SKILL.md`、`superpowers/5.0.7/README.md`、`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
    - 类型：补充修改
    - 变更摘要：在 TDD 技能中显式要求将每个 RED/GREEN 循环证据落盘到 `Vx.y.z-PRn-tdd-log.md`，并为该要求新增自动化断言
    - 变更原因：补齐“test-driven-development 技能自身未明确落盘路径”的口径缺口，避免仅在执行技能中间接约束
    - 主逻辑影响：低（规则显式化 + 测试覆盖补齐）

27. **补充修改** `superpowers/5.0.7/README.md`、`superpowers/5.0.7/skills/finishing-a-development-branch/SKILL.md`、`superpowers/5.0.7/docs/superpowers/templates/versioning/pr-folder-template.md`、`superpowers/5.0.7/docs/superpowers/templates/versioning/version-test-template.md`、`superpowers/5.0.7/hooks/test-acceptance-gate`、`superpowers/5.0.7/skills/executing-plans/SKILL.md`、`superpowers/5.0.7/skills/subagent-driven-development/SKILL.md`、`superpowers/5.0.7/skills/requesting-code-review/SKILL.md`、`superpowers/5.0.7/tests/claude-code/test-version-pr-doc-contract.sh`
    - 类型：补充修改
    - 变更摘要：统一三测试执行顺序为 `autotest -> mocktest -> devicetest`；Stop 门禁新增顺序阻断；`review-report` 明确为 reviewer 结论汇总且禁止 implementer 自评替代审批
    - 变更原因：修复七阶段高风险缺口（顺序口径冲突、收尾顺序漏检、审查主体边界不清）
    - 主逻辑影响：中（门禁更严格 + 审查治理收敛）

28. **补充修改** `superpowers/5.0.7/hooks/acceptance-order-common`、`superpowers/5.0.7/hooks/enforce-acceptance-order`、`superpowers/5.0.7/hooks/test-acceptance-gate`
    - 类型：补充修改
    - 变更摘要：抽取三测试顺序共享函数（首行匹配、顺序校验、下一步预期判断）为公共 hook 库，`UserPromptSubmit` 与 `Stop` 两类门禁共同复用
    - 变更原因：避免顺序规则在两处 hook 重复实现后发生漂移
    - 主逻辑影响：低（重构，无规则语义变更）

29. **补充修改** `superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/AGENTS.md`、`superpowers/5.0.7/README.md`
    - 类型：补充修改
    - 变更摘要：以“混合模式”补齐运行时规则摘要：七阶段流程、版本/PR 产物契约、三测试顺序门禁、`review-report` 主体边界、`code-review.md` 迁移规则与 `evolution-keeper` 触发约束
    - 变更原因：在保留 Contributor Guidelines 的同时，给运行时执行提供统一且可索引的关键契约说明
    - 主逻辑影响：低（文档增强，不改执行语义）

30. **补充修改** `superpowers/5.0.7/CLAUDE.md`、`superpowers/5.0.7/AGENTS.md`
    - 类型：补充修改
    - 变更摘要：参考 pmskills 的文档组织方式，新增“角色 / 任务 / 文件结构”三段，并按 Superpowers 当前机制重写为运行时最小契约说明
    - 变更原因：提升主控文档可读性，确保用户能快速定位职责、流程目标和关键产物结构
    - 主逻辑影响：低（文档增强，不改执行语义）

<a id="sec-20260507-superpowers-pipeline-spec"></a>
## 2026-05-07 Spec「Superpowers pipeline (hooks)」与扩展验收豁免（Full pipeline Y/N）

> 技术标签：`hooks/acceptance-order-common`（`superpowers_extension_pipeline_waived`）、`hooks/spec-gate-precheck`、`hooks/enforce-acceptance-order`、`hooks/build-version-report-guard`、`hooks/test-acceptance-gate`、`skills/brainstorming`、`skills/writing-plans`、`docs/.../version-test-template.md`、`tests/claude-code/test-extension-pipeline-waived.sh`

1. **行为**：`Vx.y.z-spec.md` 须含逐字二级标题 **`## Superpowers pipeline (hooks)`** 与一行 **`Full extension acceptance pipeline: Yes`** 或 **`No`**（brainstorming checklist 询问用户后写入；中文可用「完整扩展验收流程：是/否」）。**No** 时：`enforce-acceptance-order` 不再拦 `autotest/mocktest/devicetest` 顺序；`build-version-report-guard` 放行；`test-acceptance-gate` 跳过 **`package.json` 与扩展 `manifest.json` 版本漂移检查**（具体路径依宿主项目布局，如 ChatBobi `app/plugin/package.json` 与 `app/plugin/.output/chrome-mv3/manifest.json`；见 `hooks/test-acceptance-gate`）。**Figma Live Design Sync** 仍仅由 plan 是否含 Design Sync PR 与 `plan_has_design_sync` 决定，与此 Y/N 独立。
2. **writing-plans 前**：`spec-gate-precheck` 强制该小节存在且含合法 Yes/No。
3. **本地验证**：`bash tests/claude-code/test-extension-pipeline-waived.sh`（可与 `test-enforce-acceptance-next-expected.sh`、`test-build-version-waiver.sh` 同跑）。

<a id="sec-20260507-evolution-hook-count"></a>
## 2026-05-07 Evolution hook 候选计数与 keeper 呈现（夏老板已接受 bundle）

> 技术标签：`hooks/evolution-index-common`、`hooks/check-evolution`、`agents/evolution-keeper.md`、`skills/using-superpowers/SKILL.md`、`tests/claude-code/test-check-evolution.sh`

1. **修改** `superpowers/5.0.7/hooks/evolution-index-common`（新增于 fork，与 `check-evolution` / `farewell-git-clean-reminder` 共享统计与提醒）
   - **变更摘要（A）**：表格索引仅将 `occurrences ≥ 2` 且 `Status`（不区分大小写）为 `candidate` 或 `pending` 的行计入「Candidate signals」；`adopted` / `not_adopted` 等不再因高 `occurrences` 虚高。Legacy 索引仅匹配 `status: candidate|pending` 行计数，不再单凭 `occurrences≥2` 行虚高。
   - **变更原因**：对齐 ChatBobi 反馈「Hook 报候选数与 keeper no-op 矛盾」。
   - **主逻辑影响**：中（SessionStart / farewell 注入文案中的候选数字更准确）。

2. **修改** `superpowers/5.0.7/hooks/check-evolution`
   - **变更摘要**：薄封装：加载 `evolution-index-common`，输出 SessionStart JSON（与已安装 cache 布局一致）。
   - **主逻辑影响**：低（结构对齐 runtime）。

3. **修改** `superpowers/5.0.7/agents/evolution-keeper.md`、`superpowers/5.0.7/skills/using-superpowers/SKILL.md`
   - **变更摘要（B）**：约定主 agent 在 keeper `no-op` 时不以 SessionStart「Candidate signals detected: N」为用户叙事主轴；以 `## Evolution Keeper Result` 为准。
   - **主逻辑影响**：低（契约与呈现）。

4. **修改** `superpowers/5.0.7/tests/claude-code/test-check-evolution.sh`
   - **变更摘要**：第二组夹具（高 `occurrences` 的 `adopted`/`not_adopted` → 候选数 0、`needs_keeper` marker）；`cleanup` 安全删除临时目录。
   - **主逻辑影响**：低（回归）。

- **本地验证**：`bash tests/claude-code/test-check-evolution.sh`
- **部署**：ChatBobi `docs/superpowers-local` 扩大 `MANAGED_FILES.txt` 后 `sync-superpowers-fork.sh capture` + `deploy latest`。
