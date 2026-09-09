# Design Document: PromptKit SDLC Skill Adaptation

## Status and Scope

**Status:** Design complete for a documentation-first MVP revision.

**Purpose:** Define low-friction overlays over the existing Better-PromptKit lifecycle without replacing its router, workflow ownership, Local Task Record authority, or human approval boundaries.

**Current revision boundary:** This specification revision changes only the three files in `.kiro/specs/promptkit-sdlc-skill-adaptation/`. A later implementation agent may modify the PromptKit workflows, templates, validators, and documentation listed in the implementation tasks. No such implementation change is included here.

## Design Summary

The current PromptKit lifecycle router remains the map. The Adaptation is an evidence and decision layer applied only when the work requires it.

- `pk:route` continues to classify `Trivial` versus `Controlled` Work.
- Trivial Work retains the existing fast path.
- Controlled Work retains the canonical Local Task Record readiness gate.
- Minimal versus Full Planning Interrogation controls planning depth; it is not a second execution classification.
- Existing workflows remain authoritative for their current capabilities.
- TDD is opt-in.
- Technology research is targeted to material decisions.
- Simplification review is read-only and recommendation-only.
- CI triage is evidence-first and release-aware.
- Adapters and advanced property testing are deferred.

## Goals

- Reduce repeated questions, guessed decisions, and implementation rework.
- Make assumptions and technology evidence durable without requiring a full RFC for ordinary work.
- Add explicit evidence only at decision points where it reduces future risk.
- Preserve developer velocity for Trivial Work.
- Preserve the current lifecycle map and workflow contracts.
- Make the later implementation agent’s scope clear and incrementally verifiable.

## Non-Goals

- No new lifecycle command.
- No replacement for `pk:route` or any established workflow.
- No second authoritative task or execution record.
- No automatic research, code editing, CI retry, remote mutation, deployment, release, or rollback.
- No mandatory TDD for all code.
- No adapter inference.
- No required network integration or property-test framework in MVP.
- No retroactive conversion of existing records.
- No claim that Markdown artifacts mechanically enforce model behavior.

## Existing Ownership and Integration Boundary

| Existing capability | Existing owner | Adaptation responsibility |
|---|---|---|
| Lifecycle navigation and Trivial/Controlled classification | `pk:route` | Preserve; provide only planning-depth guidance. |
| Brownfield intake | `pk:onboard` | None. |
| Architecture, contracts, migrations, FMEA, and milestones | `pk:plan` | Add Planning Record, assumptions, and material-decision provenance. |
| Task decomposition and acceptance criteria | `pk:tasks` | Add opt-in TDD ordering and evidence links. |
| Test pyramid, seams, factories, mocks, and E2E allocation | `pk:test` | Define optional Red evidence; do not redefine test strategy. |
| Data and migrations | `pk:data` | None beyond links from planning decisions. |
| Auth and authorization | `pk:auth` | None beyond links from planning decisions. |
| API contracts | `pk:api` | None beyond links from affected-contract planning. |
| UI and accessibility | `pk:design` | None. |
| Technical investigation | `pk:spike` | Receive targeted investigations from unresolved decisions. |
| Debugging and local reproduction | `pk:debug` | Receive CI failures that need reproduction. |
| Performance profiling | `pk:perf` | None. |
| Review and data-safety audit | `pk:review` | Add Simplification Audit as a report section. |
| Release sequencing and approval | `pk:ship` | Add CI Triage linkage; preserve human authority. |
| Controlled execution evidence | Canonical Local Task Record | Remains the sole execution authority. |

## Architecture

```text
                         Developer Request
                                 |
                                 v
                              pk:route
                                 |
               +-----------------+------------------+
               |                                    |
               v                                    v
        Trivial Work                         Controlled Work
        Existing fast path                   Local Task Record
               |                                    |
               |                             Planning depth
               |                             Minimal or Full
               |                                    |
               +-----------------+------------------+
                                 |
                                 v
                  Existing lifecycle workflows
             pk:plan / pk:tasks / pk:data / pk:auth / pk:api
                                 |
                      Optional TDD evidence
                                 |
                            Implementation
                                 |
                  pk:test / pk:design / pk:spike as needed
                                 |
                 pk:debug / pk:perf / pk:review as needed
                                 |
                         pk:commit -> pk:pr
                                 |
                      pk:ship + CI triage if needed
                                 |
                 pk:checkpoint and pk:retro at any point
```

