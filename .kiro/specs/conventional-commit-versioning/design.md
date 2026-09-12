# Design Document: Conventional Commit Versioning

## Overview

This design adds a documentation-first, repository-local release-evidence contract to Better-PromptKit's existing `pk:commit`, `pk:checkpoint`, and `pk:ship` workflows. It preserves their current ownership boundaries:

- `pk:commit` remains responsible for atomic Conventional Commit creation; it gains a structured way to capture Contract Impact Evidence or an explicit Maintenance Commit classification.
- `pk:checkpoint` remains responsible for durable handover state; it gains a release-evaluation handoff section, but does not approve, tag, publish, or deploy.
- `pk:ship` remains responsible for release evaluation and recording; it gains candidate-versus-approved version records and consistency review, but does not create tags, releases, changelog publications, or remote actions.

The feature applies only to the Better-PromptKit repository. It does not impose commit formats, versioning policy, release notes, tags, tooling, remote operations, or publication behavior on repositories that consume Better-PromptKit.

### Goals

1. Preserve high-signal, atomic Conventional Commits while attaching evidence of public contract impact to eligible changes.
2. Create a reproducible release evaluation from an explicitly bounded Release Range and the latest Approved Release Record.
3. Determine a preliminary SemVer Candidate from user-observable Public PromptKit Contract impact, not Conventional Commit type alone.
4. Keep a calculated candidate separate from the Release Coordinator's explicitly approved version and tag.
5. Normalize merge, squash, duplicate, and revert history before calculating impact or deriving public notes.
6. Provide accountable Planner/Architect, Engineer, QA/Reviewer, and Release Coordinator handoffs.
7. Support an optional read-only consistency check without automatic release side effects.

### Non-Goals

- Implementing scripts, CI jobs, Git hooks, tag creation, release creation, remote pushes, deployment, or changelog publication.
- Replacing the existing production-release, deployment, migration, or rollback guidance in `pk:ship`.
- Inferring public contract impact solely from a Conventional Commit type, scope, or subject line.
- Treating a SemVer Candidate as an approved release, a tag, or a published artifact.
- Applying this workflow to Better-PromptKit consumers.

## Architecture

### Documentation-First Evidence Chain

The design uses durable Markdown records, with optional machine-readable headings or fields added only where a future read-only checker needs unambiguous parsing. The logical evidence chain is:

1. **Plan:** the Planner/Architect records a material Public PromptKit Contract decision, evidence, proposed impact, and migration guidance when breaking.
2. **Commit:** the Engineer creates one complete, reversible Conventional Commit and records either Contract Impact Evidence or an explicit Maintenance Commit classification.
3. **Evaluate:** the Release Coordinator selects a Release Candidate Commit; the evaluation records the prior approved baseline or First Release status and derives the Release Range.
4. **Normalize:** QA/Reviewer reviews history to form the effective change set: ignore merge nodes, treat squashes once, collapse duplicates, remove fully cancelled reverts, and classify modified reverts from new evidence.
5. **Propose:** the evaluation derives a preliminary SemVer Candidate from the greatest remaining impact and associates it with the candidate revision and supporting commits.
6. **Review:** QA/Reviewer verifies the range, classifications, precedence, notes, and unresolved blockers.
7. **Handoff:** `pk:checkpoint` records the candidate, blockers, review status, and required human approval action.
8. **Approve:** `pk:ship` records the Release Coordinator's Approved Release Version, Approved Release Tag, consistency results, and decision.
9. **Optionally validate:** a manual or CI-ready read-only check reports incomplete or inconsistent records and performs no Git, remote, publication, or deployment action.

### Release-Evaluation Lifecycle

