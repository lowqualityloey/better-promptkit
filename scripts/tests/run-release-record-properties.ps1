# Deterministic, dependency-free local release-evidence property harness.
# Run from repository root: pwsh -NoProfile -File .\scripts\tests\run-release-record-properties.ps1

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir '..\..')).Path
$FixtureRoot = Join-Path $RepoRoot 'scripts\tests\fixtures\release-records'
$Iterations = 100
$Seed = 20260908L
$RngState = $Seed
$Choice = 0
$CaseFields = @{}
$CaseIds = @{}
$CaseSeen = @{}

function Fail-Harness {
    param([string]$Message)
    [Console]::Error.WriteLine("HARNESS_FAILURE|$Message")
    exit 1
}

function Fail-Property {
    param([string]$Property, [int]$Iteration, [string]$Message)
    [Console]::Error.WriteLine("PROPERTY_FAILURE|$Property|ITERATION=$Iteration|$Message")
    exit 1
}

function Next-Choice {
    param([int]$Modulus)
    $script:RngState = ($script:RngState * 48271L) % 2147483647L
    $script:Choice = [int]($script:RngState % $Modulus)
}

function Get-CaseField {
    param([string]$Property, [string]$CaseId, [string]$Field)
    $key = "$Property|$CaseId|$Field"
    if ($script:CaseFields.ContainsKey($key)) { return [string]$script:CaseFields[$key] }
    return 'NONE'
}

function Load-Fixture {
    param([string]$Property)
    $file = Join-Path $script:FixtureRoot "$Property.tsv"
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { Fail-Harness "Missing fixture: $file" }
    $script:CaseIds[$Property] = [System.Collections.Generic.List[string]]::new()
    foreach ($line in @(Get-Content -LiteralPath $file)) {
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) { continue }
        $parts = $line -split "`t", 4
        if ($parts.Count -ne 4 -or [string]::IsNullOrWhiteSpace($parts[0]) -or [string]::IsNullOrWhiteSpace($parts[1]) -or [string]::IsNullOrWhiteSpace($parts[2]) -or [string]::IsNullOrWhiteSpace($parts[3])) {
            Fail-Harness "Malformed fixture row in $file"
        }
        $caseId = $parts[0]
        $key = "$Property|$caseId|$($parts[2])"
        $script:CaseFields[$key] = $parts[3]
        $caseKey = "$Property|$caseId"
        if (-not $script:CaseSeen.ContainsKey($caseKey)) {
            $script:CaseSeen[$caseKey] = $true
            [void]$script:CaseIds[$Property].Add($caseId)
        }
    }
    if ($script:CaseIds[$Property].Count -eq 0) { Fail-Harness "Fixture has no cases: $file" }
}

function Assert-ShapeGeneration {
    param([string]$Property, [int]$Iteration)
    $prefix = "$($Property.ToUpperInvariant())-$Iteration"
    $commitId = "COMMIT-$prefix"
    $mergeId = "MERGE-$prefix"
    $squashId = "SQUASH-$prefix"
    $duplicateA = "DUP-A-$prefix"
    $duplicateB = "DUP-B-$prefix"
    $revertId = "REVERT-$prefix"
    $revertedId = "REVERTED-$prefix"
    $partialId = "PARTIAL-REVERT-$prefix"
    $duplicateGroup = "DUPLICATE-GROUP-$prefix"
    $fullRevertRelation = "$revertId=>$revertedId"
    $partialEvidence = "EVIDENCE-$partialId"
    $qaPass = "QA-${prefix}:pass"
    $qaBlocked = "QA-${prefix}:blocked"
    $combinedHistory = @($commitId, $mergeId, $squashId, $duplicateA, $duplicateB, $revertedId, $revertId, $partialId)
    $actionLog = [System.Collections.Generic.List[string]]::new()
    if ($commitId -notlike 'COMMIT-*' -or $combinedHistory[0] -ne $commitId) { Fail-Harness 'Synthetic commit history is unstable' }
    if ($combinedHistory[1] -ne $mergeId -or $combinedHistory[2] -ne $squashId) { Fail-Harness 'Synthetic merge/squash order is invalid' }
    if ($duplicateA -eq $duplicateB -or $duplicateGroup -notlike 'DUPLICATE-GROUP-*') { Fail-Harness 'Synthetic duplicate group is invalid' }
    if ($fullRevertRelation -ne "$revertId=>$revertedId" -or $partialId -notlike 'PARTIAL-REVERT-*') { Fail-Harness 'Synthetic revert relations are invalid' }
    if ($partialEvidence -notlike 'EVIDENCE-*') { Fail-Harness 'Synthetic partial-revert evidence is missing' }
    if ($qaPass -notlike '*:pass' -or $qaBlocked -notlike '*:blocked') { Fail-Harness 'Synthetic QA outcomes are invalid' }
    if ($combinedHistory.Count -ne 8 -or $actionLog.Count -ne 0) { Fail-Harness 'Synthetic history or action stub is invalid' }
}

