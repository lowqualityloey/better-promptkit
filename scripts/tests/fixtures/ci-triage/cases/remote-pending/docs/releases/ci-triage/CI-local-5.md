<a id="CI-local-5"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-local-5`
- **State [Required]**: `awaiting_confirmation`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > awaiting_confirmation`
- **Resume Condition [Required]**: Human approver records the bounded action decision.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Local check 5
- **Failed Job or Command [Required when evidence is sufficient]**: Focused command 5
- **Failure Output [Required when evidence is sufficient]**: Captured failure output 5.
- **Revision Identifier [Required when evidence is sufficient]**: rev-5
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:05:00Z
- **Configuration Context [Required when evidence is sufficient]**: Local fixture context 5.
- **Classification [Required when state is classified or later]**: `infrastructure or transient`
- **Remediation Plan [Required when state is remediation_planned or later]**: Retry one bounded provider operation after confirmation.
- **Remediation Classification [Required when a plan exists]**: `infrastructure or transient`
- **Suspected Cause [Required when a plan exists]**: Provider transient.
- **Affected Scope [Required when a plan exists]**: One provider operation.
- **Minimal Change [Required when a plan exists]**: Retry only the named operation.
- **Verification Command [Required when a plan exists]**: Inspect the resulting run evidence.
- **Rollback or Reversal Action [Required when a plan exists]**: Stop the retry and retain the verified revision.
- **Remote Action Blocks [Required]**: `1`
- **Current Action Epoch [Required when action blocks exist]**: `1`

### ACTION-CI-local-5-001

- **Action ID [Required]**: `ACTION-CI-local-5-001`
- **Action Epoch [Required]**: `1`
- **Action Lifecycle [Required]**: `open`
- **Proposed Action [Required]**: Retry one provider operation.
- **Confirmation State [Required]**: `pending`
- **Approver [Required]**: `N/A - awaiting confirmation`
- **Confirmation Timestamp [Required]**: `N/A - awaiting confirmation`
- **Bounded Scope [Required]**: One operation for rev-5.
- **Reversal or Rollback Action [Required]**: Stop the retry.
- **Resume Condition [Required]**: Record the retry result.
