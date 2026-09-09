# Implementation Plan: Conventional Commit Versioning

## Overview

Add Better-PromptKit’s documentation-first release-evidence contract in dependency order: establish reusable records and templates, extend `pk:commit`, `pk:checkpoint`, and `pk:ship` without changing their ownership boundaries, then document release-note and role handoffs. Finish with an opt-in, local read-only validator and CI invocation. No task may create or push Git tags, create hosted releases, publish changelogs, make remote calls, or deploy; those remain explicit Release Coordinator decisions.

## Tasks

- [x] 1. Add shared release-evidence templates and record fields
  - [x] 1.1 Create `templates/contract-impact-evidence-template.md` as the reusable Planner/Architect, commit-linked, and review evidence record.
    - Include stable evidence references, affected Public PromptKit Contract, observable before/after behavior, impact classification, proposed increment, supporting records, and mandatory migration/upgrade guidance for breaking changes.
    - Preserve the distinction between public impact evidence and an explicit Maintenance Commit declaration.
    - _Requirements: 1.3, 1.4, 3.1, 3.5, 7.1_
  - [x] 1.2 Create `templates/release-evaluation-template.md` with evaluation, normalized-history, preliminary-candidate, QA-review, release-note/changelog-draft, approval, and consistency-result sections.
    - Capture prior approved baseline or First Release status, candidate-inclusive range, effective change set, blockers, candidate provenance, reviewed notes, explicit approval, and separate external-action decisions.
    - Make draft changelog entries explicitly unpublished and prohibit template instructions from invoking Git, remote, publication, or deployment actions.
    - _Requirements: 2.1, 2.2, 2.3, 2.5, 3.6, 4.1, 4.2, 4.5, 5.1–5.6, 6.1–6.7, 7.3, 7.5, 8.1–8.5_
  - [x] 1.3 Extend `templates/issue-task-template.md` with an optional Public PromptKit Contract Impact section for planning records.
    - Add fields for affected contract, evidence, user-observable before/after behavior, proposed impact, and breaking-change migration guidance without imposing Better-PromptKit policy on consumer repositories.
    - _Requirements: 3.1, 3.5, 7.1_
  - [x] 1.4 Extend `templates/state-tracker-template.md` with an optional release-evaluation handoff fragment.
    - Record evaluation ID, candidate commit, preliminary candidate, QA result, blockers, and the next explicit human approval action; do not represent handoff state as approval.
    - _Requirements: 2.1, 4.1, 7.4, 8.5_
  - [x] 1.5 Extend `templates/release-checklist.md` with a Better-PromptKit internal release-evidence appendix.
    - Add evaluation, range, candidate, QA, approval-record, note, and consistency fields, and clearly separate human-approved tag/release/changelog/remote actions from checklist evidence.
    - _Requirements: 2.5, 4.3, 4.4, 6.7, 7.5, 8.1–8.5_

- [x] 2. Extend `pk:commit` with commit-level evidence capture
  - [x] 2.1 Update `workflows/commit.md` after the existing Conventional Commit body guidance.
    - Preserve the existing Conventional Commit syntax and one-complete-reversible-concern rule; require either linked/body Contract Impact Evidence for eligible public-impact commits or a recorded Maintenance Commit declaration stating no intentional public-contract change.
    - Explain that `feat`, `fix`, and `perf` labels do not determine SemVer impact, while maintenance classifications do not propose increments; require breaking guidance when applicable.
    - _Requirements: 1.1–1.4, 3.2–3.8, 7.2_
  - [x]* 2.2 Add documentation-focused example/snapshot checks for `pk:commit` guidance.
    - Verify that Conventional Commit and atomic/reversible guidance remain intact and that complete evidence, maintenance, and missing-breaking-guidance examples render the intended required fields.
    - _Requirements: 1.1–1.4, 3.5, 3.7, 3.8_

