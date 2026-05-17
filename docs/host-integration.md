# Host integration: sync + wire (make fork hooks actually run)

Superpowers plugin `hooks/hooks.json` applies automatically only when Claude loads the plugin as a plugin. **ChatBobi (and similar hosts)** use project `.claude/settings.local.json` instead — fork changes must go through **three steps**:

| Step | Command | What happens |
|------|---------|----------------|
| 1 capture | `sync-superpowers-fork.sh capture` | fork → `docs/superpowers-local/overlay/` |
| 2 deploy | `sync-superpowers-fork.sh deploy latest` | overlay → `~/.claude/plugins/cache/.../superpowers/<ver>/` |
| 3 **wire** | `wire-host-project-hooks.sh apply` | overlay `hooks.json` + host `host-hook-wiring.json` → `.claude/settings.local.json` |

`full-sync` should run all three (ChatBobi: `docs/scripts/sync-superpowers-fork.sh full-sync latest`).

When you mention changing Superpowers hooks/skills/sync in ChatBobi, `superpowers-runtime-sync-reminder` (UserPromptSubmit) injects the same **full-sync latest** instruction for the agent.

## Host files (not in fork)

| File | Role |
|------|------|
| `docs/superpowers-local/host-hook-wiring.json` | Host-only hooks + insertions (e.g. `main-branch-stop-gate`, `workflow-phase-auto`) |
| `docs/scripts/hooks-backup/run-superpowers-hook` | Installed from overlay `scripts/run-superpowers-hook-host.sh` on wire |
| `.claude/settings.local.json` | Merged hook lists (permissions untouched) |

## No.18 hotfix example

After `full-sync latest` + wire:

- **Skills** (`hotfix-flow`, brainstorming Step 2) — Agent reads overlay/cache.
- **Stop guards** (`hotfix-parallel-sync-guard`, `next-minor-behind-main-guard`) — run on session Stop in settings order.
- **Resolver** uses overlay `acceptance-order-common` (not stale `hooks-backup` copies).

Verify:

```bash
docs/superpowers-local/overlay/scripts/wire-host-project-hooks.sh verify
docs/superpowers-local/overlay/scripts/wire-host-project-hooks.sh smoke
```

## Do not

- Edit hooks/skills only in ChatBobi overlay or cache (fork is source of truth).
- Keep duplicate managed hooks under `hooks-backup/` (wire `apply` prunes them).
