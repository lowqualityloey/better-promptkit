# Notification Worker Incident - Project State

- **Current Milestone**: Remediation and release
- **Status**: ACTIVE
- **Last Updated**: 2026-09-10

> This is a synchronized incident projection. The canonical task is [`docs/tasks/2026-09-10-task-worker-remediation.md`](tasks/2026-09-10-task-worker-remediation.md).

## Incident tasks

- [x] Reproduce duplicate sends
- [x] Identify timeout and idempotency gap
- [/] Add remediation and regression coverage
- [ ] Deploy behind feature flag
- [ ] Verify recovery metrics and close incident

## Locked invariants

1. A provider request has a stable notification idempotency key.
2. Queue redelivery is expected and safe.
3. Rollback remains available until duplicate-send rate is stable.