- [x] 3. Extend `pk:checkpoint` with durable release-evaluation handoff
  - [x] 3.1 Update `workflows/checkpoint.md` with an optional release-evaluation handoff block and handover-prompt content.
    - Record the evaluation ID, Release Candidate Commit, preliminary SemVer Candidate, QA status, unresolved blockers, and requested Release Coordinator decision while retaining the workflow’s session-state mission.
    - State that checkpointing never approves a candidate or performs tagging, release creation, changelog publication, remote operations, or deployment.
    - _Requirements: 2.1–2.3, 4.1, 4.2, 7.3, 7.4, 8.5_
  - [x]* 3.2 Add documentation-focused example checks for complete, incomplete, and blocked checkpoint handoffs.
    - Assert that the template distinguishes preliminary candidates from approval and retains the required release-evaluation identifiers and blockers.
    - _Requirements: 4.1, 4.2, 7.4, 7.6_

- [x] 4. Extend `pk:ship` with internal release evaluation and human approval records
  - [x] 4.1 Update `workflows/ship.md` with a Better-PromptKit internal release-evaluation section before deployment-specific guidance.
    - Specify baseline/range selection, first-release treatment, candidate membership checks, normalization of merge/squash/duplicate/revert history, evidence-based SemVer precedence, prerelease and promotion handling, empty-range decisions, QA review, release-note derivation, and Approved Release Record fields.
    - Preserve existing production-safety guidance and make every tag, hosted release, changelog publication, remote action, and deployment a separate, explicit, human-approved Release Coordinator decision.
    - _Requirements: 2.1–2.6, 3.2–3.9, 4.1–4.7, 5.1–5.6, 6.1–6.7, 7.3, 7.5, 7.6, 8.1–8.5_
  - [x]* 4.2 Add documentation-focused example checks for first-release, prerelease-promotion, empty-range, failed-consistency, deferred, and approved-release records.
    - Verify candidate/approved version separation, required approval rationale, tag/version correspondence, and human-only external-action language.
    - _Requirements: 2.3–2.6, 3.9, 4.1–4.7, 5.6, 8.1–8.5_

- [x] 5. Document release-note behavior and accountable role handoffs
  - [x] 5.1 Update `README.md` and `docs/WORKFLOW-MAP.md` to describe the Better-PromptKit-only release-evidence lifecycle.
    - Explain Planner/Architect → Engineer → QA/Reviewer → Release Coordinator handoffs, preliminary-versus-approved release decisions, filtered Public and Maintenance Release Notes, unpublished changelog drafts, and the non-applicability of this policy to consumer repositories.
    - _Requirements: 3.1, 4.1–4.4, 6.1–6.7, 7.1–7.6, 8.5_
  - [x] 5.2 Update `workflows/route.md` to route release-evidence, version-candidate, and release-note requests to the appropriate `pk:commit`, `pk:checkpoint`, and `pk:ship` phases.
    - Preserve its existing routing behavior and clarify that external release actions remain human-approved rather than automated workflow outcomes.
    - _Requirements: 1.1, 4.1, 7.1–7.5, 8.5_
  - [x]* 5.3 Add documentation reference checks covering the new templates and workflow-map links.
    - Confirm all linked artifact paths exist and release-note/handoff wording keeps publication, remote, tagging, and deployment actions non-automatic.
    - _Requirements: 6.7, 7.1–7.5, 8.4, 8.5_

