# Implementation Plan: PromptKit SDLC Skill Adaptation

## Overview

Implement the Adaptation as documentation-first overlays over the existing Better-PromptKit lifecycle. Preserve the current router, Trivial/Controlled classification, fast path, Local Task Record authority, workflow ownership, and human approval boundaries.

This task plan is for a later implementation agent. The current specification revision changes only the files in this `.kiro/specs/promptkit-sdlc-skill-adaptation/` directory.

## Implementation Principles

- Do not create a replacement lifecycle workflow or trigger.
- Do not replace `Trivial/Controlled` with another authoritative classification.
- Do not add ceremony to Trivial Work.
- Use Minimal/Full Planning Interrogation only as planning depth.
- Keep the Local Task Record authoritative for Controlled Work.
- Keep TDD disabled by default and opt-in.
- Research only material technology/vendor decisions.
- Keep simplification review read-only and recommendation-only.
- Collect CI evidence before proposing remediation.
- Keep all remote actions and release approval human-only.
- Keep adapters, automatic adapter selection, network checks, and advanced property testing deferred.
- Prefer concise, link-based artifacts over duplicated workflow text.
- Every active task must have an objective, boundary, verification, and demoable result.

## Task Dependency Graph

This is the single authoritative implementation sequence. Every task-level dependency below is part of this graph; no second dependency order or final-gate graph overrides it.

```text
Task 1: Compatibility and authority contracts
  +--> Task 2: Planning depth and Assumption Records
  |      +--> Task 3: Source-grounded decisions
  |      +--> Task 10: Minimal Planning to Controlled readiness
  |      +--> Task 14: Developer-friendly field language (also requires Tasks 3 and 11)
  |
  +--> Task 9: Canonical TDD mode and conditional behavior
  |      +--> Task 4: Optional TDD evidence (also requires Task 11)
  |      +--> Task 13: Legacy and Adaptation validator profiles (also requires Task 11)
  |
  +--> Task 11: Canonical artifact paths, identities, and schemas
           +--> Task 4: Optional TDD evidence (also requires Task 9)
           +--> Task 5: Simplification Audit
           +--> Task 6: CI triage linkage
           |      +--> Task 12: CI states and release handoff
           +--> Task 13: Legacy and Adaptation validator profiles (also requires Task 9)
           +--> Task 14: Developer-friendly field language (also requires Tasks 2 and 3)

Tasks 2, 3, 4, 5, 6, 9, 10, 11, 12, 13, and 14
  +--> Task 7: Deterministic MVP artifact and reference validation
          +--> Task 8: MVP boundary and implementation handoff baseline

Tasks 1–14
  +--> Task 16: Final cross-document traceability gate
       (Task 15 must be complete or explicitly deferred; it never blocks MVP)

Task 15: Optional friction evaluation
  - may run after Tasks 2, 9, 10, 12, and 14
  - may be completed or explicitly deferred before Task 16
```

Tasks may run in parallel only after their listed prerequisites are complete and their file ownership does not overlap. Schemas and authority rules precede overlays and validators. Task 16 is the only final consistency gate.

## Active MVP Tasks

- [ ] **Task 1: Establish compatibility and authority contracts**

  **Objective:** Add the shared ownership and non-regression rules without changing the lifecycle router.

  **Implementation guidance:**
  - Preserve `pk:route` as the authority for Trivial/Controlled classification.
  - Define Minimal/Full Planning Interrogation as planning depth only.
  - Preserve the canonical Local Task Record as the Controlled Work authority.
  - Document existing workflow ownership and human approval boundaries.
  - Keep new fields additive and existing records valid.

  **Dependencies:** None.

  **Verification:**
  - Requirements and design use no conflicting authoritative classification.
  - Authority matrix assigns one owner per evidence type.
  - Existing fast-path, Controlled Work, approval, release, and rollback boundaries remain represented.

  **Demoable result:** A reviewer can trace Trivial and Controlled Work through the new design without finding a new competing router or task authority.

  **Requirement coverage:** 7, 8, 9, 10.

