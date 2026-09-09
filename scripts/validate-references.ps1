# Validation Script: Verify all workflow→template references exist
# Run from repository root: .\.promptkit\scripts\validate-references.ps1

param(
    [string]$PromptKitDir = ".promptkit"
)

$ErrorActionPreference = "Continue"
$script:ErrorCount = 0
$script:WarningCount = 0

Write-Host "`n🔍 Better-PromptKit Reference Validation`n" -ForegroundColor Cyan

# Resolve paths
if (-not (Test-Path $PromptKitDir)) {
    Write-Host "❌ ERROR: PromptKit directory not found: $PromptKitDir" -ForegroundColor Red
    exit 1
}

$PromptKitRoot = Resolve-Path $PromptKitDir

# Define directories to scan
$WorkflowsDir = Join-Path $PromptKitRoot "workflows"
$ProtocolsDir = Join-Path $PromptKitRoot "protocols"
$TemplatesDir = Join-Path $PromptKitRoot "templates"
$ActivitiesDir = Join-Path $PromptKitRoot "activities"

Write-Host "📂 Scanning directories:" -ForegroundColor Yellow
Write-Host "   - $WorkflowsDir"
Write-Host "   - $ProtocolsDir"
Write-Host "   - $TemplatesDir"
Write-Host "   - $ActivitiesDir`n"

# Find all markdown files
$AllMarkdownFiles = @()
$AllMarkdownFiles += Get-ChildItem -Path $WorkflowsDir -Filter "*.md" -ErrorAction SilentlyContinue
$AllMarkdownFiles += Get-ChildItem -Path $ProtocolsDir -Filter "*.md" -ErrorAction SilentlyContinue
$AllMarkdownFiles += Get-ChildItem -Path $ActivitiesDir -Filter "*.md" -ErrorAction SilentlyContinue
$AllMarkdownFiles += Get-ChildItem -Path (Join-Path $PromptKitRoot "*.md") -ErrorAction SilentlyContinue

Write-Host "📄 Found $($AllMarkdownFiles.Count) markdown files to validate`n" -ForegroundColor Cyan

# Validation patterns
$Patterns = @{
    "Template Reference" = '\.promptkit/templates/([a-zA-Z0-9_-]+\.md)'
    "Workflow Reference" = '\.promptkit/workflows/([a-zA-Z0-9_-]+\.md)'
    "Protocol Reference" = '\.promptkit/protocols/([a-zA-Z0-9_-]+\.md)'
    "Docs Path Reference" = 'docs/(adrs|specs|rca|spikes|design|data|auth|api|tests|perf|tasks|releases)/'
    "Relative Template" = 'templates/([a-zA-Z0-9_-]+\.md)'
    "Relative Workflow" = 'workflows/([a-zA-Z0-9_-]+\.md)'
    "Relative Protocol" = 'protocols/([a-zA-Z0-9_-]+\.md)'
}