| State | Required evidence | Responsible role | Permitted transition |
|---|---|---|---|
| Planned | Contract decision and proposed impact | Planner/Architect | Engineer may implement the scoped change. |
| Committed | Conventional Commit plus evidence or maintenance declaration | Engineer | QA/Reviewer may include it in a release evaluation. |
| Evaluating | Prior baseline/First Release status, candidate revision, range | Release Coordinator | QA/Reviewer verifies classification and notes. |
| Blocked | One or more named blockers | QA/Reviewer or Release Coordinator | Return to planning, evidence correction, or review. No approval. |
| Candidate proposed | Preliminary SemVer Candidate, effective change set, notes | QA/Reviewer | Release Coordinator may decide approval. |
| Approved record | Approved version, tag, decision, date, consistency results | Release Coordinator | Becomes Version Source of Truth after a complete approval. |
| Deferred / no-contract-change decision | Empty impactful range and documented decision | Release Coordinator | May later begin a new evaluation; no automatic tag or publication follows. |

`Approved` describes an internal decision record only. Tagging, creating a hosted release, publishing a changelog, and remote operations remain separate, explicit Release Coordinator decisions.

### SemVer Decision Rules

| Effective Contract Impact Evidence | Preliminary candidate increment |
|---|---|
| User-Facing Additive Contract Change | minor |
| User-Facing Corrective Contract Change | patch |
| Breaking Contract Change with Migration and Upgrade Guidance | major |
| Breaking Contract Change without guidance | blocker; no approvable candidate until resolved |
| Maintenance Commit with no intentional public contract change | no increment |

The evaluator selects the greatest increment in the effective Release Range using `major > minor > patch`. A `feat`, `fix`, or `perf` label never determines impact on its own; evidence does. A `docs`, `test`, `refactor`, `style`, or `chore` commit with no intentional Public PromptKit Contract change is recorded as maintenance.

For a First Release containing at least one additive public contract change, the proposed core version is `1.0.0`. A prerelease appends a Prerelease Identifier to the calculated candidate core. Promoting a prerelease records the same Release Candidate Commit with an Approved Release Version that omits the identifier.

### History Normalization

The evaluator produces an ordered effective change set before SemVer or note derivation:

| History shape | Treatment |
|---|---|
| Merge Commit | Exclude from independent classification; examine merged non-merge commits inside the Release Range. |
| Squash Commit | Treat as one Eligible Commit and classify from the combined Contract Impact Evidence. |
| Duplicate Change Group | Retain one representative evidence record for candidate calculation and one public note. |
| Fully cancelling Revert Pair | Remove the pair from candidate calculation and Public Release Notes. |
| Revert with additional resulting contract impact | Do not treat as a full cancellation; classify the resulting public contract from new evidence. |
| No remaining impactful Eligible Commit | Mark the evaluation as an empty eligible range and require a documented Release Coordinator decision to defer or approve a no-contract-change release. |

## Components and Interfaces

| Component | Owner | Inputs | Outputs / interface contract | Boundary |
|---|---|---|---|---|
| Planner/Architect planning record | Planner/Architect | Material contract decision, affected contract, observable before/after behavior | Proposed SemVer impact, Contract Impact Evidence, and Migration and Upgrade Guidance for breaking changes | Records design intent before implementation; does not approve a release. |
| `pk:commit` evidence capture | Engineer | Atomic diff, Conventional Commit message, linked planning/review record when applicable | Conventional Commit preserving the current format; either Contract Impact Evidence or Maintenance Commit declaration | Does not calculate final versions, create tags, or publish. |
| Release range evaluator | Release Coordinator with QA/Reviewer review | Latest Approved Release Record (if any), selected Release Candidate Commit, ordered Git history | First Release status or prior baseline; ordered Release Range; candidate-membership result | Records evaluation facts only; no Git mutation. |
| History normalizer | QA/Reviewer | Release Range and commit/evidence associations | Effective change set, duplicate/revert/merge/squash treatment, and blockers | Does not infer unsupported impact from labels. |
| SemVer candidate derivation | QA/Reviewer | Effective change set, prior version, prerelease intent | Preliminary SemVer Candidate with supporting commits and rationale | Cannot become approved without the Release Coordinator. |
| Release-note derivation | QA/Reviewer | Effective public contract changes and maintenance declarations | Public Release Notes, optional Maintenance section, and draft Changelog Entries | Does not publish a changelog. |
| `pk:checkpoint` release handoff | Release Coordinator | Candidate revision, preliminary candidate, QA result, blockers, required next action | Durable handoff fragment in the existing checkpoint/state artifact | Does not tag, release, publish, or approve. |
| `pk:ship` approval record | Release Coordinator | Evaluated candidate, notes, QA result, decision, approved version/tag | Approved Release Record and release-consistency results | Human decision point only; release actions remain separately proposed. |
| Optional Automation Check | Maintainer / CI runner | Recorded evaluation artifacts | Pass/fail diagnostics for completeness and consistency | Strictly read-only: no tag, hosted release, changelog publication, remote call, or repository mutation. |