- [ ] **Task 2: Add adaptive Planning Record and Assumption Record support**

  **Objective:** Allow planning depth to match work complexity without forcing every task through a full RFC.

  **Implementation guidance:**
  - Define Minimal mode with no more than requested outcome, completion condition, and scope boundary.
  - Define Full mode with non-goals, components, contracts, failure/rollback, and verification.
  - State that Trivial Work has no mandatory Adaptation artifact.
  - State that Minimal mode does not silently continue into the full RFC.
  - Convert missing required inputs into owned Assumption Records.
  - Prevent repeated questions unless scope, assumptions, or evidence change.

  **Dependencies:** Task 1.

  **Verification:**
  - Minimal complete, Full complete, missing-input, and changed-scope examples are covered.
  - Every unanswered required field has owner, validation action, impact, and status.
  - Existing `pk:plan` architecture, contracts, migrations, FMEA, milestones, and grilling remain authoritative.

  **Demoable result:** A small Controlled Work item receives a short planning record, while an API or database change receives the full planning input.

  **Requirement coverage:** 1, 8, 9, 10.

- [ ] **Task 3: Add targeted source-grounded decision records**

  **Objective:** Make material technology/vendor decisions reviewable without requiring research for every technology mention.

  **Implementation guidance:**
  - Define decision, option, Material Claim, Citation Record, and Uncertainty Record fields.
  - Require primary documentation where available.
  - Record unavailable, stale, inaccessible, or conflicting sources as uncertainty.
  - Route investigation depth to `pk:spike`.
  - Do not create a decision record for simply naming an existing technology.

  **Dependencies:** Tasks 1 and 2.

  **Verification:**
  - Complete citation, missing citation, conflicting source, and non-decision mention scenarios are covered.
  - Every concluded material decision has selected/rejected options and remaining uncertainty status.
  - No source claim is presented as verified without citation or an explicit accepted assumption.

  **Demoable result:** A reviewer can trace a material dependency choice from decision to claim to primary source or documented uncertainty.

  **Requirement coverage:** 2, 7, 9, 10.

- [ ] **Task 4: Add opt-in TDD evidence through the canonical task authority**

  **Objective:** Provide bounded Red/Green/Refactor evidence without forcing TDD or multiplying task authorities.

  **Implementation guidance:**
  - Keep TDD disabled by default.
  - For disabled Code Work, record both the TDD intent register and TDD execution evidence as `N/A — TDD Enforcement Mode disabled`; retain normal dependency-ordered milestones, acceptance criteria, test strategy, review, and verification evidence.
  - Define one authoritative TDD mode field in the canonical Local Task Record; planning and test-plan artifacts may propose or reference it but cannot activate it independently.
  - Use one expected-behavior identifier across Red, Green, and Refactor.
  - Record execution evidence in or linked from the Local Task Record.
  - Keep issue and test-plan artifacts as supporting views.
  - Permit the exception verification path only for Documentation, Configuration, and Research Work; disabled Code Work follows the normal milestone path and is not a TDD exception.
  - Preserve existing `pk:test` seams and `pk:tasks` sizing and acceptance criteria.

  **Dependencies:** Tasks 1, 9, and 11.

  **Verification:**
  - TDD-disabled Code Work records both TDD evidence fields as `N/A — TDD Enforcement Mode disabled` while retaining normal milestones, acceptance criteria, test strategy, review, and verification.
  - TDD-enabled Code Work has Red-before-Green-before-Refactor evidence.
  - Green and Refactor use the same Red test.
  - Documentation, Configuration, Research, and ambiguous work scenarios are covered.
  - TDD does not require three separate issues for one behavior.

  **Demoable result:** One Controlled Work item shows a complete linked TDD evidence chain in the canonical execution authority.

  **Requirement coverage:** 3, 7, 8, 9.

- [ ] **Task 5: Add the recommendation-only Simplification Audit**

  **Objective:** Extend `pk:review` with an evidence-backed simplification section without creating a third review workflow.

  **Implementation guidance:**
  - Run only for a non-empty, resolved diff.
  - Permit only deletion, consolidation, inlining, and control-flow reduction.
  - Require location, diff evidence, behavior-preservation condition, risk, and verification.
  - Make no defensible candidate a valid result.
  - Never edit, stage, commit, or approve source changes from the audit.
  - Preserve existing review axes, severity framework, and data-loss audit.

  **Dependencies:** Tasks 1 and 11.

  **Verification:**
  - Candidate, no-candidate, empty-diff, and unsupported-evidence scenarios are covered.
  - No unsupported cleanup idea is reported as a Simplification Candidate.
  - The audit does not duplicate the existing Fowler smell baseline.

  **Demoable result:** A review report contains either an evidence-backed recommendation or an explicit no-candidate result.

  **Requirement coverage:** 4, 7, 9.