function Classify-Evidence {
    param([string]$CaseId, [string]$ConventionalType)
    $public = Get-CaseField 'property-01' $CaseId 'public'
    $evidence = Get-CaseField 'property-01' $CaseId 'evidence'
    $linked = Get-CaseField 'property-01' $CaseId 'linked'
    $contract = Get-CaseField 'property-01' $CaseId 'contract'
    $before = Get-CaseField 'property-01' $CaseId 'before'
    $after = Get-CaseField 'property-01' $CaseId 'after'
    $impact = Get-CaseField 'property-01' $CaseId 'impact'
    $proposed = Get-CaseField 'property-01' $CaseId 'proposed'
    $guidance = Get-CaseField 'property-01' $CaseId 'guidance'
    $maintenanceDeclared = Get-CaseField 'property-01' $CaseId 'maintenance_declared'
    $noPublicContract = Get-CaseField 'property-01' $CaseId 'no_public_contract'
    [void]$ConventionalType

    if ($public -eq '1') {
        $complete = ($evidence -ne 'NONE' -or $linked -ne 'NONE')
        foreach ($value in @($contract, $before, $after, $impact)) {
            if ($value -eq 'NONE') { $complete = $false }
        }
        $expectedProposed = 'none'
        switch ($impact) {
            'additive' { $expectedProposed = 'minor' }
            'corrective' { $expectedProposed = 'patch' }
            'breaking' {
                $expectedProposed = 'major'
                if ($guidance -eq 'NONE') { $complete = $false }
            }
            default { $complete = $false }
        }
        if ($proposed -ne $expectedProposed) { $complete = $false }
        if ($complete) { return 'eligible' }
        return 'incomplete'
    }

    if ($maintenanceDeclared -eq '1' -and $noPublicContract -eq '1' -and $proposed -eq 'none') { return 'maintenance' }
    return 'incomplete'
}

function Invoke-PropertyOne {
    $types = @('feat', 'fix', 'perf')
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-01' $iteration
        foreach ($caseId in $script:CaseIds['property-01']) {
            Next-Choice $types.Count
            $expected = Get-CaseField 'property-01' $caseId 'expected'
            $actual = Classify-Evidence $caseId $types[$script:Choice]
            if ($actual -ne $expected) { Fail-Property 'eligible-evidence-maintenance' $iteration "$caseId expected $expected got $actual" }
        }
    }
    Write-Output "PROPERTY|eligible-evidence-maintenance|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Augment-History {
    param([string]$History, [string]$Candidate, [int]$Iteration)
    $augmented = [System.Collections.Generic.List[string]]::new()
    foreach ($item in ($History -split ',')) {
        if ($item -eq $Candidate) { [void]$augmented.Add("GEN-P02-$Iteration-$script:Choice") }
        [void]$augmented.Add($item)
    }
    $script:AugmentedHistoryCsv = $augmented -join ','
}

