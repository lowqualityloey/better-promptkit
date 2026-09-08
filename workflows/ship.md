# Ship Workflow (Release Engineering, Migration Sequencing & Rollback Protocols)

## Fast Shorthand
Trigger anytime with: `pk:ship` (or `/pk-ship`)

## Mission
Guide the developer through safe, reliable production releases, deployment sequencing, and verification.

Eliminate production deployment outages: missing or invalid environment variables at runtime, race conditions between database migrations and application code deployments, unverified releases, and panicked rollbacks.

---

## Preconditions
- Code has passed code review (`pk:review`) and testing gates (`pk:test`).
- Target storage directory: `./docs/releases/` in the host project.
- Access to `.promptkit/templates/release-checklist.md`.

---

## Core Release Engineering Pillars

### 1. Runtime Environment Variable Validation (Fail-Fast Boot)
Never allow an application with missing or malformed secrets to boot into production:

1. **Type-Safe Schema Validation at Startup**:
   - Validate `process.env` using Zod or `@t3-oss/env-nextjs` inside an `env.ts` configuration module imported at the application entrypoint:
     ```typescript
     // src/env.ts
     import { z } from 'zod';

     const serverEnvSchema = z.object({
       NODE_ENV: z.enum(['development', 'test', 'production']),
       DATABASE_URL: z.string().url(),
       SESSION_SECRET: z.string().min(32),
       STRIPE_SECRET_KEY: z.string().startsWith('sk_'),
     });

     const clientEnvSchema = z.object({
       NEXT_PUBLIC_APP_URL: z.string().url(),
     });

     export const env = {
       ...serverEnvSchema.parse(process.env),
       ...clientEnvSchema.parse(process.env),
     };
     ```
2. **Fail-Fast Crash**:
   - If a required secret is missing, the application process crashes immediately during initialization with an explicit error naming the missing variable. It must never fail hours later during an active user transaction.
3. **Client vs Server Boundary**:
   - Never prefix server secrets with `NEXT_PUBLIC_` or `VITE_`.
   - Audit client bundle outputs to verify zero server secret leakage.

---

### 2. Zero-Downtime Migration Sequencing
Database schema changes and application code updates do not deploy at the exact same instant. Follow the **Golden Deployment Rule**:

```
EXPAND PHASE (Additive Changes):
Step 1: Apply backwards-compatible database migration (new nullable columns/tables).
Step 2: Deploy new application code (writes to both old and new columns).
Result: Zero downtime. Both old and new application instances function concurrently.

CONTRACT PHASE (Destructive Cleanups):
Step 1: Deploy application code that completely stops reading/writing old column.
Step 2: Verify all old containers/pods are terminated and zero traffic references old schema.
Step 3: Apply database migration to drop deprecated column or table.
Result: Zero downtime. No running instance queries a deleted column.
```

- **Hard Rule**: Never combine an additive change (Expand) and a destructive drop (Contract) in the same release or migration script.

---

### 3. Staging and Preview Environment Parity
1. **Ephemeral Preview Deployments**:
   - Verify features in preview environments (Vercel previews, Supabase database branch, Railway staging) before merging to `main`.
2. **Data Sanitization**:
   - Non-production environments must use synthetic seed fixtures.
   - Never replicate unmasked production customer PII or payment records into staging environments.

---

### 4. Release Pre-Flight and Automated Smoke Testing
Before declaring a release complete, verify production behavior with active probes:

1. **Pre-Flight Sanity Check**:
   - Clean git tag generated: `vX.Y.Z`.
   - CI pipeline passed: lint, type-check, unit tests, integration tests.
   - Build artifact size verified (check for bundle size regressions).
2. **Automated Smoke Test Verification**:
   - Immediately after traffic shifts to the new release, run automated synthetic probes:
     - **Health Check**: `GET /api/health` returns `200 OK` with database ping latency.
     - **Critical Path Probe**: Synthetic test user authenticates, loads dashboard, and performs a read.
     - **Edge Cache Invalidation**: Verify stale CDN assets are purged.

---

### 5. Instant Rollback Protocol
When production metrics degrade post-release, do not guess or attempt complex live debugging in production. Follow the structured rollback protocol:

#### Rollback Decision Criteria
Trigger an immediate rollback if within 15 minutes of deployment:
- HTTP 5xx error rate spikes above 1%.
- P99 latency degrades by more than 50% from baseline.
- Core checkout, authentication, or data persistence flows fail in smoke tests.

