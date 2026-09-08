# Deterministic, dependency-free local release-evidence property harness.
# Run from repository root: pwsh -NoProfile -File .\scripts\tests\run-release-record-properties.ps1

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir '..\..')).Path
$FixtureRoot = Join-Path $RepoRoot 'scripts\tests\fixtures\release-records'
$Iterations = if ($env:PROMPTKIT_PROPERTY_ITERATIONS) { [int]$env:PROMPTKIT_PROPERTY_ITERATIONS } else { 100 }
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

function Array-Contains {
    param([string]$Needle, [object[]]$Values)
    return ($Values -contains $Needle)
}

function Array-CsvOrNone {
    param([object[]]$Values)
    if ($null -eq $Values -or $Values.Count -eq 0) { return 'NONE' }
    return ($Values -join ',')
}

function Array-PlusOrNone {
    param([object[]]$Values)
    if ($null -eq $Values -or $Values.Count -eq 0) { return 'NONE' }
    return ($Values -join '+')
}

function Get-ItemField {
    param([string]$Property, [string]$CaseId, [string]$ItemId, [string]$Field)
    return Get-CaseField $Property $CaseId "item.$ItemId.$Field"
}

function Encode-EffectiveItem {
    param([string]$Property, [string]$CaseId, [string]$ItemId)
    $shape = Get-ItemField $Property $CaseId $ItemId 'shape'
    $kind = Get-ItemField $Property $CaseId $ItemId 'kind'
    $impact = Get-ItemField $Property $CaseId $ItemId 'impact'
    $contract = Get-ItemField $Property $CaseId $ItemId 'contract'
    $before = Get-ItemField $Property $CaseId $ItemId 'before'
    $after = Get-ItemField $Property $CaseId $ItemId 'after'
    $guidance = Get-ItemField $Property $CaseId $ItemId 'guidance'
    $evidence = Get-ItemField $Property $CaseId $ItemId 'evidence'
    return "$ItemId~$shape~$kind~$impact~$contract~$before~$after~$guidance~$evidence"
}

function Normalize-History {
    param([string]$Property, [string]$CaseId, [string]$History)
    $ordered = @($History -split ',')
    $script:NormalizedItems = [System.Collections.Generic.List[string]]::new()
    $script:NormalizedIds = [System.Collections.Generic.List[string]]::new()
    $script:FullRevertRemoved = [System.Collections.Generic.List[string]]::new()
    $script:DuplicateRepresentatives = [System.Collections.Generic.List[string]]::new()
    $script:PartialRevertSources = [System.Collections.Generic.List[string]]::new()
    $script:MergeCount = 0
    $script:SquashCount = 0
    foreach ($id in $ordered) {
        $shape = Get-ItemField $Property $CaseId $id 'shape'
        if ($shape -eq 'full-revert') {
            $target = Get-ItemField $Property $CaseId $id 'target'
            if ($target -ne 'NONE') { [void]$script:FullRevertRemoved.Add($target) }
            [void]$script:FullRevertRemoved.Add($id)
        }
    }
    foreach ($id in $ordered) {
        $shape = Get-ItemField $Property $CaseId $id 'shape'
        if ($shape -eq 'merge') { $script:MergeCount++; continue }
        if ($script:FullRevertRemoved -contains $id) { continue }
        if ($shape -eq 'duplicate') {
            $representative = Get-ItemField $Property $CaseId $id 'representative'
            if ($representative -ne 'NONE' -and $representative -ne $id) { continue }
            [void]$script:DuplicateRepresentatives.Add($id)
        }
        if ($shape -eq 'squash') { $script:SquashCount++ }
        if ($shape -eq 'partial-revert') { [void]$script:PartialRevertSources.Add($id) }
        if ((Get-ItemField $Property $CaseId $id 'kind') -eq 'excluded') { continue }
        [void]$script:NormalizedItems.Add((Encode-EffectiveItem $Property $CaseId $id))
        [void]$script:NormalizedIds.Add($id)
    }
    $script:NormalizedSerialized = $script:NormalizedItems -join ','
    $script:NormalizedIdsCsv = Array-CsvOrNone $script:NormalizedIds.ToArray()
    $script:FullRevertRemovedCsv = Array-PlusOrNone $script:FullRevertRemoved.ToArray()
    $script:DuplicateRepresentativesCsv = Array-CsvOrNone $script:DuplicateRepresentatives.ToArray()
    $script:PartialRevertSourcesCsv = Array-CsvOrNone $script:PartialRevertSources.ToArray()
}

