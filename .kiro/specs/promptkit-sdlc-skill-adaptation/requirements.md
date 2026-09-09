# Requirements Document: PromptKit SDLC Skill Adaptation

## Status and Scope

**Status:** Revised design-approved specification; documentation-first.

**Current revision scope:** This specification revision changes only the planning artifacts in `.kiro/specs/promptkit-sdlc-skill-adaptation/`. A later implementation agent may update PromptKit workflows, templates, validators, and documentation according to the tasks in `tasks.md`; those implementation files are not changed by this revision.

**MVP intent:** Add low-friction, model-agnostic overlays to the existing Better-PromptKit lifecycle. Preserve the current router, workflow ownership, fast path, canonical Local Task Record, and human approval boundaries.

## Introduction

PromptKit SDLC Skill Adaptation adds decision-critical planning questions, evidence-backed technology decisions, opt-in test-first evidence, a recommendation-only simplification audit, and evidence-first CI failure triage to existing Better-PromptKit workflows.

The adaptation is an overlay, not a replacement lifecycle. `pk:route` remains the authoritative navigation and work-classification entry point. Existing workflows retain ownership of their current capabilities. New controls are activated only when the work or an explicit developer choice requires them.

The adaptation must improve total development-cycle confidence without making every task slower. Trivial Work keeps the current fast path. Controlled Work retains its Local Task Record readiness gate. Minimal and Full Planning Interrogation describe planning depth; they do not replace the existing `Trivial` and `Controlled` execution classifications.

## Goals

- Capture only decision-critical planning information for low-complexity work.
- Make assumptions visible, owned, and actionable before implementation.
- Ground material technology and vendor decisions in primary documentation or explicit uncertainty.
- Provide opt-in Red-Green-Refactor evidence without forcing TDD on every work item.
- Add a read-only simplification audit to the existing review report.
- Collect CI evidence before classifying failures or proposing remediation.
- Preserve the current lifecycle router, workflow ownership, fast path, and approval boundaries.
- Reduce total rework, repeated questions, context loss, and guessed fixes without creating unnecessary ceremony.
- Keep the neutral core portable and defer framework/provider adapters until a concrete repeated use case exists.

## Non-Goals

- No replacement for `pk:route`, `pk:plan`, `pk:tasks`, `pk:test`, `pk:review`, `pk:ship`, or another established workflow.
- No second authoritative work-classification system.
- No runtime orchestrator, compiler, sandbox, live-generation timer, or guarantee of model compliance.
- No automatic web research, source-code edit, CI retry, remote configuration mutation, deployment, release, rollback, or issue creation.
- No requirement that Trivial Work create a Task Record or planning artifact.
- No requirement that every Code Work item use TDD.
- No requirement to research every technology mention; source grounding applies only to material Technology or Vendor Decisions.
- No adapter inference from repository contents.
- No required adapter documents, network-backed tests, or advanced property-test framework in the MVP.
- No retroactive migration requirement for existing project records.
- No duplication of existing ownership for architecture, data, authorization, API contracts, accessibility, debugging, performance, delegation, or release execution.

## Glossary

