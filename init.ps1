<#
.SYNOPSIS
    Better-PromptKit 1-Click Setup Script for Windows (PowerShell)
.DESCRIPTION
    Initializes Better-PromptKit in your project:
    - Scaffolds project documentation directories (docs/adrs, docs/specs, docs/rca, docs/spikes, docs/design)
    - Creates PROMPTKIT.md project profile if missing
    - Injects or updates Better-PromptKit directives in AGENTS.md, CLAUDE.md, GEMINI.md, .cursorrules, .windsurfrules, or .github/copilot-instructions.md
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [Alias("ProjectRoot")]
    [string]$TargetDir = ""
)

$ErrorActionPreference = "Stop"

# Determine Better-PromptKit directory and Host Project Root
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($TargetDir -ne "") {
    $ProjectRoot = Resolve-Path $TargetDir
} elseif ((Split-Path -Leaf $ScriptDir) -in @(".promptkit", "promptkit")) {
    $ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..")
} else {
    $ProjectRoot = Resolve-Path "."
}

$ProjectRootPath = if ($ProjectRoot.Path) { $ProjectRoot.Path } else { $ProjectRoot.ToString() }

Write-Host "`n🚀 Initializing Better-PromptKit..." -ForegroundColor Cyan
Write-Host "   Host Project: $ProjectRoot" -ForegroundColor DarkGray
Write-Host "   Engine Path:  $ScriptDir`n" -ForegroundColor DarkGray

# 1. Ensure Documentation Directories Exist in Host Project
$DocDirs = @(
    "docs/adrs",
    "docs/specs",
    "docs/rca",
    "docs/spikes",
    "docs/design",
    "docs/data",
    "docs/auth",
    "docs/api",
    "docs/tests",
    "docs/reviews",
    "docs/perf",
    "docs/tasks",
    "docs/releases",
    "docs/releases/ci-triage"
)

foreach ($dir in $DocDirs) {
    $fullPath = Join-Path $ProjectRoot $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  [+] Created directory: $dir" -ForegroundColor Green
    }
}

# 2. Scaffold PROMPTKIT.md if missing
$ProjectProfile = Join-Path $ProjectRoot "PROMPTKIT.md"
$TemplateProfile = Join-Path $ScriptDir "templates/project-profile-template.md"

if (-not (Test-Path $ProjectProfile)) {
    if (Test-Path $TemplateProfile) {
        Copy-Item -Path $TemplateProfile -Destination $ProjectProfile
        Write-Host "  [+] Created: PROMPTKIT.md (project profile & guardrails)" -ForegroundColor Green
    }
} else {
    Write-Host "  [✓] PROMPTKIT.md already present" -ForegroundColor DarkGray
}

$DesignProfile = Join-Path $ProjectRoot "DESIGN.md"
if (Test-Path $DesignProfile) {
    Write-Host "  [✓] DESIGN.md detected (brand identity & anti-slop rules)" -ForegroundColor DarkGray
}

# Scaffold docs/STATE.md if missing
$StateTracker = Join-Path $ProjectRoot "docs/STATE.md"
$TemplateState = Join-Path $ScriptDir "templates/state-tracker-template.md"

if (-not (Test-Path $StateTracker)) {
    if (Test-Path $TemplateState) {
        Copy-Item -Path $TemplateState -Destination $StateTracker
        Write-Host "  [+] Created: docs/STATE.md (living project & state tracker)" -ForegroundColor Green
    }
} else {
    Write-Host "  [✓] docs/STATE.md already present" -ForegroundColor DarkGray
}

# 3. Detect Agent Files or Default to AGENTS.md
$AgentFiles = @(
    "AGENTS.md",
    "CLAUDE.md",
    "GEMINI.md",
    ".cursorrules",
    ".windsurfrules",
    ".github/copilot-instructions.md"
)

$TargetsFound = @()
foreach ($file in $AgentFiles) {
    $path = Join-Path $ProjectRoot $file
    if (Test-Path $path) {
        $TargetsFound += $path
    }
}

if ($TargetsFound.Count -eq 0) {
    $defaultAgent = Join-Path $ProjectRoot "AGENTS.md"
    New-Item -ItemType File -Path $defaultAgent -Force | Out-Null
    $TargetsFound += $defaultAgent
    Write-Host "  [+] Created default agent configuration: AGENTS.md" -ForegroundColor Green
}

