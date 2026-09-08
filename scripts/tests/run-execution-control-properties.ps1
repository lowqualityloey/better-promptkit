# Deterministic, dependency-free Wave 7 property and example harness.
# Run from repository root: pwsh -NoProfile -File .\scripts\tests\run-execution-control-properties.ps1

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
$repoRoot = (Split-Path -Parent (Split-Path -Parent $scriptDir)).TrimEnd('\', '/')
$fixtureRoot = Join-Path $repoRoot "scripts/tests/fixtures/execution-control"
$examplesManifest = Join-Path $fixtureRoot "examples.tsv"
$iterations = 100
$seed = 20260908
$script:rngState = [long]$seed
$tempBase = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } elseif ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() }
$tempRoot = Join-Path $tempBase ("promptkit-execution-control-properties-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

function Fail-Property {
    param([string]$Message)
    throw "PROPERTY_FAILURE|$Message"
}

function Get-NextChoice {
    param([int]$Modulus)
    $script:rngState = ([long]$script:rngState * 48271) % 2147483647
    return [int]($script:rngState % $Modulus)
}

function Get-RepositorySnapshot {
    $gitPrefix = Join-Path $repoRoot ".git"
    return @(
        Get-ChildItem -LiteralPath $repoRoot -File -Recurse |
            Where-Object { $_.FullName -notlike "$gitPrefix*" } |
            Sort-Object FullName |
            ForEach-Object {
                $relative = $_.FullName.Substring($repoRoot.Length).TrimStart('\', '/') -replace '\\', '/'
                "$relative|$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)"
            }
    )
}

function Get-GitStatusSnapshot {
    $status = @(& git -C $repoRoot status --porcelain=v1 --untracked-files=all 2>&1)
    if ($LASTEXITCODE -ne 0) { Fail-Property "Unable to read Git status" }
    return @($status | ForEach-Object { $_.ToString() })
}

function Assert-SnapshotUnchanged {
    param([string[]]$BeforeFiles, [string[]]$BeforeStatus)
    $afterFiles = @(Get-RepositorySnapshot)
    $afterStatus = @(Get-GitStatusSnapshot)
    if (($BeforeFiles -join "`n") -ne ($afterFiles -join "`n")) { Fail-Property "Repository file hashes changed during property validation" }
    if (($BeforeStatus -join "`n") -ne ($afterStatus -join "`n")) { Fail-Property "Git status changed during property validation" }
}

function Test-OneActiveTask {
    for ($i = 1; $i -le $iterations; $i++) {
        $pointer = "TASK-2026-09-08-property-a-$i"
        $activeCount = 1
        $choice = Get-NextChoice 2
        if ($choice -eq 0) {
            if ($activeCount -ne 1 -or $pointer -notlike "*property-a-$i") { Fail-Property "one-active-task rejected-task invariant failed at iteration $i" }
        } else {
            $pointer = ""
            $activeCount = 0
            $pointer = "TASK-2026-09-08-property-b-$i"
            $activeCount = 1
        }
        if ($activeCount -gt 1 -or [string]::IsNullOrWhiteSpace($pointer)) { Fail-Property "one-active-task invariant failed at iteration $i" }
    }
    Write-Output "PROPERTY|one-active-task|SEED=$seed|ITERATIONS=$iterations|PASS"
}

function Test-ValidTransition {
    param([string]$Previous, [string]$Next)
    $key = "$Previous->$Next"
    return $key -in @(
        "planned->ready", "ready->in_progress", "in_progress->checkpoint_due", "in_progress->blocked",
        "in_progress->paused", "in_progress->handoff_ready", "in_progress->awaiting_review",
        "in_progress->completed", "checkpoint_due->in_progress", "blocked->in_progress",
        "paused->in_progress", "handoff_ready->in_progress", "awaiting_review->in_progress",
        "awaiting_review->completed"
    )
}

function Get-BoardStatus {
    param([string]$State)
    switch ($State) {
        { $_ -in @("planned", "ready", "aborted") } { return "To Do" }
        { $_ -in @("in_progress", "checkpoint_due", "blocked", "paused", "handoff_ready") } { return "In Progress" }
        "awaiting_review" { return "In Review" }
        "completed" { return "Done" }
        default { return "" }
    }
}

function Assert-ValidTransition {
    param([string]$Previous, [string]$Next)
    if (-not (Test-ValidTransition $Previous $Next)) { Fail-Property "valid-transition rejected $Previous->$Next" }
    if ([string]::IsNullOrWhiteSpace((Get-BoardStatus $Next))) { Fail-Property "valid-transition has no pk:tasks mapping for $Next" }
}

function Test-ValidTransitions {
    $stopStates = @("checkpoint_due", "blocked", "paused", "handoff_ready")
    for ($i = 1; $i -le $iterations; $i++) {
        $state = "planned"
        Assert-ValidTransition $state "ready"; $state = "ready"
        Assert-ValidTransition $state "in_progress"; $state = "in_progress"
        $choice = Get-NextChoice 5
        if ($choice -eq 4) {
            Assert-ValidTransition $state "awaiting_review"; $state = "awaiting_review"
        } else {
            $stopState = $stopStates[$choice % $stopStates.Count]
            Assert-ValidTransition $state $stopState; $state = $stopState
            Assert-ValidTransition $state "in_progress"; $state = "in_progress"
            Assert-ValidTransition $state "awaiting_review"; $state = "awaiting_review"
        }
        Assert-ValidTransition $state "completed"; $state = "completed"
        if (Test-ValidTransition $state "in_progress") { Fail-Property "valid-transition accepted completed->in_progress at iteration $i" }
    }
    Write-Output "PROPERTY|valid-state-transitions|SEED=$seed|ITERATIONS=$iterations|PASS"
}

function Test-StopStateBlocking {
    $stopStates = @("checkpoint_due", "blocked", "paused", "handoff_ready", "aborted")
    for ($i = 1; $i -le $iterations; $i++) {
        $stopState = $stopStates[(Get-NextChoice $stopStates.Count)]
        $implementationAllowed = $false
        $resumeSatisfied = $false
        $reactivated = $false
        if ($implementationAllowed) { Fail-Property "stop-state-blocking allowed implementation in $stopState at iteration $i" }
        $resumeSatisfied = $true
        if ($stopState -eq "aborted") {
            if ($resumeSatisfied -and -not $reactivated -and $implementationAllowed) { Fail-Property "stop-state-blocking allowed aborted continuation before reactivation at iteration $i" }
            $reactivated = $true
        }
        if ($resumeSatisfied -and ($stopState -ne "aborted" -or $reactivated)) { $implementationAllowed = $true }
        if (-not $implementationAllowed) { Fail-Property "stop-state-blocking did not resume $stopState at iteration $i" }
    }
    Write-Output "PROPERTY|stop-state-blocking|SEED=$seed|ITERATIONS=$iterations|PASS"
}

function Test-ScopeChangeApproval {
    $dimensions = @("objective", "files", "acceptance", "dependencies", "non-goals", "risk", "verification")
    for ($i = 1; $i -le $iterations; $i++) {
        $dimension = $dimensions[(Get-NextChoice $dimensions.Count)]
        $approved = $false
        $changeAllowed = $false
        if (-not $approved -and $changeAllowed) { Fail-Property "scope-change-approval allowed unapproved $dimension change at iteration $i" }
        $approved = $true
        $changeAllowed = $true
        if (-not $changeAllowed) { Fail-Property "scope-change-approval rejected approved $dimension change at iteration $i" }
    }
    Write-Output "PROPERTY|scope-change-approval|SEED=$seed|ITERATIONS=$iterations|PASS"
}

function Test-CompletionEvidence {
    $fields = @("acceptance", "verification", "changed-files", "commit-or-pr")
    for ($i = 1; $i -le $iterations; $i++) {
        $missingIndex = Get-NextChoice $fields.Count
        $completionAllowed = $true
        for ($field = 0; $field -lt $fields.Count; $field++) {
            if ($field -eq $missingIndex) { $completionAllowed = $false }
        }
        if ($completionAllowed) { Fail-Property "completion-evidence allowed missing $($fields[$missingIndex]) at iteration $i" }
        $completionAllowed = $true
        if (-not $completionAllowed) { Fail-Property "completion-evidence rejected complete evidence at iteration $i" }
    }
    Write-Output "PROPERTY|completion-evidence|SEED=$seed|ITERATIONS=$iterations|PASS"
}

function Test-ExamplesManifest {
    if (-not (Test-Path -LiteralPath $examplesManifest)) { Fail-Property "Missing examples manifest: $examplesManifest" }
    $seen = @{}
    $count = 0
    foreach ($line in (Get-Content -LiteralPath $examplesManifest)) {
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) { continue }
        $parts = $line -split "`t", 3
        if ($parts.Count -ne 3) { Fail-Property "Examples row must contain three tab-separated columns: $line" }
        $name = $parts[0]; $category = $parts[1]; $relativePath = $parts[2]
        if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($category) -or [string]::IsNullOrWhiteSpace($relativePath)) { Fail-Property "Examples row is incomplete: $line" }
        if ([System.IO.Path]::IsPathRooted($relativePath) -or $relativePath -match '(^|[\\/])\.\.([\\/]|$)') { Fail-Property "Examples path escapes fixture root: $relativePath" }
        $recordPath = Join-Path $fixtureRoot $relativePath
        if (-not (Test-Path -LiteralPath $recordPath -PathType Leaf)) { Fail-Property "Examples record does not exist: $relativePath" }
        if ($relativePath -notlike '*.md') { Fail-Property "Examples record is not Markdown: $relativePath" }
        $content = Get-Content -LiteralPath $recordPath -Raw
        if ($content -notmatch 'Record Type' -or $content -notmatch 'Task ID') { Fail-Property "Examples record lacks required labels: $relativePath" }
        $seen[$category] = $true
        $count++
    }
    foreach ($category in @('readiness', 'checkpoint', 'handoff', 'completion')) {
        if (-not $seen.ContainsKey($category)) { Fail-Property "Examples manifest lacks category: $category" }
    }
    if ($count -lt 4) { Fail-Property "Examples manifest contains fewer than four records" }
    Write-Output "EXAMPLES|COUNT=$count|CATEGORIES=readiness,checkpoint,handoff,completion|PASS"
}

try {
    $beforeFiles = @(Get-RepositorySnapshot)
    $beforeStatus = @(Get-GitStatusSnapshot)
    Test-OneActiveTask
    Test-ValidTransitions
    Test-StopStateBlocking
    Test-ScopeChangeApproval
    Test-CompletionEvidence
    Test-ExamplesManifest
    Assert-SnapshotUnchanged $beforeFiles $beforeStatus
    Write-Output "Execution-control PowerShell property harness passed: properties=5 iterations_per_property=$iterations seed=$seed read_only=PASS."
    Write-Output "Execution-control property evidence is local and synthetic; it cannot authorize remote, release, deployment, or rollback actions."
} finally {
    if (Test-Path -LiteralPath $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}
