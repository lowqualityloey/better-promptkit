<a id="CI-local-12"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-local-12`
- **State [Required]**: `blocked`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > local_reproduction_or_fix > verification_pending > verified > blocked`
- **Blocker [Required when blocked or previously blocked]**: Verification evidence must be reviewed by the CI triage owner.
- **Resume Target [Required when blocked or previously blocked]**: `verification_pending`
- **Resume Condition [Required]**: CI triage owner confirms the recorded verification evidence.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Local check 12
- **Failed Job or Command [Required when evidence is sufficient]**: Focused command 12
- **Failure Output [Required when evidence is sufficient]**: Captured failure output 12.
- **Revision Identifier [Required when evidence is sufficient]**: rev-12
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:18:00Z
- **Configuration Context [Required when evidence is sufficient]**: Local fixture context 12.
- **Classification [Required when state is classified or later]**: `test`
- **Remediation Plan [Required when state is remediation_planned or later]**: Review the verification evidence before release decisions.
- **Remediation Classification [Required when a plan exists]**: `test`
- **Suspected Cause [Required when a plan exists]**: Evidence ownership checkpoint is incomplete.
- **Affected Scope [Required when a plan exists]**: One CI record.
- **Minimal Change [Required when a plan exists]**: Complete the evidence review.
- **Verification Command [Required when a plan exists]**: Review the recorded verification.
- **Rollback or Reversal Action [Required when a plan exists]**: Keep the release blocked.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Pass - Focused verification passed for rev-12.`
