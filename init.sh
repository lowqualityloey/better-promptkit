#!/usr/bin/env bash
# Better-PromptKit 1-Click Setup Script for Linux/macOS
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_NAME="$(basename "$SCRIPT_DIR")"

if [[ "$#" -gt 0 ]]; then
    PROJECT_ROOT="$(cd "$1" && pwd)"
elif [[ "$DIR_NAME" == ".promptkit" || "$DIR_NAME" == "promptkit" ]]; then
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
    PROJECT_ROOT="$(pwd)"
fi

echo -e "\n\033[0;36m🚀 Initializing Better-PromptKit...\033[0m"
echo -e "   Host Project: $PROJECT_ROOT"
echo -e "   Engine Path:  $SCRIPT_DIR\n"

# 1. Ensure Documentation Directories Exist in Host Project
DOC_DIRS=(
    "docs/adrs"
    "docs/specs"
    "docs/rca"
    "docs/spikes"
    "docs/design"
    "docs/data"
    "docs/auth"
    "docs/api"
    "docs/tests"
    "docs/perf"
    "docs/releases"
)
for dir in "${DOC_DIRS[@]}"; do
    if [[ ! -d "$PROJECT_ROOT/$dir" ]]; then
        mkdir -p "$PROJECT_ROOT/$dir"
        echo -e "  \033[0;32m[+]\033[0m Created directory: $dir"
    fi
done

# 2. Scaffold PROMPTKIT.md if missing
PROJECT_PROFILE="$PROJECT_ROOT/PROMPTKIT.md"
TEMPLATE_PROFILE="$SCRIPT_DIR/templates/project-profile-template.md"

if [[ ! -f "$PROJECT_PROFILE" ]]; then
    if [[ -f "$TEMPLATE_PROFILE" ]]; then
        cp "$TEMPLATE_PROFILE" "$PROJECT_PROFILE"
        echo -e "  \033[0;32m[+]\033[0m Created: PROMPTKIT.md (project profile & guardrails)"
    fi
else
    echo -e "  \033[0;90m[✓] PROMPTKIT.md already present\033[0m"
fi

DESIGN_PROFILE="$PROJECT_ROOT/DESIGN.md"
if [[ -f "$DESIGN_PROFILE" ]]; then
    echo -e "  \033[0;90m[✓] DESIGN.md detected (brand identity & anti-slop rules)\033[0m"
fi

# 3. Detect Agent Files or Default to AGENTS.md
AGENT_FILES=(
    "AGENTS.md"
    "CLAUDE.md"
    "GEMINI.md"
    ".cursorrules"
    ".windsurfrules"
    ".github/copilot-instructions.md"
)

TARGETS_FOUND=()
for file in "${AGENT_FILES[@]}"; do
    if [[ -f "$PROJECT_ROOT/$file" ]]; then
        TARGETS_FOUND+=("$PROJECT_ROOT/$file")
    fi
done

