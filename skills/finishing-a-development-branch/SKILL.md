---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

**Scope note:** Treat this as active-PR closure logic. In multi-PR versions, run this closure flow for each PR as it finishes, explicitly switching active PR context on PR transitions, then run version-level aggregation after `PRn` with active PR still bound to `PRn`.

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 1.5: Mandatory Final Acceptance Tests

Before completion options, run real-host acceptance for the active PR closure:

1. `devicetest` (real Chrome / real host attachment)
2. `autotest` / `mocktest` only when useful as optional diagnostics

Command sources (ChatBobi project commands):

- `/Users/harry/Documents/chatbobi/.claude/commands/devicetest.md`
- optional diagnostics: `/Users/harry/Documents/chatbobi/.claude/commands/autotest.md`, `/Users/harry/Documents/chatbobi/.claude/commands/mocktest.md`

Required logging (must already be in active maintenance, then refreshed here):

- `docs/Vx.y.z-<topic>/Vx.y.z-test.md` must include the `devicetest` **status line** under the exact H2 **`## Acceptance status (hooks)`** (hooks do not read this from the PR `tdd-log`). PR `tdd-log` remains for TDD case evidence only.

If required real-host `devicetest` evidence is missing or failing, stop and do not proceed.
Do not defer missing evidence to "final cleanup later."

### Step 2: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 2.5: Finalize Log Gate (Mandatory)

Before presenting options, ensure PR finalize log exists and is updated:

- `docs/Vx.y.z-<topic>/Vx.y.z-PRn/Vx.y.z-PRn-finalize-log.md`

Required content in finalize log:

- Completed tasks summary
- Final verification evidence summary
- Open risks and follow-ups
- Decision recommendation for merge/PR/keep/discard

Version changelog requirement before Step 3:

- Confirm `docs/Vx.y.z-<topic>/Vx.y.z-changelog.md` contains important corrections from design, development, testing, and release preparation.
- If any important correction is missing, update changelog first. Do not continue to Step 3.

If finalize log is missing, create/update it first. Do not continue to Step 3.

### Step 2.55: Platform VERSION bump gate (Mandatory)

When this branch edits **sub-product semver docs** roots (examples: `docs/plugin/pv*-…/`, `docs/webapp/wv*-…/`, or top-level `docs/{prefix}v*-…/` that is **not** only material under `docs/platform/`), the repo **`VERSION`** at the workspace root **must change** relative to `main`/`master` merge-base—in the branch commits **or** unstaged/index changes—along with tagging `chatbobi/v*` per project rules.

- **Structural check:** **`hooks/platform-version-bump-guard`** runs at Stop **before** other Stop gates complete; ending the session blocked until `VERSION` is updated.
- **Waiver:** if the work is intentionally **repo-only / platform-release** handling without those sub-product roots, maintain **`.superpowers/platform-release`** (see versioning docs / CLAUDE overlay)—the guard exits without requiring `VERSION` in that marker mode.

Skip this step mentally only after confirming the guard passes or waiver applies; do not offer merge/PR options first.

### Step 2.55b: Rebuild and commit extension artifacts (CWS / sub-product tag — No.19)

**Applies to:** any **store/CWS publish** or **`plugin/pv*` / `webapp/wv*` / `*-hf*` tag** on an extension sub-product (regular version **and** hotfix — not hotfix-only).

**Problem this prevents:** worktree or feature-branch builds uploaded to CWS without committing `app/plugin/.output/` to `main` → tests PASS but production bundle lacks merged source (see project2feedback No.19).

**On `main` after merge (before tag or CWS upload):**

1. `cd app/plugin && npm run build` (or project-documented build command)
2. `git add app/plugin/.output/` (and `app/webapp/` build dirs if applicable)
3. `git commit` — message notes version stem + rebuild for publish
4. **CWS upload MUST use** the committed tree at `app/plugin/.output/chrome-mv3/` on **`main`** — never a worktree-only build
5. Only **then** run Step 2.6 sub-product tags (`plugin/pv*`, `*-hf*`)

Stop hook **`cws-artifact-sync-guard`** blocks when `app/plugin/` source is ahead of the latest git commit touching `.output/` (S3).

