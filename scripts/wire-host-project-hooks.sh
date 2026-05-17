#!/usr/bin/env bash
# Wire fork hooks.json + host host-hook-wiring.json into project .claude/settings.local.json
# Host projects set SP_* paths or rely on defaults under docs/superpowers-local/.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  wire-host-project-hooks.sh apply
  wire-host-project-hooks.sh verify
  wire-host-project-hooks.sh smoke
  wire-host-project-hooks.sh install-runner

Environment (optional):
  SP_PROJECT_ROOT          Project root (default: parent of docs/ or CLAUDE_PROJECT_DIR)
  SP_OVERLAY_HOOKS_JSON    Fork hooks.json (default: overlay/hooks/hooks.json)
  SP_WIRING_JSON           Host manifest (default: docs/superpowers-local/host-hook-wiring.json)
  SP_SETTINGS_JSON         Claude settings (default: .claude/settings.local.json)
  SP_HOST_BACKUP_DIR       Host hook scripts (default: docs/scripts/hooks-backup)
  SP_RUNNER_TEMPLATE       run-superpowers-hook-host.sh in overlay scripts/
EOF
}

resolve_defaults() {
  if [ -z "${SP_PROJECT_ROOT:-}" ]; then
    if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
      SP_PROJECT_ROOT="$CLAUDE_PROJECT_DIR"
    else
      SP_PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd || pwd)"
    fi
  fi

  SP_DOCS_DIR="${SP_DOCS_DIR:-${SP_PROJECT_ROOT}/docs}"
  SP_MANAGED_ROOT="${SP_MANAGED_ROOT:-${SP_DOCS_DIR}/superpowers-local}"
  SP_OVERLAY_ROOT="${SP_OVERLAY_ROOT:-${SP_MANAGED_ROOT}/overlay}"
  SP_OVERLAY_HOOKS_JSON="${SP_OVERLAY_HOOKS_JSON:-${SP_OVERLAY_ROOT}/hooks/hooks.json}"
  SP_WIRING_JSON="${SP_WIRING_JSON:-${SP_MANAGED_ROOT}/host-hook-wiring.json}"
  SP_SETTINGS_JSON="${SP_SETTINGS_JSON:-${SP_PROJECT_ROOT}/.claude/settings.local.json}"
  SP_HOST_BACKUP_DIR="${SP_HOST_BACKUP_DIR:-${SP_DOCS_DIR}/scripts/hooks-backup}"
  SP_RUNNER="${SP_RUNNER:-${SP_HOST_BACKUP_DIR}/run-superpowers-hook}"
  SP_RUNNER_TEMPLATE="${SP_RUNNER_TEMPLATE:-${SP_OVERLAY_ROOT}/scripts/run-superpowers-hook-host.sh}"
}

require_tools() {
  resolve_defaults
  command -v jq >/dev/null 2>&1 || {
    echo "jq is required" >&2
    exit 1
  }
  for f in "$SP_OVERLAY_HOOKS_JSON" "$SP_WIRING_JSON" "$SP_SETTINGS_JSON"; do
    if [ ! -f "$f" ]; then
      echo "missing required file: $f" >&2
      exit 1
    fi
  done
}

extract_fork_hook_names() {
  local event="$1"
  jq -r --arg ev "$event" '.hooks[$ev][0].hooks[]?.command // empty' "$SP_OVERLAY_HOOKS_JSON" 2>/dev/null \
    | sed -n 's/.*run-hook\.cmd" \{0,1\}\([a-z0-9-]*\).*/\1/p' \
    | sed '/^$/d'
}

is_host_bash_hook() {
  local name="$1"
  jq -e --arg n "$name" '.host_bash_hooks | index($n) != null' "$SP_WIRING_JSON" >/dev/null 2>&1
}

build_hook_entry_json() {
  local name="$1"
  if is_host_bash_hook "$name"; then
    jq -n --arg name "$name" \
      '{type: "command", command: ("bash \"$CLAUDE_PROJECT_DIR/docs/scripts/hooks-backup/" + $name + "\""), async: false}'
  else
    jq -n --arg name "$name" \
      '{type: "command", command: ("$CLAUDE_PROJECT_DIR/docs/scripts/hooks-backup/run-superpowers-hook " + $name), async: false}'
  fi
}

