# Design Document: Agent Execution Control & Handoff

## Planning status and release boundary

This design turns the requirements-only Agent Execution Control & Handoff handoff into an implementation-ready v1.1 planning package. It is additive planning against the approved Better-PromptKit `v1.0.0` baseline; it does not modify, retag, or reinterpret the published release.

The feature remains documentation-first. Its first implementation slice may add Markdown templates, workflow guidance, local read-only validators, synthetic fixtures, and CI checks for Better-PromptKit itself. It must not introduce a runtime agent, daemon, IDE plugin, external tracker adapter, timer service, or automatic remote action.

The eventual version is not approved by this design or by task completion. After implementation, the public-contract impact must be evaluated under the existing Conventional Commit Versioning workflow, reviewed, and separately approved by the Release Coordinator.

## Goals

1. Establish one canonical local Task Record for each unit of Controlled Work.
2. Make readiness, active-task ownership, state transitions, checkpoints, stop states, scope changes, handoffs, and completion evidence explicit and reviewable.
3. Strengthen existing `pk:*` workflows without replacing their content ownership or creating a second task lifecycle.
4. Define a portable, read-only validator with equivalent Bash and PowerShell diagnostics.
5. Make enforcement limits visible: advisory protocol guidance, host-supported gating, durable records, CI validation, and human approval are different controls.
6. Preserve safe authority boundaries around commits, pull requests, remote operations, releases, deployment, and rollback.

## Non-goals

- No runtime orchestration service, background timer, model wrapper, IDE extension, or forced generation termination.
- No second task tracker, task database, external issue-system requirement, or automatic synchronization adapter.
- No new top-level `pk:execution-control` command; existing `pk:route`, `pk:plan`, `pk:tasks`, `pk:checkpoint`, `pk:commit`, `pk:pr`, `pk:review`, and `pk:ship` remain the owners.
- No autonomous commit, push, pull-request, merge, CI retry, repository configuration change, tag, hosted release, changelog publication, deployment, or rollback.
- No new SemVer algorithm and no automatic release approval.
- No requirement that consumer repositories adopt Better-PromptKit release-evidence policy.

## Architecture: documentation-first control plane

Agent Execution Control is a linked set of durable records and workflow gates, not an execution engine. The control plane has five layers:

1. **Protocol layer:** existing workflows state when a gate, checkpoint, handoff, or approval is required.
2. **Record layer:** local Markdown records preserve the scope, state, evidence, and next action.
3. **Host layer:** Kiro hooks, IDE controls, or other host capabilities may provide advisory prompts or tool gating when available.
4. **Validation layer:** local scripts inspect records and workspace references without mutating them.
5. **Review layer:** human approval remains authoritative for scope exceptions, remote actions, release decisions, and limitations that no model or host can mechanically enforce.

The layers are additive. A host that cannot observe live generation duration can still enforce the durable checkpoint protocol after a session reports that a threshold is due. The records must state that limitation rather than claiming that a timer stopped generation.

## Canonical record storage and precedence

The Local Task Source is the authority for controlled execution. Records use Markdown with stable field labels and identifiers so they remain human-readable and parsable by Bash and PowerShell without a YAML or database dependency.

| Record | Canonical path | Required identity | Purpose |
|---|---|---|---|
| Task Record | `docs/tasks/<task-id>.md` | `Record Type: Task Record`, `Task ID` | Scope, acceptance, dependencies, state, active ownership, and completion evidence for one task. |
| Scope Change Record | `docs/tasks/<task-id>.scope-<sequence>.md` | `Scope Change ID`, `Task ID` | Proposed or approved objective, file, acceptance, dependency, risk, or verification changes. |
| Checkpoint Record | `docs/tasks/<task-id>.checkpoint-<sequence>.md` | `Checkpoint ID`, `Task ID` | Durable snapshot and exactly one prioritized next action. |
| Handoff Record | `docs/tasks/<task-id>.handoff-<sequence>.md` | `Handoff ID`, `Task ID` | Validated transfer between people, roles, agents, or sessions. |
| Batch Authorization | `docs/tasks/batch-<batch-id>.md` | `Batch ID` | Finite ordered task list, approver, scope, checkpoint policy, and stop conditions. |
| Exception Record | `docs/tasks/<task-id>.exception-<sequence>.md` | `Exception ID`, `Task ID` | Emergency or explicitly approved deviation with reason, approver, scope, evidence, and follow-up. |

