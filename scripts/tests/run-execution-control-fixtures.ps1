# Cross-platform fixture harness for the read-only execution-control validator.
# Run from repository root: pwsh -NoProfile -File .\scripts\tests\run-execution-control-fixtures.ps1

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
$repoRoot = (Split-Path -Parent (Split-Path -Parent $scriptDir)).TrimEnd('\', '/')
$fixtureRoot = Join-Path $repoRoot "scripts/tests/fixtures/execution-control"
$validator = Join-Path $repoRoot "scripts/validate-execution-control.ps1"
$validRoot = Join-Path $fixtureRoot "valid"
$invalidRoot = Join-Path $fixtureRoot "invalid"
$caseRoot = Join-Path $fixtureRoot "cases"
$expectedValid = Join-Path $fixtureRoot "expected-valid.txt"
$expectedInvalid = Join-Path $fixtureRoot "expected-invalid.txt"
$expectedInvalidSummary = Join-Path $fixtureRoot "expected-invalid-summary.txt"
$expectedCases = Join-Path $fixtureRoot "expected/cases.tsv"
$tempBase = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } elseif ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() }
$tempRoot = Join-Path $tempBase ("promptkit-execution-control-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

function Fail-Harness {
    param([string]$Message)
    throw "HARNESS_FAILURE|$Message"
}

function Get-RepositorySnapshot {
    $rootPrefix = "$repoRoot\.git\"
    return @(
        Get-ChildItem -LiteralPath $repoRoot -File -Recurse |
            Where-Object { $_.FullName -notlike "$rootPrefix*" } |
            Sort-Object FullName |
            ForEach-Object {
                $relative = $_.FullName.Substring($repoRoot.Length).TrimStart('\', '/') -replace '\\', '/'
                "$relative|$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)"
            }
    )
}

function Get-GitStatusSnapshot {
    $status = @(& git -C $repoRoot status --porcelain=v1 --untracked-files=all 2>&1)
    if ($LASTEXITCODE -ne 0) { Fail-Harness "Unable to read Git status" }
    return @($status | ForEach-Object { $_.ToString() })
}

function Assert-SnapshotUnchanged {
    param([string[]]$BeforeFiles, [string[]]$BeforeStatus, [string]$Label)
    $afterFiles = @(Get-RepositorySnapshot)
    $afterStatus = @(Get-GitStatusSnapshot)
    if (($BeforeFiles -join "`n") -ne ($afterFiles -join "`n")) { Fail-Harness "Repository file hashes changed during $Label validation" }
    if (($BeforeStatus -join "`n") -ne ($afterStatus -join "`n")) { Fail-Harness "Git status changed during $Label validation" }
}

function Normalize-Lines {
    param([object[]]$Lines)
    return @($Lines | ForEach-Object { $_.ToString().Replace("`r", "").Replace('\', '/') })
}

function Invoke-Validator {
    param([string]$CaseName, [string]$Root)
    $capturePath = Join-Path $tempRoot "$CaseName.output.txt"
    $rawLines = @(& pwsh -NoProfile -File $validator -Root $Root -Strict 2>&1)
    $exitCode = $LASTEXITCODE
    $normalized = @(Normalize-Lines $rawLines)
    $normalized | Set-Content -LiteralPath $capturePath -Encoding utf8
    return [pscustomobject]@{ ExitCode = $exitCode; Lines = $normalized; CapturePath = $capturePath }
}

function Assert-Case {
    param([string]$Name, [string]$Root, [int]$ExpectedExit)
    $result = Invoke-Validator $Name $Root
    if ($result.ExitCode -ne $ExpectedExit) { Fail-Harness "$Name expected exit $ExpectedExit but received $($result.ExitCode)" }
    $summaries = @($result.Lines | Where-Object { $_ -match '^(VALID|FAILED)\|' })
    if ($summaries.Count -ne 1) { Fail-Harness "$Name emitted an unexpected summary count: $($summaries.Count)" }
    if ($Name -eq "valid") {
        $expectedSummary = (Get-Content -LiteralPath $expectedValid -Raw).TrimEnd("`r", "`n")
        if ($summaries[0] -ne $expectedSummary) { Fail-Harness "valid summary mismatch: $($summaries[0])" }
    } else {
        $expectedSummary = (Get-Content -LiteralPath $expectedInvalidSummary -Raw).TrimEnd("`r", "`n")
        if ($summaries[0] -ne $expectedSummary) { Fail-Harness "invalid summary mismatch: $($summaries[0])" }
        $expectedDiagnostics = @(Get-Content -LiteralPath $expectedInvalid | ForEach-Object { $_.Replace("`r", "").Replace('\', '/') } | Sort-Object)
        $actualDiagnostics = @($result.Lines | Where-Object { $_ -match '^[A-Z_]+\|' -and $_ -notmatch '^(VALID|FAILED)\|' } | Sort-Object)
        if (($expectedDiagnostics -join "`n") -ne ($actualDiagnostics -join "`n")) {
            Write-Output "Expected diagnostics:"
            $expectedDiagnostics | ForEach-Object { Write-Output $_ }
            Write-Output "Actual diagnostics:"
            $actualDiagnostics | ForEach-Object { Write-Output $_ }
            Fail-Harness "invalid diagnostic contract mismatch"
        }
    }
}

function Assert-MatrixCase {
    param([string]$Name, [string]$Root, [int]$ExpectedExit, [string]$ExpectedSummaryFile, [string]$ExpectedDiagnosticsFile)
    $result = Invoke-Validator $Name $Root
    if ($result.ExitCode -ne $ExpectedExit) { Fail-Harness "$Name expected exit $ExpectedExit but received $($result.ExitCode)" }
    $summaries = @($result.Lines | Where-Object { $_ -match '^(VALID|FAILED)\|' })
    if ($summaries.Count -ne 1) { Fail-Harness "$Name emitted an unexpected summary count: $($summaries.Count)" }
    $expectedSummary = (Get-Content -LiteralPath $ExpectedSummaryFile -Raw).TrimEnd("`r", "`n")
    if ($summaries[0] -ne $expectedSummary) { Fail-Harness "$Name summary mismatch: $($summaries[0])" }
    $expectedDiagnostics = @()
    if ((Get-Item -LiteralPath $ExpectedDiagnosticsFile).Length -gt 0) {
        $expectedDiagnostics = @(Get-Content -LiteralPath $ExpectedDiagnosticsFile | ForEach-Object { $_.Replace("`r", "").Replace('\', '/') } | Sort-Object)
    }
    $actualDiagnostics = @($result.Lines | Where-Object { $_ -match '^[A-Z_]+\|' -and $_ -notmatch '^(VALID|FAILED)\|' } | Sort-Object)
    if (($expectedDiagnostics -join "`n") -ne ($actualDiagnostics -join "`n")) {
        Write-Output "Expected diagnostics for ${Name}:"
        $expectedDiagnostics | ForEach-Object { Write-Output $_ }
        Write-Output "Actual diagnostics for ${Name}:"
        $actualDiagnostics | ForEach-Object { Write-Output $_ }
        Fail-Harness "$Name diagnostic contract mismatch"
    }
}

try {
    foreach ($required in @($validator, $validRoot, $invalidRoot, $caseRoot, $expectedValid, $expectedInvalid, $expectedInvalidSummary, $expectedCases)) {
        if (-not (Test-Path -LiteralPath $required)) { Fail-Harness "Missing harness input: $required" }
    }

    $beforeFiles = @(Get-RepositorySnapshot)
    $beforeStatus = @(Get-GitStatusSnapshot)
    Assert-Case "valid" $validRoot 0
    Assert-SnapshotUnchanged $beforeFiles $beforeStatus "valid"

    $beforeInvalidFiles = @(Get-RepositorySnapshot)
    $beforeInvalidStatus = @(Get-GitStatusSnapshot)
    Assert-Case "invalid" $invalidRoot 1
    Assert-SnapshotUnchanged $beforeInvalidFiles $beforeInvalidStatus "invalid"

    $matrixCount = 0
    foreach ($manifestLine in (Get-Content -LiteralPath $expectedCases)) {
        if ([string]::IsNullOrWhiteSpace($manifestLine) -or $manifestLine.StartsWith('#')) { continue }
        $parts = $manifestLine -split "`t", 4
        if ($parts.Count -ne 4) { Fail-Harness "Invalid matrix manifest row: $manifestLine" }
        $name = $parts[0]
        $expectedExit = [int]$parts[1]
        $casePath = Join-Path $caseRoot $name
        $summaryPath = Join-Path $fixtureRoot "expected/$($parts[2])"
        $diagnosticsPath = Join-Path $fixtureRoot "expected/$($parts[3])"
        foreach ($required in @($casePath, $summaryPath, $diagnosticsPath)) {
            if (-not (Test-Path -LiteralPath $required)) { Fail-Harness "Missing matrix input: $required" }
        }
        $beforeCaseFiles = @(Get-RepositorySnapshot)
        $beforeCaseStatus = @(Get-GitStatusSnapshot)
        Assert-MatrixCase $name $casePath $expectedExit $summaryPath $diagnosticsPath
        Assert-SnapshotUnchanged $beforeCaseFiles $beforeCaseStatus $name
        $matrixCount++
    }

    $provider = if ($env:GITHUB_ACTIONS) { $env:GITHUB_ACTIONS } else { "local" }
    $workflow = if ($env:GITHUB_WORKFLOW) { $env:GITHUB_WORKFLOW } else { "local" }
    $job = if ($env:GITHUB_JOB) { $env:GITHUB_JOB } else { "local" }
    $run = if ($env:GITHUB_RUN_ID) { $env:GITHUB_RUN_ID } else { "local" }
    $revision = if ($env:GITHUB_SHA) { $env:GITHUB_SHA } else { "local" }
    $timestamp = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")
    Write-Output "Execution-control PowerShell matrix cases passed: $matrixCount isolated contracts."
    Write-Output "CI evidence: provider=$provider workflow=$workflow job=$job run=$run revision=$revision timestamp=$timestamp"
    Write-Output "Execution-control validation is durable evidence only; it cannot observe live chat duration or approve external actions."
    Write-Output "Execution-control PowerShell fixture harness passed: regression and isolated matrix contracts are stable and read-only."
} finally {
    if (Test-Path -LiteralPath $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}
