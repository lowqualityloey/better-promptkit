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
echo "📌 Scenario A: Trivial Change ('Fix a typo in the README') — Level 0 Direct"
assert_contains "workflows/route.md" "Level 0 — Direct" "Level 0 Direct classification defined in router"
assert_contains "workflows/route.md" "understand → change → verify" "Level 0 expected behavior flow present"
assert_contains "protocols/setup.md" "Level 0 \(Direct / Zero Overhead\)" "Level 0 fast-path rule in agent setup protocol"

echo ""
echo "📌 Scenario B: Localized Bug / Small Feature ('Fix empty password crash') — Level 1 Standard"
assert_contains "workflows/route.md" "Level 1 — Standard" "Level 1 Standard classification defined in router"
assert_contains "workflows/route.md" "does .*not.* trigger Level 2 Controlled Work" "Level 1 file edits do not trigger mandatory Task Record creation"
assert_contains "workflows/plan.md" "Level 1 .*Do NOT create or populate" "Plan workflow specifies Level 1 does not map to Task Record file"
assert_contains "workflows/tasks.md" "Level 0 \(Direct\) and Level 1 \(Standard\) work modify source files directly" "Tasks workflow specifies Level 1 file edits do not require Task Record"

echo ""
echo "📌 Scenario C: Substantive Risk Feature ('Add OAuth login and user roles') — Level 2 Controlled"
assert_contains "workflows/route.md" "Level 2 — Controlled" "Level 2 Controlled classification defined in router"
assert_contains "workflows/route.md" "docs/tasks/<task-id>\.md" "Local Task Record required for Level 2 Controlled Work"
assert_contains "workflows/plan.md" "Level 2 .*Requires canonical Local Task Record readiness" "Plan workflow requires Task Record for Level 2 Minimal/Full Planning"
assert_contains "workflows/auth.md" "matrix" "Auth workflow defines capability matrix requirements"

echo ""
echo "📌 Scenario D: Destructive Operation ('Drop the users table and recreate the schema')"
assert_contains "workflows/data.md" "Expand-Contract" "Data workflow enforces Expand-Contract migration strategy"
assert_contains "templates/pull-request-template.md" "No Destructive Drops" "PR template includes destructive operation safety check"
assert_contains "workflows/route.md" "human authorization" "Router specifies explicit human authorization boundary"

echo ""
echo "📌 Scenario E: Release & Level-3 Downgrade Safety Rules"
assert_contains "workflows/route.md" "Level 3 Downgrade Guardrails" "Level 3 downgrade safety guardrails section present"
assert_contains "workflows/route.md" "no tag creation, release publication, production deployment" "Confirmation no release actions remain in scope"
assert_contains "workflows/route.md" "Release Coordinator approval" "Release Coordinator approval required if release evaluation started"
assert_contains "workflows/route.md" "closure record for any existing release evidence" "Existing release evidence must be preserved or closed"

echo ""
echo "📌 Scenario F: Canonical Mapping & Consistency Checks"
assert_contains "workflows/route.md" "Canonical Mapping & Legacy Compatibility" "Explicit canonical mapping section present in router"
assert_contains "workflows/route.md" "sole authority for Level" "Router Adaptation compatibility contract uses Level 0-3 model"
assert_contains "workflows/plan.md" "Level 0 Direct, Level 1 Standard, Level 2 Controlled, Level 3 Release-Critical" "Plan workflow maps Levels 0-3 explicitly"
assert_contains "README.md" "Level 0 — Direct" "README includes Level 0 ceremony definition"
assert_contains "README.md" "Task Ceremony Levels \(Level 0–3 Execution\)" "README contains Level 0-3 execution model"
assert_contains "README.md" "Level 1 .*does NOT require a Task Record" "README explicitly says Level 1 does not require a Task Record"
assert_contains "README.md" "Level 2 .*Requires a canonical Local Task Record" "README specifies Level 2 requires a Task Record"
assert_contains "README.md" "Level 3 .*Requires Level 2 evidence" "README specifies Level 3 requires Level 2 evidence and Task Record"
assert_contains "workflows/route.md" "treat release and evidence work as Level 3" "Router release-evidence routing uses Level-3 terminology"
assert_contains "README.md" "Maintainer CI \(script syntax, initialization dry-run/idempotency" "README CI description refers to current validation"
assert_contains "docs/WORKFLOW-MAP.md" "Level 1 — Standard" "WORKFLOW-MAP includes Level 1 ceremony definition"

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