function Build-NotesInput {
    param([string]$Property, [string]$CaseId, [string]$Effective)
    $script:NoteBuildItems = [System.Collections.Generic.List[string]]::new()
    foreach ($id in @($Effective -split ',')) {
        if ($id -eq 'NONE') { continue }
        [void]$script:NoteBuildItems.Add((Encode-EffectiveItem $Property $CaseId $id))
    }
    $script:NotesInputSerialized = $script:NoteBuildItems -join ','
}

function Get-EffectiveImpacts {
    param([string]$Property, [string]$CaseId, [string]$Effective)
    $impacts = [System.Collections.Generic.List[string]]::new()
    foreach ($id in @($Effective -split ',')) {
        if ($id -eq 'NONE') { continue }
        $impact = Get-CaseField $Property $CaseId "item.$id.impact"
        if ([string]::IsNullOrWhiteSpace($impact) -or $impact -ceq 'NONE') { Fail-Harness "$Property/$CaseId effective item $id has no impact projection" }
        [void]$impacts.Add($impact)
    }
    if ($impacts.Count -eq 0) { return 'none' }
    return $impacts -join ','
}

function Derive-Candidate-From-Effective {
    param([string]$Snapshot)
    $rank = 0
    $script:CandidateInputSnapshot = $Snapshot
    $script:CandidateSources = [System.Collections.Generic.List[string]]::new()
    $script:CandidateImpact = 'none'
    foreach ($record in @($Snapshot -split ',')) {
        $parts = $record -split '~', 9
        $id = $parts[0]; $kind = $parts[2]; $impact = $parts[3]
        switch ($impact) {
            'major' { if ($rank -lt 3) { $rank = 3; $script:CandidateImpact = 'major' } }
            'minor' { if ($rank -lt 2) { $rank = 2; $script:CandidateImpact = 'minor' } }
            'patch' { if ($rank -lt 1) { $rank = 1; $script:CandidateImpact = 'patch' } }
            'blocked' { $script:CandidateImpact = 'blocked'; [void]$script:CandidateSources.Add($id); return }
            'none' { }
        }
        if ($impact -ne 'none' -and $kind -ne 'excluded') { [void]$script:CandidateSources.Add($id) }
    }
    $script:CandidateSourcesCsv = Array-CsvOrNone $script:CandidateSources.ToArray()
}

