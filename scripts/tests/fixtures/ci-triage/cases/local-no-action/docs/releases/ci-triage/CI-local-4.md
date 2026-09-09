<a id="CI-local-4"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-local-4`
- **State [Required]**: `local_reproduction_or_fix`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > local_reproduction_or_fix`
- **Resume Condition [Required]**: Engineer records the local reproduction result.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Local check 4
- **Failed Job or Command [Required when evidence is sufficient]**: Focused command 4
- **Failure Output [Required when evidence is sufficient]**: Captured failure output 4.
- **Revision Identifier [Required when evidence is sufficient]**: rev-4
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:04:00Z
- **Configuration Context [Required when evidence is sufficient]**: Local fixture context 4.
- **Classification [Required when state is classified or later]**: `test`
- **Remediation Plan [Required when state is remediation_planned or later]**: Reproduce the test failure locally and make the smallest in-scope correction.
- **Remediation Classification [Required when a plan exists]**: `test`
- **Suspected Cause [Required when a plan exists]**: Fixture setup is incomplete.
- **Affected Scope [Required when a plan exists]**: Focused fixture.
- **Minimal Change [Required when a plan exists]**: Add the missing fixture input.
- **Verification Command [Required when a plan exists]**: Run focused command 4.
- **Rollback or Reversal Action [Required when a plan exists]**: Remove the fixture input if verification fails.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