- **PromptKit Adaptation:** The overlays defined by this document.
- **PromptKit Core:** Model-, framework-, and provider-neutral workflow guidance that remains usable without an adapter.
- **Trivial Work:** The existing `pk:route` fast-path category for bounded, short, single-concern work that does not require the Controlled Work readiness process.
- **Controlled Work:** The existing `pk:route` category for durable, substantive, multi-concern, public-contract, data, authorization, integration, configuration, release, or otherwise governed changes. Controlled Work uses a canonical Local Task Record before implementation.
- **Minimal Planning Interrogation:** A planning-depth mode requiring only the requested outcome, observable completion condition, and scope boundary.
- **Full Planning Interrogation:** A planning-depth mode requiring outcome, non-goals, affected components, external contracts, failure or rollback considerations, and verification approach.
- **Planning Record:** The planning section that records interrogation depth, responses, assumptions, material decisions, and links to existing planning artifacts.
- **Assumption Record:** An unanswered decision containing a provisional answer, validation action, decision owner, impact, and status.
- **Behavioral Component:** A cohesive unit delivering an observable user, API, job, command, library, or deployment behavior.
- **Technology or Vendor Decision:** A decision to adopt, replace, configure, version, or depend materially on an external technology, service, platform, framework, library, or managed service.
- **Material Claim:** A factual claim that affects a Technology or Vendor Decision, including compatibility, security behavior, supported limits, pricing, availability, lifecycle, or integration behavior.
- **Primary Documentation:** Documentation controlled by the technology, vendor, standards body, or project that owns the described product or specification.
- **Citation Record:** Publisher, document title, canonical URL, access date, and the Material Claim supported by the source.
- **Uncertainty Record:** An unverified or conflicting Material Claim, its impact, resolution action, owner, and status.
- **TDD Enforcement Mode:** An explicitly enabled mode requiring linked Red, Green, and Refactor evidence for Code Work.
- **Code Work:** Work changing executable application, library, automation, infrastructure-as-code, or test-code behavior.
- **Documentation Work:** Work changing explanatory documentation without changing executable behavior.
- **Configuration Work:** Work changing declarative settings without changing executable source behavior.
- **Research Work:** Work producing investigation findings without changing project behavior.
- **Simplification Audit:** A read-only review section identifying evidence-backed behavior-preserving deletion or complexity reduction opportunities.
- **CI Evidence:** Check identity, failed command or job, failure output, revision identifier, execution time, and relevant configuration context.
- **Remediation Plan:** A bounded CI response containing classification, suspected cause, affected scope, minimal change, verification, and reversal action.
- **Deferred Capability:** A documented future extension that is not required for MVP completion and is not part of the active implementation dependency graph.

## Existing Ownership Boundary

The adaptation preserves the following established ownership:

| Capability | Owner | Adaptation responsibility |
|---|---|---|
| Lifecycle routing and Trivial/Controlled classification | `pk:route` | Preserve routing; supply planning-depth input only. |
| Spec-driven architecture and implementation planning | `pk:plan` | Add the Planning Interrogation and decision-provenance overlay. |
| Task decomposition and acceptance criteria | `pk:tasks` | Add optional TDD ordering and evidence links. |
| Test seams, test pyramid, mocks, factories, and E2E allocation | `pk:test` | Define optional Red evidence without replacing test strategy. |
| API contracts | `pk:api` | Receive links when an external contract is affected. |
| Data, migrations, and RLS | `pk:data` | Remain the owner of schema and migration design. |
| Authentication and authorization | `pk:auth` | Remain the owner of capability and permission design. |
| Design and accessibility | `pk:design` | Remain the owner of UI and accessibility guidance. |
| Technical investigation | `pk:spike` | Receive targeted investigations for unresolved decisions. |
| Debugging and local reproduction | `pk:debug` | Receive CI failures requiring reproduction. |
| Review findings | `pk:review` | Add the recommendation-only Simplification Audit. |
| Release readiness and approval | `pk:ship` | Link CI triage and successful verification; preserve human authority. |
| Controlled execution evidence | Canonical Local Task Record | Remain the sole execution authority. |

## Requirements

### Requirement 1: Adaptive Planning Depth

**User Story:** As a developer, I want planning questions to match the work’s complexity, so that ordinary work starts promptly while governed work begins with explicit decisions.

1. WHEN a request enters `pk:route`, THE PromptKit Adaptation SHALL preserve the existing `Trivial` or `Controlled` classification and SHALL NOT replace it with a new authoritative classification.
2. WHEN work is Trivial, THE PromptKit Adaptation SHALL add no mandatory planning artifact or interrogation.
3. WHEN Controlled Work needs planning, THE PromptKit Adaptation SHALL select Minimal or Full Planning Interrogation based on the number of affected components, public contracts, persistent data, authorization, external integration, release configuration, and failure risk.
4. WHEN Minimal Planning Interrogation is selected, THE Planning Record SHALL require no more than three inputs: requested outcome, observable completion condition, and scope boundary.
5. WHEN Full Planning Interrogation is selected, THE Planning Record SHALL require requested outcome, explicit non-goals, affected Behavioral Components, externally visible contracts, failure or rollback considerations, and verification approach.
6. IF a required planning input remains unanswered, THEN THE Planning Record SHALL create an Assumption Record before implementation steps are created.
7. WHEN the interrogation completes, THE Planning Record SHALL preserve the selected depth, responses, assumptions, and links to existing workflow owners.
8. THE PromptKit Adaptation SHALL NOT repeat a completed question unless scope changes, an assumption is invalidated, or new evidence changes the decision.

