# Behavioral Prompt-Contract Verification Harness (PowerShell)
# Run from repository root: pwsh -NoProfile -File .\scripts\tests\run-behavioral-contract-tests.ps1

$ErrorActionPreference = "Continue"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..")

$script:PassCount = 0
$script:FailCount = 0

function Assert-Contains {
    param(
        [string]$File,
        [string]$Pattern,
        [string]$Description
    )

    $fullPath = Join-Path $RepoRoot $File
    if (Test-Path $fullPath) {
        $content = Get-Content -Path $fullPath -Raw
        if ($content -match $Pattern) {
            Write-Host "  ✅ PASS: $Description" -ForegroundColor Green
            $script:PassCount++
            return
        }
    }
    Write-Host "  ❌ FAIL: $Description (pattern '$Pattern' not found in $File)" -ForegroundColor Red
    $script:FailCount++
}

Write-Host "`n🧪 Running Better-PromptKit Behavioral Prompt-Contract Tests" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor DarkGray

Write-Host "`n📌 Scenario A: Trivial Change ('Fix a typo in the README')" -ForegroundColor Yellow
Assert-Contains "workflows/route.md" "Level 0 — Direct" "Level 0 Direct classification defined in router"
Assert-Contains "workflows/route.md" "understand → change → verify" "Level 0 expected behavior flow present"
Assert-Contains "protocols/setup.md" "Level 0 \(Direct / Zero Overhead\)" "Level 0 fast-path rule in agent setup protocol"

Write-Host "`n📌 Scenario B: Substantive Feature ('Add OAuth login and user roles')" -ForegroundColor Yellow
Assert-Contains "workflows/route.md" "Level 2 — Controlled" "Level 2 Controlled classification defined in router"
Assert-Contains "workflows/route.md" "docs/tasks/<task-id>\.md" "Local Task Record required for Level 2 Controlled Work"
Assert-Contains "workflows/auth.md" "matrix" "Auth workflow defines capability matrix requirements"

Write-Host "`n📌 Scenario C: Destructive Operation ('Drop the users table and recreate the schema')" -ForegroundColor Yellow
Assert-Contains "workflows/data.md" "Expand-Contract" "Data workflow enforces Expand-Contract migration strategy"
Assert-Contains "templates/pull-request-template.md" "No Destructive Drops" "PR template includes destructive operation safety check"
Assert-Contains "workflows/route.md" "human authorization" "Router specifies explicit human authorization boundary"

Write-Host "`n📌 Scenario D: Ordinary Bug ('Login form crashes when password is empty')" -ForegroundColor Yellow
Assert-Contains "workflows/route.md" "Level 1 — Standard" "Level 1 Standard classification defined in router"
Assert-Contains "workflows/route.md" "pk:debug" "Defects and bugs route to pk:debug workflow"
Assert-Contains "workflows/debug.md" "feedback loop" "Debug workflow requires empirical feedback loop before fixing"

Write-Host "`n📌 Scenario E: Level Escalation and Downgrade Rules" -ForegroundColor Yellow
Assert-Contains "workflows/route.md" "Escalation / Upgrade" "Escalation rules defined for expanding risk"
Assert-Contains "workflows/route.md" "Downgrade" "Downgrade rules defined for simplified scope"

Write-Host "`n===========================================================" -ForegroundColor DarkGray
Write-Host "📊 Behavioral Contract Verification Summary" -ForegroundColor Cyan
Write-Host "Passed: $script:PassCount | Failed: $script:FailCount" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor DarkGray

if ($script:FailCount -gt 0) {
    Write-Host "❌ Behavioral prompt-contract verification failed.`n" -ForegroundColor Red
    exit 1
} else {
    Write-Host "✅ All behavioral prompt-contract tests passed successfully!`n" -ForegroundColor Green
    exit 0
}
