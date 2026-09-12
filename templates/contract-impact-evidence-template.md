# Contract Impact Evidence: [Evidence ID]

<!-- Use this record for PromptKit OS planning, commit-linked evidence, or QA/Reviewer review. It records evidence and a proposed impact only. It does not approve a release or perform an external action. -->

## 1. Identity and Scope

- **Record Type**: `Contract Impact Evidence`
- **Evidence ID**: `[EVIDENCE-YYYY-MM-DD-slug]`
- **Evaluation / Task / Specification References**: `[evaluation ID, task record, and specification path]`
- **Commit Reference**: `[exact commit SHA; N/A is valid only before a commit exists in planning-only evidence]`
- **Commit Evidence Location**: `[commit-body field or linked planning/review record path and anchor; required for an Engineer-created Eligible Commit]`
- **Conventional Commit Type and Subject**: `[type(scope): subject or N/A]`
- **Owner / Role**: `[Planner/Architect | Engineer | QA/Reviewer]`
- **Created**: `[YYYY-MM-DD HH:MM UTC]`
- **Applicable Repository**: `PromptKit OS`
- **Consumer Repository Applicability**: `N/A`; this evidence records PromptKit OS's own workflow and template contract and does not impose versioning or release policy on consumer repositories.

## 2. Public PromptKit Contract

- **Affected Public PromptKit Contract**: `[workflow, template, protocol, command trigger, documented output schema, required artifact, or documented behavior]`
- **Contract Category**: `[Workflow | Template | Protocol | Trigger | Output Schema | Required Artifact | Documented Behavior]`
- **Affected Path(s) or Trigger(s)**: `[repository-relative paths, command triggers, or N/A]`
- **Supporting Planning / Review Records**: `[record paths, issue references, or N/A]`
- **Intended PromptKit OS User or Maintainer**: `[role or audience]`
- **Contract Scope Boundary**: `[what is intentionally included and what remains outside this evidence]`

## 3. User-Observable Contract Evidence

- **Before Behavior**: `[What a PromptKit OS user or maintainer observes before the change]`
- **After Behavior**: `[What a PromptKit OS user or maintainer observes after the change]`
- **User / Consumer Impact**: `[observable benefit, correction, compatibility consequence, or N/A for maintenance]`
- **Compatibility and Adoption Consequence**: `[backward-compatible, requires migration, optional adoption, or N/A]`
- **Evidence Source**: `[diff, workflow comparison, example, review record, or other durable evidence reference]`

## 4. Impact Classification and SemVer Proposal

- **Impact Classification**: `[User-Facing Additive Contract Change | User-Facing Corrective Contract Change | Breaking Contract Change | Maintenance Commit]`
- **Intentional Public Contract Change**: `[Yes | No]`
- **Maintenance Commit Declaration**: `[Required for Maintenance Commit: This change has no intentional Public PromptKit Contract change.]`
- **Proposed SemVer Candidate Impact**: `[major | minor | patch | none | blocked]`
- **Impact Rationale**: `[Explain the evidence-driven relationship between the observable change and the proposed impact.]`
- **Commit-Label Independence Check**: `[Explain why the evidence, not feat/fix/perf/docs/test/refactor/style/chore alone, determines the result.]`

## 5. Migration and Upgrade Guidance

- **Guidance Status**: `[Complete | Missing and release blocker | N/A for non-breaking change]`
- **Affected Consumers**: `[consumer roles, workflows, or repositories affected by a breaking change, or N/A]`
- **Required Consumer Actions**: `[specific upgrade or migration actions, or N/A]`
- **Supported Transition Path**: `[compatibility period, old/new behavior, and completion condition, or N/A]`
- **Breaking-Guidance Decision**: `[If this is breaking, guidance is mandatory. Record Missing and name the blocker until complete. For non-breaking or maintenance evidence, record N/A.]`

## 6. Review and Disposition

- **Evidence Status**: `[Draft | Ready for Review | Accepted | Blocked | Superseded]`
- **QA/Reviewer**: `[name or role, or N/A before review]`
- **Review Date**: `[YYYY-MM-DD HH:MM UTC or N/A]`
- **Findings / Blockers**: `[unsupported classification, missing guidance, incomplete evidence, or None]`
- **Resolution / Follow-up**: `[correction, linked follow-up record, or N/A]`
- **Final Disposition**: `[Accepted as supporting evidence | Accepted as Maintenance Commit | Blocked pending correction | Superseded]`

## 7. Boundary Confirmation

- **Release Candidate Association**: `[candidate commit or N/A; this record does not approve the candidate]`
- **Approved Release Association**: `N/A until a separate Release Coordinator approval record exists.`
- **External Action Decision**: `N/A; this record never creates or pushes tags, creates hosted releases, publishes changelogs, performs remote operations, deploys, or rolls back.`

A Contract Impact Evidence record supports traceability. It does not calculate an approved version, replace the Local Task Source, authorize a commit or merge, or impose PromptKit OS policy on consumer repositories.
