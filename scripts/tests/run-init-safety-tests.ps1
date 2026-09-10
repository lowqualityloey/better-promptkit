# Regression tests for non-destructive init.ps1 directive updates (PowerShell).
# Run from repository root: pwsh -NoProfile -File .\scripts\tests\run-init-safety-tests.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "../..")).Path

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Create a temporary working directory
$TestDirItem = New-Item -ItemType Directory -Path (Join-Path ([System.IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())) -Force
$TestRoot = $TestDirItem.FullName

try {
    $ProjectRoot = (New-Item -ItemType Directory -Path (Join-Path $TestRoot "project") -Force).FullName
    $MalformedRoot = (New-Item -ItemType Directory -Path (Join-Path $TestRoot "malformed") -Force).FullName
    $DuplicateRoot = (New-Item -ItemType Directory -Path (Join-Path $TestRoot "duplicate") -Force).FullName
    $Utf8Root = (New-Item -ItemType Directory -Path (Join-Path $TestRoot "utf8") -Force).FullName

    # Test 1: Preservation of existing content & literal $ insertion & idempotency
    $agentsPath = Join-Path $ProjectRoot "AGENTS.md"
    $initialAgentsContent = @"
# User-owned instructions with `$1 literal dollar reference

Keep this content.

<!-- PROMPTKIT_START -->
old directive
<!-- PROMPTKIT_END -->

Keep this content too.
"@
    [System.IO.File]::WriteAllText($agentsPath, $initialAgentsContent, $utf8NoBom)

    $initScriptPath = Join-Path $RepoRoot "init.ps1"
    & pwsh -NoProfile -File $initScriptPath -ProjectRoot $ProjectRoot | Out-Null

    $updatedContent = [System.IO.File]::ReadAllText($agentsPath, [System.Text.Encoding]::UTF8)

    if (-not $updatedContent.Contains('# User-owned instructions with $1 literal dollar reference')) {
        throw "Failed Test 1: User-owned heading with literal dollar was modified or removed."
    }
    if (-not $updatedContent.Contains('Keep this content.')) {
        throw "Failed Test 1: User-owned content before directive was lost."
    }
    if (-not $updatedContent.Contains('Keep this content too.')) {
        throw "Failed Test 1: User-owned content after directive was lost."
    }
    if (-not $updatedContent.Contains('## Better-PromptKit Engineering Operating System')) {
        throw "Failed Test 1: New directive content was not injected."
    }

    $startMatches = [regex]::Matches($updatedContent, "^<!-- PROMPTKIT_START -->$", [System.Text.RegularExpressions.RegexOptions]::Multiline)
    $endMatches = [regex]::Matches($updatedContent, "^<!-- PROMPTKIT_END -->$", [System.Text.RegularExpressions.RegexOptions]::Multiline)
    if ($startMatches.Count -ne 1 -or $endMatches.Count -ne 1) {
        throw "Failed Test 1: Directive block marker counts are invalid (start: $($startMatches.Count), end: $($endMatches.Count))."
    }

    # Test 4: Literal $ inside injected directive check
    if (-not $updatedContent.Contains('$1')) {
        throw "Failed Test 4: Literal dollar ($1) was corrupted during replacement."
    }

    # Test 6: Idempotency re-run
    & pwsh -NoProfile -File $initScriptPath -ProjectRoot $ProjectRoot | Out-Null
    $reRunContent = [System.IO.File]::ReadAllText($agentsPath, [System.Text.Encoding]::UTF8)
    $reRunStartMatches = [regex]::Matches($reRunContent, "^<!-- PROMPTKIT_START -->$", [System.Text.RegularExpressions.RegexOptions]::Multiline)
    if ($reRunStartMatches.Count -ne 1) {
        throw "Failed Test 6 (Idempotency): Expected 1 PROMPTKIT_START after re-run, found $($reRunStartMatches.Count)."
    }

    # Test 2: Reject duplicate start/end markers and keep file byte-for-byte unchanged
    $dupAgentsPath = Join-Path $DuplicateRoot "AGENTS.md"
    $dupContent = @"
# Duplicate markers test
<!-- PROMPTKIT_START -->
Block 1
<!-- PROMPTKIT_END -->
<!-- PROMPTKIT_START -->
Block 2
<!-- PROMPTKIT_END -->
"@
    [System.IO.File]::WriteAllText($dupAgentsPath, $dupContent, $utf8NoBom)
    $dupBeforeHash = (Get-FileHash -Path $dupAgentsPath -Algorithm SHA256).Hash

    $failedAsExpected = $false
    try {
        $p = Start-Process -FilePath "pwsh" -ArgumentList "-NoProfile", "-File", "`"$initScriptPath`"", "-ProjectRoot", "`"$DuplicateRoot`"" -NoNewWindow -Wait -PassThru
        if ($p.ExitCode -ne 0) {
            $failedAsExpected = $true
        }
    } catch {
        $failedAsExpected = $true
    }
    if (-not $failedAsExpected) {
        throw "Failed Test 2: Expected duplicate marker initialization to fail loudly."
    }
    $dupAfterHash = (Get-FileHash -Path $dupAgentsPath -Algorithm SHA256).Hash
    if ($dupBeforeHash -ne $dupAfterHash) {
        throw "Failed Test 2: Duplicate marker file was modified despite failure."
    }

    # Test 3: Reject incomplete marker block and keep file byte-for-byte unchanged
    $malformedAgentsPath = Join-Path $MalformedRoot "AGENTS.md"
    $malformedContent = @"
# User-owned instructions
<!-- PROMPTKIT_START -->
incomplete directive without end marker
"@
    [System.IO.File]::WriteAllText($malformedAgentsPath, $malformedContent, $utf8NoBom)
    $malformedBeforeHash = (Get-FileHash -Path $malformedAgentsPath -Algorithm SHA256).Hash

    $malformedFailed = $false
    try {
        $p = Start-Process -FilePath "pwsh" -ArgumentList "-NoProfile", "-File", "`"$initScriptPath`"", "-ProjectRoot", "`"$MalformedRoot`"" -NoNewWindow -Wait -PassThru
        if ($p.ExitCode -ne 0) {
            $malformedFailed = $true
        }
    } catch {
        $malformedFailed = $true
    }
    if (-not $malformedFailed) {
        throw "Failed Test 3: Expected malformed marker initialization to fail loudly."
    }
    $malformedAfterHash = (Get-FileHash -Path $malformedAgentsPath -Algorithm SHA256).Hash
    if ($malformedBeforeHash -ne $malformedAfterHash) {
        throw "Failed Test 3: Malformed marker file was modified despite failure."
    }

    # Test 5: UTF-8 content containing emoji and CJK characters survives update
    $utf8AgentsPath = Join-Path $Utf8Root "AGENTS.md"
    $utf8Content = @"
# User instructions 🚀 🧪 漢字 テスト
Existing UTF-8 text with emoji and CJK characters.

<!-- PROMPTKIT_START -->
old directive
<!-- PROMPTKIT_END -->

Footer content ✨ 祝日
"@
    [System.IO.File]::WriteAllText($utf8AgentsPath, $utf8Content, $utf8NoBom)

    & pwsh -NoProfile -File $initScriptPath -ProjectRoot $Utf8Root | Out-Null
    $utf8Updated = [System.IO.File]::ReadAllText($utf8AgentsPath, [System.Text.Encoding]::UTF8)

    if (-not $utf8Updated.Contains('🚀 🧪 漢字 テスト')) {
        throw "Failed Test 5: Emoji and CJK characters in header were corrupted or lost."
    }
    if (-not $utf8Updated.Contains('✨ 祝日')) {
        throw "Failed Test 5: Emoji and CJK characters in footer were corrupted or lost."
    }

    Write-Host "init.ps1 non-destructive update, malformed/duplicate marker, literal $, UTF-8 emoji/CJK, and idempotency tests passed." -ForegroundColor Green
} finally {
    Remove-Item -Path $TestRoot -Recurse -Force -ErrorAction SilentlyContinue
}