- [ ] **Task 6: Add evidence-first CI triage linkage**

  **Objective:** Improve CI failure recovery while preserving `pk:debug`, `pk:ship`, and human approval boundaries.

  **Implementation guidance:**
  - Collect CI evidence before classification or source-change recommendation.
  - Keep GitHub CLI read-only and conditional.
  - Provide platform-neutral fallback instructions.
  - Produce no source-change recommendation when evidence is insufficient.
  - Route local reproduction needs to `pk:debug`.
  - Keep release candidates blocked until successful verification is linked to `pk:ship`.
  - Require explicit confirmation for remote retry, repository configuration, deployment, or rollback, with action, approver, timestamp, scope, reversal, and resume condition recorded separately for each action.

  **Dependencies:** Tasks 1 and 11.

  **Verification:**
  - Sufficient, insufficient, unknown, remote-action, and release-candidate scenarios are covered.
  - Evidence precedes classification and remediation.
  - Release resumption requires successful verification.
  - No remote action occurs automatically.

  **Demoable result:** A failed CI run produces either a bounded remediation plan or an evidence request, never a guessed fix or automatic retry.

  **Requirement coverage:** 5, 7, 8, 9.

- [ ] **Task 7: Add deterministic MVP artifact and reference validation**

  **Objective:** Validate the new documentation contracts without introducing a premature property-test or network-test framework.

  **Implementation guidance:**
  - Validate required headings and fields for planning, citations, uncertainty, TDD, simplification, and CI artifacts.
  - Validate owner and workflow references.
  - Validate core neutrality and deferred-scope boundaries.
  - Validate that TDD evidence points to canonical execution authority.
  - Keep MVP checks deterministic and network-free.
  - Preserve existing validator behavior.

  **Dependencies:** Tasks 2–6, 9–14.

  **Verification:**
  - Valid fixtures pass.
  - Missing-field fixtures fail clearly.
  - Conflicting-authority fixtures fail clearly.
  - Adapter leakage and active-dependency-on-deferred-work fixtures fail clearly.
  - Existing reference validation remains compatible.

  **Demoable result:** A deterministic validator catches an incomplete, conflicting, or out-of-scope Adaptation artifact before implementation proceeds.

  **Requirement coverage:** 7, 8, 9, 10.

- [ ] **Task 8: Complete the MVP boundary and implementation handoff baseline**

  **Objective:** Verify the active MVP boundary and provide a non-final handoff baseline before the single final traceability gate.

  **Implementation guidance:**
  - Map active requirements to design coverage and active implementation tasks.
  - Confirm every active task has objective, scope, dependencies, verification, and demo.
  - Confirm no active task requires adapters, network checks, or advanced property testing.
  - Confirm no active task changes workflow ownership or creates a competing authority.
  - Leave final cross-document consistency approval to Task 16.

  **Dependencies:** Task 7.

  **Verification:**
  - Active MVP and Deferred Capability boundaries are explicit.
  - Requirements, design, and active tasks use the same authority and scope terms.
  - The handoff baseline identifies any remaining final-traceability work without treating this task as final approval.

  **Demoable result:** A later implementation agent receives a bounded MVP handoff with no active dependency on deferred capabilities and a clear list of final traceability checks.

  **Requirement coverage:** 1–10.

## Deferred Future Tasks

These tasks are documented for future planning but are not active MVP work:

- [ ] **Deferred Task D1: Implement explicit React adapter**
  - Only after a repeated React-specific use case exists.
  - Must label all guidance adapter-specific and route to existing owners.

- [ ] **Deferred Task D2: Implement explicit Supabase/RLS adapter**
  - Only after a repeated provider-specific use case exists.
  - Must preserve `pk:data`, `pk:auth`, and `pk:test` ownership.

- [ ] **Deferred Task D3: Implement explicit deployment-provider adapter**
  - Only after a repeated provider-specific use case exists.
  - Must preserve `pk:ship` sequencing, rollback, and approval ownership.

- [ ] **Deferred Task D4: Add advanced property-based artifact validation**
  - Requires an actual structured artifact model and executable harness.
  - JSON descriptions alone are not considered executable property tests.

