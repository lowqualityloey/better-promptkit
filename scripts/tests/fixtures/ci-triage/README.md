# CI Triage Validator Fixtures

These fixtures are synthetic and local-only. They contain no provider URLs, real run identifiers, secrets, GitHub CLI calls, retries, deployments, configuration mutations, rollback actions, or release approvals.

- `valid/` is a complete release-candidate handoff with evidence, classification, bounded remediation, one independently confirmed action, successful verification, and `linked_to_pk_ship` release linkage.
- `invalid/` is a compact negative control that skips evidence sufficiency before classification.
- `cases/` contains focused state, action, blocked/resume, required-value, or release-handoff scenarios. The shared `expected/cases.tsv` manifest defines the exact exit code, summary line, and normalized diagnostic prefix expected from both validators.
- The matrix covers independent multiple actions, action epochs and closed declined-action recovery, duplicate action IDs, blank action payloads, pending/declined parent coupling, blocked re-entry skips, pre-remediation leakage, blank required metadata, duplicate release fields, structural anchor failures, and malformed release-side CI/verification links.
- The Bash and PowerShell harnesses run the corresponding native validator, compare the complete normalized diagnostic set and exact summary against the shared manifest, snapshot full-repository hashes plus Git status before and after every case, and preserve the complete-matrix boundary check.

Run the paired harnesses from the repository root:

```text
bash scripts/tests/run-ci-triage-fixtures.sh
pwsh -NoProfile -File .\scripts\tests\run-ci-triage-fixtures.ps1
```

CI triage validation is deterministic, network-free, read-only evidence. It never retrieves provider data, executes a remote action, approves a release, or authorizes deployment or rollback.
