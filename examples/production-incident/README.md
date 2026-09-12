# Example: Production Incident and Recovery

A non-project scenario: a background notification worker begins timing out and processing duplicate jobs after a deployment.

This demonstrates that PromptKit OS supports operational engineering, not only new application development.

## Example structure

- [`PROMPTKIT.md`](PROMPTKIT.md) - Incident context and operational guardrails.
- [`docs/STATE.md`](docs/STATE.md) - Synchronized incident-state projection.
- [`docs/specs/remediation.md`](docs/specs/remediation.md) - Remediation specification.
- [`docs/tasks/2026-09-10-task-worker-remediation.md`](docs/tasks/2026-09-10-task-worker-remediation.md) - Canonical Task Record.
- [`docs/adrs/0001-idempotent-notifications.md`](docs/adrs/0001-idempotent-notifications.md) - Remediation decision.
- [`conversations/incident-handoff.md`](conversations/incident-handoff.md) - Incident review and handoff.

## PromptKit focus

- `pk:debug`: Build a reproduction loop and test competing hypotheses.
- `pk:spike`: Compare retry and queue strategies against a baseline.
- `pk:test`: Add a regression test at the real failure seam.
- `pk:retro`: Capture the root cause, decision, and follow-up work.
- `pk:checkpoint`: Preserve incident state for a handoff.
- `pk:ship`: Prepare a reversible remediation release.

## Representative artifacts

- [`docs/rca/2026-09-10-notification-worker.md`](docs/rca/2026-09-10-notification-worker.md) - Incident timeline and root-cause analysis.
- [`docs/releases/remediation-checklist.md`](docs/releases/remediation-checklist.md) - Verification and rollback checklist.
