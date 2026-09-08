# Task Record: Duplicate active fixture B

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-duplicate-active-b
- **Specification**: `synthetic-fixture`
- **External Reference (Optional)**: N/A
- **Owner / Actor**: Fixture validator
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 14:00 UTC
- **Objective**: Demonstrate two active tasks in one execution scope.
- **In Scope**:
  - `fixture/duplicate-active-b.md`
- **Explicit Non-Goals**:
  - No remote, release, deployment, or task-record mutation.
- **Dependencies**: None
- **Risk**: Low - deterministic local fixture.
- **Verification Condition**: Run the native validator against this fixture.
- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Task ownership checkpoint
- **Stop Conditions**: More than one active task
- **Host Timer Capability**: Host timer limitation recorded; live generation cannot be forcibly terminated.
- **Execution State**: `in_progress`
- **Mapped `pk:tasks` Status**: `In Progress`
- **Active Task Pointer**: TASK-2026-09-08-duplicate-active-b
- **Start Time**: 2026-09-08 14:03 UTC
- **Current Actor**: Fixture validator B
- **Next Action**: Clear the competing active task before continuing.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 14:00 UTC | Fixture validator B | Record created | Task Record |
| planned | ready | 2026-09-08 14:01 UTC | Fixture validator B | Readiness fields complete | AC-1 |
| ready | in_progress | 2026-09-08 14:03 UTC | Fixture validator B | Work started | Verification condition |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `fixture/duplicate-active-b.md` - Synthetic fixture input.
- **Scope Change Records**: None
- **Checkpoint Records**: None
- **Handoff Records**: None
- **Verification Evidence**: Active ownership is intentionally duplicated.
- **CI Evidence**: Local synthetic case.
- **Review Evidence**: N/A
- **Commit Evidence**: N/A
- **Pull Request Evidence**: N/A
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: None
- **Completion State**: Pending
- **Acceptance Results**: AC-1 pending negative result.
- **Changed-File Summary**: Second synthetic active task.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Pending
- **Branch / Revision**: fixture-matrix @ REV-CASE-001
