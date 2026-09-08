# Implementation Plan: Agent Execution Control & Handoff

## Overview

Implement Agent Execution Control as an additive, documentation-first v1.1 feature for Better-PromptKit. The plan establishes canonical local records, overlays existing `pk:*` workflows, adds read-only Bash and PowerShell validators with deterministic fixtures, and wires validation into repository CI only after the local contract is stable.

No task may create a runtime orchestrator, external tracker integration, background timer, automatic task switch, commit/push, pull request merge, tag, hosted release, publication, deployment, rollback, or repository mutation outside the explicitly scoped file changes. The eventual release version remains subject to a separate Conventional Commit Versioning review.

## Tasks

- [ ] 1. Freeze the canonical record schemas and local storage contract
  - [ ] 1.1 Create `templates/execution-task-record-template.md` for a Controlled Work Task Record.
    - Include stable task ID, specification, objective, scope, non-goals, dependencies, owner/approval boundary, acceptance criteria, verification condition, execution policy, state, active pointer, transition history, evidence links, blockers, and completion gate.
    - Keep the template Markdown-first and parseable by both platform validators.
    - _Requirements: 1.1-1.7, 2.1-2.8, 7.1-7.8, 9.1-9.7_
  - [ ] 1.2 Create `templates/execution-scope-change-template.md` and `templates/execution-handoff-template.md`.
    - Capture affected objective/files/criteria/dependencies/non-goals/risk/verification, approval, receiver validation, branch/revision, invariants, evidence, blockers, and exactly one next action.
    - _Requirements: 3.1-3.9, 4.1-4.8, 5.1-5.7, 6.1-6.8_
  - [ ] 1.3 Add an optional execution-control fragment to `templates/state-tracker-template.md`.
    - Define `docs/STATE.md` as a synchronized projection, not a competing task source, and include active task, state, blockers, invariants, verification status, and next action.
    - _Requirements: 6.3-6.4, 11.3, 11.6_
  - [ ] 1.4 Add a controlled-work execution section to `templates/issue-task-template.md` without imposing Better-PromptKit release policy on consumers.
    - _Requirements: 1.2-1.6, 5.2-5.6, 9.1-9.2_

- [ ] 2. Define state transitions, checkpoint policy, and authority boundaries in workflow documentation
  - [ ] 2.1 Update `workflows/route.md` to classify Trivial versus Controlled Work and route controlled requests through readiness and execution-mode selection.
    - Preserve existing routing decisions and do not create a new `pk:execution-control` trigger.
    - _Requirements: 1.1, 1.6-1.7, 8.1, 8.6, 11.1-11.2_
  - [ ] 2.2 Update `workflows/plan.md` and `workflows/tasks.md` with the Task Record fields, stable IDs, explicit non-goals, acceptance/verification conditions, active-task rule, and mapping to existing board statuses.
    - _Requirements: 1.2-1.7, 2.1-2.8, 9.1-9.2, 11.1, 11.3_
  - [ ] 2.3 Update `workflows/checkpoint.md` with soft/hard checkpoint behavior, event-driven checkpoints, stop states, handoff creation, timer limitations, and `docs/STATE.md` projection rules.
    - _Requirements: 3.1-3.9, 4.1-4.8, 6.1-6.8, 11.6-11.7_
  - [ ] 2.4 Update `workflows/commit.md`, `workflows/pr.md`, and `workflows/review.md` with completion evidence, exception records, review/CI traceability, and non-autonomous authority boundaries.
    - _Requirements: 7.1-7.8, 9.2-9.7, 11.1, 11.7_
  - [ ] 2.5 Update `workflows/ship.md` with execution-control links while preserving the separate release-evaluation, Release Coordinator, tag, publication, deployment, and rollback decisions.
    - _Requirements: 9.4-9.6, 10.9-10.10, 11.4-11.7_

- [ ] 3. Add local read-only execution-control validation
  - [ ] 3.1 Implement `scripts/validate-execution-control.ps1` with an explicit root argument, stable diagnostic categories, and exit code `0` only for valid discovered records.
    - Validate required fields, IDs, readiness, transitions, one active task, checkpoint/handoff completeness, scope changes, blockers, completion evidence, traceability, revision consistency, state projection consistency, and recorded timer limitations.
    - Do not edit records, invoke remotes, mutate Git, or perform release/deployment operations.
    - _Requirements: 1.2-1.7, 2.2-2.7, 3.5-3.9, 4.2-4.8, 5.1-5.7, 6.2-6.8, 7.1-7.8, 9.1-9.6, 10.1-10.10_
  - [ ] 3.2 Implement `scripts/validate-execution-control.sh` with equivalent record parsing, diagnostics, and exit behavior.
    - _Requirements: 10.1-10.10, 11.2, 11.6-11.7_
  - [ ] 3.3 Add platform-neutral synthetic fixtures under `scripts/tests/fixtures/execution-control/`.
    - Include valid controlled work, invalid readiness, duplicate active task, invalid transition, hard checkpoint, blocked/paused/aborted records, unapproved scope expansion, incomplete handoff, unresolved blocker, missing completion evidence, traceability mismatch, revision mismatch, state projection mismatch, and host timer limitation cases.
    - Use synthetic IDs, paths, revisions, and commands only; do not reference real releases or remotes.
    - _Requirements: 1.4, 2.2-2.8, 3.5-3.9, 4.2-4.8, 5.1-5.7, 6.2-6.8, 7.1-7.8, 10.2-10.8_
  - [ ] 3.4 Add Bash and PowerShell example harnesses that run the same fixture matrix and compare diagnostic categories and exit status.
    - Assert that validator execution does not alter fixture content, repository files, or Git state.
    - _Requirements: 10.1-10.8, 11.2, 11.6_

