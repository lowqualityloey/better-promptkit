<a id="CI-local-23"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-local-23`
- **State [Required]**: `verified`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > awaiting_confirmation > remediation_planned > awaiting_confirmation > local_reproduction_or_fix > verification_pending > verified`
- **Resume Condition [Required]**: CI Triage Team records the verified result after the new action epoch.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Local check 23
- **Failed Job or Command [Required when evidence is sufficient]**: Focused command 23
- **Failure Output [Required when evidence is sufficient]**: Captured failure output 23.
- **Revision Identifier [Required when evidence is sufficient]**: rev-23
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:23:00Z
- **Configuration Context [Required when evidence is sufficient]**: Local fixture context 23.
- **Classification [Required when state is classified or later]**: `unknown`
- **Remediation Plan [Required when state is remediation_planned or later]**: Replace the declined remote retry with one newly confirmed bounded local observation.
- **Remediation Classification [Required when a plan exists]**: `unknown`
- **Suspected Cause [Required when a plan exists]**: The first remote action was declined and required an independent recovery plan.
- **Affected Scope [Required when a plan exists]**: One local observation for rev-23.
- **Minimal Change [Required when a plan exists]**: Record a new action in confirmation epoch 2.
- **Verification Command [Required when a plan exists]**: Run the focused local verification for rev-23.
- **Rollback or Reversal Action [Required when a plan exists]**: Revert the local observation and preserve rev-23.
- **Declined Action Outcome [Required after an action is declined]**: The epoch 1 remote retry was declined and closed; epoch 2 records a separate confirmed action.
- **Remote Action Blocks [Required]**: `2`
- **Current Action Epoch [Required when action blocks exist]**: `2`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Pass - The new action epoch was verified without a release handoff bypass.`

### ACTION-CI-local-23-001

- **Action ID [Required]**: `ACTION-CI-local-23-001`
- **Action Epoch [Required]**: `1`
- **Action Lifecycle [Required]**: `closed`
- **Proposed Action [Required]**: Retry one remote operation for rev-23.
- **Confirmation State [Required]**: `declined`
- **Approver [Required]**: Human Approver One
- **Confirmation Timestamp [Required]**: 2026-09-09T05:24:00Z
- **Bounded Scope [Required]**: One remote operation for rev-23.
- **Reversal or Rollback Action [Required]**: No remote action was executed.
- **Resume Condition [Required]**: Create a new remediation plan and action epoch.

### ACTION-CI-local-23-002

- **Action ID [Required]**: `ACTION-CI-local-23-002`
- **Action Epoch [Required]**: `2`
- **Action Lifecycle [Required]**: `closed`
- **Proposed Action [Required]**: Confirm one bounded local observation for rev-23.
- **Confirmation State [Required]**: `confirmed`
- **Approver [Required]**: Human Approver Two
- **Confirmation Timestamp [Required]**: 2026-09-09T05:25:00Z
- **Bounded Scope [Required]**: One local observation for rev-23.
- **Reversal or Rollback Action [Required]**: Revert the local observation.
- **Resume Condition [Required]**: Record the local verification result.