function Test-FileReference {
    param(
        [string]$SourceFile,
        [string]$RefType,
        [string]$RefPath,
        [int]$LineNumber
    )
    
    $baseDir = $PromptKitRoot
    $fullPath = Join-Path $baseDir $RefPath
    
    if (-not (Test-Path $fullPath)) {
        $relSource = $SourceFile.Substring($PromptKitRoot.Path.Length).TrimStart("\", "/")
        Write-Host "  ❌ BROKEN: ${relSource}:$LineNumber" -ForegroundColor Red
        Write-Host "     Type: $RefType" -ForegroundColor DarkGray
        Write-Host "     Missing: $RefPath`n" -ForegroundColor DarkGray
        $script:ErrorCount++
        return $false
    }
    return $true
}

# Scan each file
foreach ($file in $AllMarkdownFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $lines = Get-Content -Path $file.FullName
    
    $relPath = $file.FullName.Substring($PromptKitRoot.Path.Length).TrimStart("\", "/")
    $fileHasIssues = $false
    
    # Check template references
    $templateMatches = [regex]::Matches($content, $Patterns["Template Reference"])
    foreach ($match in $templateMatches) {
        $lineNum = ($content.Substring(0, $match.Index) -split "`n").Count
        $templatePath = "templates/$($match.Groups[1].Value)"
        if (-not (Test-FileReference $file.FullName "Template" $templatePath $lineNum)) {
            $fileHasIssues = $true
        }
    }
    
    # Check workflow references
    $workflowMatches = [regex]::Matches($content, $Patterns["Workflow Reference"])
    foreach ($match in $workflowMatches) {
        $lineNum = ($content.Substring(0, $match.Index) -split "`n").Count
        $workflowPath = "workflows/$($match.Groups[1].Value)"
        if (-not (Test-FileReference $file.FullName "Workflow" $workflowPath $lineNum)) {
            $fileHasIssues = $true
        }
    }
    
    # Check protocol references
    $protocolMatches = [regex]::Matches($content, $Patterns["Protocol Reference"])
    foreach ($match in $protocolMatches) {
        $lineNum = ($content.Substring(0, $match.Index) -split "`n").Count
        $protocolPath = "protocols/$($match.Groups[1].Value)"
        if (-not (Test-FileReference $file.FullName "Protocol" $protocolPath $lineNum)) {
            $fileHasIssues = $true
        }
    }
    
    # Check relative template references
    $relTemplateMatches = [regex]::Matches($content, $Patterns["Relative Template"])
    foreach ($match in $relTemplateMatches) {
        $lineNum = ($content.Substring(0, $match.Index) -split "`n").Count
        $templatePath = "templates/$($match.Groups[1].Value)"
        if (-not (Test-FileReference $file.FullName "Template (relative)" $templatePath $lineNum)) {
            $fileHasIssues = $true
        }
    }
    
    # Warn about workflow trigger references that may be outdated
    if ($content -match 'pk:(\w+)') {
        $triggers = [regex]::Matches($content, 'pk:(\w+)') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
        foreach ($trigger in $triggers) {
            $expectedWorkflow = Join-Path $WorkflowsDir "$trigger.md"
            if (-not (Test-Path $expectedWorkflow)) {
                # Check common aliases
                $aliases = @{
                    "db" = "data.md"
                    "profile" = "perf.md"
                    "research" = "research.md"
                    "reflect" = "reflect.md"
                    "handoff" = "checkpoint.md"
                    "issue" = "tasks.md"
                    "kanban" = "tasks.md"
                    "scan" = "onboard.md"
                    "latency" = "perf.md"
                    "grill" = "tutor.md"
                    "spike" = "research.md"
                    "retro" = "reflect.md"
                    "design" = "design-system.md"
                    "init" = "onboard.md"
                    "task" = "tasks.md"
                }
                
                if (-not $aliases.ContainsKey($trigger)) {
                    Write-Host "  ⚠️  WARNING: $relPath" -ForegroundColor Yellow
                    Write-Host "     Trigger 'pk:$trigger' may not have matching workflow" -ForegroundColor DarkGray
                    Write-Host "     Expected: workflows/$trigger.md`n" -ForegroundColor DarkGray
                    $script:WarningCount++
                }
            }
        }
    }
    
    if (-not $fileHasIssues) {
        Write-Host "  ✅ $relPath" -ForegroundColor Green
    }
}

# Validate template directory completeness
Write-Host "`n📋 Checking template directory completeness..." -ForegroundColor Cyan

$ExpectedTemplates = @(
    "project-profile-template.md",
    "design-profile-template.md",
    "state-tracker-template.md",
    "tech-spec-template.md",
    "adr-template.md",
    "data-model-spec.md",
    "auth-matrix-template.md",
    "api-contract-spec.md",
    "test-plan-template.md",
    "release-checklist.md",
    "pull-request-template.md",
    "perf-audit-template.md",
    "issue-task-template.md",
    "rca-postmortem-template.md",
    "code-review-checklist.md",
    "design-tokens-spec.md",
    "spike-template.md",
    "ci-triage-template.md"
)

foreach ($template in $ExpectedTemplates) {
    $path = Join-Path $TemplatesDir $template
    if (Test-Path $path) {
        Write-Host "  ✅ templates/$template" -ForegroundColor Green
    } else {
        Write-Host "  ❌ MISSING: templates/$template" -ForegroundColor Red
        $script:ErrorCount++
    }
}

# Validate core workflow files exist
Write-Host "`n🔄 Checking core workflow files..." -ForegroundColor Cyan

$CoreWorkflows = @(
    "route.md",
    "tutor.md",
    "plan.md",
    "onboard.md",
    "tasks.md",
    "data.md",
    "auth.md",
    "api.md",
    "test.md",
    "design-system.md",
    "research.md",
    "debug.md",
    "perf.md",
    "review.md",
    "commit.md",
    "pr.md",
    "ship.md",
    "checkpoint.md",
    "reflect.md"
)

foreach ($workflow in $CoreWorkflows) {
    $path = Join-Path $WorkflowsDir $workflow
    if (Test-Path $path) {
        Write-Host "  ✅ workflows/$workflow" -ForegroundColor Green
    } else {
        Write-Host "  ❌ MISSING: workflows/$workflow" -ForegroundColor Red
        $script:ErrorCount++
    }
}

# Validate protocol files
Write-Host "`n📜 Checking protocol files..." -ForegroundColor Cyan

$CoreProtocols = @(
    "setup.md",
    "context-sync.md",
    "code-quality-gate.md",
    "subagent-delegation.md"
)

foreach ($protocol in $CoreProtocols) {
    $path = Join-Path $ProtocolsDir $protocol
    if (Test-Path $path) {
        Write-Host "  ✅ protocols/$protocol" -ForegroundColor Green
    } else {
        Write-Host "  ❌ MISSING: protocols/$protocol" -ForegroundColor Red
        $script:ErrorCount++
    }
}

# Summary
Write-Host "`n" -NoNewline
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "📊 Validation Summary" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

if ($script:ErrorCount -eq 0 -and $script:WarningCount -eq 0) {
    Write-Host "`n✅ All references valid! No broken links found." -ForegroundColor Green
    Write-Host "   Better-PromptKit is ready for production use.`n" -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    if ($script:ErrorCount -gt 0) {
        Write-Host "  ❌ Errors: $script:ErrorCount" -ForegroundColor Red
    }
    if ($script:WarningCount -gt 0) {
        Write-Host "  ⚠️  Warnings: $script:WarningCount" -ForegroundColor Yellow
    }
    Write-Host ""
    
    if ($script:ErrorCount -gt 0) {
        Write-Host "❌ Validation failed. Fix broken references before deployment.`n" -ForegroundColor Red
        exit 1
    } else {
        Write-Host "⚠️  Validation passed with warnings. Review recommended.`n" -ForegroundColor Yellow
        exit 0
    }
}
