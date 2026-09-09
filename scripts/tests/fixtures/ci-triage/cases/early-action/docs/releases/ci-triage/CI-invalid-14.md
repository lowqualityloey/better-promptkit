<a id="CI-invalid-14"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-14`
- **State [Required]**: `classified`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified`
- **Resume Condition [Required]**: Classifier records the bounded classification.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 14
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 14
- **Failure Output [Required when evidence is sufficient]**: Output invalid 14.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-14
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:34:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 14.
- **Classification [Required when state is classified or later]**: `build`
- **Remote Action Blocks [Required]**: `1`
- **Current Action Epoch [Required when action blocks exist]**: `1`

### ACTION-CI-invalid-14-001

- **Action ID [Required]**: `ACTION-CI-invalid-14-001`
- **Action Epoch [Required]**: `1`
- **Action Lifecycle [Required]**: `open`
- **Proposed Action [Required]**: Retry one bounded operation.
- **Confirmation State [Required]**: `pending`
- **Approver [Required]**: `N/A - awaiting confirmation`
- **Confirmation Timestamp [Required]**: `N/A - awaiting confirmation`
- **Bounded Scope [Required]**: One operation.
- **Reversal or Rollback Action [Required]**: Stop the operation.
- **Resume Condition [Required]**: Record the result.