- [ ] **Deferred Task D5: Add network-backed GitHub CLI integration checks**
  - Must remain opt-in, read-only, authenticated, and separate from the network-free MVP suite.

Deferred tasks must not be required by MVP completion, active dependencies, or core workflow behavior.

## Cross-Document Traceability

| Requirement | Design coverage | Active task coverage |
|---|---|---|
| 1. Adaptive Planning Depth | Planning Depth Model, Assumption Handling, Minimal Planning to Controlled Readiness | Tasks 1–2, 8, 10, 16 |
| 2. Source-Grounded Decisions | Source-Grounded Decision Model, Canonical Artifact Contracts | Tasks 3, 8, 11, 14, 16 |
| 3. Opt-In TDD | Optional TDD Evidence Model, TDD Authority Contract | Tasks 4, 8, 9, 11, 13, 16 |
| 4. Simplification Audit | Simplification Audit Model, Canonical Artifact Contracts | Tasks 5, 8, 11, 16 |
| 5. CI Triage | CI Triage Model, CI State Machine, Action Contract | Tasks 6, 8, 11–12, 16 |
| 6. Deferred Adapters | MVP and Deferred Scope | Deferred Tasks D1–D5, Tasks 7–8, 16 |
| 7. Existing Ownership | Authority Model and Integration Points | Tasks 1, 4–8, 11, 13, 16 |
| 8. Backward Compatibility | Backward Compatibility and Non-Regression, Legacy Validator Gate | Tasks 1, 7–8, 11, 13, 16 |
| 9. Process Cost | Process Cost, Token, and Friction Budget, Developer-Facing Language Contract | Tasks 1–2, 8, 10, 14–16 |
| 10. Measurable Success | Evaluation Measures, Correctness Properties, Friction Evaluation Contract | Tasks 7–8, 11, 15–16 |

## MVP Completion Criteria

MVP implementation is complete only when:

- Trivial Work retains its existing fast path.
- Controlled Work retains canonical Local Task Record readiness and completion.
- Minimal and Full planning behavior are explicit and non-conflicting.
- Assumptions are owned and validated rather than silently invented.
- Material technology decisions have evidence or explicit uncertainty.
- TDD is opt-in, bounded, and linked to canonical execution evidence.
- Simplification review is recommendation-only and permits no-candidate results.
- CI triage is evidence-first and release-linked.
- Human approval remains required for external actions.
- Existing records remain valid without forced migration.
- Process-cost and token-friction safeguards are documented and reviewable.
- No adapter, automatic adapter selection, network-backed test, or advanced property framework is required.
- Deterministic validation and cross-document traceability pass.

## Notes for the Later Implementation Agent

- Implement one overlay at a time and validate before adding the next.
- Do not copy entire existing workflows into new sections; link to their owners.
- Do not create a second task or execution authority.
- If a proposed implementation would add mandatory ceremony to Trivial Work, stop and revise the scope.
- If a requirement appears to need a new workflow, first check whether the existing owner can receive a narrow overlay.
- Record scope expansion through the existing Controlled Work Scope Change process.
- Treat passing validation as evidence only, never as approval for commits, releases, deployment, or rollback.


## Final Implementation-Readiness Tasks

These tasks clarify and extend the active MVP sequence. They supersede any earlier wording that left authority, state, path, or compatibility decisions open.

- [ ] **Task 9: Make TDD conditional and assign one canonical mode owner**

  **Objective:** Resolve the conflict between opt-in TDD and existing TDD-by-default planning language.

  **Implementation guidance:**
  - Add `TDD Enforcement Mode: disabled | enabled` to the canonical Controlled Work Task Record contract.
  - Default an absent field to `disabled`.
  - Make planning and test-plan fields references/proposals rather than independent activation points.
  - Add explicit enabled and disabled branches to `pk:plan`, `pk:tasks`, and the technical-spec integration.
  - In the disabled Code Work branch, set both TDD intent and execution evidence to `N/A — TDD Enforcement Mode disabled`; retain normal dependency-ordered milestones, acceptance criteria, test strategy, review, and verification.
  - Keep acceptance criteria, test strategy, review, and verification in both branches.

  **Dependencies:** Task 1.

  **Verification:**
  - Existing TDD language is conditional in the implementation instructions.
  - Conflicting mode values resolve to the Task Record.
  - TDD-disabled Code Work has a complete normal-milestone path.

  **Demoable result:** An implementation agent can choose a non-TDD path without violating an existing PromptKit requirement.

  **Requirement coverage:** 3, 7, 8, 9.

