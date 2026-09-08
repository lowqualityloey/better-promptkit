# Task Record: [Short controlled-work objective]

## 1. Identity and Authority

- **Record Type**: `Task Record`
- **Task ID**: `TASK-[YYYY-MM-DD]-[slug]`
- **Specification**: `docs/specs/[specification].md` or `.kiro/specs/[specification]/`
- **External Reference (Optional)**: `[Issue, ticket, or N/A]`
- **Owner / Actor**: `[Person, role, or agent]`
- **Execution Scope**: `[Repository, workspace, package, or session boundary]`
- **Approval Boundary**: `[Actions requiring explicit human confirmation]`
- **Created**: `[YYYY-MM-DD HH:MM UTC]`

> This Local Task Source is authoritative for Controlled Work. External trackers and `docs/STATE.md` are references or synchronized projections, not alternate task authority.

## 2. Objective and Boundaries

- **Objective**: `[One observable objective]`
- **In Scope**:
  - `[File, behavior, or deliverable included]`
- **Explicit Non-Goals**:
  - `[File, behavior, release action, or independent concern excluded]`
- **Dependencies**: `[Dependency and owner, or None]`
- **Risk**: `[Low | Medium | High]` - `[Risk summary and mitigation]`
- **Verification Condition**: `[Command, check, artifact assertion, or explicit not-applicable reason]`

## 3. Acceptance Criteria

- [ ] **AC-1**: `[Observable acceptance condition]`
  - **Result**: `[Pending]`
  - **Evidence**: `[Command, check, artifact, or link]`
- [ ] **AC-2**: `[Observable acceptance condition]`
  - **Result**: `[Pending]`
  - **Evidence**: `[Command, check, artifact, or link]`

## 4. Execution Policy

- **Mode**: `Gated Mode` <!-- Use Approved Batch Mode only with a linked Batch Authorization. -->
- **Batch Authorization**: `[docs/tasks/batch-[batch-id].md or N/A]`
- **Soft Checkpoint**: `[Around 60 minutes, configured alternative, or N/A with reason]`
- **Hard Checkpoint**: `[At or before 90 minutes, configured alternative, or N/A with reason]`
- **Event-Driven Checkpoints**: `Milestone, task switch, scope expansion, handoff, compaction, or context drift`
- **Stop Conditions**: `Missing approval/context, failed verification/CI/invariant, blocker, hard checkpoint, or developer stop`
- **Host Timer Capability**: `[Observed capability and limitation; do not claim mechanical enforcement when unavailable]`

## 5. State and Active Ownership

- **Execution State**: `planned` <!-- planned | ready | in_progress | checkpoint_due | blocked | paused | handoff_ready | awaiting_review | completed | aborted -->
- **Mapped `pk:tasks` Status**: `To Do` <!-- To Do | In Progress | In Review | Done -->
- **Active Task Pointer**: `[This Task ID while in_progress, otherwise None]`
- **Start Time**: `[YYYY-MM-DD HH:MM UTC or N/A]`
- **Current Actor**: `[Person, role, or agent]`
- **Next Action**: `[Exactly one prioritized action]`

### Transition History

| Previous State | New State | Timestamp | Actor | Reason | Supporting Evidence |
|---|---|---|---|---|---|
| `[State]` | `[State]` | `[YYYY-MM-DD HH:MM UTC]` | `[Actor]` | `[Reason]` | `[Link or N/A]` |

A task cannot enter `ready` until its objective, scope, non-goals, acceptance criteria, dependencies, verification condition, owner/approval boundary, and execution policy are complete. It cannot enter `in_progress` until readiness, start time, execution scope, and active ownership are recorded. Only one task may hold the active pointer in this Execution Scope.

## 6. Evidence and Completion Gate

- **Changed Files**:
  - `[path]` - `[summary]`
- **Scope Change Records**: `[docs/tasks/[task-id].scope-[sequence].md or None]`
- **Checkpoint Records**: `[docs/tasks/[task-id].checkpoint-[sequence].md or None]`
- **Handoff Records**: `[docs/tasks/[task-id].handoff-[sequence].md or None]`
- **Verification Evidence**: `[Commands and results]`
- **CI Evidence**: `[Provider, workflow/job, run, revision, result, or N/A]`
- **Review Evidence**: `[Review report, reviewer, result, or N/A]`
- **Commit Evidence**: `[Commit SHA and message, or N/A before commit]`
- **Pull Request Evidence**: `[PR URL/number, or N/A before PR]`
- **Release Evidence**: `[Release evaluation/tag/post-release link, or N/A]`
- **Blocker and Resume Condition**: `[Blocker, owner, evidence, and precise resume condition, or None]`

### Completion Decision

- **Completion State**: `[awaiting_review | completed | blocked | paused | aborted]`
- **Acceptance Results**: `[AC-1 result; AC-2 result; ...]`
- **Changed-File Summary**: `[Complete summary]`
- **Completion Exception**: `[docs/tasks/[task-id].exception-[sequence].md, approver and reason, or None]`
- **Completion Decision and Timestamp**: `[Decision, actor, and YYYY-MM-DD HH:MM UTC]`

A task may be marked `completed` only after acceptance results, verification evidence, changed-file summary, and required commit evidence are linked. Major milestones also require pull-request evidence or an explicit human-confirmed not-applicable exception. A passing validator does not authorize remote, release, deployment, or rollback actions.
