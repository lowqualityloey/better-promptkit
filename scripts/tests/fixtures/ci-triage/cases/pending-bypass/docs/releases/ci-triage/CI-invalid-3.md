<a id="CI-invalid-3"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-3`
- **State [Required]**: `local_reproduction_or_fix`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > awaiting_confirmation > local_reproduction_or_fix`
- **Resume Condition [Required]**: Record local evidence.
- **CI Evidence [Required]**: Complete evidence bundle.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 3
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 3
- **Failure Output [Required when evidence is sufficient]**: Output invalid 3.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-3
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:13:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 3.
- **Classification [Required when state is classified or later]**: `test`
- **Remediation Plan [Required when state is remediation_planned or later]**: A bounded plan.
- **Remediation Classification [Required when a plan exists]**: `test`
- **Suspected Cause [Required when a plan exists]**: Test input.
- **Affected Scope [Required when a plan exists]**: One test.
- **Minimal Change [Required when a plan exists]**: Minimal test change.
- **Verification Command [Required when a plan exists]**: Run focused test.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore test input.
- **Remote Action Blocks [Required]**: `1`
- **Current Action Epoch [Required when action blocks exist]**: `1`

### ACTION-CI-invalid-3-001

- **Action ID [Required]**: `ACTION-CI-invalid-3-001`
- **Action Epoch [Required]**: `1`
- **Action Lifecycle [Required]**: `open`
- **Proposed Action [Required]**: Retry one operation.
- **Confirmation State [Required]**: `pending`
- **Approver [Required]**: `N/A - awaiting confirmation`
- **Confirmation Timestamp [Required]**: `N/A - awaiting confirmation`
- **Bounded Scope [Required]**: One operation.
- **Reversal or Rollback Action [Required]**: Stop the operation.
- **Resume Condition [Required]**: Record the result.
