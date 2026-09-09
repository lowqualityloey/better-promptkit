<a id="CI-github-100"></a>
# CI Triage Record: GitHub Run 100

- **CI ID [Required]**: `CI-github-100`
- **State [Required]**: `linked_to_pk_ship`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `true`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > awaiting_confirmation > local_reproduction_or_fix > verification_pending > verified > linked_to_pk_ship`
- **Blocker [Required when blocked or previously blocked]**: `N/A - not blocked`
- **Resume Target [Required when blocked or previously blocked]**: `N/A - not blocked`
- **Resume Condition [Required]**: Release Coordinator may resume after the linked release record is verified.

## CI Evidence

- **CI Evidence [Required]**: Complete provider evidence bundle recorded below.
- **Check Identity [Required when evidence is sufficient]**: GitHub Actions / test
- **Failed Job or Command [Required when evidence is sufficient]**: validate / bash test command
- **Failure Output [Required when evidence is sufficient]**: Assertion output captured in the run log.
- **Revision Identifier [Required when evidence is sufficient]**: abc100
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:00:00Z
- **Configuration Context [Required when evidence is sufficient]**: Linux runner and repository test configuration.
- **Missing Evidence [Required when state is evidence_requested]**: `N/A - evidence sufficient`
- **Evidence Request Owner [Required when state is evidence_requested]**: `N/A - evidence sufficient`

## Classification

- **Classification [Required when state is classified or later]**: `test`

## Remediation Plan

- **Remediation Plan [Required when state is remediation_planned or later]**: Correct the bounded test setup and rerun the recorded verification.
- **Remediation Classification [Required when a plan exists]**: `test`
- **Suspected Cause [Required when a plan exists]**: Test setup did not include the required fixture.
- **Affected Scope [Required when a plan exists]**: The CI test fixture only.
- **Minimal Change [Required when a plan exists]**: Add the missing fixture input.
- **Verification Command [Required when a plan exists]**: Run the focused CI fixture command.
- **Rollback or Reversal Action [Required when a plan exists]**: Remove the fixture change if the focused verification fails.
- **Declined Action Outcome [Required after an action is declined]**: `N/A - no action declined`

## Action Confirmation

- **Remote Action Blocks [Required]**: `1`
- **Current Action Epoch [Required when action blocks exist]**: `1`

### ACTION-CI-github-100-001

- **Action ID [Required]**: `ACTION-CI-github-100-001`
- **Action Epoch [Required]**: `1`
- **Action Lifecycle [Required]**: `closed`
- **Proposed Action [Required]**: Retry the bounded GitHub test run.
- **Confirmation State [Required]**: `confirmed`
- **Approver [Required]**: Release Coordinator
- **Confirmation Timestamp [Required]**: 2026-09-09T05:10:00Z
- **Bounded Scope [Required]**: One GitHub run for revision abc100.
- **Reversal or Rollback Action [Required]**: Stop the retry and preserve the prior verified revision.
- **Resume Condition [Required]**: Record the retry result before verification.

## Cross-Record Links

- **pk:debug Link [Optional]**: `N/A - no local reproduction needed`
- **pk:ship Release Link [Required when state is linked_to_pk_ship]**: `[RELEASE-release-1](../release-1.md#RELEASE-release-1)`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Pass - Focused CI verification passed for revision abc100.`