build_ordered_names() {
  local event="$1"
  local -a names=()
  local -a result=()
  local name insert_json

  if [ "$event" = "Stop" ]; then
    while IFS= read -r name; do
      [ -n "$name" ] && names+=("$name")
    done < <(jq -r '.events.Stop.prepend[]? // empty' "$SP_WIRING_JSON")
    while IFS= read -r name; do
      [ -n "$name" ] && names+=("$name")
    done < <(extract_fork_hook_names "Stop")
  elif [ "$event" = "UserPromptSubmit" ]; then
    while IFS= read -r name; do
      [ -n "$name" ] && names+=("$name")
    done < <(extract_fork_hook_names "UserPromptSubmit")
    result=()
    for name in "${names[@]}"; do
      result+=("$name")
      insert_json="$(jq -c --arg anchor "$name" '.events.UserPromptSubmit.insert_after[$anchor] // []' "$SP_WIRING_JSON")"
      if [ "$insert_json" != "[]" ] && [ "$insert_json" != "null" ]; then
        while IFS= read -r extra; do
          [ -n "$extra" ] && result+=("$extra")
        done < <(jq -r --arg anchor "$name" '.events.UserPromptSubmit.insert_after[$anchor][]?' "$SP_WIRING_JSON")
      fi
    done
    names=("${result[@]}")
  else
    return 1
  fi

  printf '%s\n' "${names[@]}"
}

build_event_hooks_json() {
  local event="$1"
  local -a entries=()
  local name entry

  while IFS= read -r name; do
    [ -z "$name" ] && continue
    entry="$(build_hook_entry_json "$name")"
    entries+=("$entry")
  done < <(build_ordered_names "$event")

  if [ "${#entries[@]}" -eq 0 ]; then
    echo "[]"
    return
  fi

  local joined=""
  for entry in "${entries[@]}"; do
    if [ -n "$joined" ]; then
      joined="${joined},${entry}"
    else
      joined="$entry"
    fi
  done
  printf '[%s]' "$joined"
}

extract_settings_hook_names() {
  local event="$1"
  jq -r --arg ev "$event" '.hooks[$ev][0].hooks[]?.command // empty' "$SP_SETTINGS_JSON" 2>/dev/null \
    | sed -n \
        -e 's/.*run-superpowers-hook *\([a-z0-9-]*\).*/\1/p' \
        -e 's/.*hooks-backup\/\([a-z0-9-]*\)".*/\1/p' \
    | sed '/^$/d'
}

cmd_install_runner() {
  require_tools
  mkdir -p "$SP_HOST_BACKUP_DIR"
  if [ ! -f "$SP_RUNNER_TEMPLATE" ]; then
    echo "missing runner template: $SP_RUNNER_TEMPLATE (run full-sync first)" >&2
    exit 1
  fi
  cp -p "$SP_RUNNER_TEMPLATE" "$SP_RUNNER"
  chmod +x "$SP_RUNNER"
  echo "installed $SP_RUNNER from overlay template"
}