function Derive-Notes-From-Effective {
    param([string]$Snapshot, [string]$MaintenancePolicy)
    $script:NoteInputSnapshot = $Snapshot
    $script:NotePublicIds = [System.Collections.Generic.List[string]]::new()
    $script:NotePublicSourceIds = [System.Collections.Generic.List[string]]::new()
    $script:NoteMaintenanceIds = [System.Collections.Generic.List[string]]::new()
    $script:NoteMaintenanceSourceIds = [System.Collections.Generic.List[string]]::new()
    $script:NoteChangelogIds = [System.Collections.Generic.List[string]]::new()
    $script:NotesResult = 'PASS'
    foreach ($record in @($Snapshot -split ',')) {
        $parts = $record -split '~', 9
        $id = $parts[0]; $kind = $parts[2]; $impact = $parts[3]; $guidance = $parts[7]
        if ($kind -eq 'excluded' -or ($impact -eq 'none' -and $kind -ne 'maintenance')) { continue }
        if ($impact -eq 'major' -and $guidance -eq 'NONE') { $script:NotesResult = 'FAIL'; continue }
        $noteId = "NOTE-$id"
        if (($script:NotePublicIds -contains $noteId) -or ($script:NoteMaintenanceIds -contains $noteId)) { $script:NotesResult = 'FAIL'; continue }
        if ($kind -eq 'maintenance') {
            if ($MaintenancePolicy -eq 'include') { [void]$script:NoteMaintenanceIds.Add($noteId); [void]$script:NoteMaintenanceSourceIds.Add($id) }
        }
        else {
            [void]$script:NotePublicIds.Add($noteId)
            [void]$script:NotePublicSourceIds.Add($id)
        }
        if ($kind -ne 'maintenance' -or $MaintenancePolicy -eq 'include') { [void]$script:NoteChangelogIds.Add("DRAFT-$noteId") }
    }
    $script:NotePublicIdsCsv = Array-CsvOrNone $script:NotePublicIds.ToArray()
    $script:NotePublicSourceIdsCsv = Array-CsvOrNone $script:NotePublicSourceIds.ToArray()
    $script:NoteMaintenanceIdsCsv = Array-CsvOrNone $script:NoteMaintenanceIds.ToArray()
    $script:NoteChangelogIdsCsv = Array-CsvOrNone $script:NoteChangelogIds.ToArray()
    $script:NotePublicCount = $script:NotePublicIds.Count
    $script:NoteMaintenanceCount = $script:NoteMaintenanceIds.Count
    $script:NoteChangelogCount = $script:NoteChangelogIds.Count
    $script:NoteChangelogState = 'Draft-unpublished'
    $script:NotePublicationDecision = 'Pending-human-decision'
}

function Invoke-PropertyEight {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-08' $iteration
        foreach ($caseId in $script:CaseIds['property-08']) {
            $history = Get-CaseField 'property-08' $caseId 'history.ordered'
            Normalize-History 'property-08' $caseId $history
            $snapshot = $script:NormalizedSerialized
            Derive-Candidate-From-Effective $snapshot
            Derive-Notes-From-Effective $snapshot 'omit'
            if ($script:CandidateInputSnapshot -ne $snapshot -or $script:NoteInputSnapshot -ne $snapshot) { Fail-Property 'history-normalization-effective-set' $iteration "$caseId consumers rebuilt the normalized set" }
            if ($script:NormalizedIdsCsv -ne (Get-CaseField 'property-08' $caseId 'expected.effective')) { Fail-Property 'history-normalization-effective-set' $iteration "$caseId effective IDs mismatch" }
            if ($script:CandidateSourcesCsv -ne (Get-CaseField 'property-08' $caseId 'expected.candidateSources')) { Fail-Property 'history-normalization-effective-set' $iteration "$caseId candidate sources mismatch" }
            if ($script:NotePublicSourceIdsCsv -ne (Get-CaseField 'property-08' $caseId 'expected.noteSources')) { Fail-Property 'history-normalization-effective-set' $iteration "$caseId note sources mismatch" }
            if ($script:MergeCount.ToString() -ne (Get-CaseField 'property-08' $caseId 'expected.mergeCount') -or $script:SquashCount.ToString() -ne (Get-CaseField 'property-08' $caseId 'expected.squashCount')) { Fail-Property 'history-normalization-effective-set' $iteration "$caseId shape counters mismatch" }
            if ($script:DuplicateRepresentativesCsv -ne (Get-CaseField 'property-08' $caseId 'expected.duplicateRepresentatives') -or $script:FullRevertRemovedCsv -ne (Get-CaseField 'property-08' $caseId 'expected.fullRevertRemoved') -or $script:PartialRevertSourcesCsv -ne (Get-CaseField 'property-08' $caseId 'expected.partialRevertSources')) { Fail-Property 'history-normalization-effective-set' $iteration "$caseId normalization decisions mismatch" }
            if ((Get-CaseField 'property-08' $caseId 'expected.result') -ne 'PASS') { Fail-Property 'history-normalization-effective-set' $iteration "$caseId fixture expected failure" }
        }
    }
    Write-Output "PROPERTY|history-normalization-effective-set|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Evaluate-EmptyRange {
    param([string]$Impacts, [string]$Decision, [string]$Rationale, [string]$Trigger, [string]$Qa, [string]$Consistency)
    $script:EmptyStatus = 'BLOCKED'; $script:EmptyCandidateImpact = 'none'; $script:EmptyResult = 'FAIL'
    foreach ($impact in @($Impacts -split ',')) {
        if ($impact -ne 'none') { $script:EmptyStatus = 'NOT_EMPTY'; $script:EmptyCandidateImpact = $impact; $script:EmptyResult = 'PASS'; return }
    }
    switch ($Decision.ToLowerInvariant()) {
        'defer' { if ($Rationale -ne 'NONE' -and $Trigger -ne 'NONE') { $script:EmptyStatus = 'DEFERRED'; $script:EmptyResult = 'PASS' } }
        'approve-no-contract-change' { if ($Rationale -ne 'NONE' -and $Qa -eq 'PASS' -and $Consistency -eq 'PASS') { $script:EmptyStatus = 'APPROVED'; $script:EmptyResult = 'PASS' } }
    }
}