### Requirement 2: Source-Grounded Technology and Vendor Decisions

**User Story:** As a developer, I want material technology and vendor decisions grounded in reliable evidence, so that planning distinguishes verified facts from assumptions without researching every technology mention.

1. WHEN a Planning Record contains a material Technology or Vendor Decision, THE Adaptation SHALL record the decision statement, considered options, Material Claims, selected option, rejected options, and remaining uncertainty.
2. THE Adaptation SHALL treat compatibility, security behavior, supported limits, pricing, availability, lifecycle, and integration behavior as Material Claims only when they affect the decision.
3. WHEN a Material Claim is used to compare options, THE Adaptation SHALL associate it with at least one Citation Record from Primary Documentation where available.
4. WHEN a citation is used, THE Citation Record SHALL contain publisher, document title, canonical URL, access date, and the supported Material Claim.
5. IF Primary Documentation is unavailable, inaccessible, stale, or conflicting, THEN THE Adaptation SHALL create an Uncertainty Record and offer only: defer the decision, run a targeted `pk:spike`, or proceed with an explicitly accepted assumption owned by a named decision maker.
6. THE Adaptation SHALL NOT require a new decision record for merely naming an existing technology without changing a material decision.
7. `pk:spike` SHALL remain the owner of investigation method and comparison depth.

### Requirement 3: Opt-In Red-Green-Refactor Evidence

**User Story:** As a developer, I want an enforceable test-first mode when it is useful, without imposing TDD on all work.

1. TDD Enforcement Mode SHALL be disabled by default.
2. WHEN TDD Enforcement Mode is enabled and work is Code Work, `pk:tasks` SHALL define a linked Red Step before its Green Step and a Refactor Step after Green.
3. WHEN `pk:test` defines a Red Step, THE test plan SHALL record the automated test, expected failing assertion, runnable command, and stable expected-behavior identifier.
4. WHEN Green is completed, THE execution evidence SHALL record the same Red test command and passing result.
5. WHEN Refactor is completed, THE execution evidence SHALL record the same Red test passing and SHALL retain the expected behavior without silently changing the acceptance condition.
6. TDD evidence SHALL be recorded or linked from the canonical Local Task Record for Controlled Work. Issue and test-plan artifacts are supporting references, not competing authorities.
7. WHEN work is Documentation Work, Configuration Work, or Research Work, THE Adaptation SHALL create an appropriate verification task instead of a Red-Green-Refactor chain.
8. Ambiguous work SHALL NOT receive an automatic TDD exception; it shall be clarified or follow the Code Work path.
9. TDD mode SHALL preserve existing test-pyramid, seam, framework, runner, and task-sizing ownership.

### Requirement 4: Simplification and Deletion Audit

**User Story:** As a reviewer, I want a focused simplification check so that changes remove unnecessary complexity where the diff provides evidence for doing so.

1. WHEN `pk:review` evaluates a non-empty, resolved change set, THE review report SHALL include a Simplification Audit section.
2. A Simplification Candidate SHALL be classified as deletion, consolidation, inlining, or control-flow reduction.
3. Each candidate SHALL include affected location, supporting diff evidence, behavior-preservation condition, risk, and verification action.
4. IF no defensible candidate exists, THEN the review report SHALL explicitly record that no Simplification Candidates were found.
5. Simplification Candidates SHALL be recommendations only and SHALL NOT edit, stage, commit, or approve source changes.
6. The audit SHALL not duplicate the existing two-axis review or Fowler smell baseline.
7. A candidate SHALL NOT be reported when evidence or a verification path is missing.

### Requirement 5: Evidence-First CI Failure Triage

**User Story:** As a release owner, I want CI failures classified from evidence before remediation is proposed, so that release recovery avoids blind fixes and retries.

