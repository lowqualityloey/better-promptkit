# Task Record: Adaptation validator fixture

<a id="TASK-adaptation-validator"></a>

- **Record Type**: `Task Record`
- **Task ID**: TASK-adaptation-validator
- **PromptKit Adaptation Profile**: `sdlc-overlay-v1`
- **Work Type**: `Code Work`
- **Specification**: `synthetic-adaptation-fixture`
- **Planning Record Link**: [PLAN-adaptation-validator](../specs/adaptation-validator.md#PLAN-adaptation-validator)
- **Planning Depth Reference**: `Minimal`
- **Assumption Record Links**: [ASSUMPTION-adaptation-validator-001](../specs/adaptation-validator.md#ASSUMPTION-adaptation-validator-001)
- **TDD Enforcement Mode**: `disabled`
- **Owner / Actor**: Adaptation fixture
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 15:00 UTC
- **Objective**: Validate an opted-in Adaptation Task Record.
- **In Scope**:
  - `fixture/adaptation-validator.md`
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
- **Current Actor**: Adaptation fixture
- **Next Action**: Run both validators and compare the expected result.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 15:00 UTC | Adaptation fixture | Record created | Task Record |
| planned | ready | 2026-09-08 15:01 UTC | Adaptation fixture | Readiness evaluation | AC-1 |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `fixture/adaptation-validator.md` - Synthetic Adaptation fixture input.
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
- **Acceptance Results**: AC-1 pending fixture result.
- **Changed-File Summary**: Synthetic Adaptation fixture.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Pending
- **Branch / Revision**: fixture-matrix @ REV-ADAPTATION-001

- [ ] **AC-1**: Both validators accept the profile and local links.
