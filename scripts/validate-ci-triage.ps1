# Read-only Better-PromptKit CI triage state, action, and release-handoff validator.
# Usage: .\scripts\validate-ci-triage.ps1 [-Root PATH] [-Strict]

[CmdletBinding()]
param(
    [string]$Root = ".",
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
$ErrorCount = 0
$RecordCount = 0
$Diagnostics = [System.Collections.Generic.List[string]]::new()
$SeenIds = [System.Collections.Generic.Dictionary[string,bool]]::new([System.StringComparer]::Ordinal)

function Add-Diagnostic {
    param([string]$Category, [string]$RecordId, [string]$Path, [string]$Message, [string]$Remediation)
    $safeMessage = ($Message -replace '[\r\n|]', ' ').Trim()
    $safeRemediation = ($Remediation -replace '[\r\n|]', ' ').Trim()
    [void]$Diagnostics.Add("$Category|$RecordId|$Path|$safeMessage|$safeRemediation")
    $script:ErrorCount++
}

try { $RootPath = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Root -ErrorAction Stop).Path) }
catch { Write-Output 'INPUT_ERROR|REPOSITORY|.|Repository root does not exist|Provide a valid -Root path'; exit 1 }

function Get-RelativePath { param([string]$Path); return ([System.IO.Path]::GetRelativePath($RootPath, $Path).Replace('\','/')) }
function Unwrap { param([AllowEmptyString()][string]$Value); if ($null -ceq $Value) { return '' }; $v = $Value.Trim(); if ($v.Length -ge 2 -and $v[0] -ceq [char]96 -and $v[$v.Length - 1] -ceq [char]96) { $v = $v.Substring(1, $v.Length - 2).Trim() }; return $v }
function Normalize-Label { param([string]$Label); return (($Label -replace '\s+\[[^]]+\]$','').Trim()) }
function Test-Placeholder { param([AllowEmptyString()][string]$Value); $v = (Unwrap $Value).ToLowerInvariant(); return [string]::IsNullOrWhiteSpace($v) -or $v -cmatch '^n/a(\s*[-—]\s*.*)?$' -or $v -cin @('none','not applicable','not approved') -or $v -cmatch '^pending(\s*[-—]\s*.*)?$' -or $v -cmatch '^\[.*\]$' }
function Test-Usable { param([AllowEmptyString()][string]$Value); return -not (Test-Placeholder $Value) }
function Test-PendingConfirmationMarker { param([AllowEmptyString()][string]$Value); $v = (Unwrap $Value).ToLowerInvariant(); return $v -cmatch '^n/a\s*[-—]\s*awaiting\s+confirmation$' }
function Get-Field { param([object]$Record,[string]$Label); if ($Record.Fields.ContainsKey($Label)) { return (Unwrap $Record.Fields[$Label]) }; return '' }
function Has-Field { param([object]$Record,[string]$Label); return $Record.Fields.ContainsKey($Label) }
function Require-Field { param([object]$Record,[string]$Label); if (-not (Has-Field $Record $Label)) { Add-Diagnostic 'MISSING_FIELD' $Record.Id $Record.RelativePath "Missing field: $Label" 'Add the labeled field to the CI Triage Record'; return $false }; return $true }
function Require-Usable { param([object]$Record,[string]$Label); if (-not (Require-Field $Record $Label)) { return $false }; if (-not (Test-Usable (Get-Field $Record $Label))) { Add-Diagnostic 'MISSING_FIELD' $Record.Id $Record.RelativePath "Missing usable value: $Label" 'Provide a non-placeholder value for the required field'; return $false }; return $true }
function Get-StateRank { param([string]$State); switch -CaseSensitive ($State) { evidence_requested { 0 } evidence_sufficient { 1 } classified { 2 } remediation_planned { 3 } awaiting_confirmation { 4 } local_reproduction_or_fix { 5 } verification_pending { 6 } verified { 7 } linked_to_pk_ship { 8 } blocked { -1 } default { -2 } } }
function Test-State { param([string]$State); return @('evidence_requested','evidence_sufficient','classified','remediation_planned','awaiting_confirmation','local_reproduction_or_fix','verification_pending','verified','linked_to_pk_ship','blocked') -ccontains $State }
function Test-NonBlockedTransition {
    param([string]$From,[string]$To,[int]$ActiveActionCount,[int]$Confirmed,[int]$Pending,[int]$Declined,[int]$AnyDeclined)
    if ($From -ceq 'blocked') { return $false }
    if ($To -ceq 'blocked') { return $true }
    switch -CaseSensitive ("$From|$To") {
        'evidence_requested|evidence_sufficient' { return $true }
        'evidence_sufficient|classified' { return $true }
        'classified|remediation_planned' { return $true }
        'remediation_planned|awaiting_confirmation' { return $ActiveActionCount -gt 0 }
        'remediation_planned|local_reproduction_or_fix' { return $ActiveActionCount -ceq 0 }
        'awaiting_confirmation|local_reproduction_or_fix' { return $ActiveActionCount -gt 0 -and $Pending -ceq 0 -and $Declined -ceq 0 -and $Confirmed -ceq $ActiveActionCount }
        'awaiting_confirmation|remediation_planned' { return $AnyDeclined -gt 0 -and $Pending -ceq 0 }
        'local_reproduction_or_fix|verification_pending' { return $true }
        'verification_pending|verified' { return $true }
        'verified|linked_to_pk_ship' { return $true }
        default { return $false }
    }
}
function Test-BlockedResume {
    param([string]$Previous,[string]$Target,[int]$ActiveActionCount,[int]$Confirmed,[int]$Pending,[int]$Declined,[int]$AnyDeclined)
    if ([string]::IsNullOrWhiteSpace($Previous)) { return $false }
    if ($Target -cin @('blocked','verified','linked_to_pk_ship')) { return $false }
    if ($Target -ceq $Previous -and $Previous -cnotin @('verified','linked_to_pk_ship')) { return $true }
    switch -CaseSensitive ("$Previous|$Target") {
        'evidence_sufficient|evidence_requested' { return $true }
        'classified|evidence_sufficient' { return $true }
        'remediation_planned|classified' { return $true }
        'awaiting_confirmation|remediation_planned' { return $AnyDeclined -gt 0 -and $Pending -ceq 0 }
        'local_reproduction_or_fix|remediation_planned' { return $true }
        'local_reproduction_or_fix|awaiting_confirmation' { return $true }
        'verification_pending|local_reproduction_or_fix' { return $true }
        'verified|verification_pending' { return $true }
        'linked_to_pk_ship|verification_pending' { return $true }
    }
    return (Test-NonBlockedTransition $Previous $Target $ActiveActionCount $Confirmed $Pending $Declined $AnyDeclined)
}
function Get-ReleaseFile {
    param([string]$Path)
    $fields = [System.Collections.Generic.Dictionary[string,string]]::new([System.StringComparer]::Ordinal)
    $duplicates = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($line in @(Get-Content -LiteralPath $Path)) {
        $m = [regex]::Match($line,'^- \*\*([^*]+)\*\*:\s*(.*)$')
        if (-not $m.Success) { continue }
        $label = Normalize-Label $m.Groups[1].Value; $value = $m.Groups[2].Value.Trim()
        if ($fields.ContainsKey($label)) { [void]$duplicates.Add($label) } else { $fields[$label] = $value }
    }
    return [pscustomobject]@{ Fields = $fields; Duplicates = @($duplicates) }
}
function Get-FileField { param([object]$File,[string]$Label); if ($File.Fields.ContainsKey($Label)) { return (Unwrap $File.Fields[$Label]) }; return '' }
function Test-FileAnchor {
    param([string]$Path,[string]$Id)
    $lines = @(Get-Content -LiteralPath $Path)
    $anchors = [System.Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $m = [regex]::Match($lines[$i],'^<a\s+id="([^"]+)"></a>\s*$')
        if ($m.Success) { [void]$anchors.Add([pscustomobject]@{ Id = $m.Groups[1].Value; Index = $i }) }
    }
    $structural = @($anchors | Where-Object { $_.Id -ceq $Id -and $_.Index -lt ($lines.Count - 1) -and $lines[$_.Index + 1] -cmatch '^#{1,6}\s+' })
    return $anchors.Count -ceq 1 -and $structural.Count -ceq 1
}

function Get-CiRecord {
    param([string]$Path)
    $fields = [System.Collections.Generic.Dictionary[string,string]]::new([System.StringComparer]::Ordinal); $duplicates = [System.Collections.Generic.Dictionary[string,bool]]::new([System.StringComparer]::Ordinal); $actions = [System.Collections.Generic.List[object]]::new(); $current = $null; $anchor = @()
    foreach ($line in @(Get-Content -LiteralPath $Path -ErrorAction Stop)) {
        $anchorMatch = [regex]::Match($line,'^<a\s+id="([^"]+)"></a>'); if ($anchorMatch.Success) { $anchor += $anchorMatch.Groups[1].Value; continue }
        $heading = [regex]::Match($line,'^###\s+(ACTION-\S+)\s*$'); if ($heading.Success) { $current = [pscustomobject]@{ Id = $heading.Groups[1].Value; Fields = [System.Collections.Generic.Dictionary[string,string]]::new([System.StringComparer]::Ordinal); Duplicates = [System.Collections.Generic.Dictionary[string,bool]]::new([System.StringComparer]::Ordinal) }; [void]$actions.Add($current); continue }
        if ($line -cmatch '^##\s+') { $current = $null; continue }
        $field = [regex]::Match($line,'^- \*\*([^*]+)\*\*:\s*(.*)$'); if (-not $field.Success) { continue }
        $label = Normalize-Label $field.Groups[1].Value; $value = $field.Groups[2].Value.Trim()
        $target = if ($null -cne $current) { $current.Fields } else { $fields }
        $dups = if ($null -cne $current) { $current.Duplicates } else { $duplicates }
        if ($target.ContainsKey($label)) { $dups[$label] = $true } else { $target[$label] = $value }
    }
    $id = if ($fields.ContainsKey('CI ID')) { Unwrap $fields['CI ID'] } else { 'UNKNOWN' }
    return [pscustomobject]@{ Path = $Path; RelativePath = Get-RelativePath $Path; Fields = $fields; Duplicates = $duplicates; Actions = @($actions); Anchors = @($anchor); Id = $id }
}

function Validate-ReleaseLink {
    param([object]$Record,[string]$Link)
    $m = [regex]::Match($Link,'^\[([^]]+)\]\(([^#]+)#([^)]*)\)$')
    if (-not $m.Success) { Add-Diagnostic 'INVALID_LINK' $Record.Id $Record.RelativePath 'pk:ship Release Link is not a stable relative Markdown link' 'Use [RELEASE-<release-slug>](../<release>.md#RELEASE-<release-slug>)'; return }
    $releaseId = $m.Groups[1].Value; $relative = $m.Groups[2].Value; $anchor = $m.Groups[3].Value
    if ($releaseId -cne $anchor) { Add-Diagnostic 'INVALID_LINK' $Record.Id $Record.RelativePath 'Release link label and anchor differ' 'Use the same immutable RELEASE ID in both positions' }
    if ($releaseId -cnotmatch '^RELEASE-[a-z0-9][a-z0-9-]*$') { Add-Diagnostic 'INVALID_ID' $Record.Id $Record.RelativePath "Invalid release ID in pk:ship Release Link: $releaseId" 'Use RELEASE-<release-slug>' }
    if ($relative -cnotmatch '^\.\.\/([a-z0-9][a-z0-9-]*)\.md$') { Add-Diagnostic 'INVALID_LINK' $Record.Id $Record.RelativePath 'pk:ship Release Link must target docs/releases/<release>.md' 'Use a direct ../<release-slug>.md link from docs/releases/ci-triage'; return }
    $releaseSlug = $Matches[1]
    if ($releaseId -cne "RELEASE-$releaseSlug") { Add-Diagnostic 'INVALID_LINK' $Record.Id $Record.RelativePath 'Release link ID does not match its canonical release path' "Use RELEASE-$releaseSlug for ../$releaseSlug.md" }
    $releasePath = Join-Path (Join-Path $RootPath 'docs/releases') "$releaseSlug.md"
    if (-not (Test-Path -LiteralPath $releasePath -PathType Leaf)) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath "Linked release record does not exist: $relative" 'Create the existing docs/releases/<release>.md record before linking release resumption'; return }
    $releaseFile = Get-ReleaseFile $releasePath
    foreach ($duplicate in @($releaseFile.Duplicates)) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath "Duplicate release field: $duplicate" 'Keep one canonical field label per release record' }
    if ((Get-FileField $releaseFile 'Release ID') -cne $releaseId) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release record ID does not match pk:ship Release Link' 'Preserve the immutable RELEASE ID across the link and target' }
    if (-not (Test-FileAnchor $releasePath $releaseId)) { Add-Diagnostic 'INVALID_LINK' $Record.Id $Record.RelativePath 'Release record is missing its explicit RELEASE anchor' ('Add <a id="' + $releaseId + '"></a> immediately before the record heading') }
    if ((Get-FileField $releaseFile 'Release Linkage State') -cne 'linked_to_pk_ship') { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release Linkage State must be linked_to_pk_ship before resumption' 'Link only after successful CI verification' }

    $ciLink = Get-FileField $releaseFile 'CI Triage Link'
    $ciMatch = [regex]::Match($ciLink,'^\[([^]]+)\]\(ci-triage/([^)#]+\.md)#([^)]*)\)$')
    if (-not $ciMatch.Success) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release CI Triage Link is not the canonical stable CI link' 'Use [CI-<provider>-<run-id>](ci-triage/<ci-id>.md#<ci-id>)' }
    else {
        $ciLabel = $ciMatch.Groups[1].Value; $ciRelpath = 'ci-triage/' + $ciMatch.Groups[2].Value; $ciAnchor = $ciMatch.Groups[3].Value
        if ($ciLabel -cne $Record.Id -or $ciRelpath -cne "ci-triage/$($Record.Id).md" -or $ciAnchor -cne $Record.Id) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release CI Triage Link does not identify this CI record' 'Use the exact CI ID, canonical ci-triage path, and matching anchor' }
        else {
            $ciTarget = Join-Path (Join-Path $RootPath 'docs/releases/ci-triage') "$($Record.Id).md"
            if (-not (Test-Path -LiteralPath $ciTarget -PathType Leaf) -or -not (Test-FileAnchor $ciTarget $Record.Id)) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release CI Triage Link target or anchor does not exist' 'Link the existing canonical CI Triage Record' }
        }
    }

    $verification = Get-FileField $releaseFile 'Verification Link'
    $verificationMatch = [regex]::Match($verification,'^\[([^]]+)\]\(([^#]+)#([^)]*)\)$')
    if (-not $verificationMatch.Success) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release Verification Link is not a stable existing Markdown link' 'Use a relative Markdown link whose target and anchor exist' }
    else {
        $verificationLabel = $verificationMatch.Groups[1].Value; $verificationRelative = $verificationMatch.Groups[2].Value; $verificationAnchor = $verificationMatch.Groups[3].Value
        if ($verificationLabel -cne $verificationAnchor -or $verificationRelative.StartsWith('/') -or $verificationRelative -cmatch '(^|[\\/])\.\.([\\/]|$)' -or $verificationRelative -cmatch '://') { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release Verification Link is not a stable existing Markdown link' 'Use a relative Markdown link whose target and anchor exist' }
        else {
            $verificationPath = Join-Path (Join-Path $RootPath 'docs/releases') $verificationRelative
            if (-not (Test-Path -LiteralPath $verificationPath -PathType Leaf) -or -not (Test-FileAnchor $verificationPath $verificationAnchor)) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release Verification Link target or anchor does not exist' 'Link the recorded verification evidence' }
        }
    }
    $verifiedResult = (Get-FileField $releaseFile 'Verified Result').ToLowerInvariant()
    if ($verifiedResult -cnotmatch '^pass(\s|[-:])') { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release record Verified Result is not Pass' 'Record the successful verification result' }
    if (-not (Test-Usable (Get-FileField $releaseFile 'Resume Condition'))) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Release record is missing Resume Condition' 'Record the precise condition for release resumption' }
}

function Validate-CiRecord {
    param([object]$Record)
    foreach ($label in @($Record.Duplicates.Keys)) { Add-Diagnostic 'INVALID_STATE' $Record.Id $Record.RelativePath "Duplicate field: $label" 'Keep one canonical field label per record' }
    foreach ($required in @('CI ID','State','State History','Release Candidate','Remote Action Blocks')) { [void](Require-Field $Record $required) }
    foreach ($requiredUsable in @('Owner','CI Evidence','Resume Condition')) { [void](Require-Usable $Record $requiredUsable) }
    if ($Record.Id -cnotmatch '^CI-[a-z0-9][a-z0-9-]*-[A-Za-z0-9._-]+$') { Add-Diagnostic 'INVALID_ID' $Record.Id $Record.RelativePath "Invalid CI ID: $($Record.Id)" 'Use CI-<provider>-<run-id> with a lowercase provider slug' }
    if ([System.IO.Path]::GetFileNameWithoutExtension($Record.Path) -cne $Record.Id) { Add-Diagnostic 'INVALID_ID' $Record.Id $Record.RelativePath 'CI filename does not match CI ID' 'Save the record as docs/releases/ci-triage/<ci-failure-id>.md' }
    if ($Record.RelativePath -cne "docs/releases/ci-triage/$($Record.Id).md") { Add-Diagnostic 'INVALID_ID' $Record.Id $Record.RelativePath 'CI record is not at the canonical docs/releases/ci-triage path' 'Save the record directly as docs/releases/ci-triage/<ci-id>.md' }
    if ($Record.Anchors.Count -cne 1 -or $Record.Anchors[0] -cne $Record.Id) { Add-Diagnostic 'INVALID_LINK' $Record.Id $Record.RelativePath 'CI record is missing its exact immutable anchor' ('Add one <a id="' + $Record.Id + '"></a> anchor') }
    $state = Get-Field $Record 'State'; if (-not (Test-State $state)) { Add-Diagnostic 'INVALID_STATE' $Record.Id $Record.RelativePath "Unsupported CI state: $state" 'Use one state from the canonical CI triage state list' }
    $releaseCandidate = (Get-Field $Record 'Release Candidate').ToLowerInvariant(); if ($releaseCandidate -cnotin @('true','false')) { Add-Diagnostic 'INVALID_STATE' $Record.Id $Record.RelativePath 'Release Candidate must be true or false' 'Record whether this CI failure affects a release candidate' }
    $history = @((Get-Field $Record 'State History') -split '>' | ForEach-Object { Unwrap $_ } | Where-Object { $_ })
    if ($history.Count -ceq 0) { Add-Diagnostic 'INVALID_TRANSITION' $Record.Id $Record.RelativePath 'State History is empty' 'Record the complete state path from evidence_requested' }
    if ($history.Count -gt 0 -and $history[0] -cne 'evidence_requested') { Add-Diagnostic 'INVALID_TRANSITION' $Record.Id $Record.RelativePath 'State History must start at evidence_requested' 'Collect evidence before any classification or remediation' }
    if ($history.Count -gt 0 -and $history[$history.Count - 1] -cne $state) { Add-Diagnostic 'INVALID_TRANSITION' $Record.Id $Record.RelativePath 'State History final state differs from State' 'Keep State equal to the final recorded transition' }
    foreach ($item in $history) { if (-not (Test-State $item)) { Add-Diagnostic 'INVALID_STATE' $Record.Id $Record.RelativePath "State History contains unsupported state: $item" 'Use only canonical CI triage states' } }

    $pending = 0; $confirmed = 0; $declined = 0; $anyDeclined = 0; $activeActionCount = 0; $currentEpoch = 0; $maxActionEpoch = 0; $maxDeclinedEpoch = 0; $seenActionIds = [System.Collections.Generic.Dictionary[string,bool]]::new([System.StringComparer]::Ordinal)
    $actionCount = $Record.Actions.Count
    if ($actionCount -gt 0) {
        if (-not $Record.Fields.ContainsKey('Current Action Epoch')) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Missing field: Current Action Epoch' 'Record the active confirmation epoch for retained action blocks' }
        $epochText = Get-Field $Record 'Current Action Epoch'
        if ($epochText -cmatch '^[1-9][0-9]*$') { $currentEpoch = [int]$epochText } else { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Current Action Epoch must be a positive integer' 'Use the latest positive action epoch' }
    }
    foreach ($action in $Record.Actions) {
        if ($seenActionIds.ContainsKey($action.Id)) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "Duplicate action ID: $($action.Id)" 'Use one unique ACTION-<ci-id>-<nnn> heading per independent action' } else { $seenActionIds[$action.Id] = $true }
        if ($action.Id -cnotmatch "^ACTION-$([regex]::Escape($Record.Id))-[0-9]{3}$") { Add-Diagnostic 'INVALID_ID' $Record.Id $Record.RelativePath "Invalid action ID: $($action.Id)" 'Use ACTION-<ci-id>-<nnn> for each independent action' }
        foreach ($label in @($action.Duplicates.Keys)) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "Duplicate action field in $($action.Id)" 'Keep one value per action field' }
        foreach ($required in @('Action ID','Action Epoch','Action Lifecycle','Proposed Action','Confirmation State','Approver','Confirmation Timestamp','Bounded Scope','Reversal or Rollback Action','Resume Condition')) {
            if (-not $action.Fields.ContainsKey($required)) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "Missing action field: $required in $($action.Id)" 'Complete every independent action block' }
            elseif ($required -cin @('Proposed Action','Bounded Scope','Reversal or Rollback Action','Resume Condition') -and -not (Test-Usable (Unwrap $action.Fields[$required]))) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "Missing usable action field: $required in $($action.Id)" 'Provide a bounded non-placeholder value for every action field' }
        }
        $actionIdValue = if ($action.Fields.ContainsKey('Action ID')) { Unwrap $action.Fields['Action ID'] } else { '' }
        if ($actionIdValue -cne $action.Id) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "Action ID field does not match heading: $($action.Id)" 'Use the exact immutable action ID' }
        $actionEpochText = if ($action.Fields.ContainsKey('Action Epoch')) { Unwrap $action.Fields['Action Epoch'] } else { '' }
        if ($actionEpochText -cmatch '^[1-9][0-9]*$') {
            $actionEpoch = [int]$actionEpochText
            if ($actionEpoch -gt $maxActionEpoch) { $maxActionEpoch = $actionEpoch }
            if ($currentEpoch -gt 0 -and $actionEpoch -gt $currentEpoch) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) requires an Action Epoch no greater than Current Action Epoch" 'Use the current or a prior recorded action epoch' }
        } else { $actionEpoch = 0; Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) requires a positive Action Epoch" 'Record the positive confirmation epoch for this action' }
        if ($currentEpoch -gt 0 -and $actionEpoch -eq $currentEpoch) { $activeActionCount++ }
        $lifecycle = if ($action.Fields.ContainsKey('Action Lifecycle')) { (Unwrap $action.Fields['Action Lifecycle']).ToLowerInvariant() } else { '' }
        $confirmation = if ($action.Fields.ContainsKey('Confirmation State')) { (Unwrap $action.Fields['Confirmation State']).ToLowerInvariant() } else { '' }
        switch ($confirmation) {
            pending {
                if ($lifecycle -cne 'open') { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) pending state requires Action Lifecycle open" 'Keep undecided actions open' }
                if ($currentEpoch -gt 0 -and $actionEpoch -ne $currentEpoch) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) pending state cannot remain in a closed prior epoch" 'Create a new current action or record a decision' } else { $pending++ }
            }
            confirmed {
                if ($lifecycle -cne 'closed') { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) confirmed state requires Action Lifecycle closed" 'Close an action when its confirmation decision is recorded' }
                if ($actionEpoch -eq $currentEpoch) { $confirmed++ }
            }
            declined {
                if ($lifecycle -cne 'closed') { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) declined state requires Action Lifecycle closed" 'Close a declined action while preserving its audit record' }
                $anyDeclined++; if ($actionEpoch -gt $maxDeclinedEpoch) { $maxDeclinedEpoch = $actionEpoch }; if ($actionEpoch -eq $currentEpoch) { $declined++ }
            }
            default { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "Unsupported Confirmation State in $($action.Id): $confirmation" 'Use pending, confirmed, or declined' }
        }
        $approver = if ($action.Fields.ContainsKey('Approver')) { Unwrap $action.Fields['Approver'] } else { '' }
        $timestamp = if ($action.Fields.ContainsKey('Confirmation Timestamp')) { Unwrap $action.Fields['Confirmation Timestamp'] } else { '' }
        if ($confirmation -ceq 'pending') { if (-not (Test-PendingConfirmationMarker $approver)) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Pending action must keep Approver at N/A - awaiting confirmation' 'Do not imply human approval while pending' }; if (-not (Test-PendingConfirmationMarker $timestamp)) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Pending action must keep Confirmation Timestamp at N/A - awaiting confirmation' 'Do not imply a confirmation timestamp while pending' } }
        elseif (-not (Test-Usable $approver)) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) requires a real Approver" 'Record the human approver for confirmed or declined actions' }
        if ($confirmation -cne 'pending' -and -not (Test-Usable $timestamp)) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) requires a Confirmation Timestamp" 'Record the UTC confirmation timestamp' }
    }
    if ($actionCount -gt 0 -and $maxActionEpoch -ne $currentEpoch) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Current Action Epoch does not match the highest action epoch' 'Use the latest epoch represented by the action blocks' }
    foreach ($action in $Record.Actions) {
        $confirmation = if ($action.Fields.ContainsKey('Confirmation State')) { (Unwrap $action.Fields['Confirmation State']).ToLowerInvariant() } else { '' }
        $actionEpochText = if ($action.Fields.ContainsKey('Action Epoch')) { Unwrap $action.Fields['Action Epoch'] } else { '' }
        if ($actionEpochText -cmatch '^[1-9][0-9]*$' -and $maxDeclinedEpoch -gt 0 -and $confirmation -cne 'declined' -and [int]$actionEpochText -le $maxDeclinedEpoch) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath "$($action.Id) must use a new Action Epoch after a declined action" 'Close the declined epoch and create the next bounded action independently' }
    }
    $remote = (Get-Field $Record 'Remote Action Blocks').ToLowerInvariant()
    if ($actionCount -ceq 0) { if ($remote -cne 'n/a - no remote action proposed') { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Remote Action Blocks must be N/A - no remote action proposed when no action exists' 'Use one independent block for every proposed remote action' } } elseif ($remote -cnotmatch '^\d+$' -or [int]$remote -cne $actionCount) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Remote Action Blocks count does not match independent action blocks' 'Record the exact number of action blocks' }
    $planReached = $false; foreach ($item in $history) { if ((Get-StateRank $item) -ge 3) { $planReached = $true } }
    if ($actionCount -gt 0 -and -not $planReached) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Action blocks require remediation_planned or later' 'Record independent actions only after a bounded remediation plan exists' }
    if ($history -ccontains 'awaiting_confirmation' -and $activeActionCount -ceq 0) { Add-Diagnostic 'INVALID_TRANSITION' $Record.Id $Record.RelativePath 'awaiting_confirmation requires an independent action block' 'Create one action block for each proposed remote action' }
    if ($state -ceq 'awaiting_confirmation' -and $activeActionCount -gt 0 -and $pending -ceq 0) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'awaiting_confirmation requires at least one pending action' 'Keep the parent state awaiting_confirmation until every action has a decision' }
    if ($confirmed -gt 0 -and -not ($history -ccontains 'awaiting_confirmation')) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Confirmed action requires an awaiting_confirmation parent state' 'Record the action decision only after entering awaiting_confirmation' }

    $requireRank = Get-StateRank $state
    if ($state -ceq 'blocked') {
        $requireRank = -1
        for ($i = $history.Count - 2; $i -ge 0; $i--) { if ($history[$i] -cne 'blocked') { $requireRank = Get-StateRank $history[$i]; break } }
    }
    if ($requireRank -ge 1) { foreach ($label in @('Check Identity','Failed Job or Command','Failure Output','Revision Identifier','Execution Time','Configuration Context')) { [void](Require-Usable $Record $label) } } else { [void](Require-Usable $Record 'Missing Evidence'); [void](Require-Usable $Record 'Evidence Request Owner') }
    foreach ($label in @('Remediation Plan','Remediation Classification','Suspected Cause','Affected Scope','Minimal Change','Verification Command','Rollback or Reversal Action')) {
        if ($requireRank -lt 3 -and (Test-Usable (Get-Field $Record $label))) { if ($label -ceq 'Remediation Plan') { Add-Diagnostic 'REMEDIATION_REQUIRED' $Record.Id $Record.RelativePath "$label precedes classified evidence" 'Record a plan only after classification' } else { Add-Diagnostic 'EVIDENCE_REQUIRED' $Record.Id $Record.RelativePath "$label must not be recorded before evidence is sufficient" 'Keep classification and remediation empty until the evidence bundle is complete' } }
    }
    $classification = (Get-Field $Record 'Classification').ToLowerInvariant()
    if ($requireRank -ge 2) { [void](Require-Usable $Record 'Classification'); if ($classification -cnotin @('test','static analysis','build','dependency or environment','infrastructure or transient','deployment','unknown') -and $classification) { Add-Diagnostic 'CLASSIFICATION_REQUIRED' $Record.Id $Record.RelativePath "Unsupported CI classification: $classification" 'Use the canonical evidence-based classification list' } } elseif (Test-Usable (Get-Field $Record 'Classification')) { Add-Diagnostic 'CLASSIFICATION_REQUIRED' $Record.Id $Record.RelativePath 'Classification precedes evidence sufficiency' 'Do not classify before evidence_sufficient' }
    if ($requireRank -ge 3) { foreach ($label in @('Remediation Plan','Remediation Classification','Suspected Cause','Affected Scope','Minimal Change','Verification Command','Rollback or Reversal Action')) { [void](Require-Usable $Record $label) } }
    if ($requireRank -ge 7) { [void](Require-Usable $Record 'Verification Evidence'); if ((Get-Field $Record 'Verification Evidence').ToLowerInvariant() -cnotmatch '^pass(\s|[-:])') { Add-Diagnostic 'VERIFICATION_REQUIRED' $Record.Id $Record.RelativePath 'Verified state requires successful Verification Evidence' 'Record a Pass result for this CI failure' } } elseif (Test-Usable (Get-Field $Record 'Verification Evidence')) { Add-Diagnostic 'VERIFICATION_REQUIRED' $Record.Id $Record.RelativePath 'Verification Evidence is premature for the current state' 'Keep successful verification for verified or linked_to_pk_ship' }

    for ($i = 0; $i -lt $history.Count - 1; $i++) {
        $from = $history[$i]; $to = $history[$i + 1]; $valid = $false
        if ($from -ceq 'blocked') { $previous = ''; for ($j = $i - 1; $j -ge 0; $j--) { if ($history[$j] -cne 'blocked') { $previous = $history[$j]; break } }; $valid = Test-BlockedResume $previous $to $activeActionCount $confirmed $pending $declined $anyDeclined }
        else { $valid = Test-NonBlockedTransition $from $to $activeActionCount $confirmed $pending $declined $anyDeclined }
        if (-not $valid) { Add-Diagnostic 'INVALID_TRANSITION' $Record.Id $Record.RelativePath "Invalid CI transition: $from -> $to" 'Follow the evidence-first state graph and conditional action branch' }
    }
    if ($pending -gt 0 -and $state -cne 'awaiting_confirmation' -and $state -cne 'blocked') { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Pending action requires awaiting_confirmation or blocked state' 'Keep the parent record blocked until the action is decided' }
    if ($anyDeclined -gt 0) {
        [void](Require-Usable $Record 'Declined Action Outcome')
        $hasDeclinedPath = $false; for ($i = 0; $i -lt $history.Count - 1; $i++) { if (($history[$i] -ceq 'awaiting_confirmation' -and $history[$i + 1] -ceq 'remediation_planned') -or ($history[$i] -ceq 'awaiting_confirmation' -and $history[$i + 1] -ceq 'blocked')) { $hasDeclinedPath = $true } }
        if (-not $hasDeclinedPath) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Declined action requires a new remediation plan or blocked parent record' 'Close only the declined action and define the next bounded path' }
        if ($declined -gt 0 -and $state -cin @('verified','linked_to_pk_ship')) { Add-Diagnostic 'ACTION_INVALID' $Record.Id $Record.RelativePath 'Declined action cannot produce verified or linked_to_pk_ship' 'Create a new plan or remain blocked' }
    }
    if ($history -ccontains 'blocked') {
        [void](Require-Usable $Record 'Blocker'); [void](Require-Usable $Record 'Resume Target'); $target = Get-Field $Record 'Resume Target'
        if (-not (Test-State $target) -or $target -cin @('blocked','verified','linked_to_pk_ship')) { Add-Diagnostic 'BLOCKED_RESUME' $Record.Id $Record.RelativePath 'Resume Target is not a safe canonical state' 'Resume through the justified current checkpoint or its immediate safe predecessor' }
        for ($i = 0; $i -lt $history.Count; $i++) {
            if ($history[$i] -ceq 'blocked') {
                if ($i -lt $history.Count - 1) { if ($history[$i + 1] -cne $target) { Add-Diagnostic 'BLOCKED_RESUME' $Record.Id $Record.RelativePath 'Resume Target does not match the state after blocked' 'Record the exact justified re-entry state' } }
                else {
                    $previous = ''; for ($j = $i - 1; $j -ge 0; $j--) { if ($history[$j] -cne 'blocked') { $previous = $history[$j]; break } }
                    if (-not (Test-BlockedResume $previous $target $activeActionCount $confirmed $pending $declined $anyDeclined)) { Add-Diagnostic 'BLOCKED_RESUME' $Record.Id $Record.RelativePath 'Resume Target is not a safe canonical re-entry from the blocked state' 'Resume through the justified current checkpoint or its immediate safe predecessor' }
                }
            }
        }
    }
    if ($state -ceq 'linked_to_pk_ship') { if ($releaseCandidate -cne 'true') { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'Only release candidates may reach linked_to_pk_ship' 'Keep non-release records at verified' }; if ($history.Count -lt 2 -or $history[$history.Count - 2] -cne 'verified') { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'linked_to_pk_ship must follow verified' 'Link release evidence only after successful verification' }; if (Test-Usable (Get-Field $Record 'pk:ship Release Link')) { Validate-ReleaseLink $Record (Get-Field $Record 'pk:ship Release Link') } else { [void](Require-Usable $Record 'pk:ship Release Link') } } elseif (Test-Usable (Get-Field $Record 'pk:ship Release Link')) { Add-Diagnostic 'RELEASE_HANDOFF' $Record.Id $Record.RelativePath 'pk:ship Release Link is present before linked_to_pk_ship' 'Keep release linkage empty until verified handoff' }
}

