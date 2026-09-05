# Plan Workflow (Spec-Driven Architecture & Feature Planning)

## Fast Shorthand
Trigger anytime with: `pk:plan` (or `/pk-plan`)

## Mission
Guide the developer through **Spec-Driven Development (SDDD)** and robust architectural planning before writing production code. Transform ambiguous product or technical requirements into clear technical specifications, system design blueprints, interface contracts, failure mode analyses, and phased implementation milestones.

---

## The Spec-Driven Engineering Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│                SPEC-DRIVEN ARCHITECTURE PLAN                │
├──────────────────────────────┬──────────────────────────────┤
│ 1. Problem & Non-Goals       │ 2. System Context & Flow     │
│    Scope boundary & context  │    Data flow & sequence      │
├──────────────────────────────┼──────────────────────────────┤
│ 3. Data Contracts & Schemas  │ 4. Failure Modes & Security  │
│    Types, tables, endpoints  │    Threats, edge cases, TTLs │
├──────────────────────────────┼──────────────────────────────┤
│ 5. Phased Milestones         │ 6. Verification Strategy     │
│    Incremental PR breakdown  │    Test coverage & metrics   │
└──────────────────────────────┴──────────────────────────────┘
```

---

## Preconditions
- Developer has a new feature, refactor, architectural migration, or complex task to plan.
- Access to `.promptkit/templates/tech-spec-template.md`.
- `.promptkit/protocols/context-sync.md` executed to verify existing tech stack, `./PROMPTKIT.md`, and conventions.

---

## Workflow Steps

### Step 1: Define Problem Statement, Requirements & Non-Goals
1. **User / Business Problem**: What problem does this solve, who is it for, and why now?
2. **Explicit Non-Goals**: What is deliberately out of scope for this version? (Prevents scope creep).
3. **Success Metrics / KPIs**: How do we measure success? (e.g., latency < 200ms, zero data loss, 99.9% uptime, Lighthouse score > 95).

### Step 2: System Architecture & Data Flow Design
1. Map out the high-level architecture:
   - Identify which services, packages, or feature directories will be created or modified.
   - Diagram the request/response lifecycle and data pipeline (Client -> Gateway -> Service -> Storage -> Event Bus).
2. Establish State Boundaries:
   - Where is state owned? (Server database, Redis session, URL search params, local client state, TanStack Query cache).
   - How is stale state invalidated or synchronized?

### Step 3: Define Domain Models & API Contracts First
Draft type definitions and API contracts before touching implementation code:
1. **Data Entities & Database Schemas**:
   - Primary keys, foreign keys, indexes, nullable constraints.
2. **API / Endpoint Specifications**:
   - HTTP methods, routes, request payload schemas, response status codes, error payloads.
   - TypeScript interface definitions / Zod schemas.
   - Example:
     ```typescript
     export const CreateWorkspaceSchema = z.object({
       name: z.string().min(3).max(50),
       slug: z.string().regex(/^[a-z0-9-]+$/),
       tier: z.enum(['free', 'pro', 'enterprise']),
     });
     export type CreateWorkspaceInput = z.infer<typeof CreateWorkspaceSchema>;
     ```

### Step 4: Threat Modeling, Edge Cases & Failure Recovery
Analyze how the system can fail and design defensive mechanisms:
1. **Security & Authorization**:
   - Who is authorized to perform this operation? How is tenancy isolated?
   - Input sanitization, CSRF/XSS protection, rate limiting.
2. **Resilience & Fault Tolerance**:
   - What if a third-party API or downstream database is slow or down?
   - Timeout budgets, retry policies, fallback degradation paths.
3. **Concurrency & Race Conditions**:
   - Can two identical requests arrive simultaneously? (Idempotency keys, database transaction locks, optimistic concurrency).

### Step 5: Phased Implementation Milestones
Break down the implementation into bite-sized, independently testable pull requests (PRs):
- **Phase 1 (Foundation)**: Domain models, database migrations, repository layer, unit tests.
- **Phase 2 (Core Business Logic)**: Service layer, API endpoints/Server Actions, integration tests.
- **Phase 3 (UI & Integration)**: Presentation components, hooks, accessibility audits, loading & error states.
- **Phase 4 (Hardening & Observability)**: Structured logging, telemetry metrics, E2E tests, load verification.

### Step 6: Generate Technical Specification Artifact
1. Use `.promptkit/templates/tech-spec-template.md` to scaffold a complete RFC document in `./docs/specs/YYYY-MM-DD-spec-<feature-name>.md` (or path configured in `PROMPTKIT.md`).
2. Review the plan with the developer and refine based on feedback.

---

## Completion Criteria
- Comprehensive technical spec document drafted and approved in `./docs/specs/`.
- API contracts and schemas defined upfront.
- Failure modes, security, and edge cases accounted for.
- Clear, phased implementation tasks ready for execution.
