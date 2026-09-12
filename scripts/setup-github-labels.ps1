<#
.SYNOPSIS
    Provision PromptKit OS standard labels on GitHub.
.DESCRIPTION
    Uses GitHub CLI (gh) to idempotently create or update the standard
    PromptKit OS priority/*, type:*, and area:* labels.
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "`n🏷️  PromptKit OS GitHub Label Provisioning" -ForegroundColor Cyan

# 1. Verify GitHub CLI is installed and authenticated
try {
    $null = Get-Command gh -ErrorAction Stop
} catch {
    Write-Error "GitHub CLI (gh) is not installed or not in PATH. Please install it: https://cli.github.com"
    exit 1
}

$authCheck = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "GitHub CLI is not authenticated. Please run 'gh auth login' first."
    exit 1
}

$Labels = @(
    # Priority
    @{ Name = "priority/p0"; Color = "b60205"; Description = "Critical blocker or P0 security issue" },
    @{ Name = "priority/p1"; Color = "d93f0b"; Description = "High priority / core feature flow" },
    @{ Name = "priority/p2"; Color = "fbca04"; Description = "Medium priority / enhancement or optimization" },
    @{ Name = "priority/p3"; Color = "0e8a16"; Description = "Low priority / polish or styling" },

    # Type
    @{ Name = "type:feature"; Color = "1d76db"; Description = "New capability, feature, or functionality" },
    @{ Name = "type:bug"; Color = "d73a4a"; Description = "Defect, regression, or broken behavior" },
    @{ Name = "type:refactor"; Color = "a2eeef"; Description = "Code refactoring without behavioral changes" },
    @{ Name = "type:test"; Color = "d4c5f9"; Description = "Test suite additions, fixes, or hardening" },
    @{ Name = "type:docs"; Color = "0075ca"; Description = "Documentation, ADRs, or guides only" },

    # Area
    @{ Name = "area:backend"; Color = "5319e7"; Description = "Server, API endpoints, microservices, business logic" },
    @{ Name = "area:frontend"; Color = "1f883d"; Description = "Web client, mobile views, screens, components" },
    @{ Name = "area:data"; Color = "0052cc"; Description = "Database schemas, migrations, ORM, persistence" },
    @{ Name = "area:ui"; Color = "e99695"; Description = "Design tokens, Tailwind styles, visual aesthetics" },
    @{ Name = "area:auth"; Color = "f9d0c4"; Description = "Authentication, sessions, tokens, RBAC permissions" },
    @{ Name = "area:perf"; Color = "c2e0c6"; Description = "Performance profiling, query optimization, latency" }
)

Write-Host "Syncing $($Labels.Count) labels to GitHub repository..." -ForegroundColor DarkGray

foreach ($label in $Labels) {
    gh label create $label.Name --color $label.Color --description $label.Description --force | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [+] Configured: $($label.Name)" -ForegroundColor Green
    } else {
        Write-Host "  [!] Failed to configure: $($label.Name)" -ForegroundColor Red
    }
}

Write-Host "`n✅ PromptKit OS GitHub labels successfully provisioned!`n" -ForegroundColor Cyan
