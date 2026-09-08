# Task Record: Revision mismatch fixture

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-revision-mismatch
- **Specification**: `synthetic-fixture`
- **External Reference (Optional)**: N/A
- **Owner / Actor**: Fixture validator
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 14:00 UTC
- **Objective**: Demonstrate a STATE projection with a stale revision.
- **In Scope**:
  - `fixture/revision-mismatch.md`
- **Explicit Non-Goals**:
  - No remote, release, deployment, or task-record mutation.
- **Dependencies**: None
- **Risk**: Low - deterministic local fixture.
- **Verification Condition**: Run the native validator against this fixture.
- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Projection checkpoint
- **Stop Conditions**: Revision mismatch
- **Host Timer Capability**: Host timer limitation recorded; live generation cannot be forcibly terminated.
- **Execution State**: `completed`
- **Mapped `pk:tasks` Status**: `Done`
- **Active Task Pointer**: None
- **Start Time**: 2026-09-08 14:02 UTC
- **Current Actor**: Fixture validator
- **Next Action**: Reconcile the STATE revision before accepting the projection.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 14:00 UTC | Fixture validator | Record created | Task Record |
| planned | ready | 2026-09-08 14:01 UTC | Fixture validator | Readiness fields complete | AC-1 |
| ready | in_progress | 2026-09-08 14:02 UTC | Fixture validator | Work started | Verification condition |
| in_progress | awaiting_review | 2026-09-08 14:03 UTC | Fixture validator | Evidence ready | Review evidence |
| awaiting_review | completed | 2026-09-08 14:04 UTC | Fixture validator | Completion gate passed | Acceptance evidence |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `fixture/revision-mismatch.md` - Synthetic fixture input.
- **Scope Change Records**: None
- **Checkpoint Records**: None
- **Handoff Records**: None
- **Verification Evidence**: Task record is complete; projection revision is intentionally stale.
- **CI Evidence**: Local synthetic case.
- **Review Evidence**: Synthetic review evidence.
- **Commit Evidence**: REV-CASE-001.
- **Pull Request Evidence**: PR-CASE-001.
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: Reconcile STATE projection revision.
- **Completion State**: completed
- **Acceptance Results**: AC-1 Pass - task evidence is complete.
- **Changed-File Summary**: Synthetic revision projection fixture.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Completed by Fixture validator at 2026-09-08 14:05 UTC.
- **Branch / Revision**: fixture-matrix @ REV-CASE-001
