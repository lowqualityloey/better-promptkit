# Task Record: Scope expansion fixture

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-scope-expansion
- **Specification**: `synthetic-fixture`
- **External Reference (Optional)**: N/A
- **Owner / Actor**: Fixture validator
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 14:00 UTC
- **Objective**: Demonstrate changed evidence outside the declared scope without approval.
- **In Scope**:
  - `fixture/in-scope.txt`
- **Explicit Non-Goals**:
  - No remote, release, deployment, or task-record mutation.
- **Dependencies**: None
- **Risk**: Low - deterministic local fixture.
- **Verification Condition**: Run the native validator against this fixture.
- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Scope-expansion checkpoint
- **Stop Conditions**: Scope change without approval
- **Host Timer Capability**: Host timer limitation recorded; live generation cannot be forcibly terminated.
- **Execution State**: `in_progress`
- **Mapped `pk:tasks` Status**: `In Progress`
- **Active Task Pointer**: TASK-2026-09-08-scope-expansion
- **Start Time**: 2026-09-08 14:02 UTC
- **Current Actor**: Fixture validator
- **Next Action**: Record approved scope before changing the out-of-scope file.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 14:00 UTC | Fixture validator | Record created | Task Record |
| planned | ready | 2026-09-08 14:01 UTC | Fixture validator | Readiness fields complete | AC-1 |
| ready | in_progress | 2026-09-08 14:02 UTC | Fixture validator | Work started | Verification condition |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `fixture/out-of-scope.txt` - Unapproved expansion.
- **Scope Change Records**: None
- **Checkpoint Records**: None
- **Handoff Records**: None
- **Verification Evidence**: Pending negative validation.
- **CI Evidence**: Local synthetic case.
- **Review Evidence**: N/A
- **Commit Evidence**: N/A
- **Pull Request Evidence**: N/A
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: None
- **Completion State**: Pending
- **Acceptance Results**: AC-1 pending negative result.
- **Changed-File Summary**: Synthetic scope expansion fixture.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Pending
- **Branch / Revision**: fixture-matrix @ REV-CASE-001