function Invoke-PropertyNine {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-09' $iteration
        foreach ($caseId in $script:CaseIds['property-09']) {
            $effective = Get-CaseField 'property-09' $caseId 'effective'
            $derivedImpacts = Get-EffectiveImpacts 'property-09' $caseId $effective
            $declaredImpacts = Get-CaseField 'property-09' $caseId 'impacts'
            $expectedProjection = Get-CaseField 'property-09' $caseId 'expected.projection'
            if ($expectedProjection -eq 'NONE') { $expectedProjection = 'PASS' }
            $actualProjection = if ($derivedImpacts -eq $declaredImpacts) { 'PASS' } else { 'FAIL' }
            if ($actualProjection -ne $expectedProjection) { Fail-Property 'empty-impactful-range-decision' $iteration "$caseId effective impact projection mismatch" }
            if ($actualProjection -eq 'FAIL') { continue }
            Evaluate-EmptyRange $derivedImpacts (Get-CaseField 'property-09' $caseId 'decision') (Get-CaseField 'property-09' $caseId 'decisionRationale') (Get-CaseField 'property-09' $caseId 'nextTrigger') (Get-CaseField 'property-09' $caseId 'qaResult') (Get-CaseField 'property-09' $caseId 'consistencyResult')
            if ($script:EmptyStatus -ne (Get-CaseField 'property-09' $caseId 'expected.status') -or $script:EmptyCandidateImpact -ne (Get-CaseField 'property-09' $caseId 'expected.candidateImpact') -or $script:EmptyResult -ne (Get-CaseField 'property-09' $caseId 'expected.result')) { Fail-Property 'empty-impactful-range-decision' $iteration "$caseId decision mismatch" }
        }
    }
    Write-Output "PROPERTY|empty-impactful-range-decision|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Invoke-PropertyTen {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-10' $iteration
        foreach ($caseId in $script:CaseIds['property-10']) {
            $effective = Get-CaseField 'property-10' $caseId 'effective'; $policy = Get-CaseField 'property-10' $caseId 'maintenancePolicy'
            Build-NotesInput 'property-10' $caseId $effective
            $snapshot = $script:NotesInputSerialized
            Derive-Notes-From-Effective $snapshot $policy
            if ($script:NoteInputSnapshot -ne $snapshot) { Fail-Property 'exact-once-unpublished-notes' $iteration "$caseId note derivation rebuilt its input" }
            if ($script:NotePublicIdsCsv -ne (Get-CaseField 'property-10' $caseId 'expected.publicNoteIds') -or $script:NoteMaintenanceIdsCsv -ne (Get-CaseField 'property-10' $caseId 'expected.maintenanceNoteIds') -or $script:NoteChangelogIdsCsv -ne (Get-CaseField 'property-10' $caseId 'expected.changelogIds')) { Fail-Property 'exact-once-unpublished-notes' $iteration "$caseId note IDs mismatch" }
            if ($script:NotePublicCount.ToString() -ne (Get-CaseField 'property-10' $caseId 'expected.publicCount') -or $script:NoteMaintenanceCount.ToString() -ne (Get-CaseField 'property-10' $caseId 'expected.maintenanceCount') -or $script:NoteChangelogCount.ToString() -ne (Get-CaseField 'property-10' $caseId 'expected.changelogCount')) { Fail-Property 'exact-once-unpublished-notes' $iteration "$caseId note counts mismatch" }
            if ($script:NoteChangelogState -ne (Get-CaseField 'property-10' $caseId 'expected.changelogState') -or $script:NotePublicationDecision -ne (Get-CaseField 'property-10' $caseId 'expected.publicationDecision')) { Fail-Property 'exact-once-unpublished-notes' $iteration "$caseId publication boundary mismatch" }
            if ($script:NotesResult -ne (Get-CaseField 'property-10' $caseId 'expected.result')) { Fail-Property 'exact-once-unpublished-notes' $iteration "$caseId note result mismatch" }
        }
    }
    Write-Output "PROPERTY|exact-once-unpublished-notes|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Evaluate-QA-Gate {
    param([string]$Classification, [string]$NoteCoverage, [string]$Blocker, [string]$InitialDecision, [string]$Correction, [string]$Rereview, [string]$FinalBlocker, [string]$FinalDecision)
    $script:QaInitialStatus = 'PASS'; $script:QaFinalStatus = 'PASS'; $script:QaApprovalAllowed = 0; $script:QaResult = 'PASS'
    if ($Classification -ne 'PASS' -or $NoteCoverage -ne 'PASS') {
        $script:QaInitialStatus = 'BLOCKED'
        if ($Blocker -eq 'NONE' -or $InitialDecision.ToLowerInvariant() -eq 'approved') { $script:QaResult = 'FAIL' }
        if ($Correction -eq 'NONE' -or $Rereview -ne 'PASS' -or ($FinalBlocker -ne 'NONE' -and $FinalBlocker -ne 'RESOLVED') -or $FinalDecision.ToLowerInvariant() -ne 'approved') { $script:QaFinalStatus = 'BLOCKED' } else { $script:QaApprovalAllowed = 1 }
    }
    else {
        if ($Blocker -ne 'NONE' -or $InitialDecision.ToLowerInvariant() -ne 'approved') { $script:QaResult = 'FAIL' }
        if ($Rereview -ne 'PASS' -or ($FinalBlocker -ne 'NONE' -and $FinalBlocker -ne 'RESOLVED') -or $FinalDecision.ToLowerInvariant() -ne 'approved') { $script:QaFinalStatus = 'BLOCKED' } else { $script:QaApprovalAllowed = 1 }
    }
}

