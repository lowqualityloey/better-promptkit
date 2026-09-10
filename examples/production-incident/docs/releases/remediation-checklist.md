# Notification Worker Remediation Checklist

- [ ] Regression test fails before the fix and passes after it.
- [ ] Idempotency behavior is verified with duplicate deliveries.
- [ ] Queue timeout and heartbeat metrics are visible.
- [ ] Feature flag and rollback command are documented.
- [ ] Error rate, latency, and duplicate-send rate are monitored after release.
- [ ] `pk:checkpoint` records the handoff state and next decision.