The router remains a navigation map. The overlay records decision depth, evidence, and boundaries without adding a new lifecycle branch.

## Authority Model

The shared contract is the generated Markdown evidence, but each artifact has one authority:

| Evidence | Primary authority | Supporting references | Boundary |
|---|---|---|---|
| Work classification | `pk:route` | Planning Record | No duplicate classification may override it. |
| Controlled readiness and execution state | Local Task Record | Issue, `docs/STATE.md`, checkpoint/handoff records | Only the Local Task Record controls readiness and completion. |
| Architecture and planning decisions | `pk:plan` technical specification | ADRs, domain workflows | Planning does not approve implementation or release. |
| Test seams and test intent | `pk:test` test plan | TDD Evidence Register | The test plan does not control execution state. |
| TDD execution evidence | Local Task Record | Test plan, task/issue artifact | Red/Green/Refactor records link to the same behavior ID. |
| Review findings | `pk:review` report | Task Record and CI evidence | Review does not approve release or remote actions. |
| CI failure evidence and remediation | CI Triage Record | `pk:ship` pre-release record, `pk:debug` RCA | Triage does not retry, deploy, or approve. |
| Release readiness and approval | `pk:ship` plus human Release Coordinator | CI, review, task, and release records | Approval does not automatically perform external actions. |

A later implementation must integrate TDD completion evidence with the canonical Local Task Record. The issue and test-plan artifacts may contain views or links, but they must not become alternate execution authorities.

## Planning Depth Model

### Trivial Work

Trivial Work keeps the existing fast path. No new Planning Record, Assumption Record, citation, TDD chain, or execution record is mandatory solely because the Adaptation exists.

### Minimal Planning Interrogation

Minimal mode is available for low-complexity Controlled Work or when a developer asks for a lightweight plan. It records only:

- requested outcome;
- observable completion condition;
- scope boundary.

It must not silently continue into the full technical RFC. If a risk or unknown makes the short path insufficient, the record escalates to Full mode and records why.

### Full Planning Interrogation

Full mode is required when the work affects multiple components or materially affects public contracts, persistent data, authorization, external integrations, release configuration, safety, or rollback. It records:

- requested outcome;
- explicit non-goals;
- affected Behavioral Components;
- externally visible contracts;
- failure and rollback considerations;
- verification approach.

It then continues into the existing `pk:plan` architecture, contracts, migration, FMEA, milestone, and grilling steps. The interrogation does not duplicate those steps.

### Assumption Handling

Every unanswered required field becomes an Assumption Record containing:

- unanswered decision;
- provisional answer;
- impact if wrong;
- validation action;
- required decision owner;
- status.

An assumption is visible and provisional; it is never represented as a confirmed decision until resolved or explicitly accepted.

## Source-Grounded Decision Model

A decision qualifies for source grounding when it adopts, replaces, configures, versions, or materially depends on an external technology, platform, provider, framework, library, or managed service.

The decision record contains:

- decision statement;
- considered options;
- Material Claims;
- Citation Records;
- selected and rejected options;
- Uncertainty Records;
- decision owner and status.

A citation contains publisher, title, canonical URL, access date, and the claim supported. Primary Documentation is preferred. If sources are unavailable or conflict, the record must choose defer, targeted `pk:spike`, or an explicitly accepted assumption. Merely naming an existing technology does not trigger a decision record.

## Technology Version-Selection Policy

When a material technology decision includes a version, the planning overlay uses a stable, support-aware, compatibility-first default:

- For greenfield work with no user preference or existing pin, recommend the latest supported stable release compatible with project constraints. "Latest" means the latest supported stable compatible release, not the newest release regardless of channel or compatibility.
- Stable means production-stable; prefer actively supported or LTS releases where applicable. Never default to prerelease, nightly, experimental, or unsupported channels.
- For an existing project, preserve current pinned versions unless the developer requests an upgrade or security, support/lifecycle, compatibility, or other material evidence justifies one. Upgrades are not silent and record migration or rollback impact when relevant.
- An older version requires an explicit rationale, a named decision owner, and support/lifecycle and compatibility evidence. Missing or conflicting evidence remains uncertainty.
- The Decision Record captures the exact selected version or versions, release channel, support/lifecycle status, compatibility constraints, rationale, citations, citation access date, and exact-version evidence. `latest` or an unbounded range is not an exact selection.
- AI or PromptKit provides a recommendation, not final approval. The named decision owner approves the recommendation, approves a deviation, or accepts the documented assumption. A user preference or project constraint may override the default when recorded.
- Unclear, stale, inaccessible, or conflicting evidence leads to defer, a targeted `pk:spike`, or an explicitly accepted assumption owned by the decision maker. The planner must not guess.

## Optional TDD Evidence Model

TDD Enforcement Mode is disabled by default. For Controlled Work, it is enabled only by the canonical Local Task Record field `TDD Enforcement Mode: disabled | enabled`. Planning and test-plan artifacts may propose or reference the setting, but the Task Record is authoritative if another artifact disagrees. An absent field means `disabled`.

When enabled for Code Work:

1. Red defines the automated test, expected failing assertion, command, and expected behavior ID.
2. Green implements the smallest behavior that makes the same Red test pass.
3. Refactor improves the implementation while rerunning the same test and preserving the behavior ID.
4. Completion evidence is recorded in or linked from the canonical Local Task Record.
5. The chain may remain within one Task Record; it does not require three separate issues.
6. Scope changes require the existing Scope Change Record and may require TDD-chain revision before implementation continues.

When `TDD Enforcement Mode` is disabled for Code Work, the TDD intent register and TDD execution evidence are each recorded as `N/A — TDD Enforcement Mode disabled`. Normal dependency-ordered milestones, acceptance criteria, test strategy, review, and verification evidence remain required. Documentation Work, Configuration Work, and Research Work receive a suitable exception verification task instead of a TDD chain; this exception path does not apply to disabled Code Work. Ambiguous work follows the Code Work path until clarified.

TDD mode does not choose a test runner, framework, seam, mocking boundary, or test pyramid. Those remain owned by `pk:test`, project configuration, and existing task rules.

## Simplification Audit Model

The Simplification Audit is a third report section inside the existing `pk:review`; it is not a third review workflow or a replacement for the two existing axes.

For a non-empty, resolved diff, the reviewer records either:

- one or more evidence-backed candidates; or
- `No Simplification Candidates found`.

Allowed candidate types:

- deletion;
- consolidation;
- inlining;
- control-flow reduction.

Each candidate requires location, diff evidence, behavior-preservation condition, risk, verification action, and recommendation. The audit is read-only. It never edits source, stages files, commits, or changes review severity. Unsupported cleanup ideas are not candidates.

## CI Triage Model

CI triage begins with evidence, not a source edit or remote retry.

1. Collect check identity, job/command, failure output, revision, execution time, and configuration context.
2. Use authenticated GitHub CLI only as an optional read-only retrieval path.
3. Otherwise request a CI URL or copied output and provide provider-neutral instructions.
4. Classify only sufficient evidence as test, static analysis, build, dependency/environment, infrastructure/transient, deployment, or unknown.
5. Insufficient evidence creates an evidence request and no source-change recommendation.
6. Sufficient evidence creates a bounded Remediation Plan with minimal change, verification, and reversal action.
7. Remote retry, repository configuration change, deployment, and rollback remain pending until explicit human confirmation.
8. Local reproduction routes to `pk:debug`.
9. A release candidate remains blocked until triage and successful verification link to the `pk:ship` pre-release record.

## Backward Compatibility and Non-Regression

The Adaptation is designed for incremental adoption:

- Trivial Work retains zero required new ceremony.
- Controlled Work retains its current Local Task Record readiness and state model.
- New fields are additive to existing artifacts.
- Existing records remain valid without retroactive migration.
- Existing workflow triggers and ownership remain unchanged.
- Existing human approval boundaries remain unchanged.
- Validators provide evidence only and never authorize external actions.
- Each overlay can be implemented and reviewed independently.
- A later implementation may revert an overlay section without rewriting the lifecycle router.

A later implementation must explicitly test that old fast-path, Controlled Work, approval, release, and rollback behavior remains represented after each overlay is added.

## Process Cost, Token, and Friction Budget

The Adaptation optimizes total cycle time, not merely time until the first code line.

### Required guardrails

- Trivial Work: zero new required artifacts or questions.
- Minimal mode: no more than three required inputs; no automatic full RFC.
- Full mode: only for substantive, high-risk, or explicitly requested planning.
- TDD: only when explicitly enabled.
- Source research: only for material decisions.
- CI triage: only when CI fails.
- Simplification audit: recommendation-only; no automatic cleanup work.
- Records: concise, link-based, and free of duplicated workflow text.
- Repeated questions: prohibited unless scope or evidence changes.
- Deferred adapters and property tests: excluded from MVP work and context consumption.

### Evaluation measures

The implementation should compare representative work with the current system and record:

- fast-path completion behavior;
- Minimal planning effort;
- Full planning effort;
- assumptions discovered before coding;
- decision evidence completeness;
- TDD evidence completeness when enabled;
- CI classification quality;
- simplification false-positive rate;
- process bypasses caused by friction;
- relative context/token overhead.

Exact token counts are not normative because host, model, and project context vary. The required evaluation is whether added evidence reduces rework and repeated context more than it costs.

## MVP and Deferred Scope

### MVP

- planning depth and Assumption Records;
- source-grounded material decisions;
- opt-in TDD evidence;
- recommendation-only Simplification Audit;
- evidence-first CI triage;
- compatibility and non-regression safeguards;
- process-cost and token-friction guidance;
- deterministic artifact and reference validation;
- requirements/design/task traceability.

### Deferred

- React adapter;
- Supabase/RLS adapter;
- deployment-provider adapter;
- advanced property-based artifact generation;
- network-backed GitHub CLI checks;
- automatic adapter selection;
- broad adapter catalogs.

Deferred capabilities require a separate approved implementation plan. They cannot become implicit dependencies of the core path.

## Implementation Integration Points for the Later Agent

### `pk:route`

Do not replace the router. Preserve the existing Trivial/Controlled classification and add only links or annotations explaining that planning depth is selected after routing.

### `pk:plan`

Add an early Planning Record with Minimal/Full depth, assumptions, and material-decision provenance. Minimal mode must have an explicit short-path rule. Existing architecture, contracts, migration, FMEA, milestones, and grilling remain authoritative.

### `pk:test`

Add optional TDD Evidence guidance after existing seam allocation. Preserve test-pyramid, real-database, mock-boundary, factory, flake, and runner guidance.

### `pk:tasks`

Add optional TDD sequencing and evidence links. Preserve 1–4 hour sizing, Gherkin acceptance criteria, invariants, Local Task Record readiness, and scope-change rules.

### `pk:review`

Add the read-only Simplification Audit after existing review axes and preflight controls. Preserve the existing severity and data-safety model.

### `pk:ship`

Add CI Triage linkage and release-resumption evidence. Preserve release sequencing, rollback, human approval, and external-action boundaries.

### Templates and validators

A later implementation may add or extend templates and deterministic validators, but it must keep new fields additive, link-based, and compatible with existing records. No network-dependent or property-test infrastructure is required for MVP.

## Schema and Action Contracts

The later implementation SHALL use the canonical artifact matrix as an executable documentation contract rather than inventing parallel record locations. Stable IDs are immutable, use lowercase kebab-case slugs, and follow these exact forms:

```text
PLAN-<spec-slug>                  ASSUMPTION-<spec-slug>-<nnn>
DECISION-<spec-slug>-<nnn>        CLAIM-<decision-id>-<nnn>
CITATION-<decision-id>-<nnn>      UNCERTAINTY-<decision-id>-<nnn>
TASK-<task-slug>                  BEHAVIOR-<task-slug>-<nnn>
TDD-INTENT-<task-slug>-<nnn>      TDD-EXEC-<task-slug>-<behavior-seq>
REVIEW-<review-slug>              SIMPLIFICATION-<review-id>-<nnn>
CI-<provider>-<run-id>            ACTION-<ci-id>-<nnn>
RELEASE-<release-slug>
```

Task Record identity is profile-scoped. For `PromptKit Adaptation Profile: sdlc-overlay-v1`, use `TASK-<task-slug>`. For an absent or `none` profile, preserve the legacy `TASK-YYYY-MM-DD-<slug>` form. Legacy templates and validators remain dated, and existing records and links require no retroactive migration. Adaptation IDs containing `<task-slug>` use the Adaptation Task Record slug; legacy records retain their dated identity.

Cross-record links SHALL use `[<stable-id>](<relative-path>#<stable-id>)`; same-file links SHALL use `[<stable-id>](#<stable-id>)`; each target SHALL expose the same ID as an explicit anchor. Every field in a fill-in artifact SHALL be labeled `Required`, `Optional`, or `Not applicable`. `N/A — <reason>` is allowed only under the artifact’s N/A rule, while `None` means a valid collection has no entries. Metadata fields do not count as Minimal Planning interrogation inputs.

The canonical schema SHALL include, at minimum, the following required field groups and state boundaries:

| Artifact | Required field group | N/A rule | Allowed states |
|---|---|---|---|
| Planning Record | ID, depth, outcome, completion condition, scope boundary, owner, status; Full mode adds non-goals, components, contracts, failure/rollback, and verification | Full-only fields may be `N/A — Minimal depth` when Minimal mode genuinely does not require them | `draft`, `ready`, `blocked`, `superseded` |
| Assumption Record | ID, unanswered decision, provisional answer, impact, validation action, owner, status | Resolution evidence is N/A until the assumption is resolved | `open`, `validated`, `accepted`, `rejected`, `superseded` |
| Decision/Citation/Uncertainty | Decision options and disposition; claim links; citation metadata and supported claim; uncertainty impact, resolution action, owner, status | Uncertainty is `None` only when no claim remains unresolved | Decision `proposed`, `decided`, `deferred`, `superseded`; Citation `candidate`, `verified`, `stale`, `inaccessible`, `conflicting`, `superseded`; Uncertainty `open`, `resolved`, `accepted`, `deferred`, `superseded` |
| TDD intent/execution | Task Record link, behavior ID, mode reference, test, expected failure command, and Red/Green/Refactor results | For disabled Code Work, intent and execution evidence are each `N/A — TDD Enforcement Mode disabled`; normal milestones, acceptance criteria, test strategy, review, and verification remain required. Documentation, Configuration, and Research Work require an exception verification link | Intent `proposed`, `ready`, `superseded`; execution `planned`, `red_recorded`, `green_recorded`, `refactor_recorded`, `exception`, `blocked`, `complete` |
| Simplification Audit | Review/diff reference, candidate ID or explicit no-candidate result; candidate location, diff evidence, preservation condition, risk, verification, recommendation | Candidate fields are N/A for `No Simplification Candidates found` | `draft`, `complete`, `superseded` |
| CI Triage and release linkage | CI evidence, owner, state, supported classification/remediation, verification, resume condition, and release link where applicable | Classification/remediation is N/A before evidence is sufficient; action-confirmation collection is N/A when no remote action is proposed | CI `evidence_requested`, `evidence_sufficient`, `classified`, `remediation_planned`, `awaiting_confirmation`, `local_reproduction_or_fix`, `verification_pending`, `verified`, `linked_to_pk_ship`, `blocked`; release linkage uses existing `pk:ship` states |

