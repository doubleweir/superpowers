#!/usr/bin/env bash
# Test: active PR resolution priority in acceptance hooks
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRIPT_DIR/../.."
COMMON="$ROOT/hooks/acceptance-order-common"

echo "=== Test: active PR resolution priority ==="
echo ""

if [ ! -f "$COMMON" ]; then
    echo "[FAIL] Missing hook helper: $COMMON"
    exit 1
fi

# shellcheck source=/dev/null
. "$COMMON"

TMP_DIR="$(mktemp -d)"
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

PROJECT_DIR="$TMP_DIR/project"
VERSION_DIR="$PROJECT_DIR/docs/V0.1.0-panel-ui"
PR1_DIR="$VERSION_DIR/V0.1.0-PR1"
PR2_DIR="$VERSION_DIR/V0.1.0-PR2"

mkdir -p "$PR1_DIR" "$PR2_DIR" "$PROJECT_DIR/.claude"
touch "$PR1_DIR/V0.1.0-PR1-tdd-log.md" "$PR2_DIR/V0.1.0-PR2-tdd-log.md"

assert_path_eq() {
    local got="$1"
    local expected="$2"
    local name="$3"
    if [ "$got" = "$expected" ]; then
        echo "  [PASS] $name"
    else
        echo "  [FAIL] $name"
        echo "  expected: $expected"
        echo "  got:      $got"
        exit 1
    fi
}

# 1) SUPERPOWERS_ACTIVE_PR_DIR has highest priority
resolved="$(SUPERPOWERS_ACTIVE_PR_DIR="$PR1_DIR" resolve_active_pr_dir "$PROJECT_DIR" "$VERSION_DIR" "run autotest for pr2")"
assert_path_eq "$resolved" "$PR1_DIR" "env SUPERPOWERS_ACTIVE_PR_DIR priority"

# 2) SUPERPOWERS_ACTIVE_PR selects by basename
resolved="$(SUPERPOWERS_ACTIVE_PR="V0.1.0-PR2" resolve_active_pr_dir "$PROJECT_DIR" "$VERSION_DIR" "")"
assert_path_eq "$resolved" "$PR2_DIR" "env SUPERPOWERS_ACTIVE_PR basename"

# 3) SUPERPOWERS_ACTIVE_PR_CONTEXT supports PRn shorthand
resolved="$(SUPERPOWERS_ACTIVE_PR_CONTEXT="PR2" resolve_active_pr_dir "$PROJECT_DIR" "$VERSION_DIR" "")"
assert_path_eq "$resolved" "$PR2_DIR" "env SUPERPOWERS_ACTIVE_PR_CONTEXT shorthand"

# 4) .active-pr supports absolute path
printf '%s\n' "$PR1_DIR" > "$PROJECT_DIR/.claude/.active-pr"
resolved="$(resolve_active_pr_dir "$PROJECT_DIR" "$VERSION_DIR" "")"
assert_path_eq "$resolved" "$PR1_DIR" ".active-pr absolute path marker"

# 5) Prompt hint selects matching PR when no explicit context
rm -f "$PROJECT_DIR/.claude/.active-pr"
resolved="$(resolve_active_pr_dir "$PROJECT_DIR" "$VERSION_DIR" "please run devicetest for PR2")"
assert_path_eq "$resolved" "$PR2_DIR" "prompt hint PR selection"

# 6) Lowercase v* version root + PR dirs (case-sensitive FS safe)
LO_ROOT="$TMP_DIR/lowercase-project"
LO_VERSION="$LO_ROOT/docs/v0.2.0-topic"
LO_PR="$LO_VERSION/v0.2.0-PR1"
mkdir -p "$LO_PR" "$LO_ROOT/.claude"
touch "$LO_PR/v0.2.0-PR1-tdd-log.md"
resolved="$(resolve_latest_version_dir "$LO_ROOT")"
assert_path_eq "$resolved" "$LO_VERSION" "resolve_latest_version_dir finds docs/v* root"
resolved="$(resolve_active_pr_dir "$LO_ROOT" "$LO_VERSION" "")"
assert_path_eq "$resolved" "$LO_PR" "resolve_active_pr_dir finds v*-PR* under lowercase root"