A Task Record may link to external issues, `docs/STATE.md`, specifications, commits, pull requests, CI runs, and release records. Those references are evidence links, not alternate authority. `docs/STATE.md` is a synchronized projection through `pk:checkpoint` when it exists; it must not silently override a Task Record. If the local record and state projection disagree, the validator reports a consistency failure and execution enters `blocked` or `checkpoint_due` until reconciled.

### Common record fields

Every record uses these labeled fields where applicable:

- `Record Type`, stable record ID, `Task ID`, `Specification`, `Execution Scope`, `Owner`, and `Created`.
- `Execution State`, `Previous State`, `Transition Reason`, `Actor`, and `Timestamp` for transitions.
- `Branch`, `Revision`, and changed-file references for workspace evidence.
- Stable links to acceptance criteria, verification commands/results, CI Evidence, reviews, commits, pull requests, and release evidence.
- Explicit `Non-Goals`, `Dependencies`, `Blocker`, `Approval Boundary`, and `Next Action` fields where the record type requires them.

Acceptance criteria use stable IDs such as `AC-1`. Verification evidence must identify a command, check, artifact assertion, or explicit not-applicable decision. Records may contain prose, but required fields cannot be satisfied only by an unstructured completion sentence.

## Task Record schema and readiness

A Task Record contains these sections in order:

1. **Identity and authority:** record type, task ID, specification, owner, execution scope, external references if any, and approval boundary.
2. **Objective and boundaries:** objective, in-scope work, explicit non-goals, dependencies, risk, and verification condition.
3. **Acceptance Criteria:** one or more stable `AC-*` entries, each with an observable result.
4. **Execution Policy:** `Gated Mode` or `Approved Batch Mode`, checkpoint intervals, stop conditions, and batch reference when applicable.
5. **State and active ownership:** current execution state, active task pointer, start time, actor, and transition history.
6. **Evidence:** changed files, scope-change links, checkpoint/handoff links, verification/CI/review/commit/PR links, blockers, and completion decision.

A controlled task cannot enter `ready` without an objective, scope, non-goals, acceptance criteria, dependencies or an explicit `None`, a verification condition, an owner/approval boundary, and an execution policy. It cannot enter `in_progress` until readiness, start time, scope, and active-task ownership are recorded.

## State model and mapping

The execution states are more precise than the existing `pk:tasks` board statuses, so they map to that board rather than replacing it.

| Execution state | Meaning | `pk:tasks` mapping | Implementation allowed? |
|---|---|---|---|
| `planned` | Record exists but readiness fields are incomplete or work is not selected. | `To Do` | No task implementation. |
| `ready` | Readiness gate passed; task may be started. | `To Do` | Only start transition and evidence. |
| `in_progress` | One task owns the execution scope. | `In Progress` | Yes, within scope and policy. |
| `checkpoint_due` | Required reconciliation or hard checkpoint is outstanding. | `In Progress` | No implementation edits; read-only diagnosis only. |
| `blocked` | Missing approval, dependency, evidence, or failed verification prevents continuation. | `In Progress` | No implementation edits; read-only diagnosis only. |
| `paused` | Developer intentionally paused the task with a resume condition. | `In Progress` | No implementation edits. |
| `handoff_ready` | Current work is preserved for a receiver or fresh session. | `In Progress` | No implementation edits until accepted. |
| `awaiting_review` | Acceptance evidence exists but required review, commit, or PR evidence is pending. | `In Review` | No scope expansion; review remediation only. |
| `completed` | Completion Gate passed and evidence is linked. | `Done` | No further work under this task. |
| `aborted` | Work stopped without completion and retained for explicit reactivation. | `To Do` | No implementation edits until reactivated as a new transition. |

The default transition graph is `planned -> ready -> in_progress`; `in_progress` may move to `checkpoint_due`, `blocked`, `paused`, `handoff_ready`, `awaiting_review`, or `completed` when evidence permits. Stop states may resume only after their recorded condition and approval are satisfied. `aborted` cannot silently return to `in_progress`; it requires an explicit reactivation decision and a new transition record. A task switch clears the active pointer before another task becomes active.

