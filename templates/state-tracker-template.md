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