- [x] 6. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 7. Add optional, local read-only release-record validation and CI wiring
  - [x] 7.1 Implement `scripts/validate-release-records.ps1` as a manually invokable read-only parser and consistency reporter for Better-PromptKit release-evaluation records.
    - Validate required fields, range candidate membership, candidate/approval provenance, approval rationale, tag/version encoding, baseline precedence, cross-record evaluation IDs, QA/note linkage, and empty-range decisions; emit diagnostics without modifying files or invoking Git/remote/publication/deployment operations.
    - _Requirements: 2.4–2.6, 4.3–4.7, 5.6, 6.6, 7.6, 8.1–8.4_
  - [x] 7.2 Implement `scripts/validate-release-records.sh` with behavior and diagnostic categories equivalent to the PowerShell validator.
    - Keep all parsing local and read-only; use no commands that create tags/releases, publish changelogs, mutate records, contact remotes, or deploy.
    - _Requirements: 2.4–2.6, 4.3–4.7, 5.6, 6.6, 7.6, 8.1–8.4_
  - [x] 7.3 Add committed valid and invalid release-record fixtures under `scripts/tests/fixtures/release-records/` for the validator’s platform-neutral, read-only smoke checks.
    - Include a complete approved record and focused malformed records for missing fields, range membership, approval, tag/version, precedence, and cross-record linkage; fixtures must contain only synthetic identifiers and no real repository or remote references.
    - _Requirements: 2.5, 2.6, 3.5, 4.7, 5.6, 6.6, 7.6, 8.1–8.4_
  - [x] 7.4 Update `.github/workflows/ci.yml` to invoke each platform’s local read-only validator against committed synthetic fixtures only after both scripts and the fixtures exist.
    - Scope the job to Better-PromptKit records and ensure the CI wiring has no credentials, remote calls, release commands, tag creation, publishing, or deployment steps.
    - _Requirements: 8.4, 8.5_
  - [x]* 7.5 Add `scripts/tests/run-release-record-properties.ps1` and `scripts/tests/run-release-record-properties.sh` as local property-test harnesses for the pure release-evidence model.
    - Generate ordered synthetic histories, stable commit identifiers, evidence records, SemVer values, tags, merge commits, squash commits, duplicate groups, fully cancelling revert pairs, partially reverting commits with new evidence, QA outcomes, and in-memory action stubs. Include combined history shapes where merge or squash commits interact with duplicate groups and fully or partially reverting commits; execute at least 100 iterations per property with no real Git or network operations.
    - _Requirements: 1.3, 2.1–2.6, 3.2–3.9, 4.1–4.7, 5.1–5.6, 6.1–6.7, 7.6, 8.1–8.4_
  - [x]* 7.6 Write a property test with independent fixtures for complete eligible evidence and maintenance declarations in `scripts/tests/fixtures/release-records/property-01.*`.
    - **Property 1: Eligible evidence and maintenance declarations are complete**
    - **Validates: Requirements 1.3, 1.4, 3.7**
  - [x]* 7.7 Write a property test with independent fixtures for bounded, reproducible, candidate-inclusive release ranges in `scripts/tests/fixtures/release-records/property-02.*`.
    - **Property 2: Release ranges are bounded, reproducible, and candidate-inclusive**
    - **Validates: Requirements 2.1, 2.2, 2.3, 2.6**
  - [x]* 7.8 Write a property test with independent fixtures for resolving the next baseline from the latest approved record in `scripts/tests/fixtures/release-records/property-03.*`.
    - **Property 3: The latest approved record supplies the next baseline**
    - **Validates: Requirements 2.4**
  - [x]* 7.9 Write a property test with independent fixtures for evidence-driven impact classification independent of commit labels in `scripts/tests/fixtures/release-records/property-04.*`.
    - **Property 4: Impact classification follows evidence, not commit labels**
    - **Validates: Requirements 3.2, 3.3, 3.4, 3.8**
  - [x]* 7.10 Write a property test with independent fixtures for greatest effective impact selection and First Release candidate policy in `scripts/tests/fixtures/release-records/property-05.*`.
    - **Property 5: Candidate selection uses greatest effective impact and first-release policy**
    - **Validates: Requirements 3.6, 3.9**
  - [x]* 7.11 Write a property test with independent fixtures for preliminary candidates, provenance, prerelease suffixes, and promotion in `scripts/tests/fixtures/release-records/property-06.*`.
    - **Property 6: Candidates are preliminary and retain provenance across prerelease promotion**
    - **Validates: Requirements 4.1, 4.2, 4.5, 4.6**
  - [x]* 7.12 Write a property test with independent fixtures for justified, version-aligned, coordinator-authorized approval records in `scripts/tests/fixtures/release-records/property-07.*`.
    - **Property 7: Approval records are justified, version-aligned, and coordinator-authorized**
    - **Validates: Requirements 4.3, 4.4, 4.7, 8.2**
  - [x]* 7.13 Write a property test with independent fixtures for effective history normalization shared by candidate and note derivation in `scripts/tests/fixtures/release-records/property-08.*`.
    - Generate merge commits, squash commits, duplicate groups, fully cancelling revert pairs, and partially reverting commits with new evidence, including merge/squash interactions with duplicate and revert groups.
    - Assert that normalization produces one ordered effective change set; the SemVer candidate calculation and filtered Public Release Note derivation must each consume that same normalized set, yielding no independent merge classification, one squash classification, one representative/note per duplicate group, no fully reverted evidence/note, and newly classified residual impact for partial reverts.
    - **Property 8: History normalization preserves only effective change evidence**
    - **Validates: Requirements 5.1, 5.2, 5.3, 5.4, 5.5**
  - [x]* 7.14 Write a property test with independent fixtures for explicit decisions on empty impactful ranges in `scripts/tests/fixtures/release-records/property-09.*`.
    - **Property 9: Empty impactful ranges require an explicit decision**
    - **Validates: Requirements 5.6**
  - [x]* 7.15 Write a property test with independent fixtures for exact-once release notes and unpublished draft changelog entries in `scripts/tests/fixtures/release-records/property-10.*`.
    - **Property 10: Release notes and draft changelog entries represent effective changes exactly once**
    - **Validates: Requirements 6.1, 6.2, 6.3, 6.4, 6.5, 6.7**
  - [x]* 7.16 Write a property test with independent fixtures for QA findings blocking release completion until correction and re-review in `scripts/tests/fixtures/release-records/property-11.*`.
    - **Property 11: QA findings block release completion until correction**
    - **Validates: Requirements 7.6**
  - [x]* 7.17 Write a property test with independent fixtures for cross-record, non-regressing, side-effect-free consistency validation in `scripts/tests/fixtures/release-records/property-12.*`.
    - **Property 12: Consistency validation is cross-record and read-only**
    - **Validates: Requirements 8.1, 8.3, 8.4**
  - [x]* 7.18 Add `scripts/tests/release-records.examples.*` example-based documentation and validator checks.
    - Cover complete/incomplete commit, checkpoint, `pk:ship`, QA, approval, tag/version, note-coverage, and no-side-effect cases using only local synthetic records.
    - Add explicit mixed-history examples with merge and squash commits combined with duplicate groups and fully or partially reverting commits; assert that the one normalized effective change set used for the SemVer candidate is also the sole source for filtered Public Release Notes.
    - _Requirements: 1.1–1.4, 2.5, 2.6, 3.1, 3.5, 4.1–4.7, 5.1–5.6, 6.1–6.7, 7.1–7.6, 8.1–8.4_