## Checkpoint, stop, and scope semantics

### Checkpoints

The default execution policy requests a soft checkpoint around 60 minutes and requires a hard checkpoint at or before 90 minutes. The policy records the configured intervals and the host capability. Milestone, task-switch, scope-expansion, handoff, compaction, and context-drift checkpoints are event-driven and do not depend on a timer.

A Checkpoint Record must include task/specification identity, current state, objective, completed and remaining work, changed files, branch/revision, locked decisions and invariants, verification and CI results, blockers, scope changes, and exactly one prioritized next action. A hard checkpoint blocks edits, commits, pull-request actions, and task switches until the record exists and execution is explicitly resumed.

### Stop states

A developer stop/pause/cancel/handoff request, missing context or approval, failed verification/review/CI, broken invariant, or uncertain workspace validity records a named stop state before further implementation. Read-only inspection may continue when it does not change project state. Each blocked or paused record names the owner, evidence, and precise resume condition. Aborted work retains changed files and evidence and cannot be called complete.

### Scope changes and task switches

A Scope Change Record is created before changing objective, files, acceptance criteria, dependencies, non-goals, risk, or verification. Expansion requires explicit human confirmation or a separate Task Record. Discovered independent work is recorded separately. A task switch first preserves evidence and moves the current task to a permissible non-active state, then clears the active pointer.

## Handoff contract

A Handoff Record is created at a checkpoint, session or role boundary, `handoff_ready`, or major milestone. It carries task and specification IDs, state, objective, completed milestones, remaining acceptance criteria, files, branch/revision, decisions and invariants, rejected approaches when relevant, verification and CI evidence, blockers, approvals, scope changes, and exactly one next action.

A receiver validates the task ID, revision, changed files, acceptance criteria, invariants, blockers, and next action before edits. A stale, incomplete, contradictory, or workspace-inconsistent handoff blocks continuation. Acceptance records receiver, time, validated revision, and next action without changing scope.

## Workflow ownership and insertion points

| Existing owner | v1.1 addition | Ownership preserved |
|---|---|---|
| `pk:route` | Classify Trivial versus Controlled Work and route the first readiness decision. | Routing remains the router; it does not own task decomposition. |
| `pk:plan` | Produce objective, boundaries, non-goals, dependencies, acceptance, and verification inputs for a Task Record. | Architecture and planning decisions remain here. |
| `pk:tasks` | Create stable task IDs, acceptance criteria, dependency links, and board-status mapping. | Task decomposition remains here; no second lifecycle. |
| `pk:checkpoint` | Write checkpoint/handoff records and synchronize `docs/STATE.md`. | Session state remains here; it never approves releases. |
| `pk:commit` | Require completion evidence and route atomic commit construction. | Commit syntax, staging, and confirmation remain here. |
| `pk:pr` | Require milestone evidence, review/CI links, risk, and rollback information. | Pull-request evidence remains here. |
| `pk:review` | Validate scope, acceptance, completion, and traceability findings. | Review findings remain here. |
| `pk:ship` | Record release-impact links and preserve human-only tag/release/deployment decisions. | Release and deployment decisions remain here. |

No workflow should duplicate another workflow's complete procedure. The overlays add gates and links at the handoff points above.

## Validator contract

The implementation will provide `scripts/validate-execution-control.ps1` and `scripts/validate-execution-control.sh`. Both accept an optional root path and a strict/read-only validation mode, default to the current repository, and return exit code `0` only when all discovered required records are valid. They must not create, edit, delete, stage, commit, push, query remotes, create tags/releases, publish, deploy, or mutate task state.

The validator reports stable diagnostic categories and the affected record ID/path:

- `MISSING_FIELD`, `INVALID_ID`, `INVALID_STATE`, `INVALID_TRANSITION`;
- `ACTIVE_TASK_CONFLICT`, `READINESS_FAILURE`, `CHECKPOINT_INCOMPLETE`, `HANDOFF_INCOMPLETE`;
- `SCOPE_CHANGE_MISSING`, `BLOCKER_UNRESOLVED`, `COMPLETION_EVIDENCE_MISSING`;
- `TRACEABILITY_MISSING`, `REVISION_MISMATCH`, `STATE_PROJECTION_MISMATCH`, `POLICY_LIMITATION`.

