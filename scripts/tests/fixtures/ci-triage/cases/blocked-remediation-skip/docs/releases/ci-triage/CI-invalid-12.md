<a id="CI-invalid-12"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-12`
- **State [Required]**: `remediation_planned`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > blocked > remediation_planned`
- **Blocker [Required when blocked or previously blocked]**: Evidence review was unavailable.
- **Resume Target [Required when blocked or previously blocked]**: `remediation_planned`
- **Resume Condition [Required]**: CI Triage Team receives the complete evidence bundle.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 12
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 12
- **Failure Output [Required when evidence is sufficient]**: Output invalid 12.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-12
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:32:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 12.
- **Classification [Required when state is classified or later]**: `build`
- **Remediation Plan [Required when state is remediation_planned or later]**: A bounded plan.
- **Remediation Classification [Required when a plan exists]**: `build`
- **Suspected Cause [Required when a plan exists]**: Build input.
- **Affected Scope [Required when a plan exists]**: One build.
- **Minimal Change [Required when a plan exists]**: Minimal build change.
- **Verification Command [Required when a plan exists]**: Run verification.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore build input.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