function Invoke-PropertyEleven {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-11' $iteration
        foreach ($caseId in $script:CaseIds['property-11']) {
            Evaluate-QA-Gate (Get-CaseField 'property-11' $caseId 'initialClassificationResult') (Get-CaseField 'property-11' $caseId 'initialNoteCoverageResult') (Get-CaseField 'property-11' $caseId 'initialBlocker') (Get-CaseField 'property-11' $caseId 'initialDecision') (Get-CaseField 'property-11' $caseId 'correction') (Get-CaseField 'property-11' $caseId 'reReviewResult') (Get-CaseField 'property-11' $caseId 'finalBlockerStatus') (Get-CaseField 'property-11' $caseId 'finalDecision')
            if ($script:QaInitialStatus -ne (Get-CaseField 'property-11' $caseId 'expected.initialStatus') -or $script:QaFinalStatus -ne (Get-CaseField 'property-11' $caseId 'expected.finalStatus') -or $script:QaApprovalAllowed.ToString() -ne (Get-CaseField 'property-11' $caseId 'expected.approvalAllowed') -or $script:QaResult -ne (Get-CaseField 'property-11' $caseId 'expected.result')) { Fail-Property 'qa-blocks-until-rereview' $iteration "$caseId QA gate mismatch" }
        }
    }
    Write-Output "PROPERTY|qa-blocks-until-rereview|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