It validates the canonical records under `docs/tasks/`, optional `docs/STATE.md` projections, and local synthetic fixtures. It does not infer a task from an issue, conversation, branch name, or commit message. It reports a timer limitation when live host duration is unavailable and validates recorded due/stop evidence instead.

Bash and PowerShell must share the same required fields, state table, diagnostic category names, and exit-code contract. Tests use deterministic local fixtures under `scripts/tests/fixtures/execution-control/`; they never rely on live Git history or a remote service.

## Enforcement and portability matrix

| Control | Advisory protocol | Host-supported gate | Durable record | CI check | Human approval |
|---|---:|---:|---:|---:|---:|
| Trivial/Controlled classification | Yes | Optional | Task Record when controlled | Validate fields when present | Scope expansion |
| One active task | Guidance | Optional | Task state/pointer | Yes | Exceptions |
| Time checkpoint | Reminder | Optional | Due/stop record | Validate recorded evidence | Resume after hard stop |
| Scope change | Guidance | Optional | Scope Change Record | Yes | Required for expansion |
| Handoff | Prompt | Optional | Handoff Record | Yes | Receiver acceptance |
| Completion | Workflow gate | Optional | Evidence and links | Yes | Commit/PR exceptions |
| Commit/PR/release/deployment | Workflow guidance | Optional | Approval/evidence links | Validate references | Always required by owning workflow |

This matrix prevents documentation from promising a mechanical control that the host cannot provide. It also prevents a passing CI check from being treated as approval for a remote action.

## Validation and testing strategy

The core implementation uses deterministic example fixtures for complete records and negative cases: missing readiness fields, two active tasks, illegal transitions, incomplete checkpoints/handoffs, unresolved blockers, scope expansion without approval, missing completion evidence, traceability mismatch, revision mismatch, and timer limitations. Tests assert that both platform validators produce equivalent categories and exit results.

Optional property tests may generate in-memory state transitions and record combinations, but they are not required to interact with Git, a network, or a host. The required smoke path runs both validators against synthetic fixtures, checks that the repository reference validator remains green, and verifies that no file or Git state changes occur during validation.

## Compatibility and release impact

The implementation is additive to the Better-PromptKit instruction-layer contract. Existing workflows, templates, `PROMPTKIT.md`, `docs/STATE.md`, release records, and consumer adoption guidance remain valid; new fields are optional outside Controlled Work and existing task-board statuses remain the public mapping.

If an implementation changes existing workflow behavior in a way that requires consumers to update established records or procedures, the release evaluation must classify that as a public-contract change and provide migration guidance. The v1.0.0 tag and release are immutable. Completion of this planning package does not create a v1.1.0 tag, approve a release, or publish anything.

## Correctness properties

1. A controlled task cannot enter `ready` or `in_progress` without required scope, acceptance, dependency, owner, verification, and execution-policy fields.
2. At most one task is active in an execution scope, and every active-task transfer clears the prior pointer first.
3. Every state transition is valid, recorded, and mapped to one existing `pk:tasks` status.
4. A hard checkpoint or stop state blocks implementation actions until its recorded resume condition is satisfied.
5. Every scope expansion has a Scope Change Record and required approval or a separate Task Record.
6. A handoff receiver cannot continue from stale, contradictory, or revision-inconsistent evidence.
7. Completion requires acceptance results, verification evidence, changed-file summary, and commit/PR evidence or an explicit exception.
8. Validator runs are read-only, local, deterministic, and behaviorally equivalent across Bash and PowerShell.
9. Passing execution-control validation never authorizes a remote, release, deployment, or rollback action.

## Implementation notes

- Reuse `docs/tasks/`, `docs/STATE.md`, and existing workflow templates instead of introducing a database.
- Use stable headings and IDs that a simple Bash/PowerShell parser can validate.
- Treat generated host context and conversational claims as untrusted until reflected in a durable record.
- Keep exception records visible and reviewable; never silently downgrade a failed gate.
- Add implementation and validation changes through a normal branch and PR; do not modify the published v1.0.0 tag or release.
