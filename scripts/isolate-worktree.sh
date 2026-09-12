#!/usr/bin/env bash
# PromptKit OS Git Worktree Isolation Utility
# Creates, lists, merges, and safely removes isolated Git worktrees
# for risky multi-file tasks, spike explorations, or subagent runs.
set -euo pipefail

ACTION="${1:-list}"
TASK_ID="${2:-}"

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$REPO_ROOT" ]]; then
    echo "Error: Not inside a git repository." >&2
    exit 1
fi

WORKTREE_BASE="$REPO_ROOT/.worktrees"
GITIGNORE="$REPO_ROOT/.gitignore"

# Ensure .worktrees/ is in .gitignore
if [[ -f "$GITIGNORE" ]]; then
    if ! grep -q "^\.worktrees/\?$" "$GITIGNORE"; then
        echo -e "\n# PromptKit OS isolated worktrees\n.worktrees/" >> "$GITIGNORE"
        echo "  [+] Added .worktrees/ to .gitignore"
    fi
else
    echo -e "# PromptKit OS isolated worktrees\n.worktrees/" > "$GITIGNORE"
    echo "  [+] Created .gitignore with .worktrees/"
fi

case "$ACTION" in
    create)
        if [[ -z "$TASK_ID" ]]; then
            echo "Error: TaskId is required for 'create'. Usage: ./scripts/isolate-worktree.sh create <task-id>" >&2
            exit 1
        fi
        BRANCH_NAME="worktree/$TASK_ID"
        TARGET_PATH="$WORKTREE_BASE/$TASK_ID"

        if [[ -d "$TARGET_PATH" ]]; then
            echo "Warning: Worktree path already exists: $TARGET_PATH"
            exit 0
        fi

        mkdir -p "$WORKTREE_BASE"
        echo -e "\033[0;36m🌿 Creating isolated worktree at $TARGET_PATH on branch '$BRANCH_NAME'...\033[0m"
        git worktree add -b "$BRANCH_NAME" "$TARGET_PATH"
        echo -e "\033[0;32m  ✅ Worktree created successfully.\033[0m"
        echo "  To enter worktree: cd $TARGET_PATH"
        ;;

    list|status)
        echo -e "\033[0;36m📋 Active Git Worktrees:\033[0m"
        git worktree list
        ;;

    merge)
        if [[ -z "$TASK_ID" ]]; then
            echo "Error: TaskId is required for 'merge'. Usage: ./scripts/isolate-worktree.sh merge <task-id>" >&2
            exit 1
        fi
        BRANCH_NAME="worktree/$TASK_ID"
        echo -e "\033[0;36m🔀 Merging branch '$BRANCH_NAME' into current branch...\033[0m"
        git merge "$BRANCH_NAME"
        echo -e "\033[0;32m  ✅ Merge completed. Remember to remove the worktree with 'remove $TASK_ID' when finished.\033[0m"
        ;;

    remove)
        if [[ -z "$TASK_ID" ]]; then
            echo "Error: TaskId is required for 'remove'. Usage: ./scripts/isolate-worktree.sh remove <task-id>" >&2
            exit 1
        fi
        BRANCH_NAME="worktree/$TASK_ID"
        TARGET_PATH="$WORKTREE_BASE/$TASK_ID"

        echo -e "\033[0;36m🧹 Removing worktree at $TARGET_PATH...\033[0m"
        if [[ -d "$TARGET_PATH" ]]; then
            git worktree remove "$TARGET_PATH" --force
        else
            git worktree prune
        fi

        if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
            git branch -D "$BRANCH_NAME"
            echo "  [-] Deleted branch $BRANCH_NAME"
        fi
        echo -e "\033[0;32m  ✅ Worktree cleaned up successfully.\033[0m"
        ;;

    *)
        echo "Usage: ./scripts/isolate-worktree.sh [create|list|merge|remove|status] [task-id]" >&2
        exit 1
        ;;
esac
