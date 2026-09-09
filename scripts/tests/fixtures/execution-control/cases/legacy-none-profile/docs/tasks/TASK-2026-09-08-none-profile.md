# Task Record: None profile fixture

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-none-profile
- **PromptKit Adaptation Profile**: `none`
- **Work Type**: `Not a valid Adaptation work type`
- **Planning Record Link**: not-a-link
- **TDD Enforcement Mode**: `not-a-mode`
- **Specification**: `synthetic-legacy-fixture`
- **Owner / Actor**: Legacy fixture
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 15:00 UTC
- **Objective**: Confirm the none profile uses legacy validation.
- **In Scope**:
  - `fixture/legacy-none-profile.md`
- **Explicit Non-Goals**:
  - No remote, release, deployment, or task-record mutation.
- **Dependencies**: None
- **Risk**: Low - deterministic local fixture.
- **Verification Condition**: Run both native validators against this fixture.
- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Milestone or context-drift checkpoint
- **Stop Conditions**: Failed verification or missing approval
- **Host Timer Capability**: Host timer limitation recorded; live generation cannot be forcibly terminated.
- **Execution State**: `ready`
- **Mapped `pk:tasks` Status**: `To Do`
- **Active Task Pointer**: None
- **Start Time**: N/A
- **Current Actor**: Legacy fixture
- **Next Action**: Run both validators and compare the expected result.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 15:00 UTC | Legacy fixture | Record created | Task Record |
| planned | ready | 2026-09-08 15:01 UTC | Legacy fixture | Readiness evaluation | AC-1 |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `fixture/legacy-none-profile.md` - Synthetic legacy fixture input.
- **Scope Change Records**: None
- **Checkpoint Records**: None
- **Handoff Records**: None
- **Verification Evidence**: Pending fixture validation.
- **CI Evidence**: Local synthetic case.
- **Review Evidence**: N/A
- **Commit Evidence**: N/A
- **Pull Request Evidence**: N/A
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: None
- **Completion State**: Pending
- **Acceptance Results**: AC-1 pending fixture result.
- **Changed-File Summary**: Synthetic legacy fixture.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Pending
- **Branch / Revision**: fixture-matrix @ REV-LEGACY-001

- [ ] **AC-1**: Both validators retain the legacy result.
