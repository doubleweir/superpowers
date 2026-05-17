---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Published-version hotfix (same plan shape as regular versions)

When brainstorming Step 2 chose **Target published / production version**, use the **same** plan + PR scaffold as any version:

- Version root: `docs/{product}/pv{x.y.z}-hotfix-<topic>/`
- PR dirs: `pv{x.y.z}-hotfix-<topic>-PRn/` with standard tdd-log / subagent-summary / review-report / finalize-log
- In the active PR `*-finalize-log.md`, include `## Parallel next minor sync` (strategy: `merge_main` | `cherry_pick` | `N/A`, target_branch; add evidence after hotfix is on main) — hotfix Stop hook requires **plan** when a higher semver `feat/pv*` branch exists; git sync enforced on the next-minor branch

Do **not** use a single root-level plan file instead of PR dirs for hotfix.

---

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Workflow phase (automation):** When the user explicitly starts this skill (e.g. `writing-plans`, `开始 writing-plans`, `/writing-plans`), the `workflow-phase-auto` hook sets `.superpowers/workflow-phase` to `writing-plans` on product repos — no manual shell setup.

**Context:** This should be run with a dedicated worktree available before Stage 5 execution (provisioned by `using-git-worktrees` when `subagent-driven-development` starts).

**Save plans to:** `docs/Vx.y.z-<topic>/Vx.y.z-plan.md`
 - (Use the exact version root confirmed during brainstorming)

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## Task Boundary Clarity Check

Before finalizing tasks, run a quick boundary check for each task:

- **Value boundary:** What user-visible value does this task deliver?
- **Execution boundary:** Can an engineer complete this task without guessing missing requirements?
- **Scope boundary:** Does the task avoid leaking into unrelated concerns?
- **Ambiguity scan:** Replace vague verbs like "improve", "optimize", "handle", "support" with concrete behavior.

If a task fails these checks, rewrite it before proceeding. This is a clarity enhancement, not a workflow change.

## Test Evidence Requirement

Planning is not complete unless testing evidence is auditable.

For each task, include at least:

- One RED step (command + expected failure signal)
- One GREEN step (command + expected pass signal)
- One rerun rule after code change ("if implementation changes, rerun verification")

In addition to `docs/Vx.y.z-<topic>/Vx.y.z-plan.md`, produce or update:

- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-tdd-log.md`
- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-subagent-summary.md`
- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-review-report.md`
- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-finalize-log.md`
- Start from `docs/superpowers/templates/tdd-report-template.md` and adapt it to PR-level log path

This report must map `spec -> plan task -> test evidence`.

## PR Splitting Strategy (Mandatory)

Before finalizing the plan:

- Build a lightweight task dependency graph
- Group dependent tasks into the same PR
- Split independent or unrelated tasks into separate PRs
- Assign sequential execution order as `PR1..PRn` (single-PR versions still use `PR1`)
- If the version includes UI, visual design, CSS token, component layout, or Figma-facing changes, append a final PR named `PRn: Figma Live Design Sync`. This PR uses `superpowers:figma-live-design-sync` and wraps `codetofigma` as a sub-step; do not create a standalone `codetofigma`-only PR for new plans.
- Add a `PR Grouping` section in `Vx.y.z-plan.md` documenting:
  - PR name
  - included task IDs
  - dependency rationale


### Figma Live Design Sync PR

When appended, the final `Figma Live Design Sync` PR has one orchestration responsibility: prove that Figma output generated from product code matches the product source. It must include these plan tasks:

1. Generate or patch the Figma plugin script with `codetofigma`.
2. Bootstrap once: the human opens the target Figma design and runs the plugin once.
3. Run live sync loop with `superpowers:figma-live-design-sync`: update plugin code, verify hot reload or assisted rerun, call `/figma-read` on the same URL/node, and compare metadata/screenshot/design context against source.
4. Respect loop budget: default 3 rounds, hard cap 5 rounds unless the human explicitly approves more.
5. Record loop status and remaining diffs in the PR docs and version test summary.