$ciDirectory = Join-Path $RootPath 'docs/releases/ci-triage'
if (-not (Test-Path -LiteralPath $ciDirectory -PathType Container)) { if ($Strict) { Add-Diagnostic 'MISSING_FIELD' 'REPOSITORY' 'docs/releases/ci-triage' 'CI Triage directory does not exist' 'Provide docs/releases/ci-triage or use a CI fixture root' } else { Write-Output 'VALID|RECORDS=0|ROOT=.'; exit 0 } } else {
    $files = @(Get-ChildItem -LiteralPath $ciDirectory -Filter '*.md' -File -Recurse | Sort-Object FullName)
    if ($files.Count -ceq 0) { Add-Diagnostic 'MISSING_FIELD' 'REPOSITORY' 'docs/releases/ci-triage' 'No CI Triage Records found' 'Provide at least one canonical CI record' }
    foreach ($file in $files) { try { $record = Get-CiRecord $file.FullName } catch { Add-Diagnostic 'READ_ERROR' 'UNKNOWN' (Get-RelativePath $file.FullName) 'Unable to read CI Triage Record' 'Provide a readable local Markdown record'; continue }; Validate-CiRecord $record; if ($SeenIds.ContainsKey($record.Id)) { Add-Diagnostic 'DUPLICATE_ID' $record.Id $record.RelativePath 'Duplicate CI ID across records' 'Keep each immutable CI ID unique' } else { $SeenIds[$record.Id] = $true }; $script:RecordCount++ }
}
foreach ($diagnostic in @($Diagnostics | Sort-Object)) { Write-Output $diagnostic }
if ($ErrorCount -gt 0) { Write-Output "FAILED|ERRORS=$ErrorCount|RECORDS=$RecordCount"; exit 1 }
Write-Output "VALID|RECORDS=$RecordCount|ROOT=."
exit 0