**Devicetest/mocktest/autotetest:** report build path (`main` vs worktree) in test summary; worktree PASS does not satisfy publish readiness.

### Step 2.6: Sub-product release tags (publish path)

When the human confirms **store/CWS publish** for a sub-product version:

| Release type | Tag after merge to `main` |
|--------------|---------------------------|
| Regular plugin | `plugin/pv{x.y.z}` (e.g. `plugin/pv0.1.14`) |
| Regular webapp | `webapp/wv{x.y.z}` |
| Plugin hotfix | `plugin/pv{x.y.z}-hf{n}` (`hf1`, `hf2`, …) |

- **Hotfix branches** MUST be created from `plugin/pv{x.y.z}` (or prior `hf{n-1}`), not from `main` HEAD when the next minor version is in flight on another branch.
- Push tags with `git push origin <tag>` after human confirms publish.
- Record tag name in version changelog and host `issues.md` if applicable.

### Step 2.65: Parallel next-minor sync (hotfix branches)

When the branch is `feat/{prefix}v*-hotfix-*` and any **in-flight next-minor** `feat/pv*` branch exists (e.g. `feat/pv0.1.15-*` while fixing `pv0.1.14`), the active PR `*-finalize-log.md` MUST include:

```markdown
## Parallel next minor sync

- strategy: merge_main | cherry_pick | N/A
- target_branch: feat/pv0.1.15-<topic>
- evidence: <commit hash after merge/rebase — fill after hotfix is on main>
```

`N/A` only when no next-minor feature branch exists. On the **hotfix** branch, Stop hook `hotfix-parallel-sync-guard` requires **plan only** (`strategy` + `target_branch`) while next-minor work is in flight — not `evidence` (that lands after hotfix merges). On the **next-minor** branch, `next-minor-behind-main-guard` blocks when integration (`main`/`master`) has sub-product commits not yet merged.

### Step 2.74: Production Build Credentials Check (Publish Path Only — No.37 / No.33)

Run this step only when the human partner explicitly wants to publish/deploy/package artifacts for end users now (CWS upload or sub-product tag on `main`).
For normal development branch closure (merge/PR/keep/discard without release), skip this step.

**Problem this prevents:** `.env` is gitignored. Deleting `.env` and rebuilding before CWS upload compiles analytics to no-op (credentials missing at build time) while Step 2.75 privacy audit still passes because the zip correctly excludes `.env*`.

**Applies to:** any CWS publish or `plugin/pv*` / `*-hf*` tag when the extension ships GA4 analytics (`ga4-analytics.ts` exists).

**Waiver:** intentional analytics-off publish → maintain **`.superpowers/cws-analytics-waived`** (empty marker file).

**Before Step 2.75, verify build credentials (ChatBobi plugin example):**

1. **Source `.env` must exist** at `app/plugin/.env` with non-empty:
   - `WXT_GA4_MEASUREMENT_ID` (e.g. `G-…`)
   - `WXT_GA4_API_SECRET`
   - `WXT_ANALYTICS_MODE=prod` (not `debug` / `validate`)
2. **Do not delete `.env` after DebugView validation.** Switch mode to `prod` and rebuild instead.
3. **Verify committed build output** at `app/plugin/.output/chrome-mv3/background.js`:
   ```bash
   grep "mp/collect" app/plugin/.output/chrome-mv3/background.js
   grep "$WXT_GA4_MEASUREMENT_ID" app/plugin/.output/chrome-mv3/background.js
   ```
   Measurement ID absent → analytics no-op build; stop and rebuild with correct `.env`.
4. **Debug build detection (No.33):** inlined mode must be `prod`, not `debug`/`validate` (minified `getMode()` embeds `` `prod` `` / `` `debug` ``).

Stop hook **`cws-production-build-credentials-guard`** enforces steps 1–4 on `main`/`master` when GA4 ships and `.output/` exists.

**If verification fails:** stop immediately; do not proceed to Step 2.75 or Step 3 until `.env` is correct and `npm run build` + commit `.output/` is redone.

### Step 2.75: Conditional Release Privacy Audit Gate (Publish Path Only)