### Handoff Contract

| From → To | Required handoff content | Receiving decision |
|---|---|---|
| Planner/Architect → Engineer | Affected Public PromptKit Contract; evidence of before/after behavior; proposed impact; breaking migration guidance | Engineer scopes one atomic change and retains/links the evidence. |
| Engineer → QA/Reviewer | Conventional Commit; evidence reference or Maintenance Commit declaration; relevant plan/review reference | QA/Reviewer accepts, corrects, or blocks the classification. |
| QA/Reviewer → Release Coordinator | Verified range boundaries; effective change set; candidate rationale; note coverage result; all blockers | Release Coordinator records evaluation status and requested decision via `pk:checkpoint`. |
| Release Coordinator → release record | Candidate revision; candidate; QA result; approved/deferred decision; approved version/tag when approved | `pk:ship` produces the durable record and determines the next human-controlled action. |

## Data Models

These are logical documentation records, not implementation-specific classes, database schemas, or a mandated serialization format.

### Contract Impact Evidence

| Field | Required when | Meaning |
|---|---|---|
| Evidence ID / stable reference | Always for an Eligible Commit with public impact | Link or anchor to the commit body, planning record, or review record. |
| Commit reference | Commit-level evidence | Commit that introduces or modifies the evidence. |
| Affected Public PromptKit Contract | Public impact | Workflow, template, protocol, trigger, documented output schema, required artifact, or behavior affected. |
| User-observable before/after behavior | Public impact | What a Better-PromptKit user experiences before and after the change. |
| Impact class | Public impact | Additive, corrective, or breaking. |
| Proposed increment | Public impact | Minor, patch, or major, justified by the impact class. |
| Migration and Upgrade Guidance | Breaking impact | Affected consumers, required actions, and supported transition path. |
| Supporting planning/review reference | When evidence is linked rather than fully in the commit body | Traceable source for the decision and review. |

### Commit Classification Record

| Field | Meaning |
|---|---|
| Commit reference and order | Identity and position in the Release Range. |
| Conventional Commit type | Informational classification only; not the versioning authority. |
| Shape | Non-merge, merge, squash, duplicate-group member, revert, or modified revert. |
| Eligibility | Eligible or excluded, including exclusion rationale. |
| Evidence reference | Contract Impact Evidence or an explicit maintenance declaration. |
| Maintenance declaration | Required for a Maintenance Commit and states no intentional Public PromptKit Contract change. |
| Effective representative | The one evidence record used for a duplicate group, if applicable. |
| Candidate impact | Major, minor, patch, none, or blocked. |

### Release Evaluation Record

| Field | Meaning |
|---|---|
| Evaluation ID | Stable identifier used to bind all evaluation artifacts. |
| Prior Approved Release Commit | Source revision from the latest Approved Release Record, if one exists. |
| Prior Approved Release Version | Version Source of Truth, if one exists. |
| First Release flag | True only when no prior Approved Release Record exists. |
| Release Candidate Commit | Selected Better-PromptKit revision under evaluation. |
| Release Range boundaries | Exclusive prior boundary when present, inclusive candidate boundary, or recorded all-history start for First Release. |
| Ordered range commit references | Reproducible list used for review and normalization. |
| Effective change set | Normalized classifications after merge, squash, duplicate, and revert treatment. |
| Empty eligible range flag | True when no effective SemVer-impacting Eligible Commit remains. |
| Blockers | Named unresolved conditions, owner, and disposition. |