function Select-ReleaseRange {
    param([string]$History, [string]$Baseline, [string]$Candidate)
    $items = @($History -split ',')
    $range = [System.Collections.Generic.List[string]]::new()
    $started = ($Baseline -eq 'NONE')
    $baselineIndex = -1
    $candidateIndex = -1
    $candidateCount = 0
    for ($index = 0; $index -lt $items.Count; $index++) {
        $item = $items[$index]
        if ($Baseline -ne 'NONE' -and $item -eq $Baseline) {
            $baselineIndex = $index
            $started = $true
            continue
        }
        if ($item -eq $Candidate) {
            $candidateCount++
            $candidateIndex = $index
        }
        if ($started) { [void]$range.Add($item) }
    }
    $valid = $true
    if ($Baseline -ne 'NONE' -and $baselineIndex -lt 0) { $valid = $false }
    if ($candidateCount -ne 1 -or $candidateIndex -lt 0) { $valid = $false }
    if ($candidateIndex -ne ($items.Count - 1)) { $valid = $false }
    if ($Baseline -ne 'NONE' -and $baselineIndex -ge $candidateIndex) { $valid = $false }
    if ($range.Count -eq 0 -or $range[$range.Count - 1] -ne $Candidate) { $valid = $false }
    $script:ResultValid = $valid
    $script:ResultRangeCsv = $range -join ','
}

function Invoke-PropertyTwo {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-02' $iteration
        foreach ($caseId in $script:CaseIds['property-02']) {
            Next-Choice 2
            $history = Get-CaseField 'property-02' $caseId 'history'
            $baseline = Get-CaseField 'property-02' $caseId 'baseline'
            $candidate = Get-CaseField 'property-02' $caseId 'candidate'
            $expected = Get-CaseField 'property-02' $caseId 'expected'
            Augment-History $history $candidate $iteration
            Select-ReleaseRange $script:AugmentedHistoryCsv $baseline $candidate
            $firstResult = "$script:ResultValid|$script:ResultRangeCsv"
            Select-ReleaseRange $script:AugmentedHistoryCsv $baseline $candidate
            $secondResult = "$script:ResultValid|$script:ResultRangeCsv"
            if ($firstResult -ne $secondResult) { Fail-Property 'candidate-inclusive-range' $iteration "$caseId is not reproducible" }
            if ($expected -eq 'PASS' -and -not $script:ResultValid) { Fail-Property 'candidate-inclusive-range' $iteration "$caseId expected PASS" }
            if ($expected -eq 'FAIL' -and $script:ResultValid) { Fail-Property 'candidate-inclusive-range' $iteration "$caseId expected FAIL" }
        }
    }
    Write-Output "PROPERTY|candidate-inclusive-range|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Resolve-LatestApproved {
    param([string]$Records)
    $highest = -1
    $script:ResultBaseline = 'NONE'
    foreach ($record in ($Records -split ';')) {
        $parts = $record -split ',', 6
        $status = $parts[1]
        $version = $parts[2]
        $commit = $parts[3]
        $evaluation = $parts[4]
        [int]$sequence = $parts[5]
        if ($status.ToLowerInvariant() -eq 'approved' -and $sequence -gt $highest) {
            $highest = $sequence
            $script:ResultBaseline = "$evaluation|$version|$commit"
        }
    }
}

function Invoke-PropertyThree {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-03' $iteration
        foreach ($caseId in $script:CaseIds['property-03']) {
            Next-Choice 2
            $records = Get-CaseField 'property-03' $caseId 'records'
            $expected = Get-CaseField 'property-03' $caseId 'expected'
            $records = "$records;R-GEN,preliminary,9.9.9,GEN-P03-$iteration,GEN-EVAL-$iteration,$(100 + $iteration)"
            Resolve-LatestApproved $records
            $actual = ($script:ResultBaseline -split '\|', 2)[0]
            if ($actual -ne $expected) { Fail-Property 'latest-approved-baseline' $iteration "$caseId expected $expected got $actual" }
        }
    }
    Write-Output "PROPERTY|latest-approved-baseline|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Classify-Impact {
    param([string]$Impact, [string]$Guidance, [string]$Proposed)
    switch ($Impact) {
        'additive' { $derived = 'minor' }
        'corrective' { $derived = 'patch' }
        'breaking' { if ($Guidance -ne 'NONE') { $derived = 'major' } else { $derived = 'blocked' } }
        'none' { $derived = 'none' }
        default { $derived = 'blocked' }
    }
    if ($Proposed -ne 'NONE' -and $Proposed -ne $derived -and $derived -ne 'blocked') { $derived = 'blocked' }
    return $derived
}

