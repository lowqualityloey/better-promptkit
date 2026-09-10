# RCA: Duplicate Notification Jobs

## Incident summary

After deployment `2026.09.10.1`, notification jobs exceeded their visibility timeout. Retries started before the first attempt completed, producing duplicate sends.

## Investigation

1. Reproduced with a slow provider response and the production timeout configuration.
2. Confirmed overlapping attempts through correlation IDs and queue receipt logs.
3. Ruled out provider duplication because the worker emitted two independent send requests.

## Root cause

The worker timeout was shorter than the provider's documented response window, and the job handler was not idempotent.

## Remediation

- Add an idempotency key to the provider request.
- Extend visibility timeout with bounded heartbeats.
- Add a regression test for slow responses and redelivery.
- Deploy behind a feature flag and monitor duplicate-send rate.
