# Requirements Document

## Introduction

Agent Execution Control & Handoff defines a model-agnostic, documentation-first control layer for keeping an AI-assisted engineering session bounded, resumable, and accountable. The feature prevents an agent from silently starting unrelated work, continuing after a required checkpoint, losing the active working state, or claiming completion without durable task and verification evidence.

The feature extends existing Better-PromptKit workflows, especially `pk:route`, `pk:plan`, `pk:tasks`, `pk:checkpoint`, `pk:commit`, `pk:pr`, `pk:review`, and `pk:ship`. It does not replace those workflows, create a second task tracker, or act as a runtime agent orchestrator.

The minimum source of truth for controlled work is a local task record. GitHub, Jira, GitLab, Linear, or another external tracker may be synchronized optionally, but no external issue or ticket is required before work can begin. The feature applies the same execution-control model whether or not an external tracker is available.

The current Better-PromptKit release context is a preliminary First Release candidate of `v1.0.0`. This requirements document does not approve a release, create a Git tag, publish a release, or establish a new version source of truth. The eventual public-contract impact of this feature SHALL be evaluated under the Conventional Commit Versioning requirements after implementation and review.

PromptKit is an instruction layer. It can require an agent to stop, preserve state, and request confirmation, but it cannot by itself guarantee that every host model or IDE will forcibly terminate an in-progress generation. Durable artifacts, host-supported hooks, CI validation, and human review provide the enforceable boundaries where available.

## Glossary

- **Agent Execution Control**: The Better-PromptKit control layer that governs task readiness, active-task ownership, checkpoints, stop states, scope changes, evidence, and handoffs.
- **Controlled Work**: Work that can change project files, task state, project configuration, commits, pull requests, release artifacts, or other durable project state and therefore requires execution-control evidence.
- **Trivial Work**: A bounded request that can be completed in one short interaction without changing a public contract, persistent data, authorization behavior, external integration, release configuration, or more than one independent concern.
- **Task Record**: A durable record for one scoped unit of work containing its stable identifier, objective, scope, acceptance criteria, dependencies, verification condition, state, and execution evidence.
- **Local Task Source**: The task record stored in the project repository, normally under `docs/tasks/`, that is sufficient to authorize and track controlled work without an external tracker.
- **External Tracker**: An optional GitHub, Jira, GitLab, Linear, or equivalent issue or project system synchronized with a Local Task Source.
- **Task Readiness Gate**: The check that determines whether a Task Record contains enough scope, acceptance, dependency, and verification information to enter active execution.
- **Active Task**: The one Task Record in `in_progress` state for the current execution scope under the default execution mode.
- **Execution State**: The lifecycle state recorded for a Task Record or handoff.
- **Checkpoint**: A durable snapshot of workspace state, decisions, evidence, blockers, and the next action used to prevent context drift and support safe continuation.
- **Soft Checkpoint**: A checkpoint reminder and controlled pause requested around the default 60-minute execution interval or an equivalent configured threshold.
- **Hard Checkpoint**: A mandatory stop at or before the default 90-minute execution interval, after which implementation actions cannot continue until the checkpoint is recorded and execution is explicitly resumed.
- **Context Drift**: Evidence that the agent or session has lost reliable working state, including forgetting recently changed files, repeating rejected proposals, inventing unavailable symbols, contradicting locked decisions, or losing the active task boundary.
- **Stop State**: A state in which implementation actions are not permitted until a stated condition is resolved. Stop States include `checkpoint_due`, `blocked`, `paused`, `handoff_ready`, and `aborted`.
- **Scope Change Record**: A durable record of a proposed change to the current task objective, files, acceptance criteria, dependencies, or non-goals.
- **Handoff Record**: A durable, resumable summary transferred to a developer, role, agent, or fresh session.
- **Handoff Receiver**: The person, role, agent, or session that validates a Handoff Record before continuing work.
- **Verification Evidence**: A command result, CI result, review result, artifact check, or other observable evidence proving an acceptance criterion or transition condition.
- **Atomic Task**: A single, reversible logical concern that can be committed independently and is within the Task Record scope.
- **Major Milestone**: A coherent group of completed atomic tasks that produces a reviewable project outcome or crosses a workflow boundary.
- **Gated Mode**: The default execution mode in which task readiness, checkpoints, scope changes, handoffs, and completion gates require the specified evidence before continuation.
- **Approved Batch Mode**: An optional mode in which a developer explicitly authorizes a finite, predeclared list of tasks to be executed sequentially without a confirmation turn before each listed task.
- **Completion Gate**: The evidence required to move a Task Record or Major Milestone to `completed`, including acceptance, verification, review, and required commit or pull-request evidence.
- **Traceability Chain**: The linked records connecting a requirement, specification, task, acceptance criterion, test or verification, review, CI run, release, and post-release verification where applicable.
- **CI Evidence**: The CI provider, workflow, job or check name, run identifier, revision, command or result, timestamp, and relevant environment information retained for a validation result.
- **Release Evidence**: The candidate revision, release evaluation, approved version, tag decision, CI evidence, QA result, and post-release result required by the release workflow.
- **Human Confirmation**: An explicit developer or Release Coordinator approval required before an action crosses the authority boundary defined by the owning workflow.
- **Execution Scope**: The repository, workspace, task group, or session boundary within which the one-active-task rule is evaluated.