1. WHEN a CI Failure is reported, THE Adaptation SHALL collect CI Evidence before creating a Remediation Plan.
2. WHERE GitHub CLI is available and authenticated for the relevant repository, THE Adaptation MAY use it only for read-only evidence retrieval.
3. IF GitHub CLI is unavailable, unauthenticated, inaccessible, or insufficient, THEN the workflow SHALL request a CI run URL or copied output and provide platform-neutral evidence-collection instructions.
4. WHEN evidence is sufficient, THE Adaptation SHALL classify the failure as test, static analysis, build, dependency or environment, infrastructure or transient, deployment, or unknown.
5. IF evidence is insufficient, THEN the workflow SHALL create an evidence request and SHALL NOT propose a source-code change.
6. WHEN evidence supports remediation, THE Remediation Plan SHALL state classification, suspected cause, affected scope, minimal change, verification command, and rollback or reversal action.
7. WHEN a Remediation Plan includes remote retry, repository configuration change, deployment, or rollback, THE plan SHALL remain pending until an action-specific human confirmation record is recorded. The confirmation record SHALL identify the proposed action, confirmation state, approver, timestamp, scope, reversal or rollback action, and resume condition. Confirmation for one action SHALL NOT authorize another action.
8. WHEN a CI Failure affects a release candidate, THE Remediation Plan and successful verification SHALL link to the existing `pk:ship` pre-release record.
9. Local reproduction needs SHALL route to `pk:debug`; release readiness and resumption SHALL remain owned by `pk:ship`.

### Requirement 6: Deferred Optional Adapters

**User Story:** As a maintainer, I want future framework and provider guidance isolated from PromptKit Core, without expanding the MVP unnecessarily.

1. PromptKit Core SHALL remain model-, framework-, and provider-neutral.
2. React, Supabase/RLS, and deployment-provider adapters MAY be specified as future Optional Adapters, but they SHALL be Deferred Capabilities for this MVP.
3. Deferred adapters SHALL NOT be required for MVP completion or appear in the active implementation dependency graph.
4. When a future adapter is eventually implemented, selection SHALL be explicit, domain-scoped, labeled adapter-specific, and subject to the same source-grounding rules.
5. The core path SHALL remain complete when no adapter is selected.
6. Adapter inference from repository contents SHALL remain prohibited.
7. Advanced property-test infrastructure and network-backed CLI integration tests are also Deferred Capabilities for this MVP.

### Requirement 7: Existing Workflow Ownership and Boundaries

**User Story:** As a Better-PromptKit maintainer, I want the adaptation to complement existing workflows rather than duplicate them.

1. THE Adaptation SHALL preserve the Existing Ownership Boundary in this document.
2. `pk:route` SHALL remain responsible for lifecycle routing and Trivial/Controlled classification.
3. `pk:plan` changes SHALL be limited to planning depth, assumptions, and source-grounded decision records.
4. `pk:test` and `pk:tasks` changes SHALL be limited to opt-in TDD evidence and ordering.
5. `pk:review` changes SHALL be limited to the recommendation-only Simplification Audit.
6. `pk:ship` changes SHALL be limited to CI evidence and triage linkage.
7. Existing owners such as `pk:data`, `pk:auth`, `pk:api`, `pk:design`, `pk:debug`, `pk:spike`, and release approval SHALL retain their current authority.
8. The Adaptation SHALL NOT create a replacement lifecycle trigger or parallel execution authority.

### Requirement 8: Backward Compatibility and Non-Regression

**User Story:** As a maintainer, I want the adaptation to be adoptable incrementally, so that existing projects and records continue to work.

1. Existing Trivial Work SHALL retain its current fast path with zero new mandatory ceremony.
2. Existing Controlled Work SHALL retain its Local Task Record readiness, ownership, transition, and completion requirements.
3. New fields and sections SHALL be additive to existing artifacts where implemented.
4. Existing project records SHALL remain valid without retroactive migration unless a separate approved task requires it.
5. Existing workflow triggers, ownership boundaries, approval requirements, release protections, and rollback boundaries SHALL remain unchanged.
6. Any implementation SHALL be incrementally deployable and reversible by workflow or artifact section.
7. A validator result SHALL remain evidence only and SHALL NOT become commit, release, deployment, or rollback approval.

### Requirement 9: Process Cost, Token, and Friction Budget

**User Story:** As a developer, I want the new controls to improve confidence without making routine development unnecessarily slow or expensive.

