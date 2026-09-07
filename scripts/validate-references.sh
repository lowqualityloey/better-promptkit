#!/usr/bin/env bash
# Validation Script: Verify all workflow→template references exist
# Run from repository root: ./.promptkit/scripts/validate-references.sh

set +e  # Don't exit on first error

PROMPTKIT_DIR="${1:-.promptkit}"
ERROR_COUNT=0
WARNING_COUNT=0

echo ""
echo "🔍 Better-PromptKit Reference Validation"
echo ""

# Resolve paths
if [ ! -d "$PROMPTKIT_DIR" ]; then
    echo "❌ ERROR: PromptKit directory not found: $PROMPTKIT_DIR"
    exit 1
fi

PROMPTKIT_ROOT="$(cd "$PROMPTKIT_DIR" && pwd)"

# Define directories
WORKFLOWS_DIR="$PROMPTKIT_ROOT/workflows"
PROTOCOLS_DIR="$PROMPTKIT_ROOT/protocols"
TEMPLATES_DIR="$PROMPTKIT_ROOT/templates"
ACTIVITIES_DIR="$PROMPTKIT_ROOT/activities"

echo "📂 Scanning directories:"
echo "   - $WORKFLOWS_DIR"
echo "   - $PROTOCOLS_DIR"
echo "   - $TEMPLATES_DIR"
echo "   - $ACTIVITIES_DIR"
echo ""

# Find all markdown files
ALL_MD_FILES=()
while IFS= read -r -d '' file; do
    ALL_MD_FILES+=("$file")
done < <(find "$WORKFLOWS_DIR" "$PROTOCOLS_DIR" "$ACTIVITIES_DIR" "$PROMPTKIT_ROOT" -maxdepth 1 -name "*.md" -type f -print0 2>/dev/null)

echo "📄 Found ${#ALL_MD_FILES[@]} markdown files to validate"
echo ""

# Function to check file existence
check_file_reference() {
    local source_file="$1"
    local ref_type="$2"
    local ref_path="$3"
    local line_num="$4"
    
    local full_path="$PROMPTKIT_ROOT/$ref_path"
    
    if [ ! -f "$full_path" ]; then
        local rel_source="${source_file#$PROMPTKIT_ROOT/}"
        echo "  ❌ BROKEN: $rel_source:$line_num"
        echo "     Type: $ref_type"
        echo "     Missing: $ref_path"
        echo ""
        ((ERROR_COUNT++))
        return 1
    fi
    return 0
}

# Scan each file
for file in "${ALL_MD_FILES[@]}"; do
    rel_path="${file#$PROMPTKIT_ROOT/}"
    file_has_issues=false
    
    # Check template references (.promptkit/templates/*)
    while IFS= read -r line_content; do
        if [[ "$line_content" =~ \.promptkit/templates/([a-zA-Z0-9_-]+\.md) ]]; then
            template_name="${BASH_REMATCH[1]}"
            line_num=$(grep -n "$line_content" "$file" | head -1 | cut -d: -f1)
            if ! check_file_reference "$file" "Template" "templates/$template_name" "$line_num"; then
                file_has_issues=true
            fi
        fi
    done < "$file"
    
    # Check workflow references (.promptkit/workflows/*)
    while IFS= read -r line_content; do
        if [[ "$line_content" =~ \.promptkit/workflows/([a-zA-Z0-9_-]+\.md) ]]; then
            workflow_name="${BASH_REMATCH[1]}"
            line_num=$(grep -n "$line_content" "$file" | head -1 | cut -d: -f1)
            if ! check_file_reference "$file" "Workflow" "workflows/$workflow_name" "$line_num"; then
                file_has_issues=true
            fi
        fi
    done < "$file"
    
    # Check protocol references (.promptkit/protocols/*)
    while IFS= read -r line_content; do
        if [[ "$line_content" =~ \.promptkit/protocols/([a-zA-Z0-9_-]+\.md) ]]; then
            protocol_name="${BASH_REMATCH[1]}"
            line_num=$(grep -n "$line_content" "$file" | head -1 | cut -d: -f1)
            if ! check_file_reference "$file" "Protocol" "protocols/$protocol_name" "$line_num"; then
                file_has_issues=true
            fi
        fi
    done < "$file"
    
    # Check relative template references (templates/* without .promptkit prefix)
    while IFS= read -r line_content; do
        if [[ "$line_content" =~ [^\.]templates/([a-zA-Z0-9_-]+\.md) ]] && [[ ! "$line_content" =~ \.promptkit ]]; then
            template_name="${BASH_REMATCH[1]}"
            line_num=$(grep -n "$line_content" "$file" | head -1 | cut -d: -f1)
            if ! check_file_reference "$file" "Template (relative)" "templates/$template_name" "$line_num"; then
                file_has_issues=true
            fi
        fi
    done < "$file"
    
    # Check for workflow triggers without matching files
    triggers=$(grep -oE 'pk:[a-z]+' "$file" | sed 's/pk://' | sort -u)
    for trigger in $triggers; do
        expected_workflow="$WORKFLOWS_DIR/$trigger.md"
        if [ ! -f "$expected_workflow" ]; then
            # Check if it's a known alias
            case "$trigger" in
                db|profile|research|reflect|handoff|issue|kanban)
                    # Known aliases, skip warning
                    ;;
                *)
                    echo "  ⚠️  WARNING: $rel_path"
                    echo "     Trigger 'pk:$trigger' may not have matching workflow"
                    echo "     Expected: workflows/$trigger.md"
                    echo ""
                    ((WARNING_COUNT++))
                    ;;
            esac
        fi
    done
    
    if [ "$file_has_issues" = false ]; then
        echo "  ✅ $rel_path"
    fi