## Requirements

### Requirement 1: Establish a Task Readiness Gate

**User Story:** As a developer, I want every non-trivial task to have a durable and verifiable starting point, so that an agent cannot begin untracked work or invent its scope during execution.

#### Acceptance Criteria

1. WHEN a request is received, THE Agent Execution Control SHALL classify the request as Trivial Work or Controlled Work before selecting an execution mode.
2. WHEN work is classified as Controlled Work, THE Local Task Source SHALL contain a Task Record with a stable task identifier, objective, in-scope work, explicit non-goals, acceptance criteria, dependencies, owner or approval boundary, and a verification command or observable completion condition.
3. WHEN an External Tracker is unavailable or not selected, THE Agent Execution Control SHALL permit the Local Task Source to authorize Controlled Work without requiring a GitHub, Jira, GitLab, Linear, or equivalent ticket.
4. IF a Controlled Work Task Record lacks acceptance criteria, an explicit scope boundary, or a verification condition, THEN THE Task Readiness Gate SHALL reject the transition to `ready` or `in_progress` and SHALL identify the missing field.
5. WHEN an External Tracker is selected, THE Task Record SHALL retain the local task identifier and SHALL record the external reference without making the external tracker the sole source of execution state.
6. WHEN a request initially classified as Trivial Work expands to affect a public contract, persistent data, authorization behavior, external integration, release configuration, or multiple independent concerns, THE Agent Execution Control SHALL reclassify it as Controlled Work and require the Task Readiness Gate before further implementation actions.
7. WHEN a Controlled Work task is ready to start, THE Agent Execution Control SHALL record the readiness decision, task identifier, execution mode, and verification condition before implementation begins.

### Requirement 2: Enforce One Active Task and Explicit State Transitions

**User Story:** As a developer, I want the agent to remain focused on one active task, so that it does not silently jump to unrelated work or lose the current task boundary.

#### Acceptance Criteria

1. WHEN a Task Record passes the Task Readiness Gate, THE Agent Execution Control SHALL permit the transition from `ready` to `in_progress` only after recording the start time, execution scope, and active task identifier.
2. WHILE Gated Mode is active, THE Agent Execution Control SHALL permit no more than one `Active Task` within the current Execution Scope.
3. IF an agent attempts to start a second task while an Active Task exists, THEN THE Agent Execution Control SHALL refuse the task switch and SHALL require the current task to be completed, paused, blocked, aborted, or handed off before another task becomes active.
4. THE Agent Execution Control SHALL support the states `planned`, `ready`, `in_progress`, `checkpoint_due`, `blocked`, `paused`, `handoff_ready`, `awaiting_review`, `completed`, and `aborted`.
5. WHEN a Task Record changes state, THE Agent Execution Control SHALL record the prior state, new state, timestamp, actor or agent, reason, and supporting evidence when the transition requires evidence.
6. THE Agent Execution Control SHALL map its execution states onto the existing `pk:tasks` statuses of `To Do`, `In Progress`, `In Review`, and `Done` without creating a second independent task lifecycle.
7. IF a task has not satisfied the transition conditions for `completed`, THEN THE Agent Execution Control SHALL prevent the task from being represented as complete merely because the agent has stopped generating text or declared completion conversationally.
8. WHEN a task is paused, blocked, aborted, or handed off, THE Agent Execution Control SHALL clear the Active Task pointer before another task can become active.

