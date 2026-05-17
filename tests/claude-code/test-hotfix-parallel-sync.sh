#!/usr/bin/env bash
# Test: H7 hotfix parallel sync helpers and Stop guards (No.18 R1/R2)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRIPT_DIR/../.."
COMMON="$ROOT/hooks/acceptance-order-common"
HF_GUARD="$ROOT/hooks/hotfix-parallel-sync-guard"
NM_GUARD="$ROOT/hooks/next-minor-behind-main-guard"

echo "=== Test: hotfix parallel sync (H7) ==="
echo ""

for f in "$COMMON" "$HF_GUARD" "$NM_GUARD"; do
  if [ ! -f "$f" ]; then
    echo "[FAIL] Missing: $f"
    exit 1
  fi
done

# shellcheck source=/dev/null
. "$COMMON"

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

assert_eq() {
  local got="$1" expected="$2" name="$3"
  if [ "$got" = "$expected" ]; then
    echo "  [PASS] $name"
  else
    echo "  [FAIL] $name (expected=$expected got=$got)"
    exit 1
  fi
}

assert_exit() {
  local expected="$1"
  shift
  set +e
  "$@" >/dev/null 2>&1
  local rc=$?
  set -e
  if [ "$rc" -eq "$expected" ]; then
    echo "  [PASS] exit $expected: $*"
  else
    echo "  [FAIL] exit $expected expected, got $rc: $*"
    exit 1
  fi
}

# 1) list_in_flight: next minor only (excludes hotfix + lower semver)
PROJ="$TMP_DIR/proj1"
mkdir -p "$PROJ"
git -C "$PROJ" init -q
printf 'init\n' > "$PROJ/.gitkeep"
git -C "$PROJ" add .gitkeep
git -C "$PROJ" -c user.email=test@test -c user.name=test commit -q -m init
git -C "$PROJ" checkout -q -b feat/pv0.1.14-hotfix-scroll
git -C "$PROJ" checkout -q -b feat/pv0.1.15-panel
printf 'v15\n' > "$PROJ/v15.txt"
git -C "$PROJ" add v15.txt
git -C "$PROJ" -c user.email=test@test -c user.name=test commit -q -m "v15 work"
git -C "$PROJ" branch feat/pv0.1.13-old
git -C "$PROJ" branch feat/pv0.1.14-hotfix-other
git -C "$PROJ" checkout -q feat/pv0.1.14-hotfix-scroll
LIST="$(list_in_flight_pv_feature_branches "$PROJ" "feat/pv0.1.14-hotfix-scroll" | sort)"
assert_eq "$LIST" "feat/pv0.1.15-panel" "in-flight lists higher semver only"

# 2) parallel_sync_section_valid modes
FL_FULL="$TMP_DIR/finalize-full.md"
cat > "$FL_FULL" <<'EOF'
## Parallel next minor sync

- strategy: merge_main
- target_branch: feat/pv0.1.15-panel
- evidence: merged main at abc1234
EOF
parallel_sync_section_valid "$FL_FULL" "full" && echo "  [PASS] full mode accepts strategy+target+evidence" || { echo "  [FAIL] full mode"; exit 1; }

FL_PLAN="$TMP_DIR/finalize-plan.md"
cat > "$FL_PLAN" <<'EOF'
## Parallel next minor sync

- strategy: merge_main
- target_branch: feat/pv0.1.15-panel
EOF
parallel_sync_section_valid "$FL_PLAN" "plan" && echo "  [PASS] plan mode without evidence" || { echo "  [FAIL] plan mode"; exit 1; }
if parallel_sync_section_valid "$FL_PLAN" "full"; then
  echo "  [FAIL] full mode should require evidence"
  exit 1
else
  echo "  [PASS] full mode rejects missing evidence"
fi

FL_NA="$TMP_DIR/finalize-na.md"
printf '## Parallel next minor sync\n\n- strategy: N/A\n' > "$FL_NA"
parallel_sync_section_valid "$FL_NA" "plan" && { echo "  [FAIL] plan should reject N/A"; exit 1; } || echo "  [PASS] plan rejects N/A"