### SemVer Candidate Record

| Field | Meaning |
|---|---|
| Candidate core version | Calculated major/minor/patch result before any prerelease suffix. |
| Prerelease Identifier | Optional suffix; absent for a final candidate. |
| Display candidate version | Core version plus suffix when present. |
| Status | Always `preliminary`; never a synonym for approved. |
| Release Candidate Commit | The exact revision evaluated. |
| Supporting Eligible Commits | Effective commits/evidence used in the calculation. |
| Rationale | Greatest-impact explanation, First Release rule, and any prerequisites. |

### Release Note and Changelog Draft

| Field | Public Release Note | Maintenance Release Note |
|---|---|---|
| Source | One distinct effective public contract change | One maintenance classification or grouped maintenance summary |
| Required content | Affected contract and user-observable change | Clearly labeled `Maintenance` and maintenance description |
| Breaking requirement | Include Migration and Upgrade Guidance | Not applicable |
| Duplicate/revert handling | One per duplicate group; none for full revert pairs | Follows effective change set |
| Changelog relation | Produces one draft Changelog Entry | Produces one draft Changelog Entry |
| Publication state | Draft/not published | Draft/not published |

### QA Review Record

| Field | Meaning |
|---|---|
| Evaluation ID | Binds review to exactly one release evaluation. |
| Range boundary result | Confirms prior/candidate boundaries and candidate membership. |
| Classification result | Confirms eligibility, impact evidence, maintenance declarations, and complex-history treatment. |
| Precedence result | Confirms the proposed candidate reflects the greatest effective impact. |
| Release-note coverage result | States whether every note has evidence and every user-observable change has one note. |
| Findings / blockers | Unsupported classifications or inaccurate notes, with required correction. |
| Reviewer identity and date | Accountable review attestation. |

### Approved Release Record

| Field | Meaning |
|---|---|
| Evaluation ID | Must match the evaluation, QA review, candidate, notes, and consistency result. |
| Approved Release Version | Final version approved by the Release Coordinator. |
| Approved Release Tag | Tag string approved for that version; it must encode the approved version. |
| Release Candidate Commit | Same revision recorded in the evaluated candidate. |
| Release Range boundaries | Boundaries used for the approval. |
| SemVer Candidate and rationale | Preliminary calculation and explanation of any approved-version difference. |
| QA/Reviewer result | Completed review outcome and named blockers. |
| Public and Maintenance Release Notes | Reviewed, derived note set. |
| Approval decision, coordinator, and date | Explicit human authorization and timing. |
| Release-consistency results | Field-level pass/fail diagnostics. |
| External-action decision | Explicit, separate choices for tag creation, release creation, changelog publication, and remote action. |

## File Boundaries and Documentation Changes

The following boundaries preserve existing workflow ownership and make the feature documentation-first. This design describes future edits only; it does not make them.

