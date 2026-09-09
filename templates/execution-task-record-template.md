# Task Record: [Short controlled-work objective]

<!-- Replace the example anchor with the immutable Task ID. For an Adaptation record use the `TASK-<task-slug>` form; for a legacy record preserve `TASK-YYYY-MM-DD-<slug>`. Derived IDs use the same full task slug. -->
<a id="TASK-task-slug"></a>

## 1. Identity and Authority

- **Record Type**: `Task Record`
- **Task ID**: `TASK-<task-slug>` for `sdlc-overlay-v1`; preserve `TASK-YYYY-MM-DD-<slug>` for legacy/no-profile records
- **Work Type**: `Code Work | Documentation Work | Configuration Work | Research Work`; ambiguous work follows Code Work until clarified
- **Specification**: `docs/specs/[specification].md` or `.kiro/specs/[specification]/`
- **Planning Record Link**: `[PLAN-<spec-slug>](../specs/<specification>.md#PLAN-<spec-slug>)`; required for new Adaptation Controlled Work, or `N/A` for legacy/no-adaptation records
- **Planning Depth Reference (Optional)**: `[Minimal | Full | N/A]`
- **Assumption Record Links (Optional)**: `[ASSUMPTION-<spec-slug>-<nnn>](../specs/<specification>.md#ASSUMPTION-<spec-slug>-<nnn>)`, `None`, or `N/A`
- **External Reference (Optional)**: `[Issue, ticket, or N/A]`
- **Owner / Actor**: `[Person, role, or agent]`
- **Execution Scope**: `[Repository, workspace, package, or session boundary]`
- **Approval Boundary**: `[Actions requiring explicit human confirmation]`
- **Created**: `[YYYY-MM-DD HH:MM UTC]`

> This Local Task Source is authoritative for Controlled Work. Planning Record and Assumption Record links provide context only; they do not control readiness, execution state, active ownership, completion, or approval. Existing records remain valid when these optional traceability fields are absent.
>
> The optional `PromptKit Adaptation Profile: none | sdlc-overlay-v1` validator boundary is deferred to the later Adaptation validator work. Do not require it for legacy records or use it to reinterpret the execution-policy `Mode`.

## 2. Objective and Boundaries

> When a linked Planning Record uses `Minimal`, map Requested Outcome to **Objective**, Observable Completion Condition to **Acceptance Criteria** and **Verification Condition**, and Scope Boundary to **In Scope** and **Explicit Non-Goals**. These mappings seed the record; every readiness field below remains required before `ready` or `in_progress`.

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

- **Mode**: `Gated Mode` <!-- Use Approved Batch Mode only with a linked Batch Authorization. This is execution policy, not TDD mode. -->
- **TDD Enforcement Mode**: `disabled` <!-- enabled is opt-in for Code Work; an absent field defaults to disabled. The Task Record owns this field. -->
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
- **Behavior IDs**: `[BEHAVIOR-<task-slug>-<nnn> links, or N/A - TDD disabled or non-Code Work]`
- **TDD Execution Evidence**: `[TDD-EXEC-<task-slug>-<behavior-seq> entries with Red, Green, Refactor commands/results and status, or N/A - TDD Enforcement Mode disabled]`
- **TDD Exception Verification**: `[Exception verification link and reason for Documentation, Configuration, or Research Work, or N/A - Code Work]`
- **CI Evidence**: `[Provider, workflow/job, run, revision, result, or N/A]`
- **Review Evidence**: `[REVIEW-<review-slug>](../reviews/<review-slug>.md#REVIEW-<review-slug>); reviewer; result; or N/A]`
- **Commit Evidence**: `[Commit SHA and message, or N/A before commit]`
- **Pull Request Evidence**: `[PR URL/number, or N/A before PR]`
- **Release Evidence**: `[Release evaluation/tag/post-release link, or N/A]`
- **Blocker and Resume Condition**: `[Blocker, owner, evidence, and precise resume condition, or None]`

### TDD Execution Evidence Shape

Use one block per enabled Code Work behavior. The Local Task Record is authoritative for execution evidence; the test plan is a supporting intent reference.

<!-- Replace the example anchors with each immutable execution and behavior ID. -->
<a id="TDD-EXEC-task-slug-001"></a>
<a id="BEHAVIOR-task-slug-001"></a>

- **Execution ID [Required when enabled]**: `TDD-EXEC-<task-slug>-<behavior-seq>`
- **Behavior ID [Required when enabled]**: `BEHAVIOR-<task-slug>-<nnn>`
- **Task Record Link [Required]**: `[TASK-<task-slug>](#TASK-<task-slug>)`
- **Red Result [Required when enabled]**: `[failing assertion, command, and result]`
- **Green Result [Required when enabled]**: `[passing result for the same behavior]`
- **Refactor Result [Required when enabled]**: `[passing result after refactor or explicit no-refactor reason]`
- **Commands and Results [Required when enabled]**: `[exact commands and observable results]`
- **Execution Status [Required when enabled]**: `planned | red_recorded | green_recorded | refactor_recorded | exception | blocked | complete`
- **Exception Verification [Not applicable for enabled Code Work]**: `[link and reason, or N/A - TDD Enforcement Mode disabled or exception work type]`



- **Completion State**: `[awaiting_review | completed | blocked | paused | aborted]`
- **Acceptance Results**: `[AC-1 result; AC-2 result; ...]`
- **Changed-File Summary**: `[Complete summary]`
- **Completion Exception**: `[docs/tasks/[task-id].exception-[sequence].md, approver and reason, or None]`
- **Completion Decision and Timestamp**: `[Decision, actor, and YYYY-MM-DD HH:MM UTC]`

A task may be marked `completed` only after acceptance results, verification evidence, changed-file summary, and required commit evidence are linked. Major milestones also require pull-request evidence or an explicit human-confirmed not-applicable exception. A passing validator does not authorize remote, release, deployment, or rollback actions.