# 3) hotfix guard: plan only (no evidence) passes
HF_PROJ="$TMP_DIR/hf-guard"
HF_VER="$HF_PROJ/docs/plugin/pv0.1.14-hotfix-scroll"
HF_PR="$HF_VER/pv0.1.14-hotfix-scroll-PR1"
mkdir -p "$HF_PR"
git -C "$HF_PROJ" init -q
printf 'init\n' > "$HF_PROJ/.gitkeep"
git -C "$HF_PROJ" add .gitkeep
git -C "$HF_PROJ" -c user.email=test@test -c user.name=test commit -q -m init
git -C "$HF_PROJ" checkout -q -b feat/pv0.1.14-hotfix-scroll
git -C "$HF_PROJ" checkout -q -b feat/pv0.1.15-panel
printf 'v15\n' > "$HF_PROJ/v15.txt"
git -C "$HF_PROJ" add v15.txt
git -C "$HF_PROJ" -c user.email=test@test -c user.name=test commit -q -m v15
git -C "$HF_PROJ" checkout -q feat/pv0.1.14-hotfix-scroll
git -C "$HF_PROJ" tag plugin/pv0.1.14
touch "$HF_PR/pv0.1.14-hotfix-scroll-PR1-tdd-log.md"
touch "$HF_PR/pv0.1.14-hotfix-scroll-PR1-finalize-log.md"
printf 'incomplete\n' > "$HF_PR/pv0.1.14-hotfix-scroll-PR1-finalize-log.md"
export CLAUDE_PROJECT_DIR="$HF_PROJ"
assert_exit 2 bash "$HF_GUARD"

cat > "$HF_PR/pv0.1.14-hotfix-scroll-PR1-finalize-log.md" <<'EOF'
## Parallel next minor sync

- strategy: cherry_pick
- target_branch: feat/pv0.1.15-panel
EOF
assert_exit 0 bash "$HF_GUARD"

# 4) missing baseline tag blocks
HF_NOTAG="$TMP_DIR/hf-notag"
HF_NT_VER="$HF_NOTAG/docs/plugin/pv0.1.14-hotfix-x"
HF_NT_PR="$HF_NT_VER/pv0.1.14-hotfix-x-PR1"
mkdir -p "$HF_NT_PR"
git -C "$HF_NOTAG" init -q
printf 'i\n' > "$HF_NOTAG/f"; git -C "$HF_NOTAG" add f
git -C "$HF_NOTAG" -c user.email=t@test -c user.name=t commit -q -m i
git -C "$HF_NOTAG" checkout -q -b feat/pv0.1.14-hotfix-x
git -C "$HF_NOTAG" checkout -q -b feat/pv0.1.15-y
printf 'y\n' > "$HF_NOTAG/y.txt"
git -C "$HF_NOTAG" add y.txt
git -C "$HF_NOTAG" -c user.email=t@test -c user.name=t commit -q -m y
git -C "$HF_NOTAG" checkout -q feat/pv0.1.14-hotfix-x
touch "$HF_NT_PR/pv0.1.14-hotfix-x-PR1-tdd-log.md"
cat > "$HF_NT_PR/pv0.1.14-hotfix-x-PR1-finalize-log.md" <<'EOF'
## Parallel next minor sync
- strategy: merge_main
- target_branch: feat/pv0.1.15-y
EOF
export CLAUDE_PROJECT_DIR="$HF_NOTAG"
assert_exit 2 bash "$HF_GUARD"

# 5) next-minor-behind-main-guard blocks when integration ahead
NM_PROJ="$TMP_DIR/nm-guard"
mkdir -p "$NM_PROJ/app/plugin"
git -C "$NM_PROJ" init -q -b main
printf 'base\n' > "$NM_PROJ/app/plugin/base.ts"
git -C "$NM_PROJ" add app/plugin/base.ts
git -C "$NM_PROJ" -c user.email=t@test -c user.name=t commit -q -m "base"
git -C "$NM_PROJ" checkout -q -b feat/pv0.1.15-panel
git -C "$NM_PROJ" checkout -q main
echo v1 > "$NM_PROJ/app/plugin/a.ts"
git -C "$NM_PROJ" add app/plugin/a.ts
git -C "$NM_PROJ" -c user.email=t@test -c user.name=t commit -q -m "hotfix on main"
git -C "$NM_PROJ" checkout -q feat/pv0.1.15-panel
export CLAUDE_PROJECT_DIR="$NM_PROJ"
assert_exit 2 bash "$NM_GUARD"

# 6) waiver requires reason:
mkdir -p "$NM_PROJ/.superpowers"
touch "$NM_PROJ/.superpowers/hotfix-sync-waived"
assert_exit 2 bash "$NM_GUARD"
printf 'reason: emergency local only\n' > "$NM_PROJ/.superpowers/hotfix-sync-waived"
assert_exit 0 bash "$NM_GUARD"

echo ""
echo "All H7 hotfix parallel sync tests passed."
