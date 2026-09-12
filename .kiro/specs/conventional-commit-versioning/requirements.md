# Requirements Document

## Introduction

Conventional Commit Versioning defines Better-PromptKit's internal workflow and template contract for assessing changes to PromptKit's public workflow and template behavior, proposing a Semantic Versioning (SemVer) candidate, producing accurate release notes, and approving a release version and tag. The feature extends `pk:commit`, `pk:checkpoint`, and `pk:ship` while preserving their existing ownership boundaries.

The feature applies only to changes in the Better-PromptKit repository. The feature does not impose versioning, release, changelog, tooling, tag, remote, or publication behavior on repositories that consume Better-PromptKit.

## Glossary

- **Better-PromptKit**: The repository containing PromptKit workflows, templates, protocols, documentation, and supporting validation assets.
- **Conventional Commit**: A commit message that conforms to the `pk:commit` Conventional Commit format.
- **Atomic Commit**: A commit that represents one complete, reversible logical concern.
- **Public PromptKit Contract**: An externally usable Better-PromptKit workflow, template, protocol, command trigger, documented output schema, required artifact, or documented workflow behavior.
- **Contract Impact Evidence**: A recorded reference to the changed Public PromptKit Contract, the before-and-after user-observable behavior, and any required migration or upgrade guidance.
- **Eligible Commit**: A non-merge commit in the Release Range with Contract Impact Evidence or with a documented maintenance classification.
- **Release Range**: The ordered commits after the Prior Approved Release Commit through the selected Release Candidate Commit, inclusive of the Release Candidate Commit.
- **Prior Approved Release Commit**: The commit recorded by the latest Approved Release Record as the source revision for the prior final release.
- **Release Candidate Commit**: The selected Better-PromptKit commit proposed for release evaluation.
- **SemVer Candidate**: A preliminary version calculated from the greatest Contract Impact Evidence in the Release Range.
- **Approved Release Version**: The final SemVer version approved by the Release Coordinator for a Release Candidate Commit.
- **Approved Release Tag**: The tag name approved by the Release Coordinator for an Approved Release Version.
- **Approved Release Record**: The `pk:ship` release record that identifies the Approved Release Version, Approved Release Tag, Release Candidate Commit, approval decision, and release-consistency results.
- **Version Source of Truth**: The Approved Release Version and Release Candidate Commit recorded in the latest Approved Release Record.
- **User-Facing Additive Contract Change**: A backward-compatible change that adds a user-observable Public PromptKit Contract capability.
- **User-Facing Corrective Contract Change**: A backward-compatible change that corrects a user-observable Public PromptKit Contract behavior.
- **Breaking Contract Change**: A change that removes, renames, or alters an existing Public PromptKit Contract in a way that requires a consumer to change usage.
- **Migration and Upgrade Guidance**: Instructions that identify affected Public PromptKit Contract consumers, required consumer actions, and the supported transition path.
- **Maintenance Commit**: An Eligible Commit that changes documentation, tests, refactors, styles, chores, or internal assets without an intentional Public PromptKit Contract change.
- **Public Release Note**: A release-note entry describing a user-observable Public PromptKit Contract change.
- **Changelog Entry**: A changelog entry derived from a Public Release Note or a Maintenance Release Note.
- **Maintenance Release Note**: A clearly labeled release-note entry describing a Maintenance Commit.
- **Duplicate Change Group**: Eligible Commits that represent the same resolved Public PromptKit Contract change.
- **Revert Pair**: An original Eligible Commit and a later commit that reverses the original Eligible Commit within the same Release Range.
- **Squash Commit**: A single commit that combines the changes from multiple prior commits.
- **Merge Commit**: A commit that joins histories without being independently classified for Contract Impact Evidence.
- **Prerelease Identifier**: A SemVer suffix that marks a version as a prerelease.
- **First Release**: The first Approved Release Record for Better-PromptKit.
- **Planner/Architect**: The role that records material Public PromptKit Contract and versioning decisions before implementation.
- **Engineer**: The role that implements scoped changes and records commit-level Contract Impact Evidence.
- **QA/Reviewer**: The role that verifies classification, range treatment, and release-note accuracy.
- **Release Coordinator**: The role that uses `pk:checkpoint` and `pk:ship` to approve the final release version and tag.
- **Optional Automation Check**: A manually invokable or CI-ready, read-only validation that reports release-record completeness and release-consistency results.