### Requirement 3: Require Time-Based and Milestone Checkpoints

**User Story:** As a developer, I want the agent to checkpoint before context quality degrades, so that important decisions, files, and rejected approaches are not lost during long sessions.

#### Acceptance Criteria

1. WHILE Gated Mode is active, THE Agent Execution Control SHALL request a Soft Checkpoint around 60 minutes after the active task starts unless an explicitly recorded execution policy sets a different interval.
2. WHILE Gated Mode is active, THE Agent Execution Control SHALL require a Hard Checkpoint at or before 90 minutes after the active task starts unless an explicitly recorded execution policy sets a different interval.
3. WHEN a Major Milestone is completed, THE Agent Execution Control SHALL require a Checkpoint before starting the next Major Milestone.
4. WHEN the agent is asked to switch tasks, expand scope, hand off work, or continue after a context-compaction event, THE Agent Execution Control SHALL require a Checkpoint before the transition.
5. WHEN Context Drift is observed, THE Agent Execution Control SHALL enter `checkpoint_due` and SHALL require the agent to reconcile the current Task Record, changed files, decisions, and verification evidence before further implementation.
6. A Checkpoint SHALL record the active task identifier, objective, completed work, remaining work, changed files, branch or revision, locked decisions and invariants, verification results, CI results when available, blockers, scope changes, and exactly one prioritized next action.
7. WHEN a Soft Checkpoint is due, THE Agent Execution Control SHALL stop starting new scope, present the Checkpoint information, and request confirmation or a handoff decision before continuing beyond the current bounded action.
8. WHEN a Hard Checkpoint is due, THE Agent Execution Control SHALL enter `checkpoint_due` and SHALL prohibit further implementation edits, commits, pull-request actions, or task switches until the Checkpoint is recorded and execution is explicitly resumed.
9. IF a host IDE or model cannot technically enforce a timer, THEN THE Agent Execution Control SHALL still record the due status and required stop protocol, and SHALL not claim that the timer was mechanically enforced.

### Requirement 4: Define Stop, Blocked, Paused, and Aborted Execution

**User Story:** As a developer, I want unsafe, ambiguous, or exhausted work to stop cleanly, so that the agent does not continue making speculative changes.

#### Acceptance Criteria

1. WHEN the developer requests a stop, pause, cancellation, or handoff, THE Agent Execution Control SHALL enter the corresponding Stop State before performing additional implementation work.
2. WHEN required scope information, approval, dependency information, verification evidence, or source context is missing, THE Agent Execution Control SHALL enter `blocked` and SHALL record the missing condition.
3. WHEN a verification command, review, CI check, or required invariant fails, THE Agent Execution Control SHALL enter `blocked` or `checkpoint_due` and SHALL record the failure evidence before proposing remediation.
4. WHEN a task is in `checkpoint_due`, `blocked`, `paused`, or `aborted`, THE Agent Execution Control SHALL prohibit implementation edits and task switching until the state-specific resume condition is satisfied. Read-only diagnosis and evidence collection MAY continue when it does not change project state.
5. A blocked or paused Task Record SHALL identify the blocker, owner of the decision or resolution, evidence collected, and the precise condition required for resumption.
6. An aborted Task Record SHALL retain its completed work, changed-file list, decisions, verification results, and reason for aborting, and SHALL not be marked `completed` without an explicit reactivation decision and new completion evidence.
7. WHEN a Stop State is cleared, THE Agent Execution Control SHALL record the resumption approval, the new next action, and any changed scope or assumptions before implementation continues.
8. IF the agent cannot establish that the current files, symbols, decisions, or task scope are still valid, THEN THE Agent Execution Control SHALL prefer a Stop State and reconciliation over speculative implementation.

### Requirement 5: Control Scope Changes and Task Switching

**User Story:** As a developer, I want scope changes to be explicit and reviewable, so that the agent does not turn one task into an unbounded batch of unrelated work.

#### Acceptance Criteria

