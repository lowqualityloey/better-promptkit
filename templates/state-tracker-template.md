# Project State & Living Execution Tracker

## 1. Executive Summary & Current Position
- **Project Name**: [Project Name]
- **Current Milestone / Epic**: [e.g., Milestone 2: Core Domain Engine]
- **Overall Status**: ACTIVE <!-- Options: ACTIVE | PAUSED | STABILIZING | RELEASE_CANDIDATE -->
- **Target Release / Deadline**: [e.g., v1.0.0 / YYYY-MM-DD]
- **Current Working Branch**: [e.g., main or feature/branch-name]
- **Last Updated**: [YYYY-MM-DD]

---

## 2. Milestone & Task Progress

### Milestone Roadmap
- [x] **Milestone 1**: Inception, Architecture & Contracts (Complete)
- [/] **Milestone 2**: Core Domain Logic & Integrations (In Progress)
- [ ] **Milestone 3**: UI, Design Tokens & Presentation Layer (Queued)
- [ ] **Milestone 4**: Performance Profiling & Hardening (Queued)
- [ ] **Milestone 5**: Release Engineering & Deployment (Queued)

### Active Milestone Task Breakdown
Track tasks using atomic checklists (`[x]` Done, `[/]` In Progress, `[ ]` Queued, `[!]` Blocked):

- [x] `TASK-01`: Define relational schema migrations and entities (`#priority/p0`)
- [x] `TASK-02`: Scaffold API contract types and error envelopes (`#priority/p1`)
- [/] `TASK-03`: Implement domain service layer and business rules (`#priority/p1`)
- [ ] `TASK-04`: Add unit and integration tests for service layer (`#priority/p1`)
- [ ] `TASK-05`: Implement error handling and edge cases (`#priority/p2`)
- [!] `TASK-06`: External API integration (BLOCKED: pending API credentials)

---

## 3. Active Working Set
- **Target Workspace / Package (if Monorepo)**: [e.g. `apps/web` or `@repo/db` (leave blank for standalone repo)]
- **Active RFC / Spec**: `docs/specs/YYYY-MM-DD-feature-name.md`
- **Active Task Spec**: `docs/tasks/YYYY-MM-DD-task-breakdown.md`
- **Key Source Files in Flight**:
  - `src/domain/service.ts`: Primary business logic implementation
  - `src/domain/types.ts`: Domain models and entity interfaces
  - `tests/domain/service.test.ts`: Active test suite
- **Verification Commands (Scoped)**:
  - Unit Tests: `npm test` (or `pnpm --filter <pkg> test`, `turbo run test --filter=<pkg>`)
  - Typecheck: `npm run typecheck` (or `pnpm --filter <pkg> typecheck`)
  - Linter: `npm run lint` (or `pnpm --filter <pkg> lint`)

---

## 3A. Execution-Control Projection (Optional)

> This section is a synchronized projection for checkpoint continuity when the host project uses Controlled Work. The canonical authority remains `docs/tasks/<task-id>.md`; disagreement with that record is a validation failure and leaves execution blocked or `checkpoint_due` until reconciled.

- **Local Task Source**: `docs/tasks/<task-id>.md`
- **Task ID**: `TASK-[YYYY-MM-DD]-[slug]`
- **Task Record**: `docs/tasks/<task-id>.md`
- **Specification**: `docs/specs/[specification].md` or `.kiro/specs/[specification]/`
- **Execution Scope**: `[Repository, workspace, package, or session boundary]`
- **Execution State**: `[planned | ready | in_progress | checkpoint_due | blocked | paused | handoff_ready | awaiting_review | completed | aborted]`
- **Mapped `pk:tasks` Status**: `[To Do | In Progress | In Review | Done]`
- **Active Task Pointer**: `[Task ID while active, otherwise None]`
- **Owner / Current Actor**: `[Person, role, agent, or session]`
- **Start Time**: `[YYYY-MM-DD HH:MM UTC or N/A]`
- **Current Branch**: `[Branch name]`
- **Current Revision**: `[Exact commit or revision]`
- **Checkpoint Policy**: `[Soft/hard intervals, event triggers, and host timer capability/limitation]`
- **Blockers and Resume Condition**: `[Blocker, owner, evidence, and precise condition, or None]`
- **Verification Status**: `[Commands, results, and timestamp]`
- **CI Evidence**: `[Provider, workflow/job, run, revision, result, or N/A]`
- **Changed-File Summary**: `[Current working set summary]`
- **Latest Checkpoint**: `[Record path or None]`
- **Latest Handoff**: `[Record path or None]`
- **Next Action**: `[Exactly one prioritized action]`