| Repository path | Proposed addition | Must not do |
|---|---|---|
| `workflows/commit.md` | Add a Contract Impact Evidence / Maintenance Classification subsection after the existing Conventional Commit body guidance. Include evidence fields, linked-record option, maintenance declaration, and breaking guidance reminder. | Change Conventional Commit syntax, weaken the atomic/reversible rule, calculate a release version, or perform release actions. |
| `workflows/checkpoint.md` | Add an optional release-evaluation handoff block containing evaluation ID, candidate commit, preliminary candidate, QA status, blockers, and the explicit next approval action. | Replace its session-state mission, mark a candidate approved, create a tag/release, publish, or call a remote. |
| `workflows/ship.md` | Add a Better-PromptKit internal release-evaluation section before any deployment-specific guidance. Define range selection, normalization, candidate analysis, notes, final approval record, and human-only external actions. | Remove or automate the current production safety guidance; tag, publish, deploy, or push by default. |
| `templates/issue-task-template.md` | Add an optional Public PromptKit Contract Impact subsection for Planner/Architect records: affected contract, before/after behavior, impact, evidence, and migration guidance. | Require generic consumer-project issues to adopt Better-PromptKit release policy. |
| `templates/state-tracker-template.md` | Add an optional release-handoff fragment matching the `pk:checkpoint` fields. | Turn `STATE.md` into an Approved Release Record or treat a handoff as approval. |
| `templates/release-checklist.md` | Add a Better-PromptKit internal release-evidence appendix: evaluation ID, range, candidate, QA result, approval record, notes, and separately checked human actions. | Convert checklist placeholders into automatic tag/publish/deploy instructions. |
| `templates/contract-impact-evidence-template.md` (new) | Define the reusable record layout for planning, commit-linked, and review evidence. | Become an executable version calculator or consumer-facing mandate. |
| `templates/release-evaluation-template.md` (new) | Define release range, effective history, candidate, QA review, notes, blockers, decision, and consistency-result sections. | Execute Git or remote operations. |
| `scripts/validate-release-records.ps1` and `scripts/validate-release-records.sh` (optional future additions) | Read documented release-evaluation records and report completeness/consistency results for manual or CI use. | Create/push tags, create releases, publish a changelog, mutate records, or make remote calls. |
| `.github/workflows/ci.yml` (optional future wiring) | Invoke the read-only checker only after it exists and only against Better-PromptKit records. | Make validation a release action or apply it to consumer repositories. |

No changes are proposed to `init.ps1`, `init.sh`, consumer scaffolding, or workflows unrelated to committing, checkpointing, shipping, and their record templates.

## Error Handling

The workflow records actionable diagnostics rather than silently correcting, auto-approving, or performing a release action.

| Condition | Detection point | Required result | Resolution owner |
|---|---|---|---|
| Eligible public-impact commit lacks evidence | Commit review or range classification | Mark classification incomplete; do not use it for candidate calculation until evidence is supplied. | Engineer, with QA/Reviewer review |
| Maintenance commit lacks explicit no-public-change declaration | Commit review | Mark maintenance classification incomplete. | Engineer |
| Missing release candidate or baseline/range boundary | Release evaluation | Block reproducibility and record missing boundary. | Release Coordinator |
| Release Candidate Commit is absent from range | Range consistency check | Failed release-consistency check. | Release Coordinator / QA Reviewer |
| Breaking change lacks Migration and Upgrade Guidance | Candidate derivation | Named release blocker; no approvable major candidate. | Planner/Architect and Engineer |
| No effective SemVer-impacting commit | Normalization | Mark empty eligible range; require explicit defer or documented no-contract-change decision. | Release Coordinator |
| Unsupported classification or inaccurate Public Release Note | QA review | Named blocker remains unresolved until corrected and reviewed. | Engineer/Planner/Architect, verified by QA/Reviewer |
| Candidate is presented as approved | Candidate/approval record review | Reject ambiguous record; retain `preliminary` candidate status. | Release Coordinator |
| Approved version differs from candidate without rationale | Approval record check | Failed completeness/consistency result. | Release Coordinator |
| Approved tag does not encode approved version | Approval record check | Failed release-consistency check. | Release Coordinator |
| Approved version has lower precedence than Version Source of Truth | Approval record check | Failed release-consistency check. | Release Coordinator |
| Approved version lacks coordinator approval | Approval record check | Failed release-consistency check. | Release Coordinator |
| Evaluation, QA review, notes, candidate, or approval reference different evaluations | Cross-record check | Failed release-consistency check identifying the mismatched artifact. | Release Coordinator with QA/Reviewer |
| Optional check cannot read a record | Optional Automation Check | Emit a diagnostic with the affected path/field; do not edit files or attempt recovery actions. | Maintainer |