1. WHEN a proposed change affects the Task Record objective, in-scope files, acceptance criteria, dependencies, non-goals, risk, or verification condition, THE Agent Execution Control SHALL create a Scope Change Record before applying the change.
2. A Scope Change Record SHALL identify the requested change, reason, affected acceptance criteria, impact on estimate or risk, affected files or artifacts, new non-goals, and required approval.
3. WHEN a Scope Change Record expands the task beyond its original bounded concern, THE Agent Execution Control SHALL require explicit Human Confirmation or SHALL create a separate Task Record for the additional work.
4. WHEN an independent task is discovered during implementation, THE Agent Execution Control SHALL record it as a proposed or new Task Record rather than silently adding it to the Active Task.
5. WHEN a developer requests a task switch, THE Agent Execution Control SHALL require the current task to reach `paused`, `blocked`, `handoff_ready`, `completed`, or `aborted` and SHALL preserve its current evidence before switching the Active Task pointer.
6. IF an external issue or ticket is absent, THEN the lack of that external record SHALL not justify skipping the Local Task Source or the scope-change gate.
7. WHEN a task dependency changes or becomes unavailable, THE Agent Execution Control SHALL record the dependency change and SHALL move the affected task to `blocked` when continuation would violate the original scope or acceptance criteria.

### Requirement 6: Produce Validated Handoffs and Resumable State

**User Story:** As a developer or receiving agent, I want a complete handoff record, so that work can resume without re-inventing decisions or contradicting earlier evidence.

#### Acceptance Criteria

1. WHEN a task reaches a checkpoint, role boundary, session boundary, `handoff_ready`, or Major Milestone boundary, THE Agent Execution Control SHALL produce or update a Handoff Record.
2. A Handoff Record SHALL identify the task and specification, current Execution State, objective, completed milestones, remaining acceptance criteria, changed files, branch and revision, locked decisions and invariants, rejected approaches when relevant, verification commands and results, CI Evidence when available, blockers, scope changes, approvals, and one precise next action.
3. WHEN `docs/STATE.md` exists in the host project, THE Handoff Record SHALL synchronize its active task, milestone, blockers, working set, invariants, verification status, and next action with that state boundary through `pk:checkpoint`.
4. WHEN `docs/STATE.md` does not exist, THE Agent Execution Control SHALL retain the Handoff Record in the Local Task Source, identify the missing state artifact, and reference `templates/state-tracker-template.md` as the available scaffold rather than inventing an unrelated state store.
5. WHEN a Handoff Receiver begins work, THE Handoff Receiver SHALL validate the task identifier, revision, changed files, locked decisions, acceptance criteria, blockers, and next action before making implementation changes.
6. IF a Handoff Record is stale, incomplete, contradictory with the Task Record, or inconsistent with the current workspace, THEN THE Handoff Receiver SHALL mark the task `blocked` or `checkpoint_due` and SHALL reconcile the records before continuing.
7. WHEN a handoff is accepted, THE Agent Execution Control SHALL record the receiver, acceptance time, validated revision, and next action without changing the task scope implicitly.
8. A Handoff Record SHALL not represent a task as completed unless the Completion Gate has been satisfied and the required commit, review, and pull-request evidence is present or an explicit exception is recorded.

### Requirement 7: Enforce Completion, Commit, Pull-Request, and Approval Boundaries

**User Story:** As a maintainer, I want every completed unit of work to leave durable Git and review evidence, so that the agent does not forget commits or major-task pull requests.

#### Acceptance Criteria