---

## 3B. Release-Evaluation Handoff (Optional)

> Use this projection only when Better-PromptKit release evaluation is being handed from QA/Reviewer to a Release Coordinator. It is a durable handoff, not approval, and the canonical evaluation or Task Record remains authoritative.

- **Evaluation ID**: `[evaluation ID or N/A]`
- **Release Candidate Commit**: `[exact candidate revision or N/A]`
- **Preliminary SemVer Candidate**: `[preliminary version, including prerelease identifier when applicable, or N/A]`
- **QA/Reviewer Result**: `[Pass | Fail | Pending | N/A]`
- **Unresolved Blockers**: `[blocker, owner, and resolution condition, or None]`
- **Requested Release Coordinator Decision / Next Approval Action**: `[exact human decision requested, or N/A]`
- **Handoff Status**: `[Ready for Coordinator Review | Blocked | Deferred | N/A]`
- **Approval Boundary**: `This projection does not approve a candidate or version and does not authorize tag creation, hosted release creation, changelog publication, remote operations, deployment, or rollback.`
- **Source Evaluation / Task Record**: `[authoritative record path or N/A]`

---

## 4. Locked Technical Invariants (Do Not Undo)
Document non-negotiable architectural decisions agreed upon during pairing sessions:
- [Invariant 1]: All database queries must enforce tenant-level isolation via Row-Level Security (RLS).
- [Invariant 2]: Presentation components must never import database clients or execute raw queries directly.
- [Invariant 3]: API responses must always conform to the unified error envelope (`{ ok: boolean, data?: T, error?: AppError }`).
- [Invariant 4]: Schema changes must follow Expand-Contract ordering to ensure zero-downtime rollouts.

---

## 5. Known Blockers, Risks & Open Questions
- **Blockers**:
  - [e.g., TASK-06 blocked on third-party API sandbox credentials from devops team]
- **Architectural Questions**:
  - [e.g., Evaluate Redis vs in-memory caching for session tokens before Milestone 4]
- **Technical Debt & Risks**:
  - [e.g., Monolithic test suite is taking >45s in CI; needs sharding before launch]

---

## 6. Recent Architectural Decisions (ADR Log)
| Date | Title & Scope | Decision Summary | ADR File |
| :--- | :--- | :--- | :--- |
| YYYY-MM-DD | Primary Key Strategy | Adopted UUIDv7 for time-ordered distributed keys | `docs/adrs/0001-uuidv7.md` |
| YYYY-MM-DD | Auth Session Storage | Enforce HttpOnly SameSite=Lax cookies over localStorage | `docs/adrs/0002-cookie-auth.md` |

---

## 7. Next Immediate Actions (Queued)
1. Complete `TASK-03`: Implement validation gate on domain service mutation handler.
2. Execute test command to transition from RED to GREEN loop.
3. Commit working changes using atomic conventional commits (`pk:commit`).

---

## 8. Session Continuity Log
Compact record of pairing sessions to enable instant chat resumption:

| Date | Engineer / Agent | Milestone / Focus | Key Changes & Artifacts |
| :--- | :--- | :--- | :--- |
| YYYY-MM-DD | Lead Engineer | Project Inception | Scaffolded repo, created PROMPTKIT.md and STATE.md |
