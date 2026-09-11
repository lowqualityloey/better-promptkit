#!/usr/bin/env bash
# ==============================================================================
# Better-PromptKit GitHub Label Provisioning (POSIX Bash)
# Uses GitHub CLI (gh) to idempotently create or update standard labels.
# ==============================================================================

set -euo pipefail

echo -e "\n\033[0;36m🏷️  Better-PromptKit GitHub Label Provisioning\033[0m"

# 1. Verify GitHub CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo -e "\033[0;31m[!] GitHub CLI (gh) is not installed or not in PATH.\033[0m"
    echo "    Please install it: https://cli.github.com"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo -e "\033[0;31m[!] GitHub CLI is not authenticated.\033[0m"
    echo "    Please run 'gh auth login' first."
    exit 1
fi

declare -a LABELS=(
    "priority/p0:b60205:Critical blocker or P0 security issue"
    "priority/p1:d93f0b:High priority / core feature flow"
    "priority/p2:fbca04:Medium priority / enhancement or optimization"
    "priority/p3:0e8a16:Low priority / polish or styling"
    "type:feature:1d76db:New capability, feature, or functionality"
    "type:bug:d73a4a:Defect, regression, or broken behavior"
    "type:refactor:a2eeef:Code refactoring without behavioral changes"
    "type:test:d4c5f9:Test suite additions, fixes, or hardening"
    "type:docs:0075ca:Documentation, ADRs, or guides only"
    "area:backend:5319e7:Server, API endpoints, microservices, business logic"
    "area:frontend:1f883d:Web client, mobile views, screens, components"
    "area:data:0052cc:Database schemas, migrations, ORM, persistence"
    "area:ui:e99695:Design tokens, Tailwind styles, visual aesthetics"
    "area:auth:f9d0c4:Authentication, sessions, tokens, RBAC permissions"
    "area:perf:c2e0c6:Performance profiling, query optimization, latency"
)

echo -e "\033[0;90mSyncing ${#LABELS[@]} labels to GitHub repository...\033[0m"

for item in "${LABELS[@]}"; do
    IFS=":" read -r name color description <<< "$item"
    if gh label create "$name" --color "$color" --description "$description" --force &> /dev/null; then
        echo -e "  \033[0;32m[+]\033[0m Configured: $name"
    else
        echo -e "  \033[0;31m[!]\033[0m Failed to configure: $name"
    fi
done

echo -e "\n\033[0;36m✅ Better-PromptKit GitHub labels successfully provisioned!\033[0m\n"