#### Execution Runbook
1. **Application Code Rollback**:
   - Redeploy the previous verified commit SHA or platform deployment immediately (1-click rollback in Vercel, Railway, or Kubernetes).
2. **Database Reversion**:
   - Because all pre-deploy migrations follow the Expand phase, the database schema remains 100% compatible with the previous application version. **Do not roll back database schema during an active incident** unless the migration itself degraded database performance.
3. **Transition to Root Cause Analysis**:
   - After production stability is restored, trigger `pk:debug` in local development to reproduce the failure.

---

## Workflow Steps

### Step 1: Pre-Release Verification
1. Confirm all code passed review (`pk:review`) and quality gates (`pk:test`).
2. Verify that all required environment variables are provisioned in the production dashboard.

### Step 2: Determine Migration Sequencing
1. Check if the release contains database migrations:
   - If Expand phase: Execute migrations *before* deploying application code.
   - If Contract phase: Verify application code is deployed and verified *before* executing cleanup migrations.

### Execution-Control Release Evidence Gate

Before Step 3, record the execution evidence needed by the release evaluation:

- Link the canonical Task Record(s), accepted completion evidence, changed-file summary, exact candidate revision, review result, CI evidence, migration sequencing, rollback plan, and any Scope Change or Exception Records.
- Confirm the task and milestone are in a releasable state and that no unresolved blocker, hard checkpoint, stale handoff, scope mismatch, or revision mismatch remains.
- Link the applicable release-impact evaluation and preserve the distinction between a preliminary candidate and an Approved Release Version.
- Record host/timer limitations and any execution-control validator result as evidence only. A passing validator or CI job cannot approve a version or authorize a tag, hosted release, publication, deployment, or rollback.
- Release Coordinator approval remains explicit and separate. The existing Step 3-5 actions, release checklist, production safety gates, and rollback authority remain owned by `pk:ship` and must not be automated by this overlay.

### Release Evidence Template Cross-Reference

Use the optional **Execution-Control Evidence** section in `templates/release-checklist.md` for the Task Record path and ID, specification, state, owner/approval boundary, acceptance and changed-file evidence, candidate revision, verification/CI/review/commit/PR links, checkpoint/handoff, scope or exception records, blockers, host/timer limitation, and release-impact evaluation. `N/A` is valid for Trivial Work or consumers that do not adopt the optional protocol. This evidence evaluates a candidate against the approved immutable `v1.0.0` baseline; it does not rewrite that baseline or authorize tag, push, publication, deployment, or rollback.

### Better-PromptKit Internal Release Evaluation

This evaluation applies only to the Better-PromptKit repository. It is a documentation record for deriving and reviewing a release candidate from Better-PromptKit evidence. It does not impose Conventional Commit, SemVer, release-note, tag, remote, publication, deployment, or rollback requirements on repositories that consume Better-PromptKit.

The evaluation must remain separate from production execution. A calculated version is a preliminary candidate, not an Approved Release Version. A passing validator, CI result, checkpoint handoff, empty blocker list, or completed QA review does not create a tag, hosted release, published changelog, remote operation, deployment, or rollback authorization.

#### 1. Establish Evaluation Identity and the Version Source of Truth

Create one stable **Evaluation ID** for every release evaluation and use that exact identifier in the evaluation, candidate, QA/Reviewer review, release notes, draft changelog entries, and Approved Release Record. Record the accountable Release Coordinator and the date the evaluation was opened.

Select the prior approved baseline before inspecting impact:

- The **Version Source of Truth** is the latest complete Approved Release Record. Use its approved version and `Prior Approved Release Commit` as the baseline for the next evaluation.
- Never use a preliminary candidate, checkpoint handoff, unapproved tag, or draft changelog as the Version Source of Truth.
- Record the prior approved version, prior approved release commit, and the source record path or identifier. If there is no prior Approved Release Record, mark the evaluation `First Release: true` and record the all-history starting point used for review.
- The baseline is immutable evidence for this evaluation. Do not rewrite it to make a range or candidate appear consistent.

#### 2. Define the Candidate-Inclusive Release Range

Record the range as reproducible boundaries before classifying commits:

| Field | Required record |
| :--- | :--- |
| **Release Range start** | The prior approved release commit as an exclusive boundary, or the recorded all-history start for a First Release. |
| **Release Range end** | The selected Better-PromptKit revision under evaluation. |
| **Release Candidate Commit** | The exact commit identifier at the Release Range end; it is inclusive and must be present in the ordered range list. |
| **Ordered range commits** | Every reviewed commit from the start boundary through and including the candidate, in a reproducible order. |