- [x] 8. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 9. Perform required repository validation and correct implementation defects
  - [x] 9.1 Run the repository reference validation, platform syntax checks, documentation-reference checks, and all non-optional release-record validator checks; fix any failures in the modified files.
    - Run optional property and example suites when selected, require at least 100 iterations for each of Properties 1–12, and verify outputs show no Git tag/release creation, publishing, remote call, repository mutation, or deployment behavior.
    - _Requirements: 1.1–1.4, 2.1–2.6, 3.1–3.9, 4.1–4.7, 5.1–5.6, 6.1–6.7, 7.1–7.6, 8.1–8.5_

## Notes

- Tasks marked with `*` are optional automated test work and can be skipped for a faster documentation-only rollout; the core workflow, template, validator, fixture, and CI tasks are not optional.
- Properties 1–12 are included because the optional validator can isolate the specified normalization, SemVer, release-note, and consistency logic using synthetic local data. They must not interact with live Git history, remotes, hosted releases, publishing systems, or deployment environments.
- All external release actions remain explicit, human-approved Release Coordinator decisions. The planned scripts and CI job only read records and report diagnostics.
- Every implementation task references granular requirement clauses for traceability; checkpoints are intentionally excluded from execution waves.

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "1.2", "1.3", "1.4", "1.5"] },
    { "id": 1, "tasks": ["2.1"] },
    { "id": 2, "tasks": ["2.2"] },
    { "id": 3, "tasks": ["3.1"] },
    { "id": 4, "tasks": ["3.2"] },
    { "id": 5, "tasks": ["4.1"] },
    { "id": 6, "tasks": ["4.2"] },
    { "id": 7, "tasks": ["5.1", "5.2"] },
    { "id": 8, "tasks": ["5.3"] },
    { "id": 9, "tasks": ["7.1", "7.2", "7.3"] },
    { "id": 10, "tasks": ["7.4", "7.5"] },
    { "id": 11, "tasks": ["7.6", "7.7", "7.8", "7.9", "7.10", "7.11", "7.12", "7.13", "7.14", "7.15", "7.16", "7.17", "7.18"] },
    { "id": 12, "tasks": ["9.1"] }
  ]
}
```
