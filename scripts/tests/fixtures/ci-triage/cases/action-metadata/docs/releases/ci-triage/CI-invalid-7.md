<a id="CI-invalid-7"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-7`
- **State [Required]**: `awaiting_confirmation`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > awaiting_confirmation`
- **Resume Condition [Required]**: Human decision is recorded.
- **CI Evidence [Required]**: Complete evidence bundle.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 7
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 7
- **Failure Output [Required when evidence is sufficient]**: Output invalid 7.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-7
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:17:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 7.
- **Classification [Required when state is classified or later]**: `build`
- **Remediation Plan [Required when state is remediation_planned or later]**: A bounded plan.
- **Remediation Classification [Required when a plan exists]**: `build`
- **Suspected Cause [Required when a plan exists]**: Build input.
- **Affected Scope [Required when a plan exists]**: One build.
- **Minimal Change [Required when a plan exists]**: Minimal build change.
- **Verification Command [Required when a plan exists]**: Run verification.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore build input.
- **Remote Action Blocks [Required]**: `1`
- **Current Action Epoch [Required when action blocks exist]**: `1`

### ACTION-CI-invalid-7-001

- **Action ID [Required]**: `ACTION-CI-invalid-7-001`
- **Action Epoch [Required]**: `1`
- **Action Lifecycle [Required]**: `closed`
- **Proposed Action [Required]**: Retry one operation.
- **Confirmation State [Required]**: `confirmed`
- **Approver [Required]**: `N/A - awaiting confirmation`
- **Confirmation Timestamp [Required]**: `N/A - awaiting confirmation`
- **Bounded Scope [Required]**: One operation.
- **Reversal or Rollback Action [Required]**: Stop the operation.
- **Resume Condition [Required]**: Record the result.