- [ ] **Task 10: Map Minimal Planning to Controlled readiness**

  **Objective:** Preserve the three-question Minimal experience without weakening Local Task Record readiness.

  **Implementation guidance:**
  - Map outcome to Objective, completion condition to Acceptance/Verification input, and scope to In Scope/Non-Goals.
  - Require all existing readiness fields for Controlled Work, using concrete `None`/not-applicable explanations where appropriate.
  - Define mandatory Full triggers for public contracts, data, auth, integrations, release risk, multiple components, rollback risk, and explicit architecture requests.
  - Make mandatory Full triggers override lightweight requests.

  **Dependencies:** Tasks 1 and 2.

  **Verification:**
  - Minimal planning never bypasses Controlled readiness.
  - High-risk work cannot remain in Minimal mode.
  - Trivial Work remains free of mandatory Adaptation ceremony.

  **Demoable result:** A simple Controlled change is quick to plan but still produces a ready Task Record.

  **Requirement coverage:** 1, 8, 9.

- [ ] **Task 11: Define canonical artifact paths, identities, and schemas**

  **Objective:** Prevent implementation agents from inventing competing record locations, fields, states, or cross-record links.

  **Implementation guidance:**
  - Define one canonical artifact matrix for Planning, Assumption, Decision/Citation/Uncertainty, TDD, Simplification, CI, and release linkage records.
  - Use the existing technical spec, test plan, Local Task Record, review report, and release record where they already provide an owner; only CI triage is a new standalone evidence record.
  - Define the CI Triage Record path `docs/releases/ci-triage/<ci-failure-id>.md`, `CI-<provider>-<run-id>` and `ACTION-<ci-id>-<nnn>` identities, required fields, allowed states, cross-record links, and ownership boundaries. Task 11 defines these CI contracts only; it does not implement state transitions, action handling, release handoff, or fixtures.
  - For `PromptKit Adaptation Profile: sdlc-overlay-v1`, use immutable Adaptation IDs with lowercase kebab-case slugs and a zero-padded three-digit sequence (`<nnn>`): `PLAN-<spec-slug>`, `ASSUMPTION-<spec-slug>-<nnn>`, `DECISION-<spec-slug>-<nnn>`, `CLAIM-<decision-id>-<nnn>`, `CITATION-<decision-id>-<nnn>`, `UNCERTAINTY-<decision-id>-<nnn>`, `TASK-<task-slug>`, `BEHAVIOR-<task-slug>-<nnn>`, `TDD-INTENT-<task-slug>-<nnn>`, `TDD-EXEC-<task-slug>-<behavior-seq>`, `REVIEW-<review-slug>`, `SIMPLIFICATION-<review-id>-<nnn>`, `CI-<provider>-<run-id>`, `ACTION-<ci-id>-<nnn>`, and `RELEASE-<release-slug>`.
  - For an absent or `none` profile, preserve the legacy `TASK-YYYY-MM-DD-<slug>` identity. Legacy templates and validators remain dated, existing records and links require no retroactive migration, and no validator migration is part of this task.
  - Use the link syntax `[<stable-id>](<relative-path>#<stable-id>)`; use `[<stable-id>](#<stable-id>)` for a record in the same file. Every linked record exposes the same ID as an explicit anchor target.
  - Mark every field Required, Optional, or Not applicable. In the matrix below, `(R)`, `(O)`, and `(N/A)` are shorthand for those full labels; implementation templates must render the full words. `N/A — <reason>` is valid only where the matrix permits it; `None` means the field has no entries and is not the same as an omitted required field. Record metadata does not count toward Minimal Planning’s three interrogation inputs.
  - Define the following canonical matrix before validator implementation:

    | Artifact | Canonical location and authority | Required fields | Optional or N/A fields | Allowed states |
    |---|---|---|---|---|
    | Planning Record | Section in `docs/specs/<specification>.md`, owned by `pk:plan` | (R) ID, planning depth, requested outcome, observable completion condition, scope boundary, owner, status; Full mode also requires non-goals, affected components, external contracts, failure/rollback considerations, and verification approach | (O) Local Task Record and workflow links; (N/A) Full-only fields in Minimal mode with an explicit reason | `draft`, `ready`, `blocked`, `superseded` |
    | Assumption Record | Planning Record section, owned by `pk:plan` | (R) ID, unanswered decision, provisional answer, impact if wrong, validation action, decision owner, status | (O) supporting evidence and resolved-decision link; (N/A) resolution evidence while not resolved | `open`, `validated`, `accepted`, `rejected`, `superseded` |
    | Decision, Claim, Citation, and Uncertainty records | Planning Record sections, owned by `pk:plan` | (R) Decision ID, statement, options, selected/rejected options, claims, owner, status; each Claim links to a Citation or Uncertainty; each Citation has publisher, title, canonical URL, access date, and supported claim; each Uncertainty has impact, resolution action, owner, and status | (O) `pk:spike` link and additional source notes; (N/A) uncertainty only when the decision has no unresolved claim, recorded as `None` | Decision: `proposed`, `decided`, `deferred`, `superseded`; Citation: `candidate`, `verified`, `stale`, `inaccessible`, `conflicting`, `superseded`; Uncertainty: `open`, `resolved`, `accepted`, `deferred`, `superseded` |
    | TDD intent register | Existing `docs/tests/<test-plan>.md`, owned by `pk:test` for intent | (R) intent ID, Task Record link, behavior ID, mode reference, test, expected failing assertion, runnable command, status | (O) seam/framework notes; (N/A) complete intent register when Code Work mode is disabled, recorded as `N/A — TDD Enforcement Mode disabled`; disabled Code Work execution evidence uses the same N/A value while normal milestones, acceptance criteria, test strategy, review, and verification remain required | `proposed`, `ready`, `superseded` |
    | TDD execution evidence | `docs/tasks/<task-id>.md`, owned by the Local Task Record | (R) execution ID, behavior ID, Task Record link, Red result, Green result, Refactor result, commands/results, status | (O) test-plan link and notes; (N/A) Red/Green/Refactor fields for disabled Code Work, recorded as `N/A — TDD Enforcement Mode disabled` while normal milestones, acceptance criteria, test strategy, review, and verification remain required; Documentation, Configuration, or Research Work use an exception verification link | `planned`, `red_recorded`, `green_recorded`, `refactor_recorded`, `exception`, `blocked`, `complete` |
    | Simplification Audit | Existing `pk:review` report, owned by `pk:review` | (R) review ID, resolved non-empty diff reference, candidate ID or explicit `No Simplification Candidates found`; candidates require location, diff evidence, preservation condition, risk, verification, and recommendation | (O) baseline and related review links; (N/A) candidate fields when the explicit no-candidate result is recorded | `draft`, `complete`, `superseded` |
    | CI Triage Record | `docs/releases/ci-triage/<ci-failure-id>.md`, owned by the CI triage owner | (R) CI ID, evidence, owner, state, classification when sufficient, remediation plan when supported, verification evidence, resume condition, and `pk:ship` link for release candidates; one action block per proposed remote action | (O) authenticated read-only retrieval metadata and `pk:debug` link; (N/A) classification/remediation before evidence is sufficient and action-confirmation block when no remote action is proposed | `evidence_requested`, `evidence_sufficient`, `classified`, `remediation_planned`, `awaiting_confirmation`, `local_reproduction_or_fix`, `verification_pending`, `verified`, `linked_to_pk_ship`, `blocked` |
    | Release linkage | Existing `docs/releases/<release>.md`, owned by `pk:ship` | (R) release ID, CI Triage link, verification link, verified result, and resume condition | (O) review and Task Record links; (N/A) triage link when the release has no CI failure | Existing `pk:ship` release states; the linkage validator recognizes only `pending`, `blocked`, `verified`, and `linked_to_pk_ship` evidence states |

  - Define each CI action block as `ACTION-<ci-id>-<nnn>` with Required fields: proposed action, confirmation state (`pending | confirmed | declined`), approver, confirmation timestamp, bounded scope, reversal or rollback action, and resume condition. Approver and timestamp are `N/A — awaiting confirmation` only while the action is pending; a confirmed or declined action requires both.
  - Define cross-record invariants: IDs are unique and immutable; every link resolves using the declared syntax; TDD mode and execution state are owned by the Local Task Record; TDD intent and execution use the same behavior ID; material claims link to a citation or uncertainty; one remote action has one confirmation block; confirmation never authorizes another action; and release resumption requires CI state `verified` followed by `linked_to_pk_ship`.
  - Define validator boundaries: deterministic, network-free checks validate paths, IDs, field labels, links, allowed states, required-field conditions, ownership, invariants, and deferred-scope boundaries; they do not verify external URLs, execute commands, or authorize remote/release actions.

  **Dependencies:** Task 1.

  **Verification:**
  - Every artifact has one canonical authority, location, stable identity, field contract, and lifecycle boundary.
  - Valid, missing-required-field, invalid-state, broken-link, duplicate-ID, conflicting-authority, and illegal-N/A fixtures are specified.
  - TDD execution evidence links to the Local Task Record and uses the same behavior ID as intent.
  - CI triage links to `pk:ship` without becoming execution or approval authority, and action confirmation is one-action-specific.
  - No artifact is both embedded and standalone without an explicit matrix rule.

  **Demoable result:** A later agent can create every required artifact without guessing its path, identity, field status, link syntax, state, or authority.

  **Requirement coverage:** 2, 3, 4, 5, 7, 8, 10.

