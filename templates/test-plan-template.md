# Test Plan Specification: [Feature / Subsystem Name]

- **Author**: [Your Name / Team]
- **Status**: [Draft | In Review | Approved | Implemented]
- **Created**: [YYYY-MM-DD]
- **Test Frameworks**: [Vitest / Playwright / Jest / Testcontainers]

---

## 1. Feature Risk Assessment & Critical Invariants

| Risk / Invariant Description | Severity | Target Test Seam | Protection Mechanism |
| :--- | :--- | :--- | :--- |
| **Multi-tenant data isolation leak** | Critical | Integration | Real PostgreSQL RLS query test |
| **Concurrent seat over-allocation** | High | Integration | Concurrent requests asserting row lock |
| **Token expiration date calculation** | Medium | Unit | Vitest with fake timers (`useFakeTimers`) |
| **Complete user signup and onboarding**| High | E2E | Playwright browser journey |

---

## 2. Test Seam Allocation Matrix

### Unit Tests (Pure Logic, <1ms execution)
| Test Target | File / Function | Scenarios Tested |
| :--- | :--- | :--- |
| `calculateProration()` | `src/lib/billing.ts` | Leap years, mid-month upgrades, downgrades, zero-dollar plans |
| `InviteFormSchema` | `src/schemas/invite.ts`| Invalid email domains, missing roles, edge whitespace |
| `workspaceReducer()` | `src/state/workspace.ts`| Optimistic member insertion, rollback on rejection |

### Integration Tests (Real Database, API Seam)
*Harness: PostgreSQL via Docker / Testcontainers / Local Supabase CLI*
| Test Target | Endpoint / Service | Scenarios Tested |
| :--- | :--- | :--- |
| `POST /api/v1/invitations` | Invitation API Route | Valid invite creates DB row and dispatches email event |
| `POST /api/v1/invitations` | Invitation API Route | Duplicate invite returns 409 Conflict with error envelope |
| RLS Query Isolation | Document Repository | User from Workspace A cannot read rows from Workspace B |
| Mutation Idempotency | Payment Webhook Handler | Replaying same `Idempotency-Key` does not charge customer twice |

### End-to-End Tests (Playwright Browser Flows)
| Journey Name | File Path | User Steps & Assertions |
| :--- | :--- | :--- |
| `e2e/invite-flow.spec.ts` | User signs in, opens invite modal, enters colleague email, submits form, verifies pending badge in member table. |

---

## 3. External Mock Boundaries

*Rule: Never mock internal database or ORM; mock only external networks.*

| External Service | Mocking Mechanism | Scope / File | Behavior Simulated |
| :--- | :--- | :--- | :--- |
| **Stripe API** | MSW (Mock Service Worker) | `tests/mocks/stripe.ts` | Successful checkout session, declined card error |
| **Resend / SendGrid**| In-memory Fake Adapter | `tests/fakes/mailer.ts` | Intercepts sent emails in array for assertions |
| **AWS S3** | LocalStack / MSW | `tests/mocks/s3.ts` | Pre-signed upload URL generation |

---

## 4. Test Data Factories

```typescript
// tests/factories/workspace.factory.ts
export function buildWorkspace(overrides: Partial<Workspace> = {}): Workspace {
  const id = crypto.randomUUID();
  return {
    id,
    name: `Workspace ${id.slice(0, 6)}`,
    slug: `ws-${id.slice(0, 8)}`,
    tier: 'FREE',
    createdAt: new Date(),
    ...overrides,
  };
}
```

---

## 5. Anti-Flakiness & Timing Checklist
- [ ] Zero arbitrary `sleep()` or `setTimeout()` calls in test suites.
- [ ] Time-dependent tests use `vi.useFakeTimers()`.
- [ ] Database tests use isolated tenant IDs or per-test transaction rollbacks.
- [ ] E2E tests use locator assertions (`expect(locator).toBeVisible()`) with automatic retry polling.

---

## 6. CI Pipeline & Coverage Targets
- **Unit & Integration Suite Execution**: `pnpm test:run` (Target runtime: < 30 seconds)
- **E2E Suite Execution**: `pnpm test:e2e` (Target runtime: < 2 minutes)
- **Core Domain Coverage Target**: [e.g., 90%+ path coverage on billing and auth state machines]