Acceptance status for new plans should use `figma-live-sync: pass|fail|blocked` under `## Acceptance status (hooks)` after `devicetest`. Legacy `codetofigma: ...` remains accepted for old plans only.

For each PR in grouping, define startup artifacts before execution begins:

- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/`
- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-tdd-log.md`
- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-subagent-summary.md`
- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-review-report.md`
- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-finalize-log.md`
- `docs/Vx.y.z-<topic>/Vx.y.z-test.md` (version-level aggregate file must already exist and be maintained across PR loops)

Initialize missing PR artifacts with minimal skeleton headings and status placeholders at plan completion time. Do not defer `subagent-summary`, `review-report`, or `finalize-log` creation to subagent execution or finalization. Acceptance preflight and stop gate depend on the full PR doc pack existing before execution begins.

## PR Execution Loop Handoff (Mandatory)

The plan must hand off execution as a PR loop, not one linear pass across all tasks:

1. Activate `PR1`
2. Run PR loop: `TDD -> Subagent Development (or Executing Plans) -> Review`; record `autotest -> mocktest -> devicetest` and, when the plan includes `Figma Live Design Sync`, `figma-live-sync` in `Vx.y.z-test.md` only under **`## Acceptance status (hooks)`**; then `Debug` if needed
3. Move to next PR after current PR passes review; version-level stop gate covers ordered acceptance in `Vx.y.z-test.md`
4. On each PR transition (`PR1 -> PR2 -> ...`), set active PR context for PR-scoped docs before hooks that need it. The acceptance **block** is in the version file, not per-PR.
5. After `PRn` completion, run version-level regression/aggregation before final branch completion while keeping active PR bound to `PRn` where needed for PR paths.

**`Vx.y.z-spec.md` → `## Superpowers pipeline (hooks)`:** If `Full extension acceptance pipeline: No` (or `完整扩展验收流程：否`), treat the version as **extension pipeline waived**: keep three lines for `autotest`/`mocktest`/`devicetest` with waived statuses (e.g. `N/A`) unless you truly run those tests; hooks will not enforce UserPromptSubmit order for those three, will not require manifest build reporting at Stop, and will skip **`package.json` vs extension `manifest.json` drift** (paths are project-specific; see `hooks/test-acceptance-gate`). **Do not** change Figma rules: if this plan includes **Figma Live Design Sync**, still append that PR and still record `figma-live-sync` after `devicetest`. If the spec says **Yes**, keep the normal ordered extension acceptance.

## Version Governance Outputs (Mandatory)

Plan completion requires these files to exist under version root:

- `Vx.y.z-design.md`
- `Vx.y.z-spec.md`
- `Vx.y.z-plan.md`
- `Vx.y.z-changelog.md`
- `Vx.y.z-decisions.md`

## Evolution Reminder Handling

If SessionStart injects an evolution reminder:

- Dispatch `agents/evolution-keeper.md`
- Have it read `.claude/feedback/FEEDBACK-INDEX.md`
- Have it identify entries with `status: candidate` or `occurrences >= 2`
- Have it produce structured proposals and ask the human to confirm/skip each one
- Have it **append** candidate summaries to `docs/LESSONS.md` with **建议是否被采纳** (`pending` / `adopted` / `not_adopted`), updating via append when the human confirms or skips
- Require it to return candidate list + required decisions so the main flow can present them verbatim
- Never auto-graduate rules without explicit confirmation
- Keep closure evidence cross-layer: feedback index + keeper output + `docs/LESSONS.md` entries must describe the same candidate state.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

**Add this line immediately after the header block:**

`**Version Root:** docs/Vx.y.z-<topic>/`

`**PR Grouping:** Vx.y.z-PR1/PR2/... with task mapping`

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/Vx.y.z-<topic>/Vx.y.z-plan.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
