#!/usr/bin/env bash
# Host resolver: overlay hooks first, then plugin cache; hooks-backup only for host_only_hooks.
set -euo pipefail

HOOK_NAME="${1:-}"
if [ -z "$HOOK_NAME" ]; then
  echo "run-superpowers-hook: missing hook name" >&2
  exit 1
fi
shift || true

WIRING_JSON="${CLAUDE_PROJECT_DIR:-}/docs/superpowers-local/host-hook-wiring.json"
OVERLAY_HOOKS="${CLAUDE_PROJECT_DIR:-}/docs/superpowers-local/overlay/hooks"

is_host_only_hook() {
  local name="$1"
  if [ ! -f "$WIRING_JSON" ]; then
    return 1
  fi
  jq -e --arg n "$name" '.host_only_hooks | index($n) != null' "$WIRING_JSON" >/dev/null 2>&1
}

find_hook() {
  local name="$1"
  local backup="${CLAUDE_PROJECT_DIR:-}/docs/scripts/hooks-backup/${name}"

  if is_host_only_hook "$name" && [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -f "$backup" ]; then
    printf '%s' "$backup"
    return 0
  fi

  if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -f "${OVERLAY_HOOKS}/${name}" ]; then
    printf '%s' "${OVERLAY_HOOKS}/${name}"
    return 0
  fi

  if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ] && [ -f "${CLAUDE_PLUGIN_ROOT}/hooks/${name}" ]; then
    printf '%s' "${CLAUDE_PLUGIN_ROOT}/hooks/${name}"
    return 0
  fi

  if [ -n "${HOME:-}" ]; then
    local match
    match="$(ls -dt "${HOME}"/.claude/plugins/cache/claude-plugins-official/superpowers/*/hooks/"${name}" 2>/dev/null | head -n 1 || true)"
    if [ -n "$match" ] && [ -f "$match" ]; then
      printf '%s' "$match"
      return 0
    fi
  fi

  if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -f "$backup" ]; then
    printf '%s' "$backup"
    return 0
  fi

  return 1
}

HOOK_PATH="$(find_hook "$HOOK_NAME" || true)"
if [ -z "$HOOK_PATH" ]; then
  echo "run-superpowers-hook: unable to resolve superpowers hook '${HOOK_NAME}'" >&2
  exit 1
fi

if [ -x "$HOOK_PATH" ]; then
  exec "$HOOK_PATH" "$@"
fi

exec bash "$HOOK_PATH" "$@"
