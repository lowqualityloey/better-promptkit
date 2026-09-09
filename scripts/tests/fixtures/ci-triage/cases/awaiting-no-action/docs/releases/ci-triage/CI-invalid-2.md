<a id="CI-invalid-2"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-invalid-2`
- **State [Required]**: `awaiting_confirmation`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > awaiting_confirmation`
- **Resume Condition [Required]**: Human decision.
- **CI Evidence [Required]**: Complete evidence bundle.
- **Check Identity [Required when evidence is sufficient]**: Check invalid 2
- **Failed Job or Command [Required when evidence is sufficient]**: Command invalid 2
- **Failure Output [Required when evidence is sufficient]**: Output invalid 2.
- **Revision Identifier [Required when evidence is sufficient]**: rev-invalid-2
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:12:00Z
- **Configuration Context [Required when evidence is sufficient]**: Context invalid 2.
- **Classification [Required when state is classified or later]**: `build`
- **Remediation Plan [Required when state is remediation_planned or later]**: A bounded plan.
- **Remediation Classification [Required when a plan exists]**: `build`
- **Suspected Cause [Required when a plan exists]**: Build input.
- **Affected Scope [Required when a plan exists]**: One build.
- **Minimal Change [Required when a plan exists]**: Minimal build change.
- **Verification Command [Required when a plan exists]**: Run build.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore build input.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
