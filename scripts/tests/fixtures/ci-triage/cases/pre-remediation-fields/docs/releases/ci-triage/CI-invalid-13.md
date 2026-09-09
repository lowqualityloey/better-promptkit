<a id="CI-invalid-13"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-13`
- **State [Required]**: `classified`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified`
- **Resume Condition [Required]**: Classifier records the bounded classification.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 13
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 13
- **Failure Output [Required when evidence is sufficient]**: Output invalid 13.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-13
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:33:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 13.
- **Classification [Required when state is classified or later]**: `build`
- **Remediation Plan [Required when state is remediation_planned or later]**: This plan is recorded too early.
- **Remediation Classification [Required when a plan exists]**: `build`
- **Suspected Cause [Required when a plan exists]**: Build input.
- **Affected Scope [Required when a plan exists]**: One build.
- **Minimal Change [Required when a plan exists]**: Minimal build change.
- **Verification Command [Required when a plan exists]**: Run verification.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore build input.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