For a normal release, the Release Range contains commits after the prior approved baseline and through the inclusive Release Candidate Commit. For a First Release, the range contains the recorded Better-PromptKit history through the inclusive candidate. Do not classify commits outside the recorded range.

Run a candidate-membership consistency check before deriving a version:

1. Confirm the Release Candidate Commit is present exactly once in the ordered range.
2. Confirm it is the inclusive end of the range and is reachable from the selected Better-PromptKit history.
3. Confirm the recorded prior boundary, when present, is the same commit and version supplied by the latest Approved Release Record.
4. Mark the evaluation blocked if the candidate is absent, duplicated, outside the boundaries, or associated with a different Evaluation ID. A failed check never substitutes a different commit automatically.

#### 3. Normalize the Effective Change Set

Normalize the complete Release Range before calculating SemVer or deriving release notes. Record the shape, eligibility, evidence reference, representative, and resulting impact for every reviewed item. Candidate calculation and note derivation must consume the same ordered **Effective Change Set**.

Apply these rules:

- **Merge Commit:** Do not classify the merge node as an independent public change. Review the eligible non-merge commits brought into the range and retain their evidence once.
- **Squash Commit:** Treat the squash as one Eligible Commit. Classify it from its combined Contract Impact Evidence rather than classifying each squashed contribution separately.
- **Duplicate Change Group:** Collapse equivalent changes to one effective representative, one evidence record, one candidate contribution, and one public note. Record the duplicate members and representative.
- **Fully cancelling Revert Pair:** Remove the original change and its complete revert from the Effective Change Set. They contribute no SemVer impact and no Public Release Note.
- **Partial Revert:** Do not treat a revert as a full cancellation when the resulting behavior leaves a new public contract effect. Classify the resulting contract from the new evidence and retain its effective residual impact and note.
- **Unresolved or unsupported history:** Record the affected commits and a blocker instead of silently guessing, excluding evidence, or allowing a label to determine impact.

The normalized result must state which merge, squash, duplicate-group, full-revert, and partial-revert rules were applied. The same normalized Effective Change Set is the sole input to both SemVer candidate calculation and filtered release-note derivation.

#### 4. Derive an Evidence-Driven SemVer Candidate

Determine impact from Contract Impact Evidence describing the user-observable Public PromptKit Contract, not from the Conventional Commit type, scope, or subject alone. `feat`, `fix`, and `perf` labels are informative history fields; they do not determine the increment.

| Effective Contract Impact Evidence | Candidate impact |
| :--- | :--- |
| **User-Facing Additive Contract Change** | `minor` |
| **User-Facing Corrective Contract Change** | `patch` |
| **Breaking Contract Change with Migration and Upgrade Guidance** | `major` |
| **Breaking Contract Change without Migration and Upgrade Guidance** | `blocked`; no approvable major candidate until guidance is supplied and reviewed |
| **Maintenance Commit** with an explicit declaration of no intentional Public PromptKit Contract change | `none`; no SemVer increment |

Select the greatest effective impact in the normalized range using the precedence **`major > minor > patch`**. `none` does not increase a version. A missing breaking-change guidance record is a named blocker even when the commit is otherwise classified as breaking. Do not use a `docs`, `test`, `refactor`, `style`, or `chore` label to override evidence or to manufacture public impact.

For a First Release, record the absence of a prior Approved Release Record and the complete first-release range. When that effective range contains at least one additive public contract change, the candidate core version is **`1.0.0`**. This is a candidate rule, not approval and not permission to create a `v1.0.0` tag. Continue to record the supporting effective commits and rationale.

The **SemVer Candidate Record** must contain:

- Candidate core version and display candidate version.
- The calculated impact and the greatest-impact rationale, including the First Release `1.0.0` rule when applicable.
- **Status: preliminary**. Never use `approved` or equivalent wording for this record.
- The exact **Release Candidate Commit** and the supporting Eligible Commits from the Effective Change Set.
- The **Evaluation ID**, prior approved baseline or First Release status, and Release Range boundaries.
- An optional **Prerelease Identifier** and the resulting display candidate, such as a core candidate plus `-alpha.1` or `-rc.1`.
- Any prerequisite, guidance, QA, or consistency blocker.