A failed check never triggers a tag, hosted release, changelog publication, remote operation, commit rewrite, or automatic version substitution.

## Testing Strategy

This is a documentation-only design. Implementation work, when separately approved, should use both targeted examples and property-based tests for the pure normalization, SemVer, note-derivation, and consistency logic. Tests for workflow text and templates should remain example/snapshot or schema checks; no property test should exercise real remotes, tags, hosted releases, or publication.

### Example, Edge, and Smoke Coverage

- Verify the `pk:commit` Conventional Commit and atomic/reversible guidance remains present (Requirements 1.1–1.2).
- Verify representative complete and incomplete planning, approval, `pk:checkpoint`, `pk:ship`, and QA handoff records (Requirements 2.5, 3.1, 4.1, 6.6, 7.1–7.5, 8.5).
- Cover absence of the candidate from a range, missing breaking-change guidance, missing coordinator approval, tag/version mismatch, and no-impact ranges as named negative cases (Requirements 2.6, 3.5, 4.7, 5.6, 8.2).
- Exercise the optional checker only with local fixtures or test doubles and assert that it reports diagnostics without side effects.

### Property-Based Coverage

Implement each property below with at least 100 generated iterations. The test label format is:

`Feature: conventional-commit-versioning, Property <number>: <property title>`

Generate ordered synthetic histories, stable commit identifiers, evidence records, SemVer values, tags, release records, duplicate/revert groups, and QA outcomes. Keep all generators in memory or use disposable fixtures. Stub action interfaces so read-only behavior can be verified without touching a Git remote.

### Property Reflection

The property set is deliberately consolidated to avoid duplicate tests:

- Individual additive, corrective, breaking, maintenance, and `feat`/`fix`/`perf` rules are combined into one evidence-driven classification property.
- Duplicate-group and full-revert note rules are covered by normalizing to one effective change set before candidate and note derivation; separate duplicates would not add coverage.
- Tag correspondence and missing approval are combined with the broader approval-validity relation.
- Planner and Engineer handoff record format checks remain example-based because they are fixed documentation schemas; their variable evidence behavior is already covered by the eligibility and classification properties.
- QA checklist presence and coordinator-only action wording remain example-based process checks, while a QA finding's blocking effect is a distinct universal property.

## Correctness Properties

*A property is a behavior that holds across all valid executions of the release-evidence model. These properties are implementation-neutral specifications for future automated tests; they do not authorize implementation in this change.*

### Property 1: Eligible evidence and maintenance declarations are complete

For any non-merge commit classified as eligible, if it intentionally changes a Public PromptKit Contract then its record contains Contract Impact Evidence in the commit body or a linked planning/review record; otherwise, if it is classified as maintenance, it retains an explicit Maintenance Commit declaration, no intentional public-contract change, and no SemVer impact.

**Validates: Requirements 1.3, 1.4, 3.7**

### Property 2: Release ranges are bounded, reproducible, and candidate-inclusive

For any ordered history and selected Release Candidate Commit, an evaluation with a prior Approved Release Record contains precisely the commits after that prior approved commit through and including the candidate; an evaluation without one is marked First Release and contains the recorded commits through and including the candidate; and any record omitting the candidate fails range consistency.

**Validates: Requirements 2.1, 2.2, 2.3, 2.6**

### Property 3: The latest approved record supplies the next baseline

For any ordered collection of Approved Release Records, subsequent release evaluation resolves its Version Source of Truth, Prior Approved Release Commit, and prior version from the latest approved record rather than from a preliminary candidate or unapproved record.

**Validates: Requirements 2.4**

### Property 4: Impact classification follows evidence, not commit labels