1. Trivial Work SHALL incur zero required Adaptation artifacts or interrogation questions.
2. Minimal Planning Interrogation SHALL have no more than three required inputs and SHALL NOT silently trigger the complete RFC process.
3. Full Planning Interrogation SHALL be limited to substantive, high-risk, or explicitly requested planning.
4. TDD, source research, CI triage, and simplification recommendations SHALL activate only when their trigger conditions are met.
5. Workflow content SHALL be linked rather than copied into new records whenever possible.
6. The Adaptation SHALL avoid asking the same question or recording the same evidence in multiple authoritative locations.
7. Implementations SHOULD measure added planning effort against reduced rework, repeated questions, failed remediation, and context loss.
8. Exact token budgets SHALL remain implementation- and model-independent; relative overhead and outcome measures are the required evaluation target.
9. A developer MAY explicitly choose a lightweight path for work that does not require Controlled Work governance, subject to existing `pk:route` rules.

### Requirement 10: Measurable Success and Traceability

**User Story:** As a maintainer, I want to know whether the adaptation is actually better than the current system, so that process can be corrected instead of expanded by assumption.

1. The revised implementation SHALL preserve measurable fast-path behavior for Trivial Work.
2. Evaluation SHALL compare Minimal and Full planning effort against comparable current-system work.
3. Evaluation SHOULD track assumption discovery before implementation, decision evidence completeness, TDD evidence completeness when enabled, CI classification quality, simplification false-positive rate, and process bypasses.
4. Requirements, design rules, implementation tasks, verification conditions, and Deferred Capabilities SHALL be cross-referenced.
5. No requirement SHALL be considered complete solely because a Markdown section exists; its required artifact shape, owner, verification, and boundary SHALL be reviewable.

## MVP Scope

The active MVP includes:

- compatible planning-depth interrogation;
- Assumption Records;
- source-grounded material decisions;
- opt-in TDD evidence;
- Simplification Audit;
- evidence-first CI triage;
- backward-compatibility safeguards;
- friction and token-overhead guidance;
- deterministic documentation/reference validation.

## Deferred Scope

The following remain documented for future work but are not required for MVP:

- React adapter;
- Supabase/RLS adapter;
- deployment-provider adapter;
- advanced property-based artifact generation;
- network-backed GitHub CLI integration checks;
- broad adapter catalogs or automatic adapter selection.

## Completion Criteria

The requirements revision is complete when:

- no new classification conflicts with `Trivial/Controlled`;
- Minimal and Full Planning Interrogation are unambiguous;
- the Local Task Record remains authoritative;
- TDD is explicitly opt-in and bounded;
- source grounding is limited to material decisions;
- simplification review is recommendation-only;
- CI triage is evidence-first and human-action-safe;
- backward compatibility and no-retroactive-migration rules are explicit;
- process-cost and token-friction safeguards are explicit;
- Deferred Capabilities are excluded from MVP completion;
- every requirement maps to design and implementation task coverage.


## Normative Final Clarifications for Implementation

This section resolves implementation ambiguity identified during final review. Where an earlier general statement is less specific than this section, this section controls.

### Conditional TDD and Canonical Mode

- TDD Enforcement Mode is disabled by default.
- For Controlled Work, the canonical Local Task Record owns the field `TDD Enforcement Mode: disabled | enabled`.
- Planning and test-plan artifacts may recommend or reference the setting, but they do not activate it independently.
- If the field is absent, the mode is `disabled`.
- If planning and the Task Record disagree, the Task Record is authoritative and the disagreement is a planning blocker.
- Existing TDD sections in `pk:plan`, `pk:tasks`, and the technical-spec template are conditional: enabled mode uses Red-Green-Refactor; disabled mode uses normal implementation milestones and verification.
- Trivial Work does not need a TDD field because it does not require a Task Record.

### Minimal Planning and Controlled Readiness

Minimal Planning limits the questions asked; it does not remove readiness evidence required for Controlled Work.

A Controlled Work Task Record still requires the existing objective, in-scope work, explicit non-goals, dependencies, acceptance criteria, owner and approval boundary, verification condition, execution policy, stop conditions, and state fields.

The Minimal inputs map as follows:

| Minimal input | Controlled readiness contribution |
|---|---|
| Requested outcome | Objective |
| Observable completion condition | Acceptance and verification input |
| Scope boundary | In-scope files, behaviors, and non-goals |

