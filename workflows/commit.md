# Atomic Conventional Commit Workflow

## Fast Shorthand
Trigger anytime with: `pk:commit` (or `/pk-commit`)

## Mission
Transform uncommitted workspace diffs into clean, atomic, high-signal Conventional Commits. Prevent accidental secret leaks, purge temporary debug probes, and enforce single-concern commit boundaries.

---

## Preconditions
- Active Git repository with uncommitted changes (`git status -s` shows modifications).
- Code compiles, passes relevant linter checks, and adheres to `protocols/code-quality-gate.md`.

---

## 5-Phase Commit Protocol

```text
┌─────────────────────────────────────────────────────────────┐
│                   PK:COMMIT LIFECYCLE                       │
├──────────────┬──────────────┬──────────────┬────────────────┤
│ Phase 1:     │ Phase 2:     │ Phase 3:     │ Phase 4:       │
│ Pre-Flight   │ Atomic Group │ Conventional │ Developer      │
│ Hygiene Scan │ & Staging    │ Message Spec │ Confirmation   │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

---

### Phase 1: Pre-Flight Hygiene Scan

Before staging any file, run these 4 safety checks:

1. **Secret & Credential Scan**:
   Verify no sensitive files or environment variables are staged:
   ```bash
   git status -s | grep -E '\.env|\.pem|\.key|credentials|secret' || true
   ```
   If any secret files are modified or untracked, halt immediately and alert the developer.

2. **Temporary Probe Purge**:
   Verify that temporary debug logs or probes (`[DEBUG-xxxx]`) from `pk:debug` are removed:
   ```bash
   git grep -E '\[DEBUG-|console\.log\("DEBUG|dbg!\(' || true
   ```
   If temporary probes remain, remove them before committing.

3. **Untracked File Inspection**:
   Inspect untracked files (`??` in `git status -s`). Ensure scratch scripts or build output folders are added to `.gitignore` rather than accidentally committed.

4. **Quality Gate Verification**:
   Verify that relevant unit tests and typechecks pass (`pnpm tsc --noEmit`, `npm test`, or commands defined in `PROMPTKIT.md`).

---

### Phase 2: Atomic Staging (One Concern Per Commit)

Senior Git history is **atomic**: each commit represents a single, complete, reversible logical change. Never bundle unrelated concerns into a single massive commit.

If a session touched multiple layers, propose splitting into sequential commits:

| Layer / Concern | Included Changes | Example Scope |
| :--- | :--- | :--- |
| **Data & Migrations** | Schema files, migrations, RLS policies, seed fixtures | `db`, `schema`, `migration` |
| **Backend & Contracts**| Server actions, endpoints, API contracts, domain services | `api`, `auth`, `server` |
| **Frontend & UI** | Components, hooks, design tokens, responsive styles | `ui`, `design`, `client` |
| **Testing & Fixtures** | Unit tests, Playwright specs, mock factories | `test`, `e2e` |
| **Infrastructure & CI**| GitHub Actions, Dockerfiles, package dependencies | `ci`, `deps`, `config` |
| **Documentation** | RFC specs, ADRs, post-mortems, README updates | `docs`, `adr`, `spec` |

**Staging Rule**:
Explicitly stage only the files relevant to the active atomic concern. Avoid blind `git add .` when multi-concern changes are present.

---

### Phase 3: Conventional Commit Specification (v1.0.0)

Format all commit messages strictly according to the Conventional Commits specification:

```text
<type>(<scope>): <imperative summary in lowercase, max 72 chars>

- <Context: Why was this change necessary?>
- <Mechanism: Key architectural decision or implementation detail>
- <Impact: Any side effects, schema shifts, or follow-ups required>

[BREAKING CHANGE: <explanation of breaking change and migration path>]
[Closes #<issue-number>]
```

#### Valid Commit Types:
* `feat`: New user-facing capability or API feature
* `fix`: Bug fix, defect resolution, or regression patch
* `refactor`: Structural rewrite that neither fixes a bug nor adds a feature
* `test`: Adding missing tests or correcting existing test suites
* `docs`: Documentation-only updates (ADRs, RFCs, READMEs)
* `perf`: Code change that improves runtime performance or reduces memory usage
* `style`: White-space, formatting, semicolon, or lint fixes (no production logic change)
* `chore`: Build tasks, package updates, configuration tweaks, or tooling maintenance

#### Summary Rules:
* Use the imperative, present tense: "add" not "added", "fix" not "fixing".
* No trailing period in the first line.
* Keep the first line under 72 characters.
* Always lowercase type and scope.

---

### Phase 4: High-Signal Commit Examples

#### Example 1: Database Migration with Invariant
```text
feat(data): add composite index and RLS policy for organization workspaces

- Add composite index on (org_id, created_at DESC) to speed up workspace queries
- Add Postgres RLS policy restricting workspace access to active organization members
- Scaffold migration file using Expand-Contract pattern
```

#### Example 2: Bug Fix with Root Cause Context
```text
fix(auth): handle expired OAuth refresh token race condition

- Wrap token refresh logic in a mutex lock to prevent concurrent token invalidation
- Add 5-second leeway buffer to token expiration validation
- Purge stale session cookies on refresh failure to force clean re-login

Closes #128
```

#### Example 3: Documentation and ADR
```text
docs(adrs): record decision to adopt UUIDv7 for primary keys

- Document performance benchmark against UUIDv4 in docs/adrs/0003-uuidv7.md
- Record trade-offs on B-tree index fragmentation and sequential sorting
```

---

### Phase 5: Developer Confirmation & Execution

1. Present the staged files and the complete proposed commit message to the developer.
2. If multiple concerns exist, explain the proposed commit sequence.
3. Upon developer confirmation, run the commit command:
   ```bash
   git add <staged-files>
   git commit -m "<subject>" -m "<body-paragraphs>"
   ```
4. Confirm commit creation with `git log -n 1 --stat`.
