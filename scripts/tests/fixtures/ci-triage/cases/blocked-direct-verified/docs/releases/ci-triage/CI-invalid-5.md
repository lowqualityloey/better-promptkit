<a id="CI-invalid-5"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-5`
- **State [Required]**: `verified`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > blocked > verified`
- **Blocker [Required when blocked or previously blocked]**: Temporary blocker.
- **Resume Target [Required when blocked or previously blocked]**: `verified`
- **Resume Condition [Required]**: Verification supplied.
- **CI Evidence [Required]**: Complete evidence bundle.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 5
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 5
- **Failure Output [Required when evidence is sufficient]**: Output invalid 5.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-5
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:15:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 5.
- **Classification [Required when state is classified or later]**: `build`
- **Remediation Plan [Required when state is remediation_planned or later]**: A bounded plan.
- **Remediation Classification [Required when a plan exists]**: `build`
- **Suspected Cause [Required when a plan exists]**: Build input.
- **Affected Scope [Required when a plan exists]**: One build.
- **Minimal Change [Required when a plan exists]**: Minimal build change.
- **Verification Command [Required when a plan exists]**: Run verification.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore build input.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Pass - Incorrect bypass.`
