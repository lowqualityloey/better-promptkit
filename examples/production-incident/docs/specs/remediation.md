# Specification: Notification Worker Remediation

## Objective

Stop duplicate notification sends while preserving queue recovery and a reversible release path.

## Acceptance

- Provider requests include stable idempotency keys.
- Visibility timeout and heartbeat behavior cover the provider response window.
- Redelivery and provider timeout tests pass.
- Duplicate-send rate, latency, and error rate are observable.
- A feature flag and rollback procedure are verified before deployment.