prune_stale_backup_hooks() {
  local -a host_only=()
  local -a fork_names=()
  local name f

  while IFS= read -r name; do
    [ -n "$name" ] && host_only+=("$name")
  done < <(jq -r '.host_only_hooks[]?' "$SP_WIRING_JSON")
  while IFS= read -r name; do
    [ -n "$name" ] && fork_names+=("$name")
  done < <(extract_fork_hook_names "Stop")
  while IFS= read -r name; do
    [ -n "$name" ] && fork_names+=("$name")
  done < <(extract_fork_hook_names "UserPromptSubmit")

  for f in "$SP_HOST_BACKUP_DIR"/*; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    case "$name" in
      run-superpowers-hook | superpowers-runtime-sync-reminder) continue ;;
    esac
    local is_host=0
    if [ "${#host_only[@]}" -gt 0 ]; then
      for h in "${host_only[@]}"; do
        [ "$h" = "$name" ] && is_host=1 && break
      done
    fi
    [ "$is_host" -eq 1 ] && continue
    is_host_bash_hook "$name" && continue
    local is_fork=0
    if [ "${#fork_names[@]}" -gt 0 ]; then
      for h in "${fork_names[@]}"; do
        [ "$h" = "$name" ] && is_fork=1 && break
      done
    fi
    if [ "$is_fork" -eq 1 ]; then
      rm -f "$f"
      echo "pruned stale backup hook: $name"
    fi
  done
  # acceptance-order-common is sourced by old backup gates — remove if present
  if [ -f "$SP_HOST_BACKUP_DIR/acceptance-order-common" ]; then
    rm -f "$SP_HOST_BACKUP_DIR/acceptance-order-common"
    echo "pruned stale backup hook: acceptance-order-common"
  fi
}

cmd_apply() {
  require_tools
  cmd_install_runner
  prune_stale_backup_hooks

  local stop_hooks ups_hooks tmp
  stop_hooks="$(build_event_hooks_json "Stop")"
  ups_hooks="$(build_event_hooks_json "UserPromptSubmit")"

  tmp="$(mktemp)"
  jq --argjson stop "$stop_hooks" --argjson ups "$ups_hooks" '
    .hooks.Stop = [{"hooks": $stop}]
    | .hooks.UserPromptSubmit = [{"matcher": "", "hooks": $ups}]
  ' "$SP_SETTINGS_JSON" >"$tmp"
  mv "$tmp" "$SP_SETTINGS_JSON"
  echo "wired Stop ($(echo "$stop_hooks" | jq 'length') hooks) and UserPromptSubmit ($(echo "$ups_hooks" | jq 'length') hooks)"
  echo "  settings: $SP_SETTINGS_JSON"
}

cmd_verify() {
  require_tools
  local event failed=0
  local -a expected=()
  local -a got=()

  for event in Stop UserPromptSubmit; do
    expected=()
    got=()
    while IFS= read -r line; do
      [ -n "$line" ] && expected+=("$line")
    done < <(build_ordered_names "$event")
    while IFS= read -r line; do
      [ -n "$line" ] && got+=("$line")
    done < <(extract_settings_hook_names "$event")

    if [ "${#expected[@]}" -ne "${#got[@]}" ]; then
      echo "[FAIL] $event: count expected=${#expected[@]} got=${#got[@]}" >&2
      failed=1
      continue
    fi

    local i
    for i in "${!expected[@]}"; do
      if [ "${expected[$i]}" != "${got[$i]}" ]; then
        echo "[FAIL] $event[$i]: expected=${expected[$i]} got=${got[$i]:-}" >&2
        failed=1
      fi
    done
  done

  if [ "$failed" -ne 0 ]; then
    exit 1
  fi
  echo "verify OK: Stop and UserPromptSubmit hook order matches wiring manifest"
}

cmd_smoke() {
  require_tools
  local hf="$SP_OVERLAY_ROOT/hooks/hotfix-parallel-sync-guard"
  local nm="$SP_OVERLAY_ROOT/hooks/next-minor-behind-main-guard"
  local common="$SP_OVERLAY_ROOT/hooks/acceptance-order-common"
  local fork_test

  for f in "$hf" "$nm" "$common"; do
    if [ ! -f "$f" ]; then
      echo "[FAIL] missing overlay hook: $f" >&2
      exit 1
    fi
  done

  if [ -f "$SP_HOST_BACKUP_DIR/hotfix-parallel-sync-guard" ]; then
    echo "[FAIL] stale hooks-backup/hotfix-parallel-sync-guard (run apply to prune)" >&2
    exit 1
  fi

  fork_test=""
  for candidate in \
    "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." 2>/dev/null && pwd)/tests/claude-code/test-hotfix-parallel-sync.sh" \
    "/Users/harry/Documents/superpowers/tests/claude-code/test-hotfix-parallel-sync.sh"; do
    if [ -f "$candidate" ]; then
      fork_test="$candidate"
      break
    fi
  done
  if [ -n "$fork_test" ]; then
    bash "$fork_test"
    echo "smoke: test-hotfix-parallel-sync.sh passed"
  else
    echo "smoke: overlay hotfix hooks present (unit test not found)"
  fi
  echo "smoke OK"
}

main() {
  local cmd="${1:-}"
  case "$cmd" in
    apply) cmd_apply ;;
    verify) cmd_verify ;;
    smoke) cmd_smoke ;;
    install-runner) cmd_install_runner ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