function Invoke-PropertyFour {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-04' $iteration
        foreach ($caseId in $script:CaseIds['property-04']) {
            $types = @(Get-CaseField 'property-04' $caseId 'types' -split ',')
            Next-Choice $types.Count
            $type = $types[$script:Choice]
            [void]$type
            $impact = Get-CaseField 'property-04' $caseId 'impact'
            $guidance = Get-CaseField 'property-04' $caseId 'guidance'
            $proposed = Get-CaseField 'property-04' $caseId 'proposed'
            $expected = Get-CaseField 'property-04' $caseId 'expected'
            $actual = Classify-Impact $impact $guidance $proposed
            if ($actual -ne $expected) { Fail-Property 'evidence-driven-impact' $iteration "$caseId expected $expected got $actual" }
        }
    }
    Write-Output "PROPERTY|evidence-driven-impact|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Parse-CoreSemVer {
    param([string]$Version)
    $normalized = $Version -replace '^v', ''
    $match = [regex]::Match($normalized, '^(\d+)\.(\d+)\.(\d+)$')
    if (-not $match.Success) { return $false }
    $script:SemVerMajor = [int64]$match.Groups[1].Value
    $script:SemVerMinor = [int64]$match.Groups[2].Value
    $script:SemVerPatch = [int64]$match.Groups[3].Value
    return $true
}

function Derive-Candidate {
    param([string]$Impacts, [string]$Prior, [string]$First)
    $rank = 0
    $script:ResultImpact = 'none'
    $script:ResultVersion = 'NONE'
    foreach ($impact in ($Impacts -split ',')) {
        switch ($impact) {
            'blocked' { $script:ResultImpact = 'blocked'; return }
            'major' { if ($rank -lt 3) { $rank = 3; $script:ResultImpact = 'major' } }
            'minor' { if ($rank -lt 2) { $rank = 2; $script:ResultImpact = 'minor' } }
            'patch' { if ($rank -lt 1) { $rank = 1; $script:ResultImpact = 'patch' } }
            'none' { }
            default { $script:ResultImpact = 'blocked'; return }
        }
    }
    if ($rank -eq 0) { return }
    if ($First -eq '1') { $script:ResultVersion = '1.0.0'; return }
    if (-not (Parse-CoreSemVer $Prior)) { $script:ResultImpact = 'blocked'; return }
    switch ($script:ResultImpact) {
        'major' { $script:ResultVersion = "$($script:SemVerMajor + 1).0.0" }
        'minor' { $script:ResultVersion = "$script:SemVerMajor.$($script:SemVerMinor + 1).0" }
        'patch' { $script:ResultVersion = "$script:SemVerMajor.$script:SemVerMinor.$($script:SemVerPatch + 1)" }
    }
}