# 4. Directive Block
$KitDirRel = if ($ScriptDir.StartsWith($ProjectRootPath)) {
    $ScriptDir.Substring($ProjectRootPath.Length).TrimStart("\", "/") -replace "\\", "/"
} else {
    ".promptkit"
}

$Directive = @"
<!-- PROMPTKIT_START -->
## Better-PromptKit Engineering Operating System
Better-PromptKit is active in this workspace (`./$KitDirRel`). Follow these protocols, workflows, and quality gates during pair-programming, design, code generation, and review:

### Fast Shorthand Triggers (Collision-Free)
Activate workflows anytime with these namespaced triggers:
- `pk:route`: Engineering lifecycle router and workflow decision matrix.
- `pk:tutor` (or `pk:tutor beginner`, `pk:tutor architect`): Socratic mentorship & 3-tier progressive hints (never dump unsolicited code).
- `pk:grill`: Intensive Staff Engineer architecture interview and defense drill.
- `pk:plan`: Spec-Driven Architecture & feature planning (domain models, API contracts, failure modes).
- `pk:onboard`: Brownfield codebase intake: scan repository, extract scripts, and auto-populate PROMPTKIT.md.
- `pk:tasks` (or `pk:issue`, `pk:kanban`): Decompose RFC specs into atomic GitHub issues with Gherkin Acceptance Criteria and Kanban sync.
- `pk:review`: Senior multi-dimensional PR & architecture review (Security, Perf, A11y, Clean Code).
- `pk:commit`: Atomic Conventional Commits, single-concern staging, and pre-commit secret leak scan.
- `pk:pr`: High-signal PR descriptions, verification evidence compilation, data safety checklist, and GitHub CLI creation.
- `pk:debug`: Hypothesis-driven scientific debugging & root cause analysis (5-Whys).
- `pk:fix`: Surgical remediation for known findings, security-first ordering, and single-concern scope.
- `pk:perf` (or `pk:profile`): Empirical performance profiling, latency SLAs, EXPLAIN ANALYZE, and delta verification.
- `pk:data` (or `pk:db`): Relational database modeling, indexing strategies, RLS, and transaction boundaries.
- `pk:auth`: Authentication flows, cookie security, session management, and RBAC/ABAC matrices.
- `pk:api`: Frontend-backend handshake, unified error envelopes, and contract generation.
- `pk:test`: Upfront testing strategy, seam allocation, and mock boundaries.
- `pk:ship`: Release engineering, migration sequencing, runtime env checks, and rollbacks.
- `pk:spike` (or `pk:research`): Technical spikes, benchmarks, and multi-vector trade-off matrices.
- `pk:design`: Modern UI/UX, Design Tokens, and WCAG 2.2 Level AA accessibility.
- `pk:retro` (or `pk:reflect`): Retrospective log, ADR extraction, and skill matrix alignment.
- `pk:checkpoint` (or `pk:handoff`): Session state compaction, invariant locking, docs/STATE.md update, and fresh chat handover prompt.

### Smart Auto-Route & Guardrails (Triggers Are Optional)
You do not need to memorize triggers. If a prompt lacks an explicit `pk:` trigger, apply this triage:
- **Fast-Path (Zero Overhead)**: For simple questions, syntax lookups, quick explanations, formatting, or single-line tweaks, answer directly and concisely. Do NOT invoke heavy workflow ceremonies or produce unnecessary documents.
- **Protocol Auto-Route (Substantive Tasks)**: For multi-file changes, architecture, broken code, or production ops, automatically adopt the matching workflow:
  - Defects, bugs, crashes, or test failures (unknown cause) -> `pk:debug` (reproduce before patching)
  - Known defects, review findings, or security patches -> `pk:fix` (remediate known root cause)
  - Performance regressions, slow queries, or latency -> `pk:perf` (measure baseline first)
  - New features, redesigns, or multi-component additions -> `pk:plan` (spec and risk analysis first)
  - Existing repo intake, setup, or codebase audit -> `pk:onboard` (scan repo and scaffold PROMPTKIT.md)
  - Task breakdowns, issue creation, or Kanban cards -> `pk:tasks` (atomic issues and Gherkin AC)
  - Database schema, indexing, or migrations -> `pk:data` (Expand-Contract ordering)
  - Auth, sessions, cookies, or RBAC -> `pk:auth` (threat model and capability matrix)
  - Endpoints, contracts, or client types -> `pk:api` (envelope and schemas)
  - Test suites, seam allocation, or mocking -> `pk:test` (pyramid seam allocation)
  - Code audits or PR reviews -> `pk:review` (two-axis standard review)
  - Git commits or staging -> `pk:commit` (atomic conventional commits)
  - Pull requests or PR descriptions -> `pk:pr` (verification evidence and PR body)
  - Context bloat, chat lag, session handover, or pausing -> `pk:checkpoint` (sync docs/STATE.md & zero-loss handover)
  - Deployments, env validation, or releases -> `pk:ship` (pre-flight checks and rollback)
  When auto-routing a substantive task, announce it briefly in one sentence (e.g., "[Better-PromptKit: Auto-routed to pk:plan]") and enforce its quality gate.

### Workflows & Protocols Reference
- **Route**: $KitDirRel/workflows/route.md
- **Tutor**: $KitDirRel/workflows/tutor.md
- **Plan**: $KitDirRel/workflows/plan.md
- **Onboard**: $KitDirRel/workflows/onboard.md
- **Tasks**: $KitDirRel/workflows/tasks.md
- **Review**: $KitDirRel/workflows/review.md
- **Commit**: $KitDirRel/workflows/commit.md
- **Pull Request**: $KitDirRel/workflows/pr.md
- **Debug**: $KitDirRel/workflows/debug.md
- **Fix**: $KitDirRel/workflows/fix.md
- **Performance**: $KitDirRel/workflows/perf.md
- **Data**: $KitDirRel/workflows/data.md
- **Auth**: $KitDirRel/workflows/auth.md
- **API**: $KitDirRel/workflows/api.md
- **Test**: $KitDirRel/workflows/test.md
- **Ship**: $KitDirRel/workflows/ship.md
- **Research**: $KitDirRel/workflows/research.md
- **Design System**: $KitDirRel/workflows/design-system.md
- **Reflect**: $KitDirRel/workflows/reflect.md
- **Checkpoint**: $KitDirRel/workflows/checkpoint.md
- **Quality Gate (DoD)**: $KitDirRel/protocols/code-quality-gate.md
- **Context Sync**: $KitDirRel/protocols/context-sync.md
- **Subagent Delegation**: $KitDirRel/protocols/subagent-delegation.md
- **Project Profile & Rules**: ./PROMPTKIT.md (if present)
- **Visual Identity & Brand**: ./DESIGN.md (if present)
- **Living State & Tracker**: ./docs/STATE.md (if present)

### Project Artifact Output Paths
All generated project documentation must be saved to the host project:
- State Tracker: docs/STATE.md
- ADRs: docs/adrs/
- Technical Specs: docs/specs/
- Task Breakdowns: docs/tasks/
- Post-Mortems: docs/rca/
- Spikes: docs/spikes/
- Design Specs: docs/design/
- Data Models: docs/data/
- Auth Specs: docs/auth/
- API Contracts: docs/api/
- Test Plans: docs/tests/
- Review Reports: docs/reviews/
- Performance Audits: docs/perf/
- Releases: docs/releases/
- CI Triage Evidence: docs/releases/ci-triage/
<!-- PROMPTKIT_END -->
"@

# 5. Inject or Replace Directives (Idempotent)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

foreach ($targetPath in $TargetsFound) {
    $relTarget = if ($targetPath.StartsWith($ProjectRootPath)) {
        $targetPath.Substring($ProjectRootPath.Length).TrimStart("\", "/") -replace "\\", "/"
    } else {
        $targetPath -replace "\\", "/"
    }

    $content = if (Test-Path $targetPath) {
        [System.IO.File]::ReadAllText($targetPath, [System.Text.Encoding]::UTF8)
    } else {
        ""
    }

    if ($content -match "<!-- PROMPTKIT_START -->") {
        $lines = $content -split "\r?\n"
        $startCount = @($lines | Where-Object { $_ -match '^<!-- PROMPTKIT_START -->$' }).Count
        $endCount = @($lines | Where-Object { $_ -match '^<!-- PROMPTKIT_END -->$' }).Count

        if ($startCount -ne 1 -or $endCount -ne 1) {
            [System.Console]::Error.WriteLine("Error: Cannot safely update ${relTarget}: expected exactly one complete PromptKit directive block.")
            throw "Error: Cannot safely update ${relTarget}: expected exactly one complete PromptKit directive block."
        }

        $pattern = '(?ms)^<!-- PROMPTKIT_START -->$.*?^<!-- PROMPTKIT_END -->$'
        $escapedDirective = $Directive.Replace('$', '$$')
        $updated = [regex]::Replace($content, $pattern, $escapedDirective)
        [System.IO.File]::WriteAllText($targetPath, $updated, $utf8NoBom)
        Write-Host "  [✓] Updated Better-PromptKit directives in: $relTarget" -ForegroundColor Yellow
    } else {
        $prefix = if ($content.Trim().Length -gt 0) { "`n`n" } else { "" }
        $updated = $content + $prefix + $Directive
        [System.IO.File]::WriteAllText($targetPath, $updated, $utf8NoBom)
        Write-Host "  [+] Injected Better-PromptKit directives into: $relTarget" -ForegroundColor Green
    }
}

Write-Host "`n✨ Better-PromptKit successfully configured for $ProjectRoot!" -ForegroundColor Cyan
Write-Host "   Start by asking your AI: 'pk:plan', 'pk:tutor', or 'pk:review'`n" -ForegroundColor White
