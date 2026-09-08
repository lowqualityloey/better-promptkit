# Task Record: Illegal transition fixture

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-illegal-transition
- **Specification**: `synthetic-fixture`
- **External Reference (Optional)**: N/A
- **Owner / Actor**: Fixture validator
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 14:00 UTC
- **Objective**: Demonstrate a transition that skips the required execution state.
- **In Scope**:
  - `fixture/illegal-transition.md`
- **Explicit Non-Goals**:
  - No remote, release, deployment, or task-record mutation.
- **Dependencies**: None
- **Risk**: Low - deterministic local fixture.
- **Verification Condition**: Run the native validator against this fixture.
- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Transition checkpoint
- **Stop Conditions**: Failed verification or invalid transition
- **Host Timer Capability**: Host timer limitation recorded; live generation cannot be forcibly terminated.
- **Execution State**: `completed`
- **Mapped `pk:tasks` Status**: `Done`
- **Active Task Pointer**: None
- **Start Time**: 2026-09-08 14:02 UTC
- **Current Actor**: Fixture validator
- **Next Action**: Correct the transition history before accepting completion.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 14:00 UTC | Fixture validator | Record created | Task Record |
| planned | ready | 2026-09-08 14:01 UTC | Fixture validator | Readiness fields complete | AC-1 |
| ready | completed | 2026-09-08 14:02 UTC | Fixture validator | Invalid shortcut | Completion evidence |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `fixture/illegal-transition.md` - Synthetic fixture input.
- **Scope Change Records**: None
- **Checkpoint Records**: None
- **Handoff Records**: None
- **Verification Evidence**: Synthetic completion evidence is present.
- **CI Evidence**: Local synthetic case.
- **Review Evidence**: Synthetic review evidence.
- **Commit Evidence**: REV-CASE-001.
- **Pull Request Evidence**: PR-CASE-001.
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: None
- **Completion State**: completed
- **Acceptance Results**: AC-1 Pass - completion evidence is present.
- **Changed-File Summary**: Synthetic transition fixture.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Completed by Fixture validator at 2026-09-08 14:03 UTC.
- **Branch / Revision**: fixture-matrix @ REV-CASE-001
