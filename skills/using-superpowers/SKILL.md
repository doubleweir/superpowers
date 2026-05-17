---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## Published-version hotfix

In **brainstorming Step 2**, choose **Published / production version** when the fix must ship on the build users have today (not the in-flight next minor). That path still requires **full brainstorming** and **full writing-plans** (version + PR dirs). After spec gate, invoke **`hotfix-flow`** for Git tag baseline, CWS/hf tags, and parallel next-minor sync — it does **not** replace brainstorming. Product issues: host `.superpowers/issues.md`; framework feedback: `project2feedback.md`.

## Instruction Priority

Superpowers skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (CLAUDE.md, GEMINI.md, AGENTS.md, direct requests) — highest priority
2. **Superpowers skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If CLAUDE.md, GEMINI.md, or AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## Project root (Superpowers-only maintenance)

When work is **only** to edit Superpowers hooks, skills, or docs in the **version-controlled fork**, open Claude Code with the **fork repo as the Project root** rather than a product repository on `main`, so product `UserPromptSubmit` workflow gates stay decoupled from branch state.

## Workflow phase marker (product repo on `main`)

**Automation (default):** In ChatBobi-style layouts, the `workflow-phase-auto` hook runs on **UserPromptSubmit** (before `workflow-bootstrap-gate`). It creates/updates **`.superpowers/workflow-phase`** when the user message clearly indicates an early pipeline phase — for example: `pv0.1.13` + `brainstorming`, `invoke brainstorming`, `/brainstorm`, `开始 writing-plans`, `git checkout -b feat/…`, or explicit “回到 brainstorming”. **No manual shell commands** are required for normal turns.

**Manual override:** You may still edit the file by hand if the hook missed a turn. First non-comment line is the token (`#` comments allowed).

Allowed auto / manual tokens (case-insensitive; trim spaces):

- `brainstorming` — ideation / UX discussion before implementation
- `writing-plans` — plan / PR scaffold work in docs, still not shipping code from this prompt class
- `planning` — requirements / scope shaping
- `requirements` — same intent as planning
- `design` — design-doc iteration
- `spec` — spec iteration before code

While one of these tokens is set, **main** bypasses the strict “must be on feat branch” gate **unless** the user prompt matches **hard implementation** signals (e.g. `src/`, `app/`, explicit ship/commit language). The hook may set **`implementation`** when the user clearly starts shipping work (e.g. real `git checkout -b feat/` intent); that turns the strict gate back on. **Deleting** `.superpowers/workflow-phase` also clears the early-phase bypass.

The marker file is often **untracked**; it does **not** count as “workspace-only whitelist changes” by itself, so prompts that clearly target `src/` / `app/` are still blocked on `main`.

Prefer a **feature branch** once you start editing product code.

## Feedback Evolution Responsibility (Evolution Keeper)

When feedback/evolution hook reminders are injected, dispatch `agents/evolution-keeper.md` to execute the loop within existing workflow:

1. Record feedback to `.claude/feedback/` using index + topic format
2. Update or increment `occurrences` (dedupe by topic)
3. Generate candidate proposals when threshold is met
4. **Append evolution proposals (进化建议) to `docs/LESSONS.md`** whenever candidates are created or updated, including **建议是否被采纳** (`pending` → `adopted` | `not_adopted` after human `confirm`/`skip`); see `agents/evolution-keeper.md`
5. Require explicit human confirm/skip before any graduation

Evolution closure is only valid when all layers align (five layers):

1. docs contract (`docs/LESSONS.md` visible log)
2. skills contract (keeper responsibilities and response block)
3. scripts/hook enforcement (signal detection + closure checks)
4. operational feedback index (`.claude/feedback/*`)
5. regression checks (tests proving pending/adopted/not_adopted paths)

Keep this as a single dedicated role (`evolution-keeper`). Do not split into multiple observer/runner roles.

When a feedback/evolution reminder was injected, the main agent must surface the keeper result block before completion:

- Include `## Evolution Keeper Result` exactly once in the response
- If keeper action is `no-op`, provide a concrete reason
- If candidates exist, list explicit `confirm/skip` decisions required from the human
- Do **not** quote the SessionStart hook's **"Candidate signals detected: N"** in the user-facing reply when the keeper returns `no-op` (that number can be stale; the Result block is authoritative). Prefer dispatching the keeper and presenting only its Result.

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In Copilot CLI:** Use the `skill` tool. Skills are auto-discovered from installed plugins. The `skill` tool works the same as Claude Code's `Skill` tool.

**In Gemini CLI:** Skills activate via the `activate_skill` tool. Gemini loads skill metadata at session start and activates the full content on demand.

**In other environments:** Check your platform's documentation for how skills are loaded.

## Platform Adaptation

Skills use Claude Code tool names. Non-CC platforms: see `references/copilot-tools.md` (Copilot CLI), `references/codex-tools.md` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.

# Using Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (frontend-design, mcp-builder) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