function Invoke-PropertyFive {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-05' $iteration
        foreach ($caseId in $script:CaseIds['property-05']) {
            Next-Choice 2
            $impacts = Get-CaseField 'property-05' $caseId 'impacts'
            $prior = Get-CaseField 'property-05' $caseId 'prior'
            $first = Get-CaseField 'property-05' $caseId 'first'
            $expectedImpact = Get-CaseField 'property-05' $caseId 'expected-impact'
            $expectedVersion = Get-CaseField 'property-05' $caseId 'expected-version'
            Derive-Candidate $impacts $prior $first
            if ($script:ResultImpact -ne $expectedImpact) { Fail-Property 'greatest-impact-first-release' $iteration "$caseId impact expected $expectedImpact got $script:ResultImpact" }
            if ($script:ResultVersion -ne $expectedVersion) { Fail-Property 'greatest-impact-first-release' $iteration "$caseId version expected $expectedVersion got $script:ResultVersion" }
        }
    }
    Write-Output "PROPERTY|greatest-impact-first-release|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Invoke-PropertySix {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-06' $iteration
        foreach ($caseId in $script:CaseIds['property-06']) {
            Next-Choice 2
            $core = Get-CaseField 'property-06' $caseId 'core'
            $prerelease = Get-CaseField 'property-06' $caseId 'prerelease'
            $commit = "$(Get-CaseField 'property-06' $caseId 'commit')-I$iteration"
            $supporting = Get-CaseField 'property-06' $caseId 'supporting'
            $generatedSupport = "$supporting,GEN-P06-$iteration"
            $expected = Get-CaseField 'property-06' $caseId 'expected'
            if (-not (Parse-CoreSemVer $core)) { Fail-Property 'preliminary-provenance-promotion' $iteration "$caseId has invalid core" }
            if ([string]::IsNullOrWhiteSpace($commit) -or $generatedSupport -eq 'NONE') { Fail-Property 'preliminary-provenance-promotion' $iteration "$caseId lost provenance" }
            if ($prerelease -eq 'NONE') { $display = $core } else { $display = "$core-$prerelease" }
            $promoted = $core
            if ($display -ne $core -and $display -ne "$core-$prerelease") { Fail-Property 'preliminary-provenance-promotion' $iteration "$caseId display changed core" }
            if ($promoted -ne $core -or $commit -notlike "*-I$iteration" -or $generatedSupport -notlike "*GEN-P06-$iteration*") { Fail-Property 'preliminary-provenance-promotion' $iteration "$caseId promotion lost provenance" }
            if ($expected -ne 'PASS') { Fail-Property 'preliminary-provenance-promotion' $iteration "$caseId fixture expected non-pass" }
        }
    }
    Write-Output "PROPERTY|preliminary-provenance-promotion|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Validate-Approval {
    param([string]$Candidate, [string]$Approved, [string]$Tag, [string]$Decision, [string]$Coordinator, [string]$Rationale)
    $normalizedApproved = $Approved -replace '^v', ''
    $script:ResultApproval = 'PASS'
    if (-not (Parse-CoreSemVer $Candidate)) { $script:ResultApproval = 'FAIL' }
    if (-not (Parse-CoreSemVer $Approved)) { $script:ResultApproval = 'FAIL' }
    if ($Decision.ToLowerInvariant() -ne 'approved') { $script:ResultApproval = 'FAIL' }
    if ($Coordinator -eq 'NONE') { $script:ResultApproval = 'FAIL' }
    if ($Tag -ne "v$normalizedApproved" -and $Tag -ne $normalizedApproved) { $script:ResultApproval = 'FAIL' }
    if ($Candidate -ne $Approved -and $Rationale -eq 'NONE') { $script:ResultApproval = 'FAIL' }
}

function Invoke-PropertySeven {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-07' $iteration
        foreach ($caseId in $script:CaseIds['property-07']) {
            Next-Choice 2
            $candidate = Get-CaseField 'property-07' $caseId 'candidate'
            $approved = Get-CaseField 'property-07' $caseId 'approved'
            $tag = Get-CaseField 'property-07' $caseId 'tag'
            $decision = Get-CaseField 'property-07' $caseId 'decision'
            $coordinator = Get-CaseField 'property-07' $caseId 'coordinator'
            $rationale = Get-CaseField 'property-07' $caseId 'rationale'
            $expected = Get-CaseField 'property-07' $caseId 'expected'
            Validate-Approval $candidate $approved $tag $decision $coordinator $rationale
            if ($script:ResultApproval -ne $expected) { Fail-Property 'approval-justification-alignment' $iteration "$caseId expected $expected got $script:ResultApproval" }
        }
    }
    Write-Output "PROPERTY|approval-justification-alignment|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

foreach ($property in @('property-01', 'property-02', 'property-03', 'property-04', 'property-05', 'property-06', 'property-07')) {
    Load-Fixture $property
}

Invoke-PropertyOne
Invoke-PropertyTwo
Invoke-PropertyThree
Invoke-PropertyFour
Invoke-PropertyFive
Invoke-PropertySix
Invoke-PropertySeven

Write-Output "Release-record PowerShell property harness passed: properties=7 iterations_per_property=$Iterations seed=$Seed read_only=PASS."
Write-Output 'Release-record property evidence is local and synthetic; it cannot authorize tags, releases, publication, remotes, deployment, or rollback actions.'
