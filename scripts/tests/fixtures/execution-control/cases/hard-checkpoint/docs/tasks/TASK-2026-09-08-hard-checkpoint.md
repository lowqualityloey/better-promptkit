# Task Record: Hard checkpoint fixture

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-hard-checkpoint
- **Specification**: `synthetic-fixture`
- **External Reference (Optional)**: N/A
- **Owner / Actor**: Fixture validator
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 14:00 UTC
- **Objective**: Demonstrate a hard checkpoint state without its durable checkpoint record.
- **In Scope**:
  - `fixture/hard-checkpoint.md`
- **Explicit Non-Goals**:
  - No remote, release, deployment, or task-record mutation.
- **Dependencies**: None
- **Risk**: Low - deterministic local fixture.
- **Verification Condition**: Run the native validator against this fixture.
- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Hard checkpoint due
- **Stop Conditions**: Hard checkpoint due
- **Host Timer Capability**: Host timer limitation recorded; live generation cannot be forcibly terminated.
- **Execution State**: `checkpoint_due`
- **Mapped `pk:tasks` Status**: `In Progress`
- **Active Task Pointer**: None
- **Start Time**: 2026-09-08 14:02 UTC
- **Current Actor**: Fixture validator
- **Next Action**: Create the checkpoint record before resuming implementation.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 14:00 UTC | Fixture validator | Record created | Task Record |
| planned | ready | 2026-09-08 14:01 UTC | Fixture validator | Readiness fields complete | AC-1 |
| ready | in_progress | 2026-09-08 14:02 UTC | Fixture validator | Work started | Verification condition |
| in_progress | checkpoint_due | 2026-09-08 14:03 UTC | Fixture validator | Hard checkpoint is due | Stop condition |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `fixture/hard-checkpoint.md` - Synthetic fixture input.
- **Scope Change Records**: None
- **Checkpoint Records**: None
- **Handoff Records**: None
- **Verification Evidence**: Pending checkpoint creation.
- **CI Evidence**: Local synthetic case.
- **Review Evidence**: N/A
- **Commit Evidence**: N/A
- **Pull Request Evidence**: N/A
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: Checkpoint record must be created before resuming.
- **Completion State**: Pending
- **Acceptance Results**: AC-1 pending checkpoint evidence.
- **Changed-File Summary**: Synthetic hard-checkpoint fixture.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Pending
- **Branch / Revision**: fixture-matrix @ REV-CASE-001
