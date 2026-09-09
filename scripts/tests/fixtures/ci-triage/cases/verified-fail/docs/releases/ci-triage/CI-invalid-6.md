<a id="CI-invalid-6"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-6`
- **State [Required]**: `verified`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > local_reproduction_or_fix > verification_pending > verified`
- **Resume Condition [Required]**: Verification must pass.
- **CI Evidence [Required]**: Complete evidence bundle.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 6
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 6
- **Failure Output [Required when evidence is sufficient]**: Output invalid 6.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-6
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:16:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 6.
- **Classification [Required when state is classified or later]**: `test`
- **Remediation Plan [Required when state is remediation_planned or later]**: A bounded plan.
- **Remediation Classification [Required when a plan exists]**: `test`
- **Suspected Cause [Required when a plan exists]**: Test input.
- **Affected Scope [Required when a plan exists]**: One test.
- **Minimal Change [Required when a plan exists]**: Minimal test change.
- **Verification Command [Required when a plan exists]**: Run verification.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore test input.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Fail - Verification did not pass.`