- [ ] **Task 12: Implement CI triage state transitions and release handoff**

  **Objective:** Implement the Task 11 CI contract from evidence collection through verified release resumption, including action-block behavior and fixtures.

  **Implementation guidance:**
  - Implement the state flow defined by Task 11: `evidence_requested`, `evidence_sufficient`, `classified`, `remediation_planned`, `awaiting_confirmation`, `local_reproduction_or_fix`, `verification_pending`, `verified`, and `linked_to_pk_ship`.
  - Implement valid and invalid fixtures for the state transitions, action confirmation states, declined-action handling, blocked/resume behavior, and release handoff.
  - Permit `blocked` from any state with an owner and precise resume condition.
  - Define ownership for CI triage, `pk:debug`, engineer remediation, verification, `pk:ship`, and human approval.
  - Create one `ACTION-<ci-id>-<nnn>` confirmation block for each proposed remote retry, repository configuration change, deployment, or rollback. Each block must contain the proposed action, `pending | confirmed | declined` state, approver, confirmation timestamp, bounded scope, reversal or rollback action, and resume condition.
  - Keep action blocks independent: confirming or declining one action does not authorize or decide another, and recording confirmation does not execute the action.
  - When a remote action is declined, close only that action. Require the parent CI Triage Record to receive a new bounded remediation plan or become `blocked` with an owner and precise resume condition. A declined action cannot produce `verified` or `linked_to_pk_ship`.
  - Allow `N/A — no remote action proposed` for the action-confirmation collection only when no remote action is in the plan; an action block may use `N/A — awaiting confirmation` for approver and timestamp only while pending.
  - Require `verified` plus `linked_to_pk_ship` before release resumption; a passing unrelated validator, classification, or proposed remediation is insufficient.

  **Dependencies:** Tasks 1 and 6.

  **Verification:**
  - Insufficient evidence remains blocked from remediation.
  - Remote-action plans require human confirmation.
  - A declined action closes only itself and forces a bounded remediation plan or a blocked record with owner/resume condition; it cannot yield `verified` or `linked_to_pk_ship`.
  - Local reproduction returns evidence to the triage record.
  - Release cannot resume from classification or proposed remediation alone.
  - Valid and invalid fixtures cover every defined state transition, action state, declined-action path, blocked/resume path, and release handoff.

  **Demoable result:** A failed release check moves through explicit states and cannot become release approval accidentally.

  **Requirement coverage:** 5, 7, 8.