A prerelease identifier changes the display candidate only; it does not change the core impact calculation or grant approval. When a prerelease is promoted, record the same Evaluation ID, Release Candidate Commit, Release Range, supporting effective commits, and candidate rationale. The promoted Approved Release Version may omit the Prerelease Identifier only after an explicit Release Coordinator approval record; preserve the prerelease provenance and explain any difference between the preliminary candidate and approved version.

#### 5. Handle an Empty Eligible Range Explicitly

After normalization, set **Empty eligible range: true** when no effective Eligible Commit has a SemVer-impacting public contract change. Maintenance-only history, a fully cancelling revert pair, or a range containing only excluded merge nodes can produce this state.

An empty eligible range is not an automatic patch release and is not an implicit approval. The Release Coordinator must record one explicit decision:

- **Defer:** no release is approved; record the reason and the next evaluation or trigger.
- **Approve a documented no-contract-change release:** record why a release with no public-contract increment is needed, the approved version rationale, QA result, and all consistency results.

If neither decision is recorded, the evaluation remains blocked. No empty-range result authorizes a tag, hosted release, changelog publication, remote action, deployment, or rollback.

#### 6. QA/Reviewer Release-Evaluation Review

Before approval, the QA/Reviewer must review and record a result under the same Evaluation ID. The review must cover:

- **Range boundary review:** prior baseline or First Release start, Release Range end, inclusive Release Candidate Commit, ordered range, and candidate-membership consistency.
- **Classification review:** eligibility, Contract Impact Evidence, Maintenance Commit declarations, breaking Migration and Upgrade Guidance, and the fact that labels do not determine SemVer impact.
- **Normalization review:** merge, squash, duplicate-group, fully cancelling revert, and partial-revert treatment, including the resulting Effective Change Set.
- **Precedence review:** confirmation that the preliminary candidate uses the greatest effective impact, with `major > minor > patch`, and applies the First Release `1.0.0` additive rule when applicable.
- **Blocker review:** every missing evidence item, missing breaking guidance, failed consistency check, unsupported classification, unresolved scope issue, and open correction with an owner and disposition.
- **Release-note coverage review:** every effective public contract change has exactly one supported Public Release Note, duplicate and full-revert handling is reflected, breaking notes include guidance, and every note maps back to evidence in the same Effective Change Set.

Record the reviewer identity, review date, findings, blocker status, and correction/re-review result. A failed or incomplete QA/Reviewer result keeps the evaluation unapproved even if the candidate version is calculable.

#### 7. Derive Public and Maintenance Release Notes Without Publishing

Derive notes only from the normalized Effective Change Set:

- **Public Release Notes** describe each distinct effective user-observable Public PromptKit Contract change once, identify the affected contract and before/after behavior, and include Migration and Upgrade Guidance for breaking changes.
- **Maintenance Release Notes** are clearly labeled `Maintenance` and describe effective maintenance classifications that declare no intentional public-contract change. They do not claim a SemVer increment.
- A duplicate change group produces one representative note. A fully cancelling Revert Pair produces no public note. A Partial Revert produces a note only when new evidence shows a resulting contract impact.
- Record note sources, evidence references, reviewer coverage, and the shared Evaluation ID.

Create explicit **draft Changelog Entries** for the reviewed Public Release Notes and Maintenance Release Notes. Every draft entry must be labeled **unpublished** or **not published** and must state that publication is a separate human decision. Drafting a changelog entry does not write to a hosted changelog, publish a file, perform a remote action, or authorize a release.

#### 8. Create the Approved Release Record Only After Human Approval

The Approved Release Record is an internal decision record, not an automatic release operation. It must be created only after the Release Coordinator has reviewed the candidate and QA/Reviewer result and made an explicit decision. Include all of these fields:

| Field | Required content |
| :--- | :--- |
| **Evaluation ID** | The same stable identifier used by the evaluation, candidate, QA review, notes, draft changelog entries, and consistency results. |
| **Approved Release Version** | The final version explicitly approved by the Release Coordinator. |
| **Approved Release Tag** | The tag string approved for that version; it must encode the Approved Release Version. Record it without creating the tag. |
| **Release Candidate Commit** | The exact candidate revision from the evaluation and candidate record. |
| **Release Range boundaries** | The reviewed start, end, ordered commits, and inclusive candidate-membership result. |
| **SemVer Candidate and rationale** | The preliminary candidate, supporting evidence, precedence result, and a non-empty rationale for any approved-version difference. |
| **QA/Reviewer result** | Range, classification, normalization, precedence, blocker, and note-coverage findings, including final correction status. |
| **Public and Maintenance Release Notes** | The reviewed effective notes and their evidence references. |
| **Approval decision, date, and coordinator** | Explicit approved, deferred, or no-contract-change decision, the Release Coordinator identity, and decision date. |
| **Release-consistency results** | Field-level pass/fail results and any resolved findings. No failed result may be represented as approved. |
| **External-action decisions** | Separate decisions for tag creation, hosted release creation, changelog publication, remote operations, deployment, and rollback. |

