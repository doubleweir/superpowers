#!/usr/bin/env bash
# Regression: cws-production-build-credentials-guard (No.37 / No.33)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRIPT_DIR/../.."
HOOK="$ROOT/hooks/cws-production-build-credentials-guard"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

setup_repo() {
  git -C "$TMP" init -q -b main
  mkdir -p "$TMP/app/plugin/entrypoints/background/services"
  mkdir -p "$TMP/app/plugin/.output/chrome-mv3"
  printf '%s\n' '// ga4' > "$TMP/app/plugin/entrypoints/background/services/ga4-analytics.ts"
  git -C "$TMP" add . && git -C "$TMP" -c user.email=t@test -c user.name=t commit -q -m init
}

write_prod_bundle() {
  local mid="${1:-G-TESTMID01}"
  cat > "$TMP/app/plugin/.output/chrome-mv3/background.js" <<EOF
function M(){let e=\`prod\`;return e===\`validate\`||e===\`debug\`?e:\`prod\`}
const id="${mid}";
const url="https://www.google-analytics.com/mp/collect";
EOF
}

write_debug_bundle() {
  cat > "$TMP/app/plugin/.output/chrome-mv3/background.js" <<'EOF'
function M(){let e=`debug`;return e===`validate`||e===`debug`?e:`prod`}
const id="G-TESTMID01";
const url="https://www.google-analytics.com/mp/collect";
EOF
}

run_hook() {
  CLAUDE_PROJECT_DIR="$TMP" bash "$HOOK"
}

setup_repo
write_prod_bundle "G-TESTMID01"
if run_hook; then echo "FAIL expected block without .env"; exit 1; else echo "PASS blocks missing .env"; fi

cat > "$TMP/app/plugin/.env" <<'EOF'
WXT_GA4_MEASUREMENT_ID=G-TESTMID01
WXT_GA4_API_SECRET=test-secret-value
WXT_ANALYTICS_MODE=prod
EOF
if ! run_hook; then echo "FAIL expected pass with prod .env + bundle"; exit 1; else echo "PASS prod credentials"; fi

write_debug_bundle
if run_hook; then echo "FAIL expected block debug bundle"; exit 1; else echo "PASS blocks debug mode"; fi

write_prod_bundle "G-WRONGID00"
if run_hook; then echo "FAIL expected block measurement id mismatch"; exit 1; else echo "PASS blocks id mismatch"; fi

echo "ALL PASS"
