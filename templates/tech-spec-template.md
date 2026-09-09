# Technical Design Document (RFC): [Feature / System Name]

- **Author**: [Your Name / Team]
- **Status**: [Draft | In Review | Approved | Implemented]
- **Created**: [YYYY-MM-DD]
- **Target Release**: [Sprint / Milestone]

---

## Planning Record (PromptKit Adaptation)

<!-- Replace the example anchor with the immutable planning ID, for example: <a id="PLAN-checkout"></a> -->
<a id="PLAN-spec-slug"></a>

> **Use this section for Controlled Work only.** Trivial Work keeps the existing fast path and does not require a Planning Record or Assumption Record. This section is the canonical planning location; do not create a parallel `docs/plans/` artifact.

### Planning Record Metadata

- **Planning Record ID [Required]**: `PLAN-<spec-slug>`
- **Planning Depth [Required]**: `Minimal | Full`
- **Owner [Required]**: [Person, role, or team]
- **Record Status [Required]**: `draft | ready | blocked | superseded`
- **Local Task Record Link [Required for Controlled Work]**: `[TASK-<task-slug>](../tasks/<task-id>.md#TASK-<task-slug>)`
- **Workflow Links [Optional]**: `[workflow anchor links]`

### Planning Inputs

- **Requested Outcome [Required]**: [What observable result is requested?]
- **Observable Completion Condition [Required]**: [What will show that the outcome is complete?]
- **Scope Boundary [Required]**: [Files, behaviors, interfaces, or components in scope and excluded]
- **TDD Enforcement Proposal (Reference Only) [Optional]**: `disabled | enabled | None`; this proposal cannot activate TDD. The canonical Local Task Record owns `TDD Enforcement Mode`, and an absent Task Record field defaults to `disabled`.

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

For each assumption, expose the exact immutable ID as an anchor immediately before the assumption heading or record block, for example `<a id="ASSUMPTION-checkout-001"></a>`:

- **Assumption ID [Required]**: `ASSUMPTION-<spec-slug>-<nnn>`
- **Unanswered Decision [Required]**: [What must be decided?]
- **Provisional Answer [Required]**: [Current working answer]
- **Impact if Wrong [Required]**: [What could change or be harmed?]
- **Validation Action [Required]**: [How and when will this be checked?]
- **Decision Owner [Required]**: [Named person or role]
- **Status [Required]**: `open | validated | accepted | rejected | superseded`
- **Supporting Evidence [Optional]**: `[<stable-id>](<relative-path>#<stable-id>)` or `None`
- **Resolution Evidence [Not applicable until resolved]**: `[<stable-id>](<relative-path>#<stable-id>)` or `N/A - unresolved`

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

## 6. Conditional Implementation Milestones

The canonical Local Task Record owns `TDD Enforcement Mode: disabled | enabled`; an absent field defaults to `disabled`. This technical specification may propose a mode, but the proposal is reference-only. If the proposal or test plan disagrees with the Task Record, readiness is blocked until reconciled, and the Task Record controls execution.

### Code Work with TDD Enforcement Mode `enabled`

Use the Red -> Green -> Refactor sequence. Every behavior keeps the same `BEHAVIOR-<task-slug>-<nnn>` identity from the test-plan intent through Task Record execution evidence.

- [ ] **Milestone 1 - Red: Contracts and Seams**:
  - Define schema, API, domain, or interface contracts and the observable behavior.
  - Record the expected failing assertion and runnable Red command in the test plan.
- [ ] **Milestone 2 - Green: Smallest Satisfying Implementation**:
  - Implement the minimum code that satisfies the recorded Red behavior.
  - Record Green results without changing the Behavior ID or acceptance meaning.
- [ ] **Milestone 3 - Refactor: Hardening and Verification**:
  - Improve structure, presentation, telemetry, migration safety, and test quality without changing the behavior contract.
  - Record Refactor results, acceptance, review, and final verification evidence.

### Code Work with TDD Enforcement Mode `disabled`

Use normal dependency-ordered milestones. Include contracts or seams, implementation, presentation or integration as applicable, hardening, acceptance criteria, test strategy, review, and verification. Do not require Red, Green, or Refactor evidence when the Task Record mode is disabled.

### Documentation, Configuration, or Research Work

Use an exception verification path with explicit acceptance, evidence, review, and verification. TDD execution fields are `N/A - <reason>` when this work type does not have Code Work behavior to exercise.

### Sign-off Readiness

The selected milestone branch, Task Record link, test-plan reference, acceptance criteria, review path, and verification condition are recorded before implementation. A proposal or test-plan intent never authorizes implementation by itself.

---

## 7. Sign-off & Grilling Checklist
- [ ] Architecture challenged via `pk:grill`.
- [ ] Zero-downtime database evolution verified.
- [ ] Non-goals agreed upon with stakeholders.
- [ ] Ready for the selected Task Record milestone path: enabled TDD, disabled Code Work, or an exception verification path.
