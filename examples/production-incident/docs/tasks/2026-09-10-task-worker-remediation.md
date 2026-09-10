# Task Record: Remediate notification worker duplicates

<a id="TASK-2026-09-10-task-worker-remediation"></a>

- **Record Type**: `Task Record`
- **Task ID**: `TASK-2026-09-10-task-worker-remediation`
- **PromptKit Adaptation Profile**: `none`
- **Work Type**: `Code Work`
- **Specification**: [`docs/specs/remediation.md`](../specs/remediation.md)
- **Owner / Actor**: On-call Platform Team
- **Execution Scope**: Worker retry policy, provider adapter, metrics, tests, and release configuration
- **Approval Boundary**: Release Coordinator approval before production deployment
- **Created**: `2026-09-10 09:00 UTC`

## Objective and boundaries

- **Objective**: Prevent duplicate sends during timeout-driven queue redelivery.
- **In Scope**:
  - Stable notification idempotency keys and bounded worker heartbeats.
  - Regression coverage, delivery telemetry, feature-flag rollout, and rollback verification.
- **Explicit Non-Goals**:
  - Replacing the queue implementation or notification provider.
  - Changing unrelated notification product behavior.
- **Dependencies**: On-call access to worker metrics, feature-flag configuration, and release-coordinator availability.
- **Risk**: High - remediation touches production delivery; mitigate with feature flag and staged release.
- **Verification Condition**: Regression, release, and post-deploy metric checks pass.

## Acceptance criteria

- [ ] **AC-1**: Slow provider responses do not create duplicate sends.
- [ ] **AC-2**: Redelivered jobs remain safe to process.
- [ ] **AC-3**: Rollback restores the previous worker behavior without data loss.

## Execution state

- **Mode**: `Gated Mode`
- **TDD Enforcement Mode**: `disabled`
- **Batch Authorization**: `N/A`
- **Soft Checkpoint**: `Around 60 minutes`
- **Hard Checkpoint**: `At or before 90 minutes`
- **Event-Driven Checkpoints**: `Incident milestone, task switch, scope expansion, handoff, compaction, or context drift`
- **Stop Conditions**: `Missing approval or metrics, failed verification, incident escalation, hard checkpoint, or developer stop`
- **Host Timer Capability**: `Advisory only; the host does not mechanically enforce timers`
- **Execution State**: `in_progress`
- **Mapped `pk:tasks` Status**: `In Progress`
- **Active Task Pointer**: `TASK-2026-09-10-task-worker-remediation`
- **Start Time**: `2026-09-10 09:00 UTC`
- **Current Actor**: `On-call Platform Team`
- **Next Action**: Run regression tests and verify release rollback.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-10 09:00 UTC | On-call Platform Team | Incident record created | RCA |
| planned | ready | 2026-09-10 09:10 UTC | On-call Platform Team | Remediation scope and approval boundary recorded | Acceptance criteria |
| ready | in_progress | 2026-09-10 09:15 UTC | On-call Platform Team | Feature-flagged remediation started | Incident handoff |

## Evidence and completion gate

- **Changed Files**: `worker retry handler`, `provider adapter`, `notification idempotency store`, regression tests, and release configuration.
- **Scope Change Records**: `None`
- **Checkpoint Records**: `None`
- **Handoff Records**: [`Incident handoff`](../../conversations/incident-handoff.md)
- **Verification Evidence**: `Pending regression, rollback, and post-deploy metric checks.`
- **Behavior IDs**: `N/A - TDD Enforcement Mode disabled`
- **TDD Intent Register**: `N/A - TDD Enforcement Mode disabled`
- **TDD Execution Evidence**: `N/A - TDD Enforcement Mode disabled`
- **TDD Exception Verification**: `N/A - Code Work`
- **CI Evidence**: `N/A - illustrative composite; run the regression suite before a real release.`
- **Review Evidence**: [`Incident review and handoff`](../../conversations/incident-handoff.md); remediation pending verification.
- **Commit Evidence**: `N/A - illustrative composite; no real repository commit`
- **Pull Request Evidence**: `N/A - illustrative composite; no real pull request`
- **Release Evidence**: [`Remediation checklist`](../releases/remediation-checklist.md); human Release Coordinator approval remains required.
- **Blocker and Resume Condition**: `Post-deploy metrics are unavailable; resume release evaluation when duplicate-send and retry telemetry are collected.`
- **Completion State**: `Pending`
- **Acceptance Results**: `AC-1 through AC-3 Pending.`
- **Changed-File Summary**: `Illustrative worker remediation, regression coverage, telemetry, and feature-flag changes; no source files are included in this example.`
- **Completion Exception**: `None`
- **Completion Decision and Timestamp**: `Pending verification and explicit Release Coordinator approval.`