# 7) Product-line prefix pv* version root + PR
PV_ROOT="$TMP_DIR/pv-project"
PV_VERSION="$PV_ROOT/docs/pv0.3.0-panel-ui"
PV_PR="$PV_VERSION/pv0.3.0-PR1"
mkdir -p "$PV_PR" "$PV_ROOT/.claude"
touch "$PV_PR/pv0.3.0-PR1-tdd-log.md"
resolved="$(resolve_latest_version_dir "$PV_ROOT")"
assert_path_eq "$resolved" "$PV_VERSION" "resolve_latest_version_dir finds docs/pv* root"
resolved="$(SUPERPOWERS_ACTIVE_PR_CONTEXT="PR1" resolve_active_pr_dir "$PV_ROOT" "$PV_VERSION" "")"
assert_path_eq "$resolved" "$PV_PR" "resolve_active_pr_dir finds pv*-PR* under prefixed version root"

# 8) Nested docs/<product>/<semantic>/ (ChatBobi v0.1.14+)
NEST_ROOT="$TMP_DIR/nested-project"
NEST_VERSION="$NEST_ROOT/docs/plugin/pv0.4.0-dom-adapt"
NEST_PR="$NEST_VERSION/pv0.4.0-PR1"
mkdir -p "$NEST_PR" "$NEST_ROOT/.claude"
touch "$NEST_PR/pv0.4.0-PR1-tdd-log.md"
resolved="$(resolve_latest_version_dir "$NEST_ROOT")"
assert_path_eq "$resolved" "$NEST_VERSION" "resolve_latest_version_dir finds docs/plugin/pv* nested root"
resolved="$(SUPERPOWERS_ACTIVE_PR_CONTEXT="PR1" resolve_active_pr_dir "$NEST_ROOT" "$NEST_VERSION" "")"
assert_path_eq "$resolved" "$NEST_PR" "resolve_active_pr_dir under nested version root"

# 9) Same basename shallow vs deep → deep wins (No.9 tie-break)
DUP_ROOT="$TMP_DIR/dup-basename-project"
DUP_SHALLOW="$DUP_ROOT/docs/pv0.5.0-same"
DUP_DEEP="$DUP_ROOT/docs/plugin/pv0.5.0-same"
mkdir -p "$DUP_DEEP" "$DUP_SHALLOW"
touch "$DUP_SHALLOW/.keep" "$DUP_DEEP/.keep"
# Shallow newer mtime must not win while deduping same basename
touch -t 202501010101 "$DUP_DEEP/.keep"
touch -t 202601010101 "$DUP_SHALLOW/.keep"
resolved="$(resolve_latest_version_dir "$DUP_ROOT")"
assert_path_eq "$resolved" "$DUP_DEEP" "same basename: deeper docs path wins for resolve_latest"
resolved="$(resolve_version_dir_from_branch "$DUP_ROOT" "feat/pv0.5.0-same")"
assert_path_eq "$resolved" "$DUP_DEEP" "same basename: deeper path for resolve_version_dir_from_branch"

# 10) Hotfix branch binds docs/plugin/pv*-hotfix-* (No.18)
HF_ROOT="$TMP_DIR/hotfix-project"
HF_VERSION="$HF_ROOT/docs/plugin/pv0.1.14-hotfix-scroll"
HF_OTHER="$HF_ROOT/docs/plugin/pv0.1.14-panel-polish"
mkdir -p "$HF_VERSION" "$HF_OTHER"
touch "$HF_VERSION/.keep" "$HF_OTHER/.keep"
touch -t 202601010101 "$HF_OTHER/.keep"
touch -t 202501010101 "$HF_VERSION/.keep"
resolved="$(resolve_active_version_dir "$HF_ROOT" "feat/pv0.1.14-hotfix-scroll")"
assert_path_eq "$resolved" "$HF_VERSION" "resolve_active_version_dir prefers hotfix branch-bound root"
if is_hotfix_branch "feat/pv0.1.14-hotfix-scroll"; then
  echo "  [PASS] is_hotfix_branch"
else
  echo "  [FAIL] is_hotfix_branch"
  exit 1
fi
if is_hotfix_version_basename "pv0.1.14-hotfix-scroll"; then
  echo "  [PASS] is_hotfix_version_basename"
else
  echo "  [FAIL] is_hotfix_version_basename"
  exit 1
fi

# 11) Hotfix PR dir pv*-hotfix-*-PRn resolves under hotfix version root
HF_PR_DIR="$HF_VERSION/pv0.1.14-hotfix-scroll-PR1"
mkdir -p "$HF_PR_DIR"
touch "$HF_PR_DIR/pv0.1.14-hotfix-scroll-PR1-tdd-log.md"
resolved="$(resolve_active_pr_dir "$HF_ROOT" "$HF_VERSION" "")"
assert_path_eq "$resolved" "$HF_PR_DIR" "resolve_active_pr_dir finds hotfix *-PRn dir"

echo ""
echo "=== active PR resolution checks passed ==="