Mandatory Full Planning triggers override a lightweight request when work affects public contracts, persistent data, authorization, external integrations, release configuration, multiple components, serious rollback/data-loss risk, or explicitly requested architecture planning.

### Canonical Artifact Contracts

| Artifact | Canonical location | Identity | Authority | Required evidence |
|---|---|---|---|---|
| Planning Record | Section in the existing technical specification under `docs/specs/` | `PLAN-<spec-slug>` | `pk:plan` | Depth, responses, assumptions, links |
| Assumption Record | Planning Record section | `ASSUMPTION-<spec-slug>-<nnn>` | `pk:plan` | Provisional answer, impact, validation action, owner, status |
| Decision/Citation/Uncertainty Records | Planning Record section | `DECISION-<spec-slug>-<nnn>`, `CLAIM-<decision-id>-<nnn>`, `CITATION-<decision-id>-<nnn>`, `UNCERTAINTY-<decision-id>-<nnn>` | `pk:plan` | Options, claims, sources, disposition, unresolved impact |
| TDD intent register | Existing test-plan artifact under `docs/tests/` | `TDD-INTENT-<task-slug>-<nnn>` and behavior ID | `pk:test` for intent | Test, expected failure, command, behavior ID |
| TDD execution evidence | Canonical `docs/tasks/<task-id>.md` | `TDD-EXEC-<task-slug>-<behavior-seq>` | Local Task Record | Red failure, Green pass, Refactor pass |
| Simplification Audit | Existing `pk:review` report | `REVIEW-<review-slug>` and `SIMPLIFICATION-<review-id>-<nnn>` | `pk:review` | Candidate or explicit no-candidate result |
| CI Triage Record | Standalone `docs/releases/ci-triage/<ci-failure-id>.md` | `CI-<provider>-<run-id>` | CI triage owner | Evidence, state, classification, plan, verification |
| Release linkage | Existing `docs/releases/<release>.md` record | `RELEASE-<release-slug>` | `pk:ship` | Triage link, verified result, resume condition |

New records must link to the canonical Task Record, specification, release record, or review report where applicable. A supporting view must not become a second authority.

### Artifact Identity, Field Status, and Link Contracts

The later implementation SHALL use the artifact locations and authorities in the Canonical Artifact Contracts table and SHALL not create parallel record locations. Stable identities SHALL be immutable after creation and SHALL use these exact forms, with lowercase kebab-case slugs and a zero-padded three-digit sequence where shown:

```text
PLAN-<spec-slug>
ASSUMPTION-<spec-slug>-<nnn>
DECISION-<spec-slug>-<nnn>
CLAIM-<decision-id>-<nnn>
CITATION-<decision-id>-<nnn>
UNCERTAINTY-<decision-id>-<nnn>
TASK-<task-slug>
BEHAVIOR-<task-slug>-<nnn>
TDD-INTENT-<task-slug>-<nnn>
TDD-EXEC-<task-slug>-<behavior-seq>
REVIEW-<review-slug>
SIMPLIFICATION-<review-id>-<nnn>
CI-<provider>-<run-id>
ACTION-<ci-id>-<nnn>
RELEASE-<release-slug>
```

Cross-record links SHALL use `[<stable-id>](<relative-path>#<stable-id>)`; links to records in the same file SHALL use `[<stable-id>](#<stable-id>)`. Every linked record SHALL expose the same stable ID as its explicit anchor target. Every fill-in field SHALL be labeled `Required`, `Optional`, or `Not applicable`. `N/A — <reason>` is permitted only where the artifact contract allows it, while `None` records that a valid collection has no entries. Record metadata does not count as one of Minimal Planning’s three interrogation inputs.

The artifact contract SHALL require, at minimum:

- Planning Records: ID, depth, outcome, completion condition, scope boundary, owner, status, and Full-mode fields for non-goals, affected components, external contracts, failure/rollback considerations, and verification approach.
- Assumption Records: unanswered decision, provisional answer, impact, validation action, owner, and status.
- Decision/Citation/Uncertainty records: decision options and disposition; claim-to-citation or claim-to-uncertainty links; citation publisher, title, canonical URL, access date, and supported claim; and uncertainty impact, resolution action, owner, and status.
- TDD intent and execution records: Task Record link, behavior ID, mode reference, test and expected failure command for intent, and Red/Green/Refactor results for execution. When `TDD Enforcement Mode` is disabled, the intent register is `N/A — TDD Enforcement Mode disabled`; Documentation, Configuration, and Research Work use an exception verification link instead of a TDD chain.
- Simplification Audits: review/diff reference, candidate ID or `No Simplification Candidates found`; candidates include location, diff evidence, behavior-preservation condition, risk, verification, and recommendation.
- CI Triage Records: CI evidence, owner, state, sufficient-evidence classification, supported remediation, verification evidence, resume condition, and `pk:ship` link for release candidates. CI states SHALL be `evidence_requested`, `evidence_sufficient`, `classified`, `remediation_planned`, `awaiting_confirmation`, `local_reproduction_or_fix`, `verification_pending`, `verified`, `linked_to_pk_ship`, or `blocked`.
- Release linkage: release ID, CI Triage link, verification link, verified result, and resume condition; `pk:ship` remains the authority for release state.

Each proposed remote retry, repository configuration change, deployment, or rollback SHALL have its own `ACTION-<ci-id>-<nnn>` block containing the proposed action, `pending | confirmed | declined` confirmation state, approver, confirmation timestamp, bounded scope, reversal or rollback action, and resume condition. Approver and timestamp MAY be `N/A — awaiting confirmation` only while the action is pending; confirmed or declined actions require both. One action’s confirmation SHALL never authorize another action, and recording confirmation SHALL not execute the action. A release candidate SHALL not resume unless its CI Triage Record reaches `verified` and then `linked_to_pk_ship`.

The validator boundary is deterministic and network-free: it SHALL check IDs, locations, labels, links, states, required-field conditions, ownership, cross-record invariants, and deferred-scope boundaries. It SHALL not verify external URLs, execute commands, or authorize remote or release actions.


CI Triage Records use these states:

```text
evidence_requested
  -> evidence_sufficient
  -> classified
  -> remediation_planned
  -> awaiting_confirmation       (only when a remote action is proposed)
  -> local_reproduction_or_fix
  -> verification_pending
  -> verified
  -> linked_to_pk_ship
```

Any state may become `blocked` with an owner and precise resume condition. `pk:debug` owns local reproduction, the engineer owns an in-scope fix, and `pk:ship` owns release blocking and resumption. Only `verified` followed by `linked_to_pk_ship` permits a release candidate to resume. A proposed fix, classification, empty blocker list, or passing unrelated validator never permits release resumption.

### Legacy Validator Compatibility

- Existing Task Records without an Adaptation marker remain valid under the existing execution-control contract.
- An optional Task Record field `PromptKit Adaptation Profile: none | sdlc-overlay-v1` identifies whether Adaptation-specific validation applies.
- `none` or an absent marker means legacy validation only.
- `sdlc-overlay-v1` means the new Adaptation fields and links are also validated.
- No existing record requires retroactive migration.
- Later validator work must include legacy, valid upgraded, and invalid upgraded fixtures for both PowerShell and Bash behavior.

### Developer-Friendly Fill-In Language

Canonical field names remain stable for agents and validators, but every developer-facing field must include a plain-language instruction, an example where useful, and a clear Required/Optional/Not applicable label. For example:

```markdown
- **Affected Behavioral Components** *(Which parts of the system will change? List screens, APIs, jobs, database areas, or commands.)*:
- **Externally Visible Contracts** *(Will an API, data format, command, integration, or user-visible behavior change? Write `None` if not applicable.)*:
- **Verification Condition** *(How will we prove this is complete?)*:
```

Acronyms must be expanded on first use. Technical definitions remain in the glossary, but developers should not need to read the glossary to complete a normal Minimal record. Required fields must accept concise answers and explicitly explain when `None` or `N/A` is valid.

### Friction Evaluation Ownership

Formal friction measurement is lightweight and may remain optional for MVP, but if collected it is owned by the PromptKit maintainer and records representative Trivial, Minimal Controlled, Full Controlled, TDD-enabled, and CI-failure scenarios. It compares added questions/artifacts with assumptions found, rework avoided, and relative context overhead; it does not impose a universal token limit.
