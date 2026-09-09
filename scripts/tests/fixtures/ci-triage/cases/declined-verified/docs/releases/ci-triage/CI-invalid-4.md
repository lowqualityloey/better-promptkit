<a id="CI-invalid-4"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-4`
- **State [Required]**: `verified`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > awaiting_confirmation > local_reproduction_or_fix > verification_pending > verified`
- **Resume Condition [Required]**: Verification passed.
- **CI Evidence [Required]**: Complete evidence bundle.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 4
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 4
- **Failure Output [Required when evidence is sufficient]**: Output invalid 4.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-4
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:14:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 4.
- **Classification [Required when state is classified or later]**: `infrastructure or transient`
- **Remediation Plan [Required when state is remediation_planned or later]**: A bounded plan.
- **Remediation Classification [Required when a plan exists]**: `infrastructure or transient`
- **Suspected Cause [Required when a plan exists]**: Transient failure.
- **Affected Scope [Required when a plan exists]**: One operation.
- **Minimal Change [Required when a plan exists]**: Minimal retry.
- **Verification Command [Required when a plan exists]**: Run focused verification.
- **Rollback or Reversal Action [Required when a plan exists]**: Stop the retry.
- **Declined Action Outcome [Required after an action is declined]**: Action declined but incorrectly marked verified.
- **Remote Action Blocks [Required]**: `1`
- **Current Action Epoch [Required when action blocks exist]**: `1`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Pass - Incorrect fixture.`

### ACTION-CI-invalid-4-001

- **Action ID [Required]**: `ACTION-CI-invalid-4-001`
- **Action Epoch [Required]**: `1`
- **Action Lifecycle [Required]**: `closed`
- **Proposed Action [Required]**: Retry one operation.
- **Confirmation State [Required]**: `declined`
- **Approver [Required]**: Human Approver
- **Confirmation Timestamp [Required]**: 2026-09-09T05:24:00Z
- **Bounded Scope [Required]**: One operation.
- **Reversal or Rollback Action [Required]**: No remote action executed.
- **Resume Condition [Required]**: New plan required.