function Record-Action-Request {
    param([string]$Request)
    $script:ConsistencyRequestedAction = $Request
    # External requests are recorded as data only; this boundary never invokes an action.
    $script:ConsistencyActionLog = 'NONE'
}

function Validate-Consistency {
    param([string]$Property, [string]$CaseId)
    $evalId = Get-CaseField $Property $CaseId 'artifact.evaluation.evaluationId'
    $linkedIds = @((Get-CaseField $Property $CaseId 'artifact.candidate.evaluationId'), (Get-CaseField $Property $CaseId 'artifact.qa.evaluationId'), (Get-CaseField $Property $CaseId 'artifact.notes.evaluationId'), (Get-CaseField $Property $CaseId 'artifact.approval.evaluationId'), (Get-CaseField $Property $CaseId 'artifact.consistency.evaluationId'))
    $script:ConsistencyResult = 'PASS'; $script:ConsistencyDiagnostic = 'NONE'; $script:ConsistencyActionLog = 'NONE'; $script:ConsistencySharedEvaluationId = $evalId; $script:ConsistencyNonRegressing = 0; $script:ConsistencyCandidateAtRangeEnd = 0
    Record-Action-Request (Get-CaseField $Property $CaseId 'artifact.actionRequest')
    if ([string]::IsNullOrWhiteSpace($evalId) -or $evalId -eq 'NONE') { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'EVALUATION_ID_MISMATCH'; return }
    foreach ($linked in $linkedIds) { if ([string]::IsNullOrWhiteSpace($linked) -or $linked -eq 'NONE' -or $linked -ne $evalId) { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'EVALUATION_ID_MISMATCH'; return } }
    $candidate = Get-CaseField $Property $CaseId 'candidateCommit'; $approvedCandidate = Get-CaseField $Property $CaseId 'approvedCandidateCommit'; $range = Get-CaseField $Property $CaseId 'orderedRange'; $occurrences = Get-CaseField $Property $CaseId 'candidateOccurrences'; $atEnd = Get-CaseField $Property $CaseId 'candidateAtEnd'
    $rangeItems = @($range -split ',')
    $actualOccurrences = @($rangeItems | Where-Object { $_ -eq $candidate }).Count
    $actualAtEnd = 0
    if ($range -ne 'NONE' -and $rangeItems.Count -gt 0 -and $rangeItems[-1] -eq $candidate) { $actualAtEnd = 1 }
    $script:ConsistencyCandidateAtRangeEnd = $actualAtEnd
    if ($candidate -eq 'NONE' -or $approvedCandidate -eq 'NONE' -or $approvedCandidate -ne $candidate -or $actualOccurrences -ne 1 -or $actualAtEnd -ne 1 -or $occurrences -ne $actualOccurrences.ToString() -or $atEnd -ne $actualAtEnd.ToString()) { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'RANGE_MEMBERSHIP'; return }
    $version = Get-CaseField $Property $CaseId 'approvedVersion'; $tag = Get-CaseField $Property $CaseId 'approvedTag'; $prior = Get-CaseField $Property $CaseId 'priorVersion'; $candidateVersion = Get-CaseField $Property $CaseId 'candidateVersion'; $rationale = Get-CaseField $Property $CaseId 'approvalRationale'; $qa = Get-CaseField $Property $CaseId 'qaResult'; $notes = Get-CaseField $Property $CaseId 'noteCoverage'
    if ($tag -ne "v$version" -and $tag -ne $version) { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'TAG_VERSION_MISMATCH'; return }
    if (-not (Parse-CoreSemVer $version)) { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'INVALID_VERSION'; return }
    $approvedMajor = $script:SemVerMajor; $approvedMinor = $script:SemVerMinor; $approvedPatch = $script:SemVerPatch
    if (-not (Parse-CoreSemVer $prior)) { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'INVALID_VERSION'; return }
    $priorMajor = $script:SemVerMajor; $priorMinor = $script:SemVerMinor; $priorPatch = $script:SemVerPatch
    if (-not (Parse-CoreSemVer $candidateVersion)) { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'INVALID_VERSION'; return }
    if ($approvedMajor -lt $priorMajor -or ($approvedMajor -eq $priorMajor -and $approvedMinor -lt $priorMinor) -or ($approvedMajor -eq $priorMajor -and $approvedMinor -eq $priorMinor -and $approvedPatch -lt $priorPatch)) { $script:ConsistencyNonRegressing = 0; $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'VERSION_PRECEDENCE'; return }
    $script:ConsistencyNonRegressing = 1
    if ($candidateVersion -ne $version -and $rationale -eq 'NONE') { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'APPROVAL_REQUIRED'; return }
    if ($qa -ne 'PASS' -or $notes -ne 'PASS') { $script:ConsistencyResult = 'FAIL'; $script:ConsistencyDiagnostic = 'QA_NOTE_LINKAGE'; return }
}