Run this step only when the human partner explicitly wants to publish/deploy/package artifacts for end users now.
For normal development branch closure (merge/PR/keep/discard without release), skip this step.

**Scope:** audit the **CWS upload zip / publish artifact tree** (e.g. `app/plugin/.output/chrome-mv3/`), **not** the source workspace. Step 2.74 requires `.env` at **build time**; excluding `.env*` from the shipped zip is correct here.

If publish path is selected, identify the build artifact directory and run a minimum privacy audit before presenting completion options:

- No developer path leakage (for example `/Users/`)
- No hardcoded credential patterns (for example `sk-ant-`, `sk-proj-`, `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)
- No shipped local database artifacts (`*.db`, `*.db-shm`, `*.db-wal`)
- No shipped env/credential files (`.env*`, `credentials*`, `*.pem`, `*.key`)

If any item fails:

- Stop immediately
- Record findings with file references
- Do not proceed to Step 3 until fixed and re-verified

### Step 3: Present Options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** - keep options concise.

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass — clean up both local and remote
git branch -d <feature-branch>
git push origin --delete <feature-branch> 2>/dev/null || true
git remote prune origin
```

Then: Final verification (Step 5)

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Then: Final verification (Step 5)

#### Option 3: Keep As-Is

Report: "Keeping branch <name>. Worktree preserved at <path>."

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
git push origin --delete <feature-branch> 2>/dev/null || true
git remote prune origin
```

Then: Final verification (Step 5)

### Step 5: Final Verification

After executing the chosen option, run this checklist to confirm clean state:

```bash
# 1. Verify on correct branch
git branch --show-current  # Should be <base-branch>

# 2. Verify no stale remote branches
git branch -r  # Should only show expected remote branches

# 3. Verify local is in sync with remote
git status

# 4. If worktree was used, verify cleanup
git worktree list  # Should not show stale worktrees
```

**For Options 1, 4:**

Check if in worktree:
```bash
git worktree list | grep $(git branch --show-current)
```

If yes:
```bash
git worktree remove <worktree-path>
```

**For Option 2, 3:** Don't cleanup worktree.

**Report final state:**
```
Branch closure complete:
- Current branch: <base-branch>
- Feature branch <name>: deleted (local + remote)
- Worktree: cleaned up / preserved
- Remote tracking: pruned
```

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Local Branch | Cleanup Remote Branch |
|--------|-------|------|---------------|----------------------|----------------------|
| 1. Merge locally | ✓ | - | - | ✓ | ✓ |
| 2. Create PR | - | ✓ | ✓ | - | - |
| 3. Keep as-is | - | - | ✓ | - | - |
| 4. Discard | - | - | - | ✓ (force) | ✓ |

## Common Mistakes

**Skipping test verification**
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options

**Open-ended questions**
- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

**Automatic worktree cleanup**
- **Problem:** Remove worktree when might need it (Option 2, 3)
- **Fix:** Only cleanup for Options 1 and 4

**No confirmation for discard**
- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

**Forgetting remote branch cleanup**
- **Problem:** Merged/discarded branches remain on remote indefinitely, accumulating stale branches and confusing repo state
- **Fix:** Always delete remote branch + `git remote prune origin` for Options 1 and 4

## Red Flags

**Never:**
- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request

**Always:**
- Verify tests before offering options
- Run real-host `devicetest` before completion and record ordered status under **`## Acceptance status (hooks)`** in `Vx.y.z-test.md`
- Run production build credentials check (Step 2.74) then release privacy audit (Step 2.75) when publish path is requested
- Respect **`hooks/cws-production-build-credentials-guard`** on `main` when GA4 ships (unless `.superpowers/cws-analytics-waived`)
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 & 4 only
- Delete remote branch + prune for Options 1 & 4
- Report final state after cleanup (Step 5)
- Require `*-finalize-log.md` before completion options
- Respect **`hooks/platform-version-bump-guard`**: bump root `VERSION` when sub-product semver docs change unless `.superpowers/platform-release` waiver applies

## Integration

**Called by:**
- **subagent-driven-development** (Step 7) - After all tasks complete
- **executing-plans** (Step 5) - After all batches complete

**Pairs with:**
- **using-git-worktrees** - Cleans up worktree created by that skill
