# Plan Workflow (Spec-Driven Architecture & Feature Planning)

## Fast Shorthand
Trigger anytime with: `pk:plan` (or `/pk-plan`)

## Mission
Guide the developer through **Spec-Driven Development (SDD)**, robust architectural planning, and zero-downtime system design before writing production code.

Transform ambiguous product or technical requirements into clear technical specifications, deep modular architectures, strict interface contracts, empirical failure mode analyses (FMEA), zero-downtime database evolution plans, and test-first (TDD) implementation milestones.

---

## Architectural Principles to Enforce

### 1. Deep Modules vs. Shallow Wrappers
- **Deep Modules**: The best abstractions provide substantial functionality behind a clean, deceptively simple interface (e.g., standard file I/O, garbage collectors, or a cohesive domain engine).
- **Avoid Shallow Pass-Throughs**: Beware of controllers that simply call a service that simply calls a repository with identical method signatures. This scatters complexity without adding leverage.
- **The Deletion Test**: Before creating an abstraction, ask:
  > *"If we delete this module, does it concentrate complexity into a single coherent place, or does it merely move boilerplate around?"* If it just moves it, inline it.
- **The Interface is the Test Surface**: Design seams where tests can assert real business outcomes through public APIs rather than brittle private mocks.

### 2. Zero-Downtime Schema Evolution (Expand-Contract Pattern)
> [!CAUTION]
> **Accidental Data Loss & Downtime Prevention**: Never plan destructive migrations (`DROP COLUMN`, `DROP TABLE`, table renames) as single instantaneous changes.
>
> All schema modifications must plan for the **Expand-Contract (Parallel Run)** lifecycle:
> 1. **Expand**: Add new columns/tables as nullable or with defaults. Dual-write to old and new schemas.
> 2. **Backfill & Read**: Migrate historical records in asynchronous batches; switch application read paths to the new schema.
> 3. **Contract**: Remove dual-write logic; deprecate and safely drop old columns only after zero running services reference them.

---

## The Spec-Driven Engineering Lifecycle

```
┌──────────────────────────────────────────────────────────────────┐
│                   SPEC-DRIVEN ARCHITECTURE PLAN                  │
├──────────────────────────────────┬───────────────────────────────┤
│ 1. Problem & Non-Goals           │ 2. System Context & Flow      │
│    Scope boundary, metrics, YAGNI│    Deep modules, test surfaces│
├──────────────────────────────────┼───────────────────────────────┤
│ 3. Data Contracts & Evolution    │ 4. FMEA Failure Analysis      │
│    Types, Expand-Contract schema │    Threats, race guards, DLQs │
├──────────────────────────────────┼───────────────────────────────┤
│ 5. TDD Phased Milestones         │ 6. Spec Artifact & Grilling   │
│    Red-Green-Refactor PR breakdown│   docs/specs/ + pk:grill prep │
└──────────────────────────────────┴───────────────────────────────┘
```

---

## Workflow Steps

### Step 1: Define Problem Statement, Metrics & Explicit Non-Goals
1. **User & Business Problem**: What exact friction or capability does this address, for whom, and why now?
2. **Explicit Non-Goals (Scope Boundary)**:
   - What is deliberately excluded from this version?
   - Prevent scope creep by writing down what we are explicitly *not* building.
3. **Measurable Success Metrics / SLAs**:
   - Define concrete targets (e.g., p99 latency < 150ms, zero data loss, 99.9% uptime, Lighthouse score > 95, bundle size delta < 5kB).

### Step 2: System Context & Deep Module Architecture
1. **Map the System Context**:
   - Diagram request/response lifecycles and event flows:
     `Client -> Edge Gateway -> Core Domain Engine -> Storage / Message Queue`
2. **Identify Deep Modules & Seams**:
   - Group cohesive business logic together. Avoid splitting code across too many layers unless each layer provides distinct transformative value.
   - Define clear architectural seams that enable testing without network or filesystem mocking.
3. **State Ownership & Invalidation**:
   - Where is state owned? (Database of record, Redis distributed cache, client cache, URL search params).
   - How is state invalidated or reconciled across concurrent writers?

### Step 3: Define Domain Models & Expand-Contract Evolution
1. **Domain Models & API Contracts First**:
   - Write TypeScript interfaces, Zod validation schemas, or Protocol Buffers before writing implementation code.
   - Specify request parameters, response bodies, and explicit error status codes.
2. **Database Schema & Migration Plan**:
   - Define tables, foreign keys, constraints, and query indexes upfront.
   - For changes to existing data, specify the **Expand-Contract** stages and rollback plan (RPO/RTO).

### Step 4: Threat Modeling & Failure Mode and Effects Analysis (FMEA)
Analyze system failure modes systematically before coding:

1. **Security & Authorization Audit**:
   - Multi-tenant data isolation: How do we guarantee Tenant A cannot access Tenant B's data?
   - Input validation: Runtime schema boundaries (Zod/Valibot) for all external inputs.
   - Rate limiting, CSRF protection, and secret/PII redaction.
2. **FMEA Matrix (Resilience & Degradation)**:
   | Failure Scenario | Probability / Severity | Detection Method | Mitigation / Fallback | Recovery Strategy |
   | :--- | :--- | :--- | :--- | :--- |
   | Downstream Service Timeout | Medium / High | APM 5xx alert | Circuit breaker + cached response | Exponential backoff retry |
   | Concurrent Double-Submit | High / Medium | Unique constraint violation | Client idempotency key + row lock | Return existing transaction status |
   | Cache Cluster Eviction | Low / High | Cache miss rate spike | Degraded fallback to DB replica | Throttled cache repopulation |

### Step 5: Phased Implementation Milestones (TDD Breakdown)
Decompose the implementation into bite-sized, independently reviewable PRs following **Test-Driven Development (Red-Green-Refactor)**:

- **Milestone 1 (Contracts & Seams - RED)**:
  - Add database schema migrations (Expand phase).
  - Define API contracts and schemas.
  - Write automated failing integration tests asserting expected behavior against the interface.
- **Milestone 2 (Core Domain Engine - GREEN)**:
  - Implement business logic, repository methods, and state machines to satisfy the tests.
  - Verify all red tests transition to green.
- **Milestone 3 (Presentation & Client Integration)**:
  - UI components, form validation, accessible design tokens (WCAG 2.2 AA), loading/error boundaries.
- **Milestone 4 (Hardening, Telemetry & Contract Phase)**:
  - Structured logging with correlation IDs, alerting dashboards, E2E user flows.
  - Finalize the Contract phase of schema migration (remove deprecated legacy fields).

### Step 6: Generate Technical Specification & Grilling Pre-Flight
1. Scaffold the RFC document using `.promptkit/templates/tech-spec-template.md`.
2. Save to `./docs/specs/YYYY-MM-DD-spec-<feature-name>.md` (or directory configured in `PROMPTKIT.md`).
3. **Pre-Implementation Grilling**:
   - Before writing code, challenge the design using `pk:grill` to stress-test failure edge cases, scaling limits, and architectural assumptions.

---

## Completion Criteria
- Technical specification documented and approved in `./docs/specs/`.
- Deep module boundaries and test surfaces clearly mapped.
- Zero-downtime Expand-Contract migration plan detailed for all database changes.
- FMEA failure modes and mitigation fallbacks explicitly documented.
- Phased implementation broken down into test-first (TDD) milestones.
