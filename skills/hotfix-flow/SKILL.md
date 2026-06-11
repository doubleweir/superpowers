---
name: hotfix-flow
description: Use after brainstorming Step 2 selects Target published version — Git tag baseline, CWS/hf tags, and parallel next-minor sync. Does NOT replace brainstorming or writing-plans.
---

# Hotfix Flow (Published Version — Git & Release Checklist)

**Announce at start:** "I'm using the hotfix-flow skill for Git/release steps on a published-version fix."

## When to use

- **After** brainstorming Step 2 = **Target published / production version** (线上已发布版本).
- **Before** implementation: complete **full brainstorming** → **writing-plans** (same PR + version doc shape as regular releases).
- **Do not use** for: work on current in-flight minor, new version only, or Superpowers mechanism feedback.

## What this skill is NOT

- **Not** a lite substitute for brainstorming or writing-plans.
- **Not** a separate seven-step pipeline.
- ISSUE-driven P0 fixes **must** still run full brainstorming + writing-plans (EP-009 one-line skip does **not** apply).

## Host contracts (ChatBobi)

- Product issues: `.superpowers/issues.md` (`ISSUE-NNN`) — link in version `*-spec.md`.
- Framework feedback: `.superpowers/project2feedback.md` — not for product bugs.

### Host deployment (required for Stop hooks)

Fork changes alone do **not** register Stop hooks in project settings. After editing this skill or `hooks/*` in the fork:

1. `docs/scripts/sync-superpowers-fork.sh full-sync latest` (capture → deploy → **wire**)
2. Confirm: `wire-host-project-hooks.sh verify` and `smoke` (see `docs/host-integration.md`)

Without **wire**, `hotfix-parallel-sync-guard` / `next-minor-behind-main-guard` exist in overlay/cache but **will not run** on session Stop.

## Git baseline (mandatory before implementation)

```bash
git fetch --tags
# Baseline tag MUST exist (e.g. plugin/pv0.1.14 @ merge commit). Stop hook blocks hotfix work if missing.
git rev-parse --verify plugin/pv0.1.14
git checkout -b feat/pv0.1.14-hotfix-<topic> plugin/pv0.1.14
```

| Item | Convention |
|------|------------|
| Doc root | `docs/plugin/pv0.1.14-hotfix-<topic>/` + `*-PRn/` (same as regular) |
| CWS manifest | Still `0.1.14.N` (buildNumber); distinguish via `plugin/pv0.1.14-hf{n}` tag |
| Platform tag | Bump root `VERSION` + `chatbobi/v*` on merge |

## Skill order (full seven-step — same as regular)

1. **brainstorming** (full checklist; Step 2 = published version)
2. **writing-plans** (full; PR splitting if needed)
3. **test-driven-development**
4. **subagent-driven-development** (when plan requires)
5. **requesting-code-review**
6. **finishing-a-development-branch**
7. codetofigma only if visual change

## Parallel next minor (v0.1.15+) — hook-enforced

After hotfix merges to `main`, in-flight `feat/pv0.1.15-*` must absorb the fix:

| Next minor state | Action |
|------------------|--------|
| No `feat/pv0.1.15-*` branch | N/A — next branch from `main` includes fix |
| Branch in progress | `git merge main` or `git rebase main` on that branch, or `cherry-pick` hf tag commit |

Record in active PR `*-finalize-log.md` **early** (plan before hotfix merges):

```markdown
## Parallel next minor sync

- strategy: merge_main | cherry_pick | N/A
- target_branch: feat/pv0.1.15-<topic>
- evidence: <fill after merge/rebase on target branch>
```

| Phase | Hook | Checks |
|-------|------|--------|
| Hotfix branch (in-flight next minor exists) | `hotfix-parallel-sync-guard` | Baseline tag exists; finalize-log has **strategy + target_branch** |
| Next-minor branch (after hotfix on main) | `next-minor-behind-main-guard` | `HEAD..main` empty for `app/plugin`, `docs/plugin`, `app/webapp`, `docs/webapp` |

**Waiver** (emergency only): `.superpowers/hotfix-sync-waived` with a `reason:` line skips the next-minor git guard — remove after sync.

## Finalize checklist

1. Merge `feat/pv0.1.14-hotfix-*` → `main`
2. Bump `VERSION`, tag `chatbobi/v*`
3. Tag `plugin/pv0.1.14-hfN`, push tags
4. Submit CWS `0.1.14.N`
5. Complete parallel sync to next-minor branch if exists
6. Update `issues.md` ISSUE status

See **finishing-a-development-branch** Step 2.55b (rebuild + commit `.output` on `main` before CWS/tag — **No.19**), Step **2.74** (prod `.env` + GA4 credentials in build — **No.37/33**), Step 2.6 (sub-product tags), and Step 2.55 (platform VERSION).