For any Contract Impact Evidence, additive evidence produces a minor candidate impact, corrective evidence produces a patch candidate impact, breaking evidence with complete Migration and Upgrade Guidance produces a major candidate impact, and permuting a `feat`, `fix`, or `perf` Conventional Commit type does not change that evidence-derived impact.

**Validates: Requirements 3.2, 3.3, 3.4, 3.8**

### Property 5: Candidate selection uses greatest effective impact and first-release policy

For any normalized effective Release Range with one or more non-blocked impacts, the SemVer Candidate selects the maximum precedence of major, minor, and patch; for any First Release whose effective changes include an additive public contract change, its candidate core version is `1.0.0`.

**Validates: Requirements 3.6, 3.9**

### Property 6: Candidates are preliminary and retain provenance across prerelease promotion

For any derivable candidate, its record is labeled preliminary and identifies the exact Release Candidate Commit and supporting Eligible Commits; for any valid prerelease request, its display version preserves the calculated core and appends the identifier; and for any promotion, the final approved version removes that identifier while retaining the same Release Candidate Commit.

**Validates: Requirements 4.1, 4.2, 4.5, 4.6**

### Property 7: Approval records are justified, version-aligned, and coordinator-authorized

For any approved release record, the approved version either equals its SemVer Candidate or includes a non-empty rationale for the difference, its approved tag encodes that approved version, and it includes a Release Coordinator approval; any violation produces the corresponding failed release-consistency result.

**Validates: Requirements 4.3, 4.4, 4.7, 8.2**

### Property 8: History normalization preserves only effective change evidence

For any Release Range, independently classifying only non-merge commits, treating each squash as one combined-evidence commit, selecting one representative per duplicate group, removing fully cancelling revert pairs, and newly classifying modified reverts yields the effective change set used by both candidate and public-note derivation.

**Validates: Requirements 5.1, 5.2, 5.3, 5.4, 5.5**

### Property 9: Empty impactful ranges require an explicit decision

For any normalized Release Range with no Eligible Commit that has a SemVer Candidate impact, the release evaluation is marked as an empty eligible range and cannot conclude without a Release Coordinator decision to defer or to approve a documented no-contract-change release.

**Validates: Requirements 5.6**

### Property 10: Release notes and draft changelog entries represent effective changes exactly once

For any effective change set, release-note derivation produces one Public Release Note per distinct user-observable Public PromptKit Contract change, includes the affected contract and observable change (plus migration guidance for breaking changes), omits or Maintenance-labels maintenance changes, excludes full reverts, collapses duplicates, and produces exactly one unpublished draft Changelog Entry for every Public or Maintenance Release Note.

**Validates: Requirements 6.1, 6.2, 6.3, 6.4, 6.5, 6.7**

### Property 11: QA findings block release completion until correction

For any QA/Reviewer result that contains an unsupported SemVer Candidate classification or an inaccurate Public Release Note, the evaluation contains an unresolved release blocker and cannot reach an approved release decision until the affected classification or note is corrected and re-reviewed.

**Validates: Requirements 7.6**

### Property 12: Consistency validation is cross-record and read-only

For any release evaluation artifact set, the consistency result passes only when the approved version, approved tag, Release Candidate Commit, range, candidate rationale, QA result, and Public Release Notes identify the same evaluation, and the approved version is not lower in SemVer precedence than the Version Source of Truth; for any such validation run, the recorded action set contains no tag creation, release creation, changelog publication, repository mutation, or remote action.

**Validates: Requirements 8.1, 8.3, 8.4**

## Approval and Release-Control Policy

Every tag, hosted release, changelog publication, remote operation, and deployment remains a distinct, explicit decision by the Release Coordinator. `pk:commit`, `pk:checkpoint`, `pk:ship`, templates, and any optional Automation Check may present prerequisites, proposed commands, risks, and a decision record, but they must never carry out those external actions automatically. This policy preserves human approval for every release boundary and prevents a documentation or consistency workflow from becoming an implicit publication mechanism.
