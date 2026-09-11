#!/usr/bin/env bash
# Regression tests for non-destructive init.sh directive updates.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_ROOT="$(mktemp -d)"
FAKE_BIN="$TEST_ROOT/bin"
PROJECT_ROOT="$TEST_ROOT/project"
MALFORMED_ROOT="$TEST_ROOT/malformed"

cleanup() {
    rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

mkdir -p "$PROJECT_ROOT" "$MALFORMED_ROOT"

cat > "$PROJECT_ROOT/AGENTS.md" <<'EOF'
# User-owned instructions

Keep this content.

<!-- PROMPTKIT_START -->
old directive
<!-- PROMPTKIT_END -->

Keep this content too.
EOF

bash "$REPO_ROOT/init.sh" "$PROJECT_ROOT" >/dev/null

grep -q '^# User-owned instructions$' "$PROJECT_ROOT/AGENTS.md"
grep -q '^Keep this content\.$' "$PROJECT_ROOT/AGENTS.md"
grep -q '^Keep this content too\.$' "$PROJECT_ROOT/AGENTS.md"
grep -q '^## Better-PromptKit Engineering Operating System$' "$PROJECT_ROOT/AGENTS.md"
[[ "$(grep -c '^<!-- PROMPTKIT_START -->$' "$PROJECT_ROOT/AGENTS.md")" -eq 1 ]]
[[ "$(grep -c '^<!-- PROMPTKIT_END -->$' "$PROJECT_ROOT/AGENTS.md")" -eq 1 ]]

# Test: Incomplete marker block fails loudly and preserves file
cat > "$MALFORMED_ROOT/AGENTS.md" <<'EOF'
# User-owned instructions

<!-- PROMPTKIT_START -->
incomplete directive
EOF
before_hash="$(sha256sum "$MALFORMED_ROOT/AGENTS.md" | cut -d' ' -f1)"
if bash "$REPO_ROOT/init.sh" "$MALFORMED_ROOT" >/dev/null 2>&1; then
    echo "Expected malformed directive update to fail." >&2
    exit 1
fi
after_hash="$(sha256sum "$MALFORMED_ROOT/AGENTS.md" | cut -d' ' -f1)"
[[ "$before_hash" == "$after_hash" ]]

# Test: Duplicate START markers fail loudly and preserve file
DUP_START_ROOT="$TEST_ROOT/dupstart"
mkdir -p "$DUP_START_ROOT"
cat > "$DUP_START_ROOT/AGENTS.md" <<'EOF'
Header
<!-- PROMPTKIT_START -->
Block 1
<!-- PROMPTKIT_START -->
Block 2
<!-- PROMPTKIT_END -->
EOF
before_hash="$(sha256sum "$DUP_START_ROOT/AGENTS.md" | cut -d' ' -f1)"
if bash "$REPO_ROOT/init.sh" "$DUP_START_ROOT" >/dev/null 2>&1; then
    echo "Expected duplicate START markers to fail." >&2
    exit 1
fi
after_hash="$(sha256sum "$DUP_START_ROOT/AGENTS.md" | cut -d' ' -f1)"
[[ "$before_hash" == "$after_hash" ]]

# Test: Duplicate END markers fail loudly and preserve file
DUP_END_ROOT="$TEST_ROOT/dupend"
mkdir -p "$DUP_END_ROOT"
cat > "$DUP_END_ROOT/AGENTS.md" <<'EOF'
Header
<!-- PROMPTKIT_START -->
Block 1
<!-- PROMPTKIT_END -->
<!-- PROMPTKIT_END -->
EOF
before_hash="$(sha256sum "$DUP_END_ROOT/AGENTS.md" | cut -d' ' -f1)"
if bash "$REPO_ROOT/init.sh" "$DUP_END_ROOT" >/dev/null 2>&1; then
    echo "Expected duplicate END markers to fail." >&2
    exit 1
fi
after_hash="$(sha256sum "$DUP_END_ROOT/AGENTS.md" | cut -d' ' -f1)"
[[ "$before_hash" == "$after_hash" ]]

# Test: Reversed END-before-START markers fail loudly and preserve file
REVERSED_ROOT="$TEST_ROOT/reversed"
mkdir -p "$REVERSED_ROOT"
cat > "$REVERSED_ROOT/AGENTS.md" <<'EOF'
Header
<!-- PROMPTKIT_END -->
Reversed body
<!-- PROMPTKIT_START -->
Footer
EOF
before_hash="$(sha256sum "$REVERSED_ROOT/AGENTS.md" | cut -d' ' -f1)"
if bash "$REPO_ROOT/init.sh" "$REVERSED_ROOT" >/dev/null 2>&1; then
    echo "Expected reversed markers to fail." >&2
    exit 1
fi
after_hash="$(sha256sum "$REVERSED_ROOT/AGENTS.md" | cut -d' ' -f1)"
[[ "$before_hash" == "$after_hash" ]]

# Test: Directive replacement tool failure (awk failure) fails loudly and preserves file
AWK_FAIL_ROOT="$TEST_ROOT/awkfail"
mkdir -p "$AWK_FAIL_ROOT" "$FAKE_BIN"
cat > "$AWK_FAIL_ROOT/AGENTS.md" <<'EOF'
Header
<!-- PROMPTKIT_START -->
old directive
<!-- PROMPTKIT_END -->
Footer
EOF
cat > "$FAKE_BIN/awk" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
chmod +x "$FAKE_BIN/awk"

before_hash="$(sha256sum "$AWK_FAIL_ROOT/AGENTS.md" | cut -d' ' -f1)"
if PATH="$FAKE_BIN:$PATH" bash "$REPO_ROOT/init.sh" "$AWK_FAIL_ROOT" >/dev/null 2>&1; then
    echo "Expected init.sh to fail when replacement tool (awk) fails." >&2
    exit 1
fi
after_hash="$(sha256sum "$AWK_FAIL_ROOT/AGENTS.md" | cut -d' ' -f1)"
[[ "$before_hash" == "$after_hash" ]]

echo "init.sh non-destructive update and malformed-marker tests passed."