- [ ] **Task 13: Add legacy and Adaptation-enabled validator compatibility**

  **Objective:** Preserve existing Task Records while allowing stricter validation for opted-in Adaptation records.

  **Implementation guidance:**
  - Define the optional `PromptKit Adaptation Profile: none | sdlc-overlay-v1` marker.
  - Keep absent/`none` records under current execution-control validation with dated `TASK-YYYY-MM-DD-<slug>` identities; validate `sdlc-overlay-v1` records with Adaptation `TASK-<task-slug>` identities.
  - Validate new fields only for `sdlc-overlay-v1` records.
  - Add equivalent PowerShell and Bash behavior requirements.
  - Do not require retroactive record migration.

  **Dependencies:** Tasks 1, 9, and 11.

  **Verification:**
  - Legacy fixtures pass unchanged.
  - Valid upgraded fixtures pass.
  - Invalid upgraded fixtures fail with clear diagnostics.
  - No validator result authorizes a remote or release action.

  **Demoable result:** A project can adopt the Adaptation gradually without breaking existing records.

  **Requirement coverage:** 8, 10.

- [ ] **Task 14: Apply developer-friendly language to fill-in artifacts**

  **Objective:** Preserve canonical technical field names while making records understandable to general developers.

  **Implementation guidance:**
  - Add plain-language explanations beside technical labels.
  - Expand acronyms on first use.
  - Mark Required, Optional, and Not applicable fields.
  - Add examples for unfamiliar planning, evidence, TDD, CI, and verification fields.
  - Allow concise answers and explain when `None`/`N/A` is valid.
  - Apply the language pass to these exact artifacts: `templates/execution-task-record-template.md`, `templates/tech-spec-template.md`, `templates/test-plan-template.md`, the CI triage template created by Task 12, `workflows/review.md` and the review report format, and release linkage/release checklist artifacts.
  - Keep this a language-focused task; do not change validator-facing canonical labels, ownership, TDD semantics, identity forms, or validator behavior.

  **Dependencies:** Tasks 2, 3, and 11.

  **Verification:**
  - A general developer can complete a Minimal record without reading the glossary.
  - Every technical fill-in field has nearby guidance or an example.
  - Canonical labels and validator references remain unchanged.

  **Demoable result:** A developer can complete representative planning and CI records without needing to ask what each field means.

  **Requirement coverage:** 1, 2, 3, 5, 9, 10.

