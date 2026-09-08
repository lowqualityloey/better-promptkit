# Pull Request Preparation Workflow

## Fast Shorthand
Trigger anytime with: `pk:pr` (or `/pk-pr`)

## Mission
Transform a series of local commits into a high-signal, staff-level Pull Request description. Compile testing evidence, evaluate database migration safety, document rollback procedures, and optionally automate PR creation via the GitHub CLI (`gh pr create`).

---

## Preconditions
- Active feature or bugfix branch with commits ready for review.
- Target base branch identified (default: `main` or `origin/main`).
- All tests and typechecks passing per `protocols/code-quality-gate.md`.

---

## 4-Phase Pull Request Protocol

```text
┌─────────────────────────────────────────────────────────────┐
│                      PK:PR LIFECYCLE                        │
├──────────────┬──────────────┬──────────────┬────────────────┤
│ Phase 1:     │ Phase 2:     │ Phase 3:     │ Phase 4:       │
│ Diff & Log   │ Evidence &   │ PR Body      │ Submission or  │
│ Inspection   │ Safety Audit │ Generation   │ CLI Creation   │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

---

### Phase 1: Diff & Log Inspection

1. **Verify Target Comparison**:
   ```bash
   BASE_BRANCH="origin/main"
   git log ${BASE_BRANCH}..HEAD --oneline
   git diff --stat ${BASE_BRANCH}...HEAD
   ```
2. **Review Commit History**:
   Ensure commits on the branch follow Conventional Commits format (`feat:`, `fix:`, `refactor:`, `test:`). If commits are messy, suggest cleaning them up via `pk:commit` before opening the PR.

---

### Phase 2: Evidence & Safety Audit

Before writing the PR body, collect verifiable evidence:

1. **Test Verification**:
   Execute the project test suite and capture the result:
   ```bash
   pnpm test        # or npm test / pytest
   pnpm test:e2e    # if E2E suites exist
   ```
2. **Database Migration Safety**:
   Inspect whether any migration files were touched:
   - Are schema changes additive (Expand-Contract pattern)?
   - Are there any `DROP TABLE`, `DROP COLUMN`, or `TRUNCATE` calls? If so, halt and require multi-phase migration planning.
   - Are Row-Level Security (RLS) policies and composite indexes defined?
3. **Secret & Probe Check**:
   Confirm that zero secrets or temporary debug probes (`[DEBUG-xxxx]`) exist across the branch diff.

### Controlled Work Traceability and PR Gate

Before generating a PR body for Controlled Work, include and verify:

- **Task Identity**: Task ID, canonical `docs/tasks/<task-id>.md` path, specification, execution scope, and current state (normally `awaiting_review`).
- **Scope and Acceptance**: Changed-file summary, stable `AC-*` results, verification commands/results, review findings, blockers, and linked Scope Change or Exception Records.
- **Revision and Handoff Evidence**: Branch, exact revision, latest checkpoint/handoff links, and evidence that the working tree matches the reviewed scope.
- **CI and Completion Evidence**: CI provider/workflow/job/run references, validator results when available, commit evidence, and the required completion or milestone decision.
- **Risk and Rollback**: Preserve the existing migration safety, risk, and rollback requirements. Do not smuggle scope expansion into the PR body; record it first.

A consistent Task Record or validator result proves durable evidence consistency only. It does not approve opening or merging a remote pull request. Preserve the optional `gh pr create` path in Phase 4, but require explicit developer approval before executing it.

---

### Execution-Control PR Evidence Template

For Controlled Work, use the optional **Execution-Control Traceability** section in `templates/pull-request-template.md` to link the Task ID and canonical record, `awaiting_review` state, acceptance results, exact revision, checkpoint/handoff, CI, blockers, scope changes, and exceptions. For Trivial Work, record `N/A`. Keep `gh pr create` optional and explicitly developer-approved; a passing validator or CI job supports traceability only and does not approve opening, merging, shipping, or deploying the PR.

---

### Phase 3: PR Body Generation

Structure the PR description using `templates/pull-request-template.md`:

1. **Title**: Follow Conventional Commits format (`type(scope): concise summary under 72 chars`).
2. **Summary**: Group changes by architectural layer (Data, Backend, Frontend, Config).
3. **Database Checklist**: State whether migrations are present and verify Expand-Contract safety.
4. **Testing Evidence**: Paste test runner pass counts and provide numbered manual testing steps.
5. **Rollback Strategy**: Document whether this PR is zero-state reversible or requires step-by-step database rollbacks.
6. **Reviewer Focus**: Point reviewers to the most load-bearing lines or complex logic.

---

### Phase 4: Submission or CLI Creation

Provide the generated PR description to the developer in two formats:

1. **Markdown Document**: For copy-pasting directly into GitHub, GitLab, or Bitbucket web interfaces.
2. **GitHub CLI Command (`gh pr create`)**:
   Offer a pre-formatted CLI command to open the PR immediately:
   ```bash
   gh pr create --title "<type>(<scope>): <summary>" --body-file pr-body.md
   ```
   *(Or interactive `gh pr create --web`)*.
