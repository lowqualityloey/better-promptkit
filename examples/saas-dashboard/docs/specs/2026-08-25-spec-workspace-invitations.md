# Technical Design Document (RFC): Workspace Invitations

- **Author**: Alice (Tech Lead)
- **Status**: Approved
- **Created**: 2026-08-25
- **Target Release**: Milestone 3

---

## Planning Record

<a id="PLAN-workspace-invitations"></a>

- **Planning Record ID**: `PLAN-workspace-invitations`
- **Planning Depth**: `Full`
- **Owner**: Alice (Tech Lead)
- **Record Status**: `ready`
- **Local Task Record Link**: [TASK-2026-09-05-task-304-invitation-flow](../tasks/2026-09-05-task-304-invitation-flow.md#TASK-2026-09-05-task-304-invitation-flow)
- **Requested Outcome**: Allow authorized workspace members to invite users by email and assign a role.
- **Observable Completion Condition**: An invite can be created, delivered, accepted once before expiry, and converted into workspace membership.
- **Scope Boundary**: Invitation procedures, invitation persistence, email-link acceptance, member creation, and critical integration coverage. Excludes member-management UI and real-time presence.
- **Explicit Non-Goals**: Password signup, provider selection, member removal, role editing, and deployment.
- **Affected Behavioral Components**: Workspace invitation API, database invitation records, Supabase Auth link flow, and acceptance integration tests.
- **Externally Visible Contracts**: Invitation creation and acceptance procedures, email link behavior, and role assignment.
- **Failure or Rollback Considerations**: Enforce workspace authorization, single-use expiry, bounded mutation scope, duplicate prevention, and rollback-safe schema changes.
- **Verification Approach**: Run scoped API tests, invitation-flow integration tests, type checks, and lint checks.
- **Assumption Records**: None.

## Requirements

- **R1**: Authorized workspace members can invite an email address with a supported role.
- **R2**: The system sends a time-limited magic link.
- **R3**: Expired, revoked, or already accepted links are rejected.
- **R4**: Acceptance creates exactly one workspace membership.
- **R5**: Duplicate active invitations are prevented atomically.
- **R6**: Authorization is enforced at the API boundary.
- **R7**: Invitation mutations have integration coverage for success and failure paths.

## Data and Migration Strategy

Use the Expand-Contract pattern for invitation schema changes. Add nullable fields or new tables first, backfill and dual-write while reads migrate, then remove obsolete paths only after all running services no longer reference them. Active invitations require a database-level uniqueness guard over workspace and email.

## Milestones

1. Define invitation schema and uniqueness constraints.
2. Implement authorized creation and magic-link delivery.
3. Implement token validation and membership creation.
4. Add integration tests, review, and scoped verification.