An approved version must equal the preliminary candidate unless the record contains a specific rationale for the difference. Approval is never inferred from a candidate, QA pass, or completed record field. A deferred decision remains deferred and cannot be described as an Approved Release Version.

#### 9. Run Cross-Record Consistency Checks

Before treating the Approved Release Record as complete, record the result of each check:

- **Shared Evaluation ID:** evaluation, range, candidate, QA/Reviewer review, Public Release Notes, Maintenance Release Notes, draft Changelog Entries, approval, and consistency results use one Evaluation ID.
- **Candidate-in-range:** the exact Release Candidate Commit is present once and inclusively at the end of the recorded Release Range.
- **Tag/version alignment:** the approved tag string encodes exactly the Approved Release Version. A proposed tag is evidence only until separately approved and created.
- **Version precedence:** the Approved Release Version does not regress below the Version Source of Truth under SemVer precedence, unless a documented and separately reviewed policy decision explicitly explains the outcome.
- **Approval and rationale:** the Release Coordinator, decision date, decision, and approval rationale are present; a difference from the preliminary candidate has a non-empty explanation.
- **QA and note linkage:** the QA/Reviewer result covers the same range and Effective Change Set, and every reviewed note is linked to evidence and the same Evaluation ID.
- **Consistency outcome:** each failure names the artifact, field, owner, and correction. A failed check blocks approval and never triggers corrective Git, remote, publication, deployment, or rollback activity.

#### 10. Keep External Release Actions Human-Only and Separate

The Release Coordinator must make separate, explicit human-approved decisions for each action. Recording one action does not imply permission for another:

- Create the Git release tag.
- Create the hosted release.
- Publish the changelog or any release notes.
- Perform remote operations, including pushing release-related refs.
- Trigger or authorize production deployment.
- Execute or authorize a production rollback.

`pk:ship` records the evaluation, evidence, QA result, approval decision, and requested action boundaries. It must not automatically run tag commands, push commands, hosted-release commands, changelog publication, deployment, or rollback. The existing production-safety guidance, release checklist, and Steps 3 through 5 remain in force after this evaluation, and each external action still requires its own human Release Coordinator decision.

---

### Step 3: Trigger Production Deployment
1. Create a version tag (`git tag -a vX.Y.Z -m "Release message"`).
2. Push to production deployment pipeline.

### Step 4: Execute Post-Deploy Smoke Testing
1. Run automated health check endpoints and inspect deployment logs.
2. Manually or synthetically verify the primary user journey in production.

### Step 5: Monitor and Sign-off
1. Monitor error tracking (Sentry / Datadog / CloudWatch) for 15 minutes post-deploy.
2. Complete and commit the release record to `./docs/releases/`.

---

## Anti-Patterns to Avoid

| Anti-Pattern | Consequence | Remedy |
| :--- | :--- | :--- |
| **Unvalidated Environment Variables** | Silent crashes hours after deploy when missing secrets are first accessed. | Validate all environment variables with Zod at application startup. |
| **Deploying Code and Migration Simultaneously** | Container start races against migration execution, causing broken queries during rolling update. | Follow the Golden Deployment Rule (Expand before deploy; Contract after deploy). |
| **Debugging Live in Production** | Extended customer downtime while developers scramble under pressure. | Roll back immediately; debug safely in local development using `pk:debug`. |
| **Untested Rollbacks** | Rollback fails because new schema broke backwards compatibility with old code. | Ensure every schema migration is backwards-compatible with previous application version. |
| **Skipping Smoke Tests** | Broken client bundles or routing errors discovered by customers instead of engineers. | Run automated smoke tests immediately post-deployment. |

---

## Completion Criteria
- Environment variables validated with startup schema checks.
- Migration sequencing planned and executed in correct phase order.
- Post-deployment smoke tests executed and passed.
- Release document saved to `./docs/releases/`.