## Requirements

### Requirement 1: Preserve Commit Contract

**User Story:** As a Better-PromptKit maintainer, I want release-versioning guidance to retain high-signal commits, so that version evidence remains traceable to scoped changes.

#### Acceptance Criteria

1. THE Better-PromptKit Conventional Commit Versioning feature SHALL preserve the `pk:commit` Conventional Commit format.
2. THE Better-PromptKit Conventional Commit Versioning feature SHALL preserve the `pk:commit` Atomic Commit requirement of one complete, reversible logical concern per commit.
3. WHEN an Engineer creates an Eligible Commit, THE Better-PromptKit Conventional Commit Versioning feature SHALL require Contract Impact Evidence in the commit body or in a linked planning or review record.
4. WHEN an Engineer classifies an Eligible Commit as a Maintenance Commit, THE Better-PromptKit Conventional Commit Versioning feature SHALL record the maintenance classification and the absence of an intentional Public PromptKit Contract change.

### Requirement 2: Establish Release Range and Version Source of Truth

**User Story:** As a Release Coordinator, I want a bounded release range and one approved version record, so that every release decision has a reproducible baseline.

#### Acceptance Criteria

1. WHEN a Release Coordinator opens release evaluation, THE Better-PromptKit Conventional Commit Versioning feature SHALL record the Prior Approved Release Commit and the Release Candidate Commit.
2. WHEN a Prior Approved Release Commit exists, THE Better-PromptKit Conventional Commit Versioning feature SHALL define the Release Range as commits after the Prior Approved Release Commit through the Release Candidate Commit.
3. WHEN no Prior Approved Release Commit exists, THE Better-PromptKit Conventional Commit Versioning feature SHALL classify the release evaluation as a First Release and define the Release Range as all commits through the Release Candidate Commit that the Release Coordinator records.
4. WHEN a Release Coordinator approves a release, THE Approved Release Record SHALL become the Version Source of Truth for subsequent release evaluations.
5. WHEN a Release Coordinator records an Approved Release Record, THE Approved Release Record SHALL contain the Approved Release Version, Approved Release Tag, Release Candidate Commit, Release Range boundaries, approval decision, and approval date.
6. IF the Release Candidate Commit is absent from the Release Range, THEN THE Better-PromptKit Conventional Commit Versioning feature SHALL report a failed release-consistency check.

### Requirement 3: Determine SemVer Candidates from Public Contract Impact

**User Story:** As a Planner/Architect, I want SemVer candidates to reflect externally observable contract impact, so that commit labels do not substitute for release analysis.

#### Acceptance Criteria

1. WHEN a Planner/Architect identifies a material Public PromptKit Contract decision, THE Planner/Architect SHALL record the affected Public PromptKit Contract, Contract Impact Evidence, and proposed SemVer Candidate impact in the planning record.
2. WHEN Contract Impact Evidence identifies a User-Facing Additive Contract Change, THE Better-PromptKit Conventional Commit Versioning feature SHALL propose a minor SemVer Candidate increment.
3. WHEN Contract Impact Evidence identifies a User-Facing Corrective Contract Change, THE Better-PromptKit Conventional Commit Versioning feature SHALL propose a patch SemVer Candidate increment.
4. WHEN Contract Impact Evidence identifies a Breaking Contract Change with Migration and Upgrade Guidance, THE Better-PromptKit Conventional Commit Versioning feature SHALL propose a major SemVer Candidate increment.
5. IF Contract Impact Evidence identifies a Breaking Contract Change without Migration and Upgrade Guidance, THEN THE Better-PromptKit Conventional Commit Versioning feature SHALL record the missing guidance as a release blocker.
6. WHEN the Release Range contains multiple Eligible Commits with SemVer Candidate impacts, THE Better-PromptKit Conventional Commit Versioning feature SHALL select the greatest increment using major, then minor, then patch precedence.
7. WHEN an Eligible Commit has a Conventional Commit type of `docs`, `test`, `refactor`, `style`, or `chore` and has no intentional Public PromptKit Contract change, THE Better-PromptKit Conventional Commit Versioning feature SHALL classify the Eligible Commit as a Maintenance Commit without proposing a SemVer increment.
8. WHEN an Eligible Commit has a Conventional Commit type of `feat`, `fix`, or `perf`, THE Better-PromptKit Conventional Commit Versioning feature SHALL determine the SemVer Candidate impact from Contract Impact Evidence rather than from the Conventional Commit type alone.
9. WHEN a First Release contains at least one User-Facing Additive Contract Change, THE Better-PromptKit Conventional Commit Versioning feature SHALL propose `1.0.0` as the SemVer Candidate core version.

