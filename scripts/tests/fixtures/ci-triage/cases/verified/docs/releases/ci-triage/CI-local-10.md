<a id="CI-local-10"></a>
# CI Triage Record

- **CI ID [Required]**: `CI-local-10`
- **State [Required]**: `verified`
- **Owner [Required]**: CI Triage Team
- **Release Candidate [Required]**: `false`
- **State History [Required]**: `evidence_requested > evidence_sufficient > classified > remediation_planned > local_reproduction_or_fix > verification_pending > verified`
- **Resume Condition [Required]**: No release handoff is required for this non-release record.
- **CI Evidence [Required]**: Complete evidence bundle is recorded.
- **Check Identity [Required when evidence is sufficient]**: Local check 10
- **Failed Job or Command [Required when evidence is sufficient]**: Focused command 10
- **Failure Output [Required when evidence is sufficient]**: Captured failure output 10.
- **Revision Identifier [Required when evidence is sufficient]**: rev-10
- **Execution Time [Required when evidence is sufficient]**: 2026-09-09T05:10:00Z
- **Configuration Context [Required when evidence is sufficient]**: Local fixture context 10.
- **Classification [Required when state is classified or later]**: `static analysis`
- **Remediation Plan [Required when state is remediation_planned or later]**: Apply the bounded static-analysis correction.
- **Remediation Classification [Required when a plan exists]**: `static analysis`
- **Suspected Cause [Required when a plan exists]**: One stale analysis rule.
- **Affected Scope [Required when a plan exists]**: One analysis rule.
- **Minimal Change [Required when a plan exists]**: Update the stale rule.
- **Verification Command [Required when a plan exists]**: Run focused command 10.
- **Rollback or Reversal Action [Required when a plan exists]**: Restore the previous rule.
- **Remote Action Blocks [Required]**: `N/A - no remote action proposed`
- **Verification Evidence [Required when state is verified or linked_to_pk_ship]**: `Pass - Focused verification passed for rev-10.`