The CI Triage Record SHALL contain a separate action block for each proposed remote retry, repository configuration change, deployment, or rollback. Each `ACTION-<ci-id>-<nnn>` block records the proposed action, `pending | confirmed | declined` confirmation state, approver, confirmation timestamp, bounded scope, reversal or rollback action, and resume condition. Approver and timestamp are `N/A — awaiting confirmation` only while pending; confirmed and declined actions require both. Confirmation of one action never authorizes another, and recording confirmation never executes the action. A declined remote action closes only that action. The parent CI Triage Record must receive a new bounded remediation plan or become `blocked` with an owner and precise resume condition; the decline event cannot transition the record to `verified` or `linked_to_pk_ship`. Only `verified` followed by `linked_to_pk_ship` permits release resumption.

Cross-record invariants are normative: each ID is unique and immutable; each link resolves using the declared syntax; the Local Task Record owns TDD mode and execution state; TDD intent and execution share one behavior ID; every material claim links to a citation or uncertainty; one remote action has one confirmation block; and standalone CI triage remains evidence authority only, never execution or release-approval authority.

The validator boundary is deterministic and network-free. It validates paths, IDs, field labels, links, allowed states, required-field conditions, ownership, cross-record invariants, and deferred-scope boundaries. It does not verify external URLs, execute commands, or authorize remote/release actions.

## Implementation Sequencing Contract

The dependency graph in `tasks.md` is the single authoritative implementation sequence. It places authority, TDD mode ownership, Minimal readiness mapping, and canonical schemas before affected overlays and places legacy/profile-aware validation after those schemas. It has one final traceability gate. Optional friction evaluation may be explicitly deferred and must not block the final gate.

The CI contract/implementation boundary is explicit: Task 11 defines the canonical CI triage path, identities, required fields, states, links, and ownership. Task 12 implements the state transitions, action-block lifecycle, declined-action handling, release handoff, and valid/invalid fixtures from that contract.

For this MVP sequence, Task 15 friction measurement is explicitly deferred. It may be completed later by the PromptKit maintainer and does not block Task 16 or implementation handoff.

Task 14's developer-friendly language contract remains a language-only pass over fill-in artifacts. It preserves canonical labels, ownership, TDD semantics, identity forms, and validator behavior.

## Testing and Validation Strategy

### Documentation validation

- Validate required sections and fields in representative artifacts.
- Validate workflow, template, owner, and deferred-scope references.
- Validate that core documents do not require named adapters or providers.
- Validate that TDD evidence links to a canonical Task Record authority.
- Validate that no active dependency points to Deferred Capability work.
- Preserve deterministic, network-free MVP validation.

### Scenario checks

At minimum, review these scenarios:

1. Trivial Work remains on the fast path.
2. Minimal Controlled Work uses no more than three required inputs.
3. Full planning is selected for API, data, auth, integration, and release-risk work.
4. Missing planning input produces an owned assumption.
5. A material technology decision has citations or explicit uncertainty.
6. A non-material technology mention does not create unnecessary research.
7. TDD-disabled work follows existing behavior.
8. TDD-enabled Code Work has one linked Red/Green/Refactor chain.
9. Documentation, Configuration, and Research Work receive suitable exceptions.
10. Simplification review can validly find no candidate.
11. Insufficient CI evidence produces no guessed source fix.
12. Release-candidate CI failure blocks resumption until verification succeeds.
13. Existing records remain valid without migration.
14. Deferred adapters and property testing are not required by MVP.

### Human review

A maintainer reviews whether:

- the new process is shorter for low-risk work;
- no workflow authority is duplicated;
- records do not copy whole workflows;
- source grounding is proportionate;
- TDD remains opt-in;
- release and remote actions remain human-only;
- the design reduces total rework rather than only adding documentation.

## Correctness Properties

### Property 1: Classification and planning depth remain separate

For every request, `pk:route` retains the existing Trivial/Controlled classification. Planning depth may be Minimal or Full without overriding execution authority. Trivial Work receives no mandatory Adaptation ceremony.

### Property 2: Planning records are complete and ordered

Every selected planning depth contains its required fields. Every unanswered required field becomes an Assumption Record. The record appears before implementation steps.

### Property 3: Material decisions have provenance