function Invoke-PropertyTwelve {
    for ($iteration = 1; $iteration -le $script:Iterations; $iteration++) {
        Assert-ShapeGeneration 'property-12' $iteration
        foreach ($caseId in $script:CaseIds['property-12']) {
            Validate-Consistency 'property-12' $caseId
            $expectedConsistency = Get-CaseField 'property-12' $caseId 'expected.consistency'; $expectedDiagnostic = Get-CaseField 'property-12' $caseId 'expected.diagnosticCategory'; $expectedCaseResult = Get-CaseField 'property-12' $caseId 'expected.result'; $expectedNonRegressing = Get-CaseField 'property-12' $caseId 'expected.nonRegressing'; $expectedSharedEvaluationId = Get-CaseField 'property-12' $caseId 'expected.sharedEvaluationId'; $expectedCandidateAtRangeEnd = Get-CaseField 'property-12' $caseId 'expected.candidateAtRangeEnd'; $expectedActionRequest = Get-CaseField 'property-12' $caseId 'artifact.actionRequest'
            if ($script:ConsistencyResult -ne $expectedConsistency -or $script:ConsistencyDiagnostic -ne $expectedDiagnostic -or $script:ConsistencyActionLog -ne (Get-CaseField 'property-12' $caseId 'expected.actionLog') -or $script:ConsistencyNonRegressing.ToString() -ne $expectedNonRegressing -or $script:ConsistencySharedEvaluationId -ne $expectedSharedEvaluationId -or $script:ConsistencyCandidateAtRangeEnd.ToString() -ne $expectedCandidateAtRangeEnd -or $script:ConsistencyRequestedAction -ne $expectedActionRequest -or $expectedCaseResult -ne 'PASS') { Fail-Property 'cross-record-read-only-consistency' $iteration "$caseId consistency mismatch" }
        }
    }
    Write-Output "PROPERTY|cross-record-read-only-consistency|SEED=$script:Seed|ITERATIONS=$script:Iterations|PASS"
}

foreach ($property in @('property-01', 'property-02', 'property-03', 'property-04', 'property-05', 'property-06', 'property-07', 'property-08', 'property-09', 'property-10', 'property-11', 'property-12')) {
    Load-Fixture $property
}

Invoke-PropertyOne
Invoke-PropertyTwo
Invoke-PropertyThree
Invoke-PropertyFour
Invoke-PropertyFive
Invoke-PropertySix
Invoke-PropertySeven
Invoke-PropertyEight
Invoke-PropertyNine
Invoke-PropertyTen
Invoke-PropertyEleven
Invoke-PropertyTwelve

Write-Output "Release-record PowerShell property harness passed: properties=12 iterations_per_property=$Iterations seed=$Seed read_only=PASS."
Write-Output 'Release-record property evidence is local and synthetic; it cannot authorize tags, releases, publication, remotes, deployment, or rollback actions.'
