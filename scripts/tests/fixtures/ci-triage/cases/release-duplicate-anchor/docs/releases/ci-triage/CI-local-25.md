<a id="CI-local-25"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-local-25`
- **State [Required]**: `linked_to_pk_ship`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `true`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > local_reproduction_or_fix > verification_pending > verified > linked_to_pk_ship`
- **Resume Condition [Required]**: Release Coordinator may resume from the linked release record.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Local release check 25
- **Failed Job or Command [Required when evidence is sufficient]**: Focused release command 25
- **Failure Output [Required when evidence is sufficient]**: Captured failure output 25.
- **Revision Identifier [Required when evidence is sufficient]**: rev-25
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:25:00Z
- **Configuration Context [Required when evidence is sufficient]**: Local release fixture context 25.
- **Classification [Required when state is classified or later]**: `deployment`
- **Remediation Plan [Required when state is remediation_planned or later]**: Verify the bounded release candidate before handoff.
- **Remediation Classification [Required when a plan exists]**: `deployment`
- **Suspected Cause [Required when a plan exists]**: Release verification was incomplete.
- **Affected Scope [Required when a plan exists]**: One release candidate.
- **Minimal Change [Required when a plan exists]**: Complete the recorded verification.
- **Verification Command [Required when a plan exists]**: Run the release verification procedure.
- **Rollback or Reversal Action [Required when a plan exists]**: Keep the prior verified release available.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
- **pk:ship Release Link [Required when state is linked_to_pk_ship]**: `[RELEASE-release-25](../release-25.md#RELEASE-release-25)`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Pass - Release verification passed for rev-25.`