Every concluded material Technology or Vendor Decision contains options, decision disposition, claim-to-citation coverage, citation metadata, and retained uncertainty where evidence is incomplete or conflicting.

### Property 4: TDD chains are linked and bounded

When TDD is enabled for Code Work, Red precedes Green, Green precedes Refactor, all evidence uses the same behavior ID, and execution evidence is linked to the canonical Local Task Record. Non-code exceptions are limited to the three permitted categories.

### Property 5: Simplification audits are read-only

Every non-empty resolved diff receives a Simplification Audit. Candidates have all required evidence and permitted classifications, while a no-candidate result is valid. The audit does not modify source.

### Property 6: CI triage is evidence-gated

Insufficient evidence produces no source-change recommendation. Sufficient evidence produces a bounded plan. Remote actions remain confirmation-pending. Release candidates remain blocked until successful verification is linked.

### Property 7: Compatibility and friction boundaries hold

Trivial Work remains fast, existing records remain valid, existing authorities remain intact, and new controls activate only at their defined triggers.

### Property 8: Deferred scope stays isolated

No MVP workflow, task, validator, or completion criterion requires adapters, automatic adapter selection, network-backed checks, or advanced property-test infrastructure.

## Completion Criteria

The design revision is complete when:

- the architecture shows the Adaptation as an overlay on the current router;
- authority is assigned exactly once for each evidence type;
- Minimal and Full planning behavior is explicit;
- TDD mode ownership and evidence propagation are explicit;
- source-grounding scope is proportionate;
- simplification and CI boundaries are explicit;
- compatibility, non-regression, and friction budgets are explicit;
- MVP and Deferred scope are separate;
- implementation integration points preserve existing workflow ownership;
- every correctness property maps to requirements and tasks.


## Normative Final Implementation Contracts

This section resolves implementation ambiguity identified during final review. It is normative where earlier design language allowed multiple interpretations.

### TDD Authority and Existing Workflow Compatibility

The canonical Controlled Work Task Record owns:

```text
TDD Enforcement Mode: disabled | enabled
```

Planning and test-plan records may propose or display the value, but only the Task Record activates the mode. An absent field means `disabled`. If records disagree, the Task Record wins and the mismatch blocks readiness until resolved.

Existing `pk:plan`, `pk:tasks`, and technical-spec TDD sections become conditional in the later implementation:

- enabled mode: Red test, Green implementation, Refactor evidence;
- disabled Code Work: TDD intent register and TDD execution evidence are each `N/A — TDD Enforcement Mode disabled`, while normal dependency-ordered milestones, acceptance criteria, test strategy, review, and verification evidence remain required;
- Documentation, Configuration, and Research Work: exception verification instead of a TDD chain.

The exception path applies only to those three non-Code Work categories. Both Code Work branches retain acceptance criteria, test strategy, quality gates, review, and verification requirements.

### Minimal Planning to Controlled Readiness

Minimal Planning is a conversation and planning-depth limit, not a reduced Controlled Work contract. The three Minimal answers seed the Local Task Record, but the full existing readiness fields still need concrete values or explicit `None`/not-applicable reasoning before implementation.

Full Planning is mandatory when the work affects public contracts, persistent data, authorization, external integrations, release configuration, multiple components, serious rollback/data-loss risk, or explicitly requested architecture. A developer request for a lightweight plan cannot override those triggers.

### Canonical Artifact Contract Matrix

