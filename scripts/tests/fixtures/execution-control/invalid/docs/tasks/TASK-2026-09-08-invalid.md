# Invalid Task Record: readiness and state failures

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-invalid
- **Specification**: `.kiro/specs/agent-execution-control-handoff/`
- **Owner / Actor**: Validator test
- **Execution Scope**: Synthetic fixture
- **Approval Boundary**: N/A
- **Created**: 2026-09-08 13:20 UTC
- **Objective**: [One observable objective]
- **In Scope**:
  - `[File]`
- **Explicit Non-Goals**:
  - `[File]`
- **Dependencies**: None
- **Risk**: Low
- **Verification Condition**: [Command]
- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Milestone checkpoint
- **Stop Conditions**: Failed verification
- **Host Timer Capability**: Host timer is available.
- **Execution State**: `in_progress`
- **Mapped `pk:tasks` Status**: `In Progress`
- **Active Task Pointer**: None
- **Start Time**: N/A
- **Current Actor**: Validator test
- **Next Action**: [Exactly one prioritized action]

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| ready | completed | 2026-09-08 13:20 UTC | Validator test | Invalid transition | None |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `outside/scope.txt` - Unapproved expansion.
- **Scope Change Records**: None
- **Checkpoint Records**: None
- **Handoff Records**: None
- **Verification Evidence**: None
- **CI Evidence**: None
- **Review Evidence**: None
- **Commit Evidence**: None
- **Pull Request Evidence**: None
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: None
- **Completion State**: Pending
- **Acceptance Results**: Pending
- **Changed-File Summary**: Pending
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Pending
