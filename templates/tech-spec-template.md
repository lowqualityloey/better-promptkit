# Technical Design Document (RFC): [Feature / System Name]

- **Author**: [Your Name / Team]
- **Status**: [Draft | In Review | Approved | Implemented]
- **Created**: [YYYY-MM-DD]
- **Target Release**: [Sprint / Milestone]

---

## Planning Record (PromptKit Adaptation)

> **Use this section for Controlled Work only.** Trivial Work keeps the existing fast path and does not require a Planning Record or Assumption Record. This section is the canonical planning location; do not create a parallel `docs/plans/` artifact.

### Planning Record Metadata

- **Planning Record ID [Required]**: `PLAN-<spec-slug>`
- **Planning Depth [Required]**: `Minimal | Full`
- **Owner [Required]**: [Person, role, or team]
- **Record Status [Required]**: `draft | ready | blocked | superseded`
- **Local Task Record Link [Required for Controlled Work]**: [Relative link to `docs/tasks/<task-id>.md`]
- **Workflow Links [Optional]**: [Links to `pk:plan`, `pk:tasks`, or affected workflow records]

### Planning Inputs

- **Requested Outcome [Required]**: [What observable result is requested?]
- **Observable Completion Condition [Required]**: [What will show that the outcome is complete?]
- **Scope Boundary [Required]**: [Files, behaviors, interfaces, or components in scope and excluded]

### Minimal Planning

When **Planning Depth** is `Minimal`, the three Planning Inputs above are the only required planning questions. They seed the Local Task Record but do not satisfy its full readiness contract. Full-only fields below are `N/A - Minimal depth` when genuinely not required in this planning record; the Local Task Record still requires explicit non-goals, dependencies, owner/approval boundary, verification, and execution-policy values.

### Full Planning

Select `Full` when work affects a public or external contract, persistent data or schema, authentication or authorization, an external integration, release configuration or release risk, multiple Behavioral Components, serious safety/rollback/data-loss risk, or an explicitly requested architecture plan. A lightweight request cannot override these triggers.

- **Explicit Non-Goals [Required in Full; Not applicable in Minimal]**: [What is deliberately excluded?]
- **Affected Behavioral Components [Required in Full; Not applicable in Minimal]**: [Screens, APIs, jobs, commands, libraries, data areas, or deployment behaviors]
- **Externally Visible Contracts [Required in Full; Not applicable in Minimal]**: [APIs, data formats, commands, integrations, or user-visible behavior; write `None` if not applicable]
- **Failure or Rollback Considerations [Required in Full; Not applicable in Minimal]**: [Failure modes, data-loss risk, rollback or recovery considerations]
- **Verification Approach [Required in Full; Not applicable in Minimal]**: [How the design and implementation will be verified]

After Full inputs are recorded, continue through the existing architecture, contracts, migration, FMEA, milestone, and grilling sections below. Do not repeat those workflow sections in this Planning Record.

### Assumption Records

If a required planning input is unanswered, record an owned provisional assumption before handing inputs to `pk:tasks`. If no unanswered required input exists, write `None` instead of leaving this section blank. An Assumption Record is not a confirmed decision and remains in this Planning Record; it does not create a second authority.

For each assumption:

- **Assumption ID [Required]**: `ASSUMPTION-<spec-slug>-<nnn>`
- **Unanswered Decision [Required]**: [What must be decided?]
- **Provisional Answer [Required]**: [Current working answer]
- **Impact if Wrong [Required]**: [What could change or be harmed?]
- **Validation Action [Required]**: [How and when will this be checked?]
- **Decision Owner [Required]**: [Named person or role]
- **Status [Required]**: `open | validated | accepted | rejected | superseded`
- **Supporting Evidence [Optional]**: [Link or `None`]
- **Resolution Evidence [Not applicable until resolved]**: [Link or `N/A - unresolved`]

Do not repeat a completed planning question unless scope changes, an assumption is invalidated, or new evidence changes the decision. Record the changed scope, assumption, or evidence when asking it again.

---

## 1. Executive Summary & Problem Statement
[A 1-2 paragraph high-level overview of what this project accomplishes, who it is for, why it is necessary now, and the primary business/engineering outcome it delivers.]

---

## 2. Goals and Explicit Non-Goals

### Goals (In Scope)
- [Goal 1: Measurable outcome, e.g., Implement optimistic workspace membership invitations with email verification]
- [Goal 2: Performance SLA, e.g., API response time p99 < 120ms under 500 req/sec]
- [Goal 3: Reliability target, e.g., Zero downtime deployment with zero unhandled promise rejections]

### Non-Goals (Explicit Scope Boundary)
- [Non-Goal 1: What we are deliberately NOT building in this version, e.g., SAML/SSO enterprise authentication]
- [Non-Goal 2: What is deferred to V2, e.g., Bulk CSV user upload]

---

## 3. Architecture & System Context