| Artifact | Canonical location | Stable identity | Authority | State/validation boundary |
|---|---|---|---|---|
| Planning Record | Section in the existing `docs/specs/<specification>.md` technical specification | `PLAN-<spec-slug>` | `pk:plan` | Required before plan implementation steps |
| Assumption, decision, citation, and uncertainty records | Sections in the Planning Record | `ASSUMPTION-<spec-slug>-<nnn>`, `DECISION-<spec-slug>-<nnn>`, `CLAIM-<decision-id>-<nnn>`, `CITATION-<decision-id>-<nnn>`, `UNCERTAINTY-<decision-id>-<nnn>` | `pk:plan` | Claims must link to sources or uncertainty |
| TDD intent register | Existing `docs/tests/<test-plan>.md` artifact | `TDD-INTENT-<task-slug>-<nnn>` and behavior ID | `pk:test` | Defines the Red test and intended behavior |
| TDD execution evidence | `docs/tasks/<task-id>.md` Local Task Record | `TDD-EXEC-<task-slug>-<behavior-seq>` | Local Task Record | Owns execution state and completion evidence |
| Simplification Audit | Existing `pk:review` report | `REVIEW-<review-slug>` and `SIMPLIFICATION-<review-id>-<nnn>` | `pk:review` | Candidate or explicit no-candidate result |
| CI Triage Record | `docs/releases/ci-triage/<ci-failure-id>.md` | `CI-<provider>-<run-id>` | CI triage owner | Evidence and state transitions below |
| Release linkage | Existing `docs/releases/<release>.md` record | `RELEASE-<release-slug>` | `pk:ship` | Verified triage link required to resume candidate |

Later templates and validators must implement these contracts without creating competing authorities. Embedded sections remain embedded; standalone records must link back to the relevant Task Record, specification, review, or release record.

### CI Triage State Machine and Ownership

```text
evidence_requested
  -> evidence_sufficient
  -> classified
  -> remediation_planned
  -> awaiting_confirmation       (remote retry/config/deploy/rollback only)
  -> local_reproduction_or_fix
  -> verification_pending
  -> verified
  -> linked_to_pk_ship
```

Any state may become `blocked` with an owner and precise resume condition.

| State responsibility | Owner |
|---|---|
| Collect CI run details and classify evidence sufficiency | CI triage owner |
| Reproduce a local failure | `pk:debug` |
| Implement an in-scope source fix | Engineer under the Task Record |
| Verify the correction | Engineer/QA using the recorded command |
| Block and resume a release candidate | `pk:ship` |
| Approve remote retry, configuration, deployment, or rollback | Human Release Coordinator |

Only `verified` plus `linked_to_pk_ship` permits release resumption. Classification, a proposed fix, an empty blocker list, or a passing unrelated validator does not permit resumption.

### Legacy Validator Gate

The later implementation must distinguish legacy and Adaptation-enabled records:

```text
PromptKit Adaptation Profile: none | sdlc-overlay-v1
```

An absent or `none` profile validates using the current execution-control contract and preserves the dated Task Record identity `TASK-YYYY-MM-DD-<slug>`. `sdlc-overlay-v1` validates the current contract plus the new Adaptation fields and links and uses `TASK-<task-slug>`. Legacy templates and validators remain dated; existing records and links require no retroactive migration. PowerShell and Bash validators require equivalent legacy, valid-upgraded, and invalid-upgraded fixtures.

### Developer-Facing Language Contract

Canonical field names remain stable for validators and agent handoffs. Fill-in documents must add:

- a plain-language explanation immediately below or beside each technical field;
- one example for unfamiliar fields;
- Required, Optional, or Not applicable status;
- expanded acronym on first use;
- concise answer guidance;
- explicit permission to write `None` or `N/A` where valid.

Task 14 applies this language-only pass to `templates/execution-task-record-template.md`, `templates/tech-spec-template.md`, `templates/test-plan-template.md`, the CI triage template created by Task 12, `workflows/review.md` and the review report format, and release linkage/release checklist artifacts. It does not change canonical labels, ownership, TDD semantics, identity forms, or validator behavior.

Example:

```markdown
- **Affected Behavioral Components** *(Which parts of the system will change? List screens, APIs, jobs, database areas, or commands.)*:
- **Verification Condition** *(How will we prove this is complete?)*:
```

The agent and validator may use canonical technical terms, but a general developer should be able to complete a normal Minimal record without reading the glossary first.

### Friction Evaluation Contract

Formal friction measurement is optional for MVP and owned by the PromptKit maintainer when enabled. A network-free evaluation uses representative Trivial, Minimal Controlled, Full Controlled, TDD-enabled, and CI-failure scenarios. It compares added questions and artifacts with assumptions found, rework avoided, classification quality, false-positive suggestions, and relative context overhead. It must not impose a universal token target.
