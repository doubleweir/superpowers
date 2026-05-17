#!/usr/bin/env bash
# Test: superpowers-runtime-sync-reminder injects routing context only for
# maintenance prompts that target superpowers surfaces.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOOK="$ROOT/hooks/superpowers-runtime-sync-reminder"

echo "=== Test: superpowers runtime sync reminder ==="

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local name="$3"
  if printf '%s' "$haystack" | rg -q "$needle"; then
    echo "  [PASS] $name"
  else
    echo "  [FAIL] $name"
    echo "  Missing pattern: $needle"
    echo "$haystack"
    exit 1
  fi
}

output="$(printf '%s' '{"prompt":"帮我改一下 superpowers 的 hook 和本地发版流程"}' | CLAUDE_PLUGIN_ROOT="$ROOT" bash "$HOOK")"
assert_contains "$output" '"hookEventName": "UserPromptSubmit"' "hook emits UserPromptSubmit payload"
assert_contains "$output" 'Superpowers maintenance task detected' "hook injects routing reminder"
assert_contains "$output" 'sync-superpowers-fork.sh full-sync latest' "hook references full-sync pipeline"
assert_contains "$output" 'wire' "hook mentions wire step"

empty_output="$(printf '%s' '{"prompt":"帮我改一下 panel dark token"}' | CLAUDE_PLUGIN_ROOT="$ROOT" bash "$HOOK")"
if [ -z "$empty_output" ]; then
  echo "  [PASS] non-superpowers prompt does not inject reminder"
else
  echo "  [FAIL] non-superpowers prompt should not inject reminder"
  echo "$empty_output"
  exit 1
fi

echo ""
echo "=== superpowers runtime sync reminder checks passed ==="
