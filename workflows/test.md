# Test Workflow (Testing Strategy, Seam Allocation & Flake Prevention)

## Fast Shorthand
Trigger anytime with: `pk:test` (or `/pk-test`)

## Mission
Guide the developer through designing a comprehensive, cost-effective testing strategy before or during feature development.

Move away from brittle mocks and slow, flaky test suites toward disciplined seam allocation, real-database integration testing, modular test data factories, and deterministic contract verification.

---

## Preconditions
- Developer is planning test coverage for a new feature, refactor, or critical subsystem.
- Target storage directory: `./docs/tests/` in the host project.
- Access to `.promptkit/templates/test-plan-template.md`.

---

## Core Testing Strategy Pillars

### 1. The Modern Testing Pyramid and Seam Allocation
Allocate test effort where it provides the highest confidence per execution millisecond:

```
         ▲
        / \        E2E Tests (Playwright)
       /   \       Top 5-10 critical user flows; real browser.
      /─────\
     /       \     Integration Tests (Vitest / Jest + Real DB)
    /         \    API routes, DB queries, RLS policies, external mocks.
   /───────────\
  /             \  Unit Tests (Vitest / Jest / Pytest)
 /               \ Pure domain logic, state reducers, transforms (<1ms).
─────────────────
```

1. **Unit Tests (Fast, In-Memory, High Density)**:
   - Target: Pure functions, financial/tax math, state reducers, validation parsers, and string algorithms.
   - Constraint: Zero network, filesystem, or database I/O. Must execute in sub-milliseconds.
2. **Integration Tests (The Highest Leverage Seam)**:
   - Target: API route handlers, repository queries, service boundaries, and multi-tenant RLS checks.
   - **Mandatory Real Database**: Run integration tests against a real PostgreSQL instance (via Docker, Testcontainers, or Supabase Local CLI). Never use in-memory SQLite for PostgreSQL code; SQLite ignores row locks, handles JSONB differently, and lacks Row-Level Security.
3. **End-to-End Tests (Lean, High Value)**:
   - Target: The top 5 to 10 golden user journeys (for example: Registration $\rightarrow$ Team Invite $\rightarrow$ Checkout).
   - Constraint: Do not write E2E tests for minor edge cases or input validations; test those in unit or integration suites.

---

### 2. Mocking Boundaries: "Don't Mock What You Own"
Mocking the wrong boundaries creates tests that pass in CI while crashing in production.

- **What You Must NOT Mock**:
  - Do not mock your database, ORM (Prisma, Drizzle), or internal repository classes. If you mock the ORM, your test asserts only that your mock returns what you told it to return, not that your SQL is valid.
- **What You MUST Mock**:
  - External third-party APIs and paid networks outside your process boundary: Stripe, Twilio, SendGrid, AWS S3, OpenAI.
- **How to Mock Externals**:
  - Use **Mock Service Worker (MSW)** at the network level, or encapsulate third-party clients behind typed adapter interfaces and inject in-memory fake adapters during tests.

---

### 3. Test Data Strategy: Modular Factories over Shared Seeds
Shared global seed files (`seed.sql`) create invisible dependencies across tests: editing a user record in seed data to satisfy Test A silently breaks Test B.

1. **Modular Test Data Factories**:
   - Define small factory functions that return valid entities with sensible defaults, allowing individual tests to override only what is load-bearing:
     ```typescript
     // test/factories/user.factory.ts
     export function buildUser(overrides: Partial<User> = {}): User {
       const id = crypto.randomUUID();
       return {
         id,
         email: `user-${id.slice(0, 8)}@example.com`,
         name: 'Test User',
         role: 'MEMBER',
         createdAt: new Date(),
         ...overrides,
       };
     }
     ```
2. **Deterministic Test Isolation**:
   - Ensure every test runs in isolation:
     - **Option A (Tenant Isolation)**: Generate a unique `workspaceId` per test suite so concurrent tests never collide on the same rows.
     - **Option B (Transaction Rollback)**: Wrap each test in a database transaction that rolls back at completion.

---

### 4. Contract Testing
Prevent frontend and backend drift:
- Share TypeScript validation schemas (Zod) between frontend API client hooks and backend route handlers.
- Write automated schema tests verifying that mock server fixtures parse cleanly against client-side response schemas.

---

### 5. Flake Prevention and Determinism
- **Never Use Arbitrary Timeouts**:
  - Replace `await sleep(1000)` with deterministic condition waiting:
    ```typescript
    // BAD
    await new Promise(r => setTimeout(r, 2000));
    expect(button).toBeEnabled();

    // GOOD
    await expect(button).toBeEnabled({ timeout: 3000 });
    ```
- **Freeze Time for Time-Sensitive Tests**:
  - When testing expiration, TTLs, or billing cycles, use fake timers (`vi.useFakeTimers()`) and advance time deterministically (`vi.advanceTimersByTime(86400000)`).
- **Seed Randomness**:
  - If generating randomized fuzz inputs, log the seed so failed runs can be reproduced deterministically.

---

## Workflow Steps

### Step 1: Analyze Feature Risk and Surface Area
1. Identify the core user journey, critical business invariants, and external integrations.
2. Determine where defects would cause data loss, financial impact, or security breach.

### Step 2: Map Test Seams
1. Allocate scenarios across the pyramid:
   - What belongs in Unit? (pure algorithms, validation schemas)
   - What belongs in Integration? (database queries, RLS policies, multi-step services)
   - What belongs in E2E? (happy path browser flow)

### Step 3: Define External Mock Boundaries
1. Identify all third-party dependencies (Stripe, email, S3).
2. Specify MSW handlers or typed fake adapters for each external dependency.

### Step 4: Specify Test Data Factories
1. List required entities and build factory helper signatures.
2. Define boundary fixtures (empty sets, maximum payload sizes, expired tokens).

### Step 5: Establish CI Execution and Coverage Targets
1. Define test execution commands and parallelization strategy.
2. Establish coverage thresholds for core domain business logic.

### Step 6: Generate Test Plan Artifact
1. Use `.promptkit/templates/test-plan-template.md`.
2. Save specification to `./docs/tests/YYYY-MM-DD-test-<feature-name>.md`.

---

## Anti-Patterns to Avoid

| Anti-Pattern | Consequence | Remedy |
| :--- | :--- | :--- |
| **Mocking the Database** | Tests pass while queries fail on syntax, nullability, or foreign keys in production. | Run integration tests against real PostgreSQL via Docker or Testcontainers. |
| **Monolithic Shared Seeds** | Modifying seed data to fix one test breaks dozens of unrelated tests. | Use modular factory functions (`buildUser()`) with per-test overrides. |
| **E2E Over-Testing** | 45-minute CI runs, frequent flaky timeouts, and developer frustration. | Restrict E2E tests to the top 5-10 golden user flows; test edge cases in integration suites. |
| **Arbitrary Sleep Delays** | Slow test execution and intermittent timing flakes under CI load. | Use polling assertions (`waitFor`, `expect(locator).toBeVisible()`). |
| **Testing Implementation Details** | Tests break on internal refactorings even when public behavior is unchanged. | Assert on public outputs, returned responses, and database state. |

---

## Completion Criteria
- Comprehensive test plan generated in `./docs/tests/`.
- Scenarios allocated across Unit, Integration, and E2E seams.
- Real-database harness configured for integration tests.
- External mock boundaries and test data factories documented.