- [ ] 4. Wire the validator into repository quality gates
  - [ ] 4.1 Add a CI step to `.github/workflows/ci.yml` for the PowerShell validator and synthetic fixtures after the script and fixture contract is stable.
    - _Requirements: 10.1-10.10_
  - [ ] 4.2 Add the equivalent Bash CI step and ensure platform failures identify the same record ID, path, category, and remediation condition.
    - _Requirements: 10.5-10.8, 11.2_
  - [ ] 4.3 Document that CI validates durable repository evidence only and cannot observe live chat duration or approve any external action.
    - _Requirements: 3.9, 10.4, 10.8-10.10, 11.6_

- [ ] 5. Add traceability and adoption documentation
  - [ ] 5.1 Update `README.md`, `docs/WORKFLOW-MAP.md`, and the relevant workflow references with the v1.1 execution-control lifecycle.
    - Explain Planner/Architect -> Engineer -> QA/Reviewer -> Release Coordinator handoffs, local-task authority, optional external references, and the v1.0.0 baseline.
    - _Requirements: 6.1-6.8, 8.1-8.8, 9.1-9.7, 11.1-11.7_
  - [ ] 5.2 Update `templates/release-checklist.md` and `templates/pull-request-template.md` with optional execution-control evidence links.
    - Keep tag, publication, deployment, and remote actions separately human-approved.
    - _Requirements: 7.2-7.8, 9.3-9.6, 10.9-10.10, 11.4-11.7_
  - [ ] 5.3 Run existing reference validation and correct broken links or stale claims without modifying v1.0.0 release evidence.
    - _Requirements: 9.7, 11.3, 11.5_

- [ ] 6. Checkpoint - Validate the implementation slice before release-impact review
  - [ ] 6.1 Run both execution-control validators against valid and invalid synthetic fixtures.
  - [ ] 6.2 Run the repository Bash and PowerShell reference validators, syntax checks, documentation checks, and CI-equivalent local commands.
  - [ ] 6.3 Record failures as blockers; do not mark the feature complete because a script merely exits successfully.
  - _Requirements: 3.5-3.9, 4.2-4.8, 10.1-10.10_

- [ ] 7. Optional property and example test coverage
  - [ ]* 7.1 Add deterministic transition-property checks for one-active-task, valid-state transitions, stop-state blocking, scope-change approval, and completion evidence.
  - [ ]* 7.2 Add record-schema examples for readiness, checkpoint, handoff, and completion edge cases.
  - [ ]* 7.3 Require at least 100 generated iterations per selected property and keep all data local and synthetic.
  - _Requirements: 1.4-1.7, 2.2-2.8, 3.5-3.9, 4.2-4.8, 5.1-5.7, 6.2-6.8, 7.1-7.8, 10.2-10.8_

- [ ] 8. Prepare review and release-impact evidence
  - [ ] 8.1 Create a feature PR from a dedicated branch; include changed-file scope, acceptance evidence, validator results, CI links, portability limitations, and authority-boundary review.
  - [ ] 8.2 Update the v1.1 planning/release-impact record only after implementation is reviewed; classify changes against approved `v1.0.0` rather than assuming `1.1.0`.
  - [ ] 8.3 Record explicit non-goals and any rejected implementation alternatives in the handoff/state artifact.
  - [ ] 8.4 Do not create a tag, hosted release, publication, deployment, or remote action as part of this planning or implementation package.
  - _Requirements: 9.4-9.6, 10.9-10.10, 11.4-11.7_

- [ ] 9. Final checkpoint - Ensure all selected tests and quality gates pass
  - [ ] 9.1 Re-run repository reference validation, both execution-control validators, fixture harnesses, syntax checks, and CI-equivalent checks.
  - [ ] 9.2 Confirm no untracked generated artifacts, secrets, remote-action commands, or changes to the immutable `v1.0.0` tag/release.
  - [ ] 9.3 Record the exact next action for implementation or return the feature to `blocked` with evidence.
  - _Requirements: 10.1-10.10, 11.2, 11.4-11.7_

## Notes

- Tasks marked with `*` are optional automated property/example work. The record templates, workflow overlays, read-only validators, deterministic fixtures, CI wiring, and required validation are core tasks.
- All implementation tasks preserve existing `pk:*` ownership and board statuses. A new task lifecycle, command, external tracker, or runtime service is out of scope.
- A passing validator or CI job proves only that durable evidence is internally consistent. It never approves a commit, pull request, tag, release, deployment, or rollback.
- The v1.0.0 tag and hosted release are immutable. The eventual release version for this feature must be proposed and approved separately after implementation and public-contract review.
- Consumer repositories may adopt the protocol voluntarily; the validator and release-impact policy apply to Better-PromptKit repository records unless a future design explicitly expands scope.

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "1.2", "1.3", "1.4"] },
    { "id": 1, "tasks": ["2.1", "2.2", "2.3", "2.4", "2.5"] },
    { "id": 2, "tasks": ["3.1", "3.2", "3.3"] },
    { "id": 3, "tasks": ["3.4", "4.1", "4.2", "4.3"] },
    { "id": 4, "tasks": ["5.1", "5.2", "5.3"] },
    { "id": 5, "tasks": ["6.1", "6.2", "6.3"] },
    { "id": 6, "tasks": ["7.1", "7.2", "7.3"] },
    { "id": 7, "tasks": ["8.1", "8.2", "8.3", "8.4"] },
    { "id": 8, "tasks": ["9.1", "9.2", "9.3"] }
  ]
}
```