1. WHEN an Atomic Task is completed, THE Agent Execution Control SHALL require acceptance-criteria results, verification evidence, a changed-file summary, and an atomic commit reference before marking the task `completed`, unless an explicit documented exception applies.
2. WHEN a Major Milestone is completed, THE Agent Execution Control SHALL require a pull-request reference or an explicit Human Confirmation explaining why a pull request is not applicable before marking the milestone complete.
3. THE Agent Execution Control SHALL direct commit preparation through `pk:commit` and SHALL preserve the existing Conventional Commit, atomicity, staging-hygiene, and developer-confirmation requirements owned by that workflow.
4. THE Agent Execution Control SHALL direct pull-request preparation through `pk:pr` and SHALL preserve its required change summary, acceptance evidence, test evidence, risk, and rollback information.
5. WHEN a commit or pull-request action requires remote access, repository configuration, branch protection changes, CI retries, merge, release, deployment, tag creation, or publication, THE Agent Execution Control SHALL require the owning workflow and explicit Human Confirmation before the action.
6. IF the required commit or pull-request evidence is missing, THEN THE Completion Gate SHALL leave the task or milestone in `awaiting_review`, `handoff_ready`, or another non-complete state and SHALL identify the missing action.
7. WHEN a developer deliberately elects not to create a commit or pull request for an otherwise completed task, THE Agent Execution Control SHALL require a recorded exception reason, approver, affected scope, and follow-up action.
8. THE Agent Execution Control SHALL not autonomously create or push commits, open or merge pull requests, retry remote CI, alter repository configuration, tag releases, publish releases, deploy, or roll back unless a separate owning workflow explicitly permits the action and the required Human Confirmation is recorded.

### Requirement 8: Support Gated Mode, Approved Batch Mode, and Explicit Exceptions

**User Story:** As a developer, I want strict defaults with controlled flexibility, so that routine work is safe without making every interaction unnecessarily slow.

#### Acceptance Criteria

1. THE Agent Execution Control SHALL use Gated Mode as the default for Controlled Work.
2. WHEN a developer enables Approved Batch Mode, THE Agent Execution Control SHALL record the approver, finite task list, task order or dependencies, execution scope, checkpoint policy, and stop conditions before the batch begins.
3. WHILE Approved Batch Mode is active, THE Agent Execution Control SHALL permit only the predeclared tasks, SHALL keep at most one task active at a time, and SHALL require a state and evidence update between tasks.
4. IF a task not included in the approved batch is discovered, THEN THE Agent Execution Control SHALL stop and require a Scope Change Record, a new approval, or a separate task after the batch boundary.
5. WHEN a Hard Checkpoint, blocker, failed verification, unsafe condition, or developer stop occurs during Approved Batch Mode, THE Agent Execution Control SHALL stop the batch rather than advance to the next predeclared task.
6. WHEN Trivial Work satisfies all Trivial Work conditions and does not expand during execution, THE Agent Execution Control MAY use the fast path without a full Task Record, but SHALL still preserve normal safety and human-approval boundaries.
7. WHEN an urgent incident or emergency response requires an exception to normal task ceremony, THE Agent Execution Control SHALL record the reason, scope, approver, actions taken, verification evidence, and required retrospective or follow-up task before the exception is considered closed.
8. THE Agent Execution Control SHALL not treat convenience, absence of an external issue, model preference, context-window pressure, or a requested speed-up as sufficient approval to bypass Gated Mode.

### Requirement 9: Preserve Traceability Across Workflow Artifacts

**User Story:** As a QA/Reviewer, I want execution evidence to remain connected across planning, implementation, review, and release, so that completion claims can be independently verified.

#### Acceptance Criteria

1. WHEN Controlled Work is planned, THE Agent Execution Control SHALL assign or reference stable identifiers for the planning record, Task Record, acceptance criteria, and relevant specification.
2. WHEN an acceptance criterion is evaluated, THE Task Record SHALL link it to the Verification Evidence, review result, or explicit not-applicable decision that supports its status.
3. WHEN a task is committed or reviewed, THE Task Record or Handoff Record SHALL link the relevant commit, pull request, review report, and CI Evidence when those artifacts exist.
4. WHEN a Better-PromptKit repository change is part of release evaluation, THE Agent Execution Control SHALL link the task and completion evidence to the relevant release evaluation and candidate revision under the Conventional Commit Versioning workflow.
5. THE Agent Execution Control SHALL preserve the distinction between a preliminary release candidate and an Approved Release Version and SHALL not infer or approve `v1.0.0` or any later version from task completion alone.
6. IF a required traceability link is missing, contradictory, or points to a different task or revision, THEN the affected task, handoff, review, or release evaluation SHALL be marked incomplete or blocked until the link is corrected or an explicit not-applicable reason is recorded.
7. THE Agent Execution Control SHALL reference existing `pk:plan`, `pk:tasks`, `pk:checkpoint`, `pk:commit`, `pk:pr`, `pk:review`, and `pk:ship` artifacts as the owners of their respective content rather than duplicating their full procedures.

