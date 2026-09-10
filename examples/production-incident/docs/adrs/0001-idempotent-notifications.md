# ADR 0001: Idempotent Notification Delivery

- **Status**: Accepted
- **Date**: 2026-09-10

## Decision

Generate a stable idempotency key from the notification event and pass it to the provider on every retry. Persist delivery state before acknowledging the queue message.

## Rationale

Queue redelivery is normal. Making the provider operation idempotent fixes the failure at the actual side-effect boundary instead of relying on timing assumptions.

## Consequence

Delivery state requires retention and reconciliation, and provider support for idempotency must be monitored.