- [ ] **Task 15: Assign optional friction evaluation**

  **MVP status:** Optional. It may be completed after its prerequisites or explicitly deferred; it cannot block MVP completion, Task 16, or implementation handoff.

  **Objective:** Measure whether the Adaptation reduces rework more than it adds process overhead.

  **Implementation guidance:**
  - Assign ownership to the PromptKit maintainer.
  - Use network-free representative Trivial, Minimal Controlled, Full Controlled, TDD-enabled, and CI-failure scenarios.
  - Compare added questions/artifacts with assumptions found, rework avoided, classification quality, false positives, and relative context overhead.
  - Do not impose a universal token budget.

  **Dependencies:** Tasks 2, 9, 10, 12, and 14.

  **Verification:**
  - The evaluation distinguishes added process cost from avoided rework.
  - Results can identify excessive friction.
  - Formal measurement remains optional for MVP if explicitly deferred.

  **Demoable result:** Maintainers can decide whether an overlay should be simplified after observing representative use.

  **Requirement coverage:** 9, 10.

- [ ] **Task 16: Re-run final cross-document traceability**

  **Objective:** Confirm the new authority, artifact, state, compatibility, and language contracts agree across all three spec files.

  **Implementation guidance:**
  - Add the new contract tasks and coverage to the traceability table.
  - Confirm all requirements, design sections, artifacts, states, and tasks use the same terms.
  - Confirm MVP/deferred boundaries remain intact.
  - Confirm no active task requires adapters, network checks, or advanced property testing.

  **Dependencies:** Tasks 1–14; Task 15 complete or explicitly deferred.

  **Verification:**
  - Requirements-to-design-to-task traceability passes.
  - TDD authority and default agree everywhere.
  - Minimal/readiness rules agree everywhere.
  - Artifact paths, profile-scoped Task IDs, and CI states agree everywhere.
  - Task 11 remains the CI contract definition boundary and Task 12 remains the implementation, declined-action, release-handoff, and fixture boundary.
  - Declined remote actions close only themselves and cannot produce `verified` or `linked_to_pk_ship`.
  - Legacy compatibility, disabled-Code-Work TDD N/A rules, and developer-language artifact scope agree everywhere.

  **Demoable result:** The later implementation agent receives one deterministic, developer-friendly specification with no unresolved implementation-critical decisions.

  **Requirement coverage:** 1–10 and all cross-cutting clarifications.

The Task Dependency Graph at the top of this document is the single authoritative dependency graph. It is the only source for task sequencing and final-gate status; the active task sections provide the matching prerequisites and verification details.
