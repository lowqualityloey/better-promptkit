# Project Profile: Notification Worker Incident

## Context

A background worker delivers email and push notifications through a queue and external provider.

## Active commands

```bash
npm test -- worker
npm run typecheck
npm run lint
npm run release:verify
```

## Incident guardrails

- Preserve evidence before changing production behavior.
- Use correlation IDs for every job attempt.
- Remediation must be reversible and feature-flagged.
- Never retry non-idempotent provider calls without a deduplication key.
- Record owner, next action, and rollback conditions at every handoff.
