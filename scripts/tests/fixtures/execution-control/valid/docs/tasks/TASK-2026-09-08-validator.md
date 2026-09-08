# Task Record: Validator contract

## 1. Identity and Authority

- **Record Type**: `Task Record`
- **Task ID**: TASK-2026-09-08-validator
- **Specification**: `.kiro/specs/agent-execution-control-handoff/`
- **External Reference (Optional)**: N/A
- **Owner / Actor**: Validator maintainer
- **Execution Scope**: Better-PromptKit repository
- **Approval Boundary**: Human approval required before remote or release action
- **Created**: 2026-09-08 13:20 UTC

## 2. Objective and Boundaries

- **Objective**: Validate durable execution-control records without mutation.
- **In Scope**:
  - `scripts/validate-execution-control.sh`
  - `scripts/validate-execution-control.ps1`
- **Explicit Non-Goals**:
  - No Git, remote, release, deployment, or task-record mutation.
- **Dependencies**: None
- **Risk**: Low - parser behavior is covered by deterministic local fixtures.
- **Verification Condition**: Both validators return equivalent results for the fixture matrix.

## 3. Acceptance Criteria

- [x] **AC-1**: Valid records return exit code 0 on Bash and PowerShell.
  - **Result**: Pass
  - **Evidence**: Bash and PowerShell fixture smoke commands.
- [x] **AC-2**: Invalid records identify a stable category, record ID, path, and remediation.
  - **Result**: Pass
  - **Evidence**: Negative fixture diagnostics.

## 4. Execution Policy

- **Mode**: `Gated Mode`
- **Batch Authorization**: N/A
- **Soft Checkpoint**: Around 60 minutes
- **Hard Checkpoint**: At or before 90 minutes
- **Event-Driven Checkpoints**: Milestone, task switch, scope expansion, handoff, compaction, or context drift
- **Stop Conditions**: Missing approval/context, failed verification/CI/invariant, blocker, hard checkpoint, or developer stop
- **Host Timer Capability**: Host timer limitation recorded; the validator cannot forcibly terminate generation.

## 5. State and Active Ownership

- **Execution State**: `completed`
- **Mapped `pk:tasks` Status**: `Done`
- **Active Task Pointer**: None
- **Start Time**: 2026-09-08 13:20 UTC
- **Current Actor**: Validator maintainer
- **Next Action**: Preserve the validated evidence and await review.

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| N/A | planned | 2026-09-08 13:20 UTC | Validator maintainer | Record created | Task Record |
| planned | ready | 2026-09-08 13:21 UTC | Validator maintainer | Readiness fields complete | AC-1 |
| ready | in_progress | 2026-09-08 13:22 UTC | Validator maintainer | Work started | Verification condition |
| in_progress | awaiting_review | 2026-09-08 13:35 UTC | Validator maintainer | Evidence ready | CI evidence |
| awaiting_review | completed | 2026-09-08 13:40 UTC | Validator maintainer | Completion gate passed | PR evidence |

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `scripts/validate-execution-control.sh` - Bash validator.
  - `scripts/validate-execution-control.ps1` - PowerShell validator.
- **Scope Change Records**: docs/tasks/TASK-2026-09-08-validator.scope-1.md
- **Checkpoint Records**: docs/tasks/TASK-2026-09-08-validator.checkpoint-1.md
- **Handoff Records**: docs/tasks/TASK-2026-09-08-validator.handoff-1.md
- **Verification Evidence**: Bash and PowerShell validators returned 0 for the valid fixture.
- **CI Evidence**: Local CI-equivalent smoke result passed on REV-VALID-001.
- **Review Evidence**: Cross-platform contract review completed.
- **Commit Evidence**: REV-VALID-001 contains the validator implementation.
- **Pull Request Evidence**: PR-VALIDATOR-001 review evidence recorded.
- **Release Evidence**: N/A
- **Blocker and Resume Condition**: None
- **Completion State**: completed
- **Acceptance Results**: AC-1 Pass; AC-2 Pass.
- **Changed-File Summary**: Added paired read-only validators.
- **Completion Exception**: None
- **Completion Decision and Timestamp**: Completed by Validator maintainer at 2026-09-08 13:40 UTC.
- **Branch / Revision**: feature/agent-execution-control-validator @ REV-VALID-001
