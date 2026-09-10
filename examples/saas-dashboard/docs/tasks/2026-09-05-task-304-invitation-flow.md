# Task Record: Implement workspace invitation flow

<a id="TASK-2026-09-05-task-304-invitation-flow"></a>

## 1. Identity and Authority

- **Record Type**: `Task Record`
- **Task ID**: `TASK-2026-09-05-task-304-invitation-flow`
- **PromptKit Adaptation Profile**: `none`
- **Work Type**: `Code Work`
- **Planning Record Link**: [PLAN-workspace-invitations](../specs/2026-08-25-spec-workspace-invitations.md#PLAN-workspace-invitations)
- **Specification**: [`docs/specs/2026-08-25-spec-workspace-invitations.md`](../specs/2026-08-25-spec-workspace-invitations.md)
- **Owner / Actor**: Bob (Frontend Lead)
- **Execution Scope**: `apps/web` and `packages/api` invitation flow
- **Approval Boundary**: Human approval required before merge, release, or deployment
- **Created**: `2026-09-05 09:00 UTC`

## 2. Objective and Boundaries

- **Objective**: Implement a secure, single-use workspace invitation flow using Supabase magic links.
- **In Scope**:
  - Invitation creation and authorization
  - Magic-link acceptance and membership creation
  - Duplicate, expiry, revocation, and failure handling
  - Integration and end-to-end verification
- **Explicit Non-Goals**:
  - Member-management UI
  - Real-time presence
  - Production deployment
- **Dependencies**: Supabase Auth configuration and workspace RBAC capability checks
- **Risk**: High - cross-tenant authorization and duplicate acceptance can affect data integrity; mitigate with server-side checks, database constraints, and integration tests.
- **Verification Condition**: Scoped API tests, invitation integration tests, type checks, and lint checks pass.

## 3. Acceptance Criteria

- [x] **AC-1**: Authorized users can create invitations for a workspace role.
- [x] **AC-2**: Acceptance rejects expired, revoked, and previously accepted tokens.
- [x] **AC-3**: Acceptance creates one membership and marks the invitation accepted.
- [x] **AC-4**: Cross-workspace mutation attempts are rejected.
- [ ] **AC-5**: Integration and E2E verification is complete.

## 4. Execution Policy

- **Mode**: `Gated Mode`
- **TDD Enforcement Mode**: `disabled`
- **Batch Authorization**: `N/A`
- **Soft Checkpoint**: `Around 60 minutes`
- **Hard Checkpoint**: `At or before 90 minutes`
- **Event-Driven Checkpoints**: `Milestone, task switch, scope expansion, handoff, compaction, or context drift`
- **Stop Conditions**: `Missing approval/context, failed verification, blocker, hard checkpoint, or developer stop`
- **Host Timer Capability**: `Advisory only; the host does not mechanically enforce timers`

## 5. State and Active Ownership

- **Execution State**: `in_progress`
- **Mapped `pk:tasks` Status**: `In Progress`
- **Active Task Pointer**: `TASK-2026-09-05-task-304-invitation-flow`
- **Start Time**: `2026-09-05 09:00 UTC`
- **Current Actor**: `Bob (Frontend Lead)`
- **Next Action**: `Complete integration and E2E verification for the invitation flow`

## 6. Evidence and Completion Gate

- **Changed Files**: `packages/api/src/routers/workspace.ts`, invitation schema, and invitation UI
- **Scope Change Records**: `None`
- **Checkpoint Records**: `None`
- **Handoff Records**: `None`
- **Verification Evidence**: `Pending integration and E2E verification`
- **Behavior IDs**: `N/A - TDD Enforcement Mode disabled`
- **TDD Intent Register**: `N/A - TDD Enforcement Mode disabled`
- **TDD Execution Evidence**: `N/A - TDD Enforcement Mode disabled`
- **TDD Exception Verification**: `N/A - Code Work`
- **CI Evidence**: `N/A - illustrative composite; run the scoped verification commands before a real merge`
- **Review Evidence**: [`Invitation-flow review`](../../conversations/code-review-invitation-flow.md); changes requested
- **Commit Evidence**: `N/A - illustrative composite; no real repository commit`
- **Pull Request Evidence**: `N/A - illustrative composite; no real pull request`
- **Release Evidence**: `N/A - not release-critical work`
- **Blocker and Resume Condition**: `Integration and E2E verification are pending; resume when both scoped commands pass.`
- **Completion State**: `Pending`
- **Acceptance Results**: `AC-1 through AC-4 Pass; AC-5 Pending.`
- **Changed-File Summary**: `Illustrative invitation API, schema, and dialog changes; no source files are included in this example.`
- **Completion Exception**: `None`
- **Completion Decision and Timestamp**: `Pending verification and human review.`

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-05 09:00 UTC | Bob (Frontend Lead) | Record created | Planning record |
| planned | ready | 2026-09-05 09:15 UTC | Bob (Frontend Lead) | Readiness fields complete | Acceptance criteria |
| ready | in_progress | 2026-09-05 09:30 UTC | Bob (Frontend Lead) | Implementation started | Scoped verification plan |
