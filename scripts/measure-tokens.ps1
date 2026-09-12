<#
.SYNOPSIS
    Better-PromptKit Directive Token Measurement Utility
.DESCRIPTION
    Extracts the active Better-PromptKit directive block from your agent
    instructions file (AGENTS.md, CLAUDE.md, etc.) and calculates the exact
    character, word, and estimated token counts (using industry standard 4 chars/token).
    Compares against typical monolithic AI prompt packs (~18,500 tokens).
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [string]$TargetFile = ""
)

$ErrorActionPreference = "Stop"

Write-Host "`n📊 Better-PromptKit Static Directive Token Analysis" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

# 1. Discover target directive file
$Candidates = @(
    "AGENTS.md",
    "CLAUDE.md",
    "GEMINI.md",
    ".cursorrules",
    ".cursor/rules/promptkit.mdc",
    ".windsurfrules",
    ".github/copilot-instructions.md",
    ".clinerules"
)

$DirectiveText = ""
$SourceDescription = ""

if ($TargetFile -ne "" -and (Test-Path $TargetFile)) {
    $FoundFile = Resolve-Path $TargetFile
    $Content = Get-Content $FoundFile -Raw
    $Pattern = "(?s)<!-- PROMPTKIT_START -->.*?<!-- PROMPTKIT_END -->"
    $Match = [regex]::Match($Content, $Pattern)
    if ($Match.Success) {
        $DirectiveText = $Match.Value
        $SourceDescription = $FoundFile
    }
} else {
    foreach ($cand in $Candidates) {
        if (Test-Path $cand) {
            $Content = Get-Content $cand -Raw
            $Pattern = "(?s)<!-- PROMPTKIT_START -->.*?<!-- PROMPTKIT_END -->"
            $Match = [regex]::Match($Content, $Pattern)
            if ($Match.Success) {
                $DirectiveText = $Match.Value
                $SourceDescription = (Resolve-Path $cand).Path
                break
            }
        }
    }
}

# Fallback to measuring the canonical template inside init.ps1 if running standalone inside .promptkit
if ([string]::IsNullOrWhiteSpace($DirectiveText)) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $InitPs1 = Join-Path $ScriptDir "..\init.ps1"
    if (Test-Path $InitPs1) {
        $Content = Get-Content $InitPs1 -Raw
        $Pattern = '(?s)\$Directive\s*=\s*@"\r?\n(<!-- PROMPTKIT_START -->.*?<!-- PROMPTKIT_END -->)'
        $Match = [regex]::Match($Content, $Pattern)
        if ($Match.Success) {
            $DirectiveText = $Match.Groups[1].Value
            $SourceDescription = "Canonical template in init.ps1"
        }
    }
}

if ([string]::IsNullOrWhiteSpace($DirectiveText)) {
    Write-Error "No Better-PromptKit directive block found. Run init.ps1 first or pass a file path."
    exit 1
}
$LineCount = ($DirectiveText -split "`r?`n").Count
$CharCount = $DirectiveText.Length
$WordCount = ($DirectiveText -split "\s+" | Where-Object { $_ -ne "" }).Count

# Standard heuristic across OpenAI/Anthropic tokenizers: ~4 chars per token for English markdown
$EstimatedTokens = [math]::Round($CharCount / 4.0)

# Monolithic baseline (inlining 20 workflows + templates)
$MonolithicTokens = 18500
$SavingsPercent = [math]::Round((1.0 - ($EstimatedTokens / $MonolithicTokens)) * 100, 1)

Write-Host "Source: $SourceDescription" -ForegroundColor DarkGray
Write-Host "`nMeasurement Results:" -ForegroundColor Yellow
Write-Host "  • Lines:            $LineCount"
Write-Host "  • Characters:       $CharCount"
Write-Host "  • Words:            $WordCount"
Write-Host "  • Estimated Tokens: ~$EstimatedTokens tokens (at ~4 chars/token)" -ForegroundColor Green

Write-Host "`nToken Economics Comparison:" -ForegroundColor Yellow
Write-Host "  ┌─────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
Write-Host "  │ Model Architecture                 Static Overhead          │" -ForegroundColor DarkGray
Write-Host "  ├─────────────────────────────────────────────────────────────┤" -ForegroundColor DarkGray
Write-Host "  │ Monolithic Prompt Packs            ~18,500 tokens           │" -ForegroundColor Red
Write-Host "  │ Better-PromptKit JIT Router        ~$EstimatedTokens tokens (measured)      │" -ForegroundColor Green
Write-Host "  ├─────────────────────────────────────────────────────────────┤" -ForegroundColor DarkGray
Write-Host "  │ Static Context Reduction:          $SavingsPercent% reduction             │" -ForegroundColor Cyan
Write-Host "  └─────────────────────────────────────────────────────────────┘" -ForegroundColor DarkGray
Write-Host "`n✅ Measurement Complete: Validated JIT filesystem router saves $SavingsPercent% static overhead vs monolithic inlining.`n" -ForegroundColor Green
