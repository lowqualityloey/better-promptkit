#!/usr/bin/env bash
# PromptKit OS Directive Token Measurement Utility
# Calculates character, word, and estimated token counts for the injected directive.
set -euo pipefail

TARGET_FILE="${1:-}"

echo -e "\n\033[0;36m📊 PromptKit OS Static Directive Token Analysis\033[0m"
echo -e "\033[0;90m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

CANDIDATES=(
    "AGENTS.md"
    "CLAUDE.md"
    "GEMINI.md"
    ".cursorrules"
    ".cursor/rules/promptkit.mdc"
    ".windsurfrules"
    ".github/copilot-instructions.md"
    ".clinerules"
)

FOUND_FILE=""
if [[ -n "$TARGET_FILE" && -f "$TARGET_FILE" ]]; then
    FOUND_FILE="$TARGET_FILE"
else
    for cand in "${CANDIDATES[@]}"; do
        if [[ -f "$cand" ]]; then
            FOUND_FILE="$cand"
            break
        fi
    done
fi

BLOCK=""
SOURCE_DESC=""

if [[ -n "$FOUND_FILE" && -f "$FOUND_FILE" ]]; then
    if grep -q "<!-- PROMPTKIT_START -->" "$FOUND_FILE"; then
        BLOCK=$(awk '/^<!-- PROMPTKIT_START -->/{flag=1} flag; /^<!-- PROMPTKIT_END -->/{flag=0}' "$FOUND_FILE")
        SOURCE_DESC="$FOUND_FILE"
    fi
fi

if [[ -z "$BLOCK" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    INIT_SH="$SCRIPT_DIR/../init.sh"
    if [[ -f "$INIT_SH" ]]; then
        BLOCK=$(awk '/^<!-- PROMPTKIT_START -->/{flag=1} flag; /^<!-- PROMPTKIT_END -->/{flag=0}' "$INIT_SH")
        SOURCE_DESC="Canonical template in init.sh"
    fi
fi

if [[ -z "$BLOCK" ]]; then
    echo "Error: No PromptKit OS directive block found. Run init.sh first or pass a file path." >&2
    exit 1
fi

LINE_COUNT=$(echo "$BLOCK" | wc -l | tr -d ' ')
CHAR_COUNT=$(echo "$BLOCK" | wc -c | tr -d ' ')
WORD_COUNT=$(echo "$BLOCK" | wc -w | tr -d ' ')
ESTIMATED_TOKENS=$(( (CHAR_COUNT + 2) / 4 ))
MONOLITHIC_TOKENS=18500
SAVINGS_PERCENT=$(( 100 - (ESTIMATED_TOKENS * 100 / MONOLITHIC_TOKENS) ))

echo -e "\033[0;90mTarget File: $FOUND_FILE\033[0m"
echo -e "\n\033[1;33mMeasurement Results:\033[0m"
echo "  • Lines:            $LINE_COUNT"
echo "  • Characters:       $CHAR_COUNT"
echo "  • Words:            $WORD_COUNT"
echo -e "  • Estimated Tokens: \033[0;32m~$ESTIMATED_TOKENS tokens (at ~4 chars/token)\033[0m"

echo -e "\n\033[1;33mToken Economics Comparison:\033[0m"
echo -e "  \033[0;90m┌─────────────────────────────────────────────────────────────┐\033[0m"
echo -e "  \033[0;90m│ Model Architecture                 Static Overhead          │\033[0m"
echo -e "  \033[0;90m├─────────────────────────────────────────────────────────────┤\033[0m"
echo -e "  │ Monolithic Prompt Packs            \033[0;31m~18,500 tokens\033[0m           │"
echo -e "  │ PromptKit OS JIT Router            \033[0;32m~$ESTIMATED_TOKENS tokens (measured)\033[0m      │"
echo -e "  \033[0;90m├─────────────────────────────────────────────────────────────┤\033[0m"
echo -e "  │ Static Context Reduction:          \033[0;36m~$SAVINGS_PERCENT% reduction\033[0m             │"
echo -e "  \033[0;90m└─────────────────────────────────────────────────────────────┘\033[0m"

TOKEN_BUDGET=2000

echo -e "\n\033[1;33mBudget Assertion Verification:\033[0m"
echo "  • Configured Token Budget:  $TOKEN_BUDGET tokens"
echo "  • Measured Estimate:        $ESTIMATED_TOKENS tokens"

if [ "$ESTIMATED_TOKENS" -le "$TOKEN_BUDGET" ]; then
    echo -e "\n\033[0;32m✅ Verification Passed: Directive ($ESTIMATED_TOKENS tokens) adheres to the <= $TOKEN_BUDGET token budget.\033[0m\n"
else
    echo -e "\n\033[0;31m❌ Verification Failed: Directive ($ESTIMATED_TOKENS tokens) exceeds the $TOKEN_BUDGET token budget by $(( ESTIMATED_TOKENS - TOKEN_BUDGET )) tokens.\033[0m\n" >&2
    exit 1
fi