### Requirement 4: Distinguish Candidate and Approved Versions

**User Story:** As a Release Coordinator, I want preliminary analysis to remain distinct from release approval, so that no calculated version is misrepresented as a final release decision.

#### Acceptance Criteria

1. WHEN the Better-PromptKit Conventional Commit Versioning feature calculates a SemVer Candidate, THE Better-PromptKit Conventional Commit Versioning feature SHALL label the SemVer Candidate as preliminary.
2. WHEN a SemVer Candidate is recorded, THE Better-PromptKit Conventional Commit Versioning feature SHALL associate the SemVer Candidate with the Release Candidate Commit and the supporting Eligible Commits.
3. WHEN a Release Coordinator approves a final release, THE Release Coordinator SHALL record an Approved Release Version that is equal to the SemVer Candidate or record the rationale for a different Approved Release Version.
4. WHEN a Release Coordinator approves a final release, THE Release Coordinator SHALL record an Approved Release Tag that corresponds to the Approved Release Version.
5. WHEN a prerelease is proposed, THE Better-PromptKit Conventional Commit Versioning feature SHALL append a Prerelease Identifier to the calculated SemVer Candidate core version.
6. WHEN a prerelease is promoted to a final release, THE Release Coordinator SHALL record an Approved Release Version without the Prerelease Identifier and shall retain the supporting Release Candidate Commit reference.
7. IF an Approved Release Version has no Release Coordinator approval record, THEN THE Better-PromptKit Conventional Commit Versioning feature SHALL report a failed release-consistency check.

### Requirement 5: Classify Complex History and Empty Ranges

**User Story:** As a QA/Reviewer, I want explicit handling for common Git history shapes, so that version and release-note results do not count the same contract change incorrectly.

#### Acceptance Criteria

1. WHEN the Release Range contains a Merge Commit, THE Better-PromptKit Conventional Commit Versioning feature SHALL exclude the Merge Commit from independent SemVer Candidate classification and shall classify the merged non-merge commits in the Release Range.
2. WHEN the Release Range contains a Squash Commit, THE Better-PromptKit Conventional Commit Versioning feature SHALL classify the Squash Commit as one Eligible Commit using Contract Impact Evidence for the combined change.
3. WHEN the Release Range contains a Duplicate Change Group, THE Better-PromptKit Conventional Commit Versioning feature SHALL use one representative Contract Impact Evidence record for SemVer Candidate calculation and Public Release Note derivation.
4. WHEN a Revert Pair fully cancels a Public PromptKit Contract change within the Release Range, THE Better-PromptKit Conventional Commit Versioning feature SHALL exclude the Revert Pair from SemVer Candidate calculation and Public Release Note derivation.
5. WHEN a reverting commit changes the resulting Public PromptKit Contract beyond the reverted change, THE Better-PromptKit Conventional Commit Versioning feature SHALL classify the resulting Public PromptKit Contract using new Contract Impact Evidence.
6. IF the Release Range contains no Eligible Commit with a SemVer Candidate impact, THEN THE Better-PromptKit Conventional Commit Versioning feature SHALL record an empty eligible range and require a Release Coordinator decision to defer approval or approve a documented no-contract-change release.

### Requirement 6: Derive Accurate, Filtered Release Notes

**User Story:** As a Better-PromptKit user, I want release notes to describe contract changes that affect my use of PromptKit, so that release communication remains relevant and complete.

#### Acceptance Criteria