### Requirement 10: Validate Execution Evidence Through CI/CD Gates

**User Story:** As a maintainer, I want CI/CD to detect incomplete execution control evidence, so that a task cannot appear complete merely because an agent claims that it is complete.

#### Acceptance Criteria

1. THE Agent Execution Control SHALL provide a read-only execution-control validator that repository CI/CD can run for pull requests, pushes to the protected branch, and release-candidate evaluation according to repository policy.
2. THE execution-control validator SHALL check, at minimum, Local Task Source presence for Controlled Work, stable task identifiers, one-active-task compliance, valid state transitions, required acceptance criteria, scope-change records, checkpoint completeness, handoff completeness, blocker resolution, Completion Gate evidence, and required commit or pull-request references.
3. WHEN traceability is required for a task, THE execution-control validator SHALL check the links among the requirement, specification, Task Record, acceptance criterion, verification result, review, CI Evidence, and release evidence where applicable.
4. WHEN a release candidate is evaluated, THE CI/CD evidence SHALL retain the candidate revision, workflow and job names, run identifiers, pass or fail results, timestamps, and environment information needed to reproduce the validation.
5. IF the validator detects a missing required field, invalid state transition, multiple active tasks, unresolved blocker, inconsistent revision, or absent completion evidence, THEN the CI check SHALL fail and SHALL identify the affected task identifier and remediation condition.
6. WHERE the repository has both Bash and PowerShell validation environments, THE execution-control validation behavior and failure categories SHALL remain equivalent across the two implementations.
7. THE execution-control validator SHALL be local and read-only and SHALL not create or push commits, open or merge pull requests, retry remote CI, alter repository configuration, create tags, create releases, publish changelogs, deploy, or modify task records as a side effect.
8. IF the host CI provider cannot observe live chat duration or model behavior, THEN CI SHALL report that limitation and SHALL validate only the durable execution evidence available in the repository and CI run context.
9. WHEN CI/CD validation passes for a release candidate, THE result SHALL be linkable to the release evaluation, candidate revision, QA or review result, and post-release verification without implying that an external release or deployment has occurred.
10. THE distribution-release path SHALL require explicit Release Coordinator approval before tag creation, hosted release creation, publication, remote action, or deployment, even when all execution-control CI checks pass.

### Requirement 11: Preserve Workflow Ownership, Portability, and Release Boundaries

**User Story:** As a Better-PromptKit maintainer, I want execution control to strengthen existing workflows without creating lock-in or unsafe automation, so that the system remains portable and understandable.

#### Acceptance Criteria

1. THE Agent Execution Control SHALL preserve `pk:plan` ownership of architecture and planning decisions, `pk:tasks` ownership of task decomposition and acceptance-criteria formulation, `pk:checkpoint` ownership of session-state persistence and handover generation, `pk:commit` ownership of commit construction and confirmation, `pk:pr` ownership of pull-request evidence, `pk:review` ownership of review findings, and `pk:ship` ownership of release and deployment decisions.
2. THE Agent Execution Control SHALL not require a specific AI model, IDE, framework, deployment provider, issue tracker, CI provider, database, or runtime orchestration service.
3. THE Agent Execution Control SHALL not replace `PROMPTKIT.md`, `DESIGN.md`, `docs/STATE.md`, technical specifications, ADRs, issue records, pull requests, or release records; it SHALL link and reconcile those artifacts where they participate in the Traceability Chain.
4. THE Agent Execution Control SHALL not define a new SemVer algorithm or alter the Conventional Commit Versioning rules for First Release treatment, public-contract impact, approved release records, or tag approval.
5. WHEN implementation changes the Better-PromptKit public workflow contract, THE release-impact record SHALL classify the change under the Conventional Commit Versioning workflow and SHALL provide migration guidance if the change is breaking.
6. THE Agent Execution Control SHALL identify host-specific enforcement limitations and SHALL distinguish advisory protocol behavior, host-supported tool gating, durable artifact validation, CI enforcement, and human approval.
7. THE Agent Execution Control SHALL keep external issue synchronization, remote actions, release publication, deployment, and rollback as explicit decisions of their owning workflows rather than implicit consequences of a task state transition.