done

# Validate template directory completeness
echo ""
echo "📋 Checking template directory completeness..."

EXPECTED_TEMPLATES=(
    "project-profile-template.md"
    "design-profile-template.md"
    "state-tracker-template.md"
    "tech-spec-template.md"
    "adr-template.md"
    "data-model-spec.md"
    "auth-matrix-template.md"
    "api-contract-spec.md"
    "test-plan-template.md"
    "release-checklist.md"
    "pull-request-template.md"
    "perf-audit-template.md"
    "issue-task-template.md"
    "rca-postmortem-template.md"
    "code-review-checklist.md"
    "design-tokens-spec.md"
    "spike-template.md"
)

for template in "${EXPECTED_TEMPLATES[@]}"; do
    if [ -f "$TEMPLATES_DIR/$template" ]; then
        echo "  ✅ templates/$template"
    else
        echo "  ❌ MISSING: templates/$template"
        ((ERROR_COUNT++))
    fi
done

# Validate core workflow files
echo ""
echo "🔄 Checking core workflow files..."

CORE_WORKFLOWS=(
    "route.md"
    "tutor.md"
    "plan.md"
    "onboard.md"
    "tasks.md"
    "data.md"
    "auth.md"
    "api.md"
    "test.md"
    "design-system.md"
    "research.md"
    "debug.md"
    "perf.md"
    "review.md"
    "commit.md"
    "pr.md"
    "ship.md"
    "checkpoint.md"
    "reflect.md"
)

for workflow in "${CORE_WORKFLOWS[@]}"; do
    if [ -f "$WORKFLOWS_DIR/$workflow" ]; then
        echo "  ✅ workflows/$workflow"
    else
        echo "  ❌ MISSING: workflows/$workflow"
        ((ERROR_COUNT++))
    fi
done

# Validate protocol files
echo ""
echo "📜 Checking protocol files..."

CORE_PROTOCOLS=(
    "setup.md"
    "context-sync.md"
    "code-quality-gate.md"
    "subagent-delegation.md"
)

for protocol in "${CORE_PROTOCOLS[@]}"; do
    if [ -f "$PROTOCOLS_DIR/$protocol" ]; then
        echo "  ✅ protocols/$protocol"
    else
        echo "  ❌ MISSING: protocols/$protocol"
        ((ERROR_COUNT++))
    fi
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Validation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERROR_COUNT -eq 0 ] && [ $WARNING_COUNT -eq 0 ]; then
    echo ""
    echo "✅ All references valid! No broken links found."
    echo "   Better-PromptKit is ready for production use."
    echo ""
    exit 0
else
    echo ""
    if [ $ERROR_COUNT -gt 0 ]; then
        echo "  ❌ Errors: $ERROR_COUNT"
    fi
    if [ $WARNING_COUNT -gt 0 ]; then
        echo "  ⚠️  Warnings: $WARNING_COUNT"
    fi
    echo ""
    
    if [ $ERROR_COUNT -gt 0 ]; then
        echo "❌ Validation failed. Fix broken references before deployment."
        echo ""
        exit 1
    else
        echo "⚠️  Validation passed with warnings. Review recommended."
        echo ""
        exit 0
    fi
fi
