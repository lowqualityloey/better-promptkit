#!/usr/bin/env bash
# Behavioral Prompt-Contract Verification Harness (Bash)
# Run from repository root: bash scripts/tests/run-behavioral-contract-tests.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

FAIL_COUNT=0
PASS_COUNT=0

assert_contains() {
    local file="$1"
    local pattern="$2"
    local desc="$3"

    if grep -Ei "$pattern" "$REPO_ROOT/$file" >/dev/null 2>&1; then
        echo "  ✅ PASS: $desc"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  ❌ FAIL: $desc (pattern '$pattern' not found in $file)"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

echo ""
echo "🧪 Running Better-PromptKit Behavioral Prompt-Contract Tests"
echo "==========================================================="

echo ""
echo "📌 Scenario A: Trivial Change ('Fix a typo in the README')"
assert_contains "workflows/route.md" "Level 0 — Direct" "Level 0 Direct classification defined in router"
assert_contains "workflows/route.md" "understand → change → verify" "Level 0 expected behavior flow present"
assert_contains "protocols/setup.md" "Level 0 \(Direct / Zero Overhead\)" "Level 0 fast-path rule in agent setup protocol"

echo ""
echo "📌 Scenario B: Substantive Feature ('Add OAuth login and user roles')"
assert_contains "workflows/route.md" "Level 2 — Controlled" "Level 2 Controlled classification defined in router"
assert_contains "workflows/route.md" "docs/tasks/<task-id>\.md" "Local Task Record required for Level 2 Controlled Work"
assert_contains "workflows/auth.md" "matrix" "Auth workflow defines capability matrix requirements"

echo ""
echo "📌 Scenario C: Destructive Operation ('Drop the users table and recreate the schema')"
assert_contains "workflows/data.md" "Expand-Contract" "Data workflow enforces Expand-Contract migration strategy"
assert_contains "templates/pull-request-template.md" "No Destructive Drops" "PR template includes destructive operation safety check"
assert_contains "workflows/route.md" "human authorization" "Router specifies explicit human authorization boundary"

echo ""
echo "📌 Scenario D: Ordinary Bug ('Login form crashes when password is empty')"
assert_contains "workflows/route.md" "Level 1 — Standard" "Level 1 Standard classification defined in router"
assert_contains "workflows/route.md" "pk:debug" "Defects and bugs route to pk:debug workflow"
assert_contains "workflows/debug.md" "feedback loop" "Debug workflow requires empirical feedback loop before fixing"

echo ""
echo "📌 Scenario E: Level Escalation and Downgrade Rules"
assert_contains "workflows/route.md" "Escalation / Upgrade" "Escalation rules defined for expanding risk"
assert_contains "workflows/route.md" "Downgrade" "Downgrade rules defined for simplified scope"

echo ""
echo "==========================================================="
echo "📊 Behavioral Contract Verification Summary"
echo "Passed: $PASS_COUNT | Failed: $FAIL_COUNT"
echo "==========================================================="

if [ "$FAIL_COUNT" -gt 0 ]; then
    echo "❌ Behavioral prompt-contract verification failed."
    exit 1
else
    echo "✅ All behavioral prompt-contract tests passed successfully!"
    exit 0
fi