if [[ ${#TARGETS_FOUND[@]} -eq 0 ]]; then
    DEFAULT_AGENT="$PROJECT_ROOT/AGENTS.md"
    touch "$DEFAULT_AGENT"
    TARGETS_FOUND+=("$DEFAULT_AGENT")
    echo -e "  \033[0;32m[+]\033[0m Created default agent configuration: AGENTS.md"
fi

# 4. Directive Block
KIT_DIR_REL=".promptkit"
if [[ "$SCRIPT_DIR" == "$PROJECT_ROOT"* ]]; then
    KIT_DIR_REL="${SCRIPT_DIR#$PROJECT_ROOT/}"
fi

DIRECTIVE=$(cat <<EOF
<!-- PROMPTKIT_START -->
## Better-PromptKit Engineering Operating System
Better-PromptKit is active in this workspace (\`./$KIT_DIR_REL\`). Follow these protocols, workflows, and quality gates during pair-programming, design, code generation, and review:

### Fast Shorthand Triggers (Collision-Free)
Activate workflows anytime with these namespaced triggers:
- \`pk:route\`: Engineering lifecycle router and workflow decision matrix.
- \`pk:tutor\` (or \`pk:tutor beginner\`, \`pk:tutor architect\`): Socratic mentorship & 3-tier progressive hints (never dump unsolicited code).
- \`pk:grill\`: Intensive Staff Engineer architecture interview and defense drill.
- \`pk:plan\`: Spec-Driven Architecture & feature planning (domain models, API contracts, failure modes).
- \`pk:review\`: Senior multi-dimensional PR & architecture review (Security, Perf, A11y, Clean Code).
- \`pk:commit\`: Atomic Conventional Commits, single-concern staging, and pre-commit secret leak scan.
- \`pk:pr\`: High-signal PR descriptions, verification evidence compilation, data safety checklist, and GitHub CLI creation.
- \`pk:debug\`: Hypothesis-driven scientific debugging & root cause analysis (5-Whys).
- \`pk:perf\` (or \`pk:profile\`): Empirical performance profiling, latency SLAs, EXPLAIN ANALYZE, and delta verification.
- \`pk:data\` (or \`pk:db\`): Relational database modeling, indexing strategies, RLS, and transaction boundaries.
- \`pk:auth\`: Authentication flows, cookie security, session management, and RBAC/ABAC matrices.
- \`pk:api\`: Frontend-backend handshake, unified error envelopes, and contract generation.
- \`pk:test\`: Upfront testing strategy, seam allocation, and mock boundaries.
- \`pk:ship\`: Release engineering, migration sequencing, runtime env checks, and rollbacks.
- \`pk:spike\` (or \`pk:research\`): Technical spikes, benchmarks, and multi-vector trade-off matrices.
- \`pk:design\`: Modern UI/UX, Design Tokens, and WCAG 2.2 Level AA accessibility.
- \`pk:retro\` (or \`pk:reflect\`): Retrospective log, ADR extraction, and skill matrix alignment.
- \`pk:checkpoint\` (or \`pk:handoff\`): Session state compaction, invariant locking, and fresh chat handover prompt.

### Smart Auto-Route & Guardrails (Triggers Are Optional)
You do not need to memorize triggers. If a prompt lacks an explicit \`pk:\` trigger, apply this triage:
- **Fast-Path (Zero Overhead)**: For simple questions, syntax lookups, quick explanations, formatting, or single-line tweaks, answer directly and concisely. Do NOT invoke heavy workflow ceremonies or produce unnecessary documents.
- **Protocol Auto-Route (Substantive Tasks)**: For multi-file changes, architecture, broken code, or production ops, automatically adopt the matching workflow:
  - Defects, bugs, crashes, or test failures -> \`pk:debug\` (reproduce before patching)
  - Performance regressions, slow queries, or latency -> \`pk:perf\` (measure baseline first)
  - New features, redesigns, or multi-component additions -> \`pk:plan\` (spec and risk analysis first)
  - Database schema, indexing, or migrations -> \`pk:data\` (Expand-Contract ordering)
  - Auth, sessions, cookies, or RBAC -> \`pk:auth\` (threat model and capability matrix)
  - Endpoints, contracts, or client types -> \`pk:api\` (envelope and schemas)
  - Test suites, seam allocation, or mocking -> \`pk:test\` (pyramid seam allocation)
  - Code audits or PR reviews -> \`pk:review\` (two-axis standard review)
  - Git commits or staging -> \`pk:commit\` (atomic conventional commits)
  - Pull requests or PR descriptions -> \`pk:pr\` (verification evidence and PR body)
  - Context bloat, chat lag, session handover, or pausing -> \`pk:checkpoint\` (zero-loss handover)
  - Deployments, env validation, or releases -> \`pk:ship\` (pre-flight checks and rollback)
  When auto-routing a substantive task, announce it briefly in one sentence (e.g., "[Better-PromptKit: Auto-routed to pk:plan]") and enforce its quality gate.

### Workflows & Protocols Reference
- **Route**: $KIT_DIR_REL/workflows/route.md
- **Tutor**: $KIT_DIR_REL/workflows/tutor.md
- **Plan**: $KIT_DIR_REL/workflows/plan.md
- **Review**: $KIT_DIR_REL/workflows/review.md
- **Commit**: $KIT_DIR_REL/workflows/commit.md
- **Pull Request**: $KIT_DIR_REL/workflows/pr.md
- **Debug**: $KIT_DIR_REL/workflows/debug.md
- **Performance**: $KIT_DIR_REL/workflows/perf.md
- **Data**: $KIT_DIR_REL/workflows/data.md
- **Auth**: $KIT_DIR_REL/workflows/auth.md
- **API**: $KIT_DIR_REL/workflows/api.md
- **Test**: $KIT_DIR_REL/workflows/test.md
- **Ship**: $KIT_DIR_REL/workflows/ship.md
- **Research**: $KIT_DIR_REL/workflows/research.md
- **Design System**: $KIT_DIR_REL/workflows/design-system.md
- **Reflect**: $KIT_DIR_REL/workflows/reflect.md
- **Checkpoint**: $KIT_DIR_REL/workflows/checkpoint.md
- **Quality Gate (DoD)**: $KIT_DIR_REL/protocols/code-quality-gate.md
- **Context Sync**: $KIT_DIR_REL/protocols/context-sync.md
- **Project Profile & Rules**: ./PROMPTKIT.md (if present)
- **Visual Identity & Brand**: ./DESIGN.md (if present)

### Project Artifact Output Paths
All generated project documentation must be saved to the host project:
- ADRs: docs/adrs/
- Technical Specs: docs/specs/
- Post-Mortems: docs/rca/
- Spikes: docs/spikes/
- Design Specs: docs/design/
- Data Models: docs/data/
- Auth Specs: docs/auth/
- API Contracts: docs/api/
- Test Plans: docs/tests/
- Performance Audits: docs/perf/
- Releases: docs/releases/
<!-- PROMPTKIT_END -->
EOF
)

# 5. Inject or Replace Directives (Idempotent)
for target in "${TARGETS_FOUND[@]}"; do
    REL_TARGET="${target#$PROJECT_ROOT/}"
    if grep -q "<!-- PROMPTKIT_START -->" "$target" 2>/dev/null; then
        # Replace existing block using perl / awk
        perl -i -0777 -pe "s/<!-- PROMPTKIT_START -->.*?<!-- PROMPTKIT_END -->/\Q$DIRECTIVE\E/s" "$target" 2>/dev/null || {
            echo "$DIRECTIVE" > "$target"
        }
        echo -e "  \033[0;33m[✓]\033[0m Updated Better-PromptKit directives in: $REL_TARGET"
    else
        printf "\n\n%s\n" "$DIRECTIVE" >> "$target"
        echo -e "  \033[0;32m[+]\033[0m Injected Better-PromptKit directives into: $REL_TARGET"
    fi
done

echo -e "\n\033[0;36m✨ Better-PromptKit successfully configured for $PROJECT_ROOT!\033[0m"
echo -e "   Start by asking your AI: 'pk:plan', 'pk:tutor', or 'pk:review'\n"