### High-Level Architecture Diagram
```text
┌──────────────┐       HTTPS        ┌────────────────┐       SQL        ┌──────────────────┐
│ Client (Web) ├───────────────────►│ Next.js API    ├─────────────────►│ PostgreSQL (DB) │
└──────────────┘                    │ (Server Action)│                  └──────────────────┘
                                    └───────┬────────┘
                                            │ Dispatches
                                            ▼
                                    ┌────────────────┐       Async      ┌──────────────────┐
                                    │ Event Queue    ├─────────────────►│ Transactional    │
                                    │ (Redis / SQS)  │                  │ Email Worker     │
                                    └────────────────┘                  └──────────────────┘
```

### Deep Module Decomposition & Seams
> *Deletion Test: Does this module concentrate complexity, or merely scatter it? Ensure interfaces are deep (simple interface, powerful internal logic).*

| Module / Seam | Public Interface / Boundary | Internal Complexity Hidden |
| :--- | :--- | :--- |
| **InvitationEngine** | `createInvite()`, `claimToken()` | State transitions, cryptographic token generation, rate-limit check, TTL calculation |
| **MembershipStore** | `saveInvitation()`, `atomicPromote()` | Row locking, transaction atomicity, multi-tenant isolation |
| **InviteModal** | `<InviteDialog onInvite={...} />` | Accessible Radix dialog, Zod client validation, optimistic state |

---

## 4. Detailed Design & Contracts First

### 4.1 Data Models & Schemas
```prisma
// Example Schema Definition
model WorkspaceInvitation {
  id          String   @id @default(cuid())
  email       String
  workspaceId String
  role        Role     @default(MEMBER)
  token       String   @unique
  expiresAt   DateTime
  createdAt   DateTime @default(now())
  workspace   Workspace @relation(fields: [workspaceId], references: [id], onDelete: Cascade)

  @@index([email, workspaceId])
  @@index([token])
}
```

### 4.2 Zero-Downtime Migration Plan (Expand-Contract)
If modifying existing schemas or columns, describe the zero-downtime lifecycle:
1. **Phase 1 (Expand)**: Add new column as nullable; write to both old and new columns.
2. **Phase 2 (Backfill & Read Switch)**: Backfill historical records via background job; switch application read queries to new column.
3. **Phase 3 (Contract)**: Stop writes to old column; drop old column in subsequent deployment after verification.
- **Rollback Plan (RPO/RTO)**: [How to revert safely if the migration fails during deployment]

### 4.3 API Endpoints & Zod Contracts
```typescript
export const SendInviteRequestSchema = z.object({
  workspaceId: z.string().cuid(),
  email: z.string().email(),
  role: z.enum(['ADMIN', 'MEMBER', 'VIEWER']),
});
export type SendInviteRequest = z.infer<typeof SendInviteRequestSchema>;

export const SendInviteResponseSchema = z.object({
  success: z.boolean(),
  invitationId: z.string(),
  expiresAt: z.string().datetime(),
});
export type SendInviteResponse = z.infer<typeof SendInviteResponseSchema>;
```

---

## 5. Security, Privacy & Failure Modes (FMEA)

### Security & Multi-Tenancy Audit
- **Tenancy Boundary**: How do we guarantee Tenant A cannot read or mutate Tenant B's data?
- **Authentication & RBAC**: Required permissions to invoke this endpoint (`MANAGE_MEMBERS`).
- **Input Sanitization**: Runtime validation schemas (Zod) on all inputs; parameterized database queries.
- **Secrets & PII**: Ensure email addresses and tokens are omitted from public client payloads and unredacted logs.

### FMEA Resilience Matrix
| Failure Scenario | Probability / Severity | Detection Method | Mitigation / Fallback | Recovery Strategy |
| :--- | :--- | :--- | :--- | :--- |
| **Email Worker Down** | Medium / High | Queue lag alert | Retain in durable queue with DLQ | Exponential backoff retry |
| **Duplicate Invite Sent** | High / Low | Unique index constraint | Upsert: refresh token & extend TTL | Return existing invite status |
| **Rate Limit Exceeded** | Low / Medium | HTTP 429 response count | Client toast warning with retry timer | User retries after cooldown |

---

## 6. Phased Implementation Milestones (TDD Red-Green-Refactor)

- [ ] **Milestone 1 (Contracts & Seams - RED)**:
  - Add schema migration (Expand phase).
  - Define Zod schemas and TypeScript domain contracts.
  - Write failing integration tests asserting public contract behavior. (PR #1)
- [ ] **Milestone 2 (Core Domain Engine - GREEN)**:
  - Implement business logic, repository methods, and state machines to satisfy tests.
  - Verify all red tests turn green. (PR #2)
- [ ] **Milestone 3 (Presentation & Client Integration)**:
  - Implement UI dialogs, keyboard navigation, focus management, and loading/error states.
  - Audit against WCAG 2.2 AA accessibility. (PR #3)
- [ ] **Milestone 4 (Hardening, Telemetry & Contract Phase)**:
  - Structured logs, APM alerts, synthetic monitors.
  - Complete Contract phase of database migration (drop obsolete fields). (PR #4)

---

## 7. Sign-off & Grilling Checklist
- [ ] Architecture challenged via `pk:grill`.
- [ ] Zero-downtime database evolution verified.
- [ ] Non-goals agreed upon with stakeholders.
- [ ] Ready for Milestone 1 execution.
