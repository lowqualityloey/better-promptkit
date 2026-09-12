<#
.SYNOPSIS
    Better-PromptKit Git Worktree Isolation Utility
.DESCRIPTION
    Creates, lists, merges, and safely removes isolated Git worktrees
    for risky multi-file tasks, spike explorations, or subagent runs.
    Ensures .worktrees/ is excluded from git tracking.
.PARAMETER Action
    create, list, merge, remove
.PARAMETER TaskId
    Identifier for the isolated worktree (e.g. task-123 or feat-auth)
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0, Mandatory = $false)]
    [ValidateSet("create", "list", "merge", "remove", "status")]
    [string]$Action = "list",

    [Parameter(Position = 1, Mandatory = $false)]
    [string]$TaskId = ""
)

$ErrorActionPreference = "Stop"

# Verify inside git repository
try {
    $RepoRoot = (git rev-parse --show-toplevel).Trim()
} catch {
    Write-Error "Not inside a git repository."
    exit 1
}

$WorktreeBase = Join-Path $RepoRoot ".worktrees"

# Ensure .worktrees/ is in .gitignore
$GitIgnorePath = Join-Path $RepoRoot ".gitignore"
$NeedIgnore = $true
if (Test-Path $GitIgnorePath) {
    $Content = Get-Content $GitIgnorePath -Raw
    if ($Content -match "(?m)^\.worktrees/?$") {
        $NeedIgnore = $false
    }
}
if ($NeedIgnore) {
    Add-Content -Path $GitIgnorePath -Value "`n# Better-PromptKit isolated worktrees`n.worktrees/`n"
    Write-Host "  [+] Added .worktrees/ to .gitignore" -ForegroundColor DarkGray
}

switch ($Action) {
    "create" {
        if ([string]::IsNullOrWhiteSpace($TaskId)) {
            Write-Error "TaskId is required for 'create'. Example: .\scripts\isolate-worktree.ps1 create task-42"
            exit 1
        }
        $BranchName = "worktree/$TaskId"
        $TargetPath = Join-Path $WorktreeBase $TaskId

        if (Test-Path $TargetPath) {
            Write-Warning "Worktree path already exists: $TargetPath"
            exit 0
        }

        if (-not (Test-Path $WorktreeBase)) {
            New-Item -ItemType Directory -Path $WorktreeBase -Force | Out-Null
        }

        Write-Host "🌿 Creating isolated worktree at $TargetPath on branch '$BranchName'..." -ForegroundColor Cyan
        git worktree add -b $BranchName $TargetPath
        Write-Host "  ✅ Worktree created successfully." -ForegroundColor Green
        Write-Host "  To enter worktree: cd $TargetPath" -ForegroundColor DarkGray
    }

    { $_ -in @("list", "status") } {
        Write-Host "📋 Active Git Worktrees:" -ForegroundColor Cyan
        git worktree list
    }

    "merge" {
        if ([string]::IsNullOrWhiteSpace($TaskId)) {
            Write-Error "TaskId is required for 'merge'. Example: .\scripts\isolate-worktree.ps1 merge task-42"
            exit 1
        }
        $BranchName = "worktree/$TaskId"
        Write-Host "🔀 Merging branch '$BranchName' into current branch..." -ForegroundColor Cyan
        git merge $BranchName
        Write-Host "  ✅ Merge completed. Remember to remove the worktree with 'remove $TaskId' when finished." -ForegroundColor Green
    }

    "remove" {
        if ([string]::IsNullOrWhiteSpace($TaskId)) {
            Write-Error "TaskId is required for 'remove'. Example: .\scripts\isolate-worktree.ps1 remove task-42"
            exit 1
        }
        $BranchName = "worktree/$TaskId"
        $TargetPath = Join-Path $WorktreeBase $TaskId

        Write-Host "🧹 Removing worktree at $TargetPath..." -ForegroundColor Cyan
        if (Test-Path $TargetPath) {
            git worktree remove $TargetPath --force
        } else {
            git worktree prune
        }

        # Optional branch deletion
        $branchExists = git branch --list $BranchName
        if ($branchExists) {
            git branch -D $BranchName
            Write-Host "  [-] Deleted branch $BranchName" -ForegroundColor DarkGray
        }
        Write-Host "  ✅ Worktree cleaned up successfully." -ForegroundColor Green
    }
}