1. WHEN the Better-PromptKit Conventional Commit Versioning feature derives release notes, THE Better-PromptKit Conventional Commit Versioning feature SHALL create one Public Release Note for each distinct user-observable Public PromptKit Contract change in the Release Range.
2. WHEN the Better-PromptKit Conventional Commit Versioning feature creates a Public Release Note, THE Public Release Note SHALL identify the affected Public PromptKit Contract, the user-observable change, and Migration and Upgrade Guidance when the change is a Breaking Contract Change.
3. WHEN the Better-PromptKit Conventional Commit Versioning feature identifies a Maintenance Commit, THE Better-PromptKit Conventional Commit Versioning feature SHALL omit the Maintenance Commit from Public Release Notes or include the Maintenance Commit in a section labeled `Maintenance`.
4. WHEN the Better-PromptKit Conventional Commit Versioning feature derives release notes from a Duplicate Change Group, THE Better-PromptKit Conventional Commit Versioning feature SHALL produce one Public Release Note for the Duplicate Change Group.
5. WHEN the Better-PromptKit Conventional Commit Versioning feature derives release notes from a Revert Pair that fully cancels a contract change, THE Better-PromptKit Conventional Commit Versioning feature SHALL omit the Revert Pair from Public Release Notes.
6. WHEN a QA/Reviewer completes release-note review, THE QA/Reviewer SHALL record whether every Public Release Note is supported by Contract Impact Evidence and whether every user-observable Public PromptKit Contract change has a Public Release Note.
7. WHEN the Better-PromptKit Conventional Commit Versioning feature produces a Public Release Note or a Maintenance Release Note, THE Better-PromptKit Conventional Commit Versioning feature SHALL derive a corresponding Changelog Entry without publishing the Changelog Entry.

### Requirement 7: Define Role Handoffs and Approval Control

**User Story:** As a Better-PromptKit maintainer, I want explicit handoffs between planning, implementation, review, and release, so that release evidence remains accountable across workflow stages.

#### Acceptance Criteria

1. WHEN a material Public PromptKit Contract decision is made, THE Planner/Architect SHALL record the decision, Contract Impact Evidence, proposed SemVer Candidate impact, and Migration and Upgrade Guidance when required.
2. WHEN an Engineer completes an atomic Better-PromptKit change, THE Engineer SHALL create a Conventional Commit and record the commit-level Contract Impact Evidence or Maintenance Commit classification.
3. WHEN release evaluation begins, THE QA/Reviewer SHALL verify the Release Range boundaries, Eligible Commit classifications, SemVer Candidate precedence, complex-history treatment, and release-note accuracy.
4. WHEN release evaluation is handed off, THE Release Coordinator SHALL use `pk:checkpoint` to record the Release Candidate Commit, SemVer Candidate, unresolved blockers, and required approval action.
5. WHEN final release evaluation is complete, THE Release Coordinator SHALL use `pk:ship` to record the Approved Release Version, Approved Release Tag, release-consistency results, and release approval decision.
6. IF QA/Reviewer verification identifies an unsupported SemVer Candidate classification or an inaccurate Public Release Note, THEN THE Better-PromptKit Conventional Commit Versioning feature SHALL record a release blocker until the classification or Public Release Note is corrected.

### Requirement 8: Validate Release Consistency Without Automatic Release Actions

**User Story:** As a Better-PromptKit maintainer, I want verifiable release records without mandatory release automation, so that teams retain control of tags, publishing, and remote operations.

#### Acceptance Criteria

1. WHEN the Release Coordinator completes `pk:ship` release evaluation, THE Better-PromptKit Conventional Commit Versioning feature SHALL verify that the Approved Release Version, Approved Release Tag, Release Candidate Commit, Release Range, SemVer Candidate rationale, QA/Reviewer result, and Public Release Notes refer to the same release evaluation.
2. IF an Approved Release Tag does not encode the Approved Release Version, THEN THE Better-PromptKit Conventional Commit Versioning feature SHALL report a failed release-consistency check.
3. IF an Approved Release Version has a lower SemVer precedence than the Version Source of Truth, THEN THE Better-PromptKit Conventional Commit Versioning feature SHALL report a failed release-consistency check.
4. WHERE an Optional Automation Check is configured, THE Optional Automation Check SHALL validate required release-record fields and release-consistency checks without creating a tag, creating a release, publishing a changelog, or performing a remote action.
5. THE Better-PromptKit Conventional Commit Versioning feature SHALL present tag creation, release creation, changelog publication, and remote actions as Release Coordinator decisions.
