# Technical Design Document (RFC): [Feature / System Name]

- **Author**: [Your Name / Team]
- **Status**: [Draft | In Review | Approved | Implemented]
- **Created**: [YYYY-MM-DD]
- **Target Release**: [Sprint / Milestone]

---

## 1. Executive Summary & Problem Statement
[A 1-2 paragraph high-level overview of what this project accomplishes, why it is necessary, and what value it delivers to users or the engineering team.]

---

## 2. Goals and Explicit Non-Goals

### Goals (In Scope)
- [Goal 1: Measurable outcome, e.g., Implement optimistic workspace membership invitations with email verification]
- [Goal 2: Latency or performance target, e.g., API response time p99 < 120ms]
- [Goal 3: Test coverage threshold, e.g., 90%+ unit test coverage on invitation state machine]

### Non-Goals (Out of Scope)
- [Non-Goal 1: What we are explicitly NOT building in this version, e.g., SAML/SSO enterprise authentication]
- [Non-Goal 2: e.g., Batch CSV user upload (deferred to V2)]

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

### Component Breakdown
| Component | Responsibility | Technologies |
| :--- | :--- | :--- |
| **InvitationService** | Business logic, token generation, expiry verification | TypeScript, Node.js |
| **WorkspaceRepository**| Database queries, transactional member insertions | Prisma / PostgreSQL |
| **InviteModal** | Accessible UI dialog, validation, optimistic feedback | Radix Dialog, Zod, React |

---

## 4. Detailed Design & Contracts

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

### 4.2 API Endpoints / RPC Contracts
```typescript
// Request & Response Schemas
export const SendInviteRequestSchema = z.object({
  workspaceId: z.string().cuid(),
  email: z.string().email(),
  role: z.enum(['ADMIN', 'MEMBER', 'VIEWER']),
});

export const SendInviteResponseSchema = z.object({
  success: z.boolean(),
  invitationId: z.string(),
  expiresAt: z.string().datetime(),
});
```

---

## 5. Security, Privacy & Failure Modes

### Security Considerations
- **Authorization**: Verify requesting user possesses `MANAGE_MEMBERS` permission in the specified workspace before creating invite.
- **Rate Limiting**: Limit invitation dispatches to max 10 requests per user per minute (keyed by `userId` and IP via Redis).
- **Token Entropy**: Tokens generated using cryptographically secure random bytes (`crypto.randomBytes(32)`).

### Failure Modes & Degradation Paths
| Failure Mode | Impact | Recovery Strategy |
| :--- | :--- | :--- |
| **Email Worker Down** | User receives success UI but email delayed | Message retained in durable Redis queue with dead-letter queue (DLQ) retry |
| **Duplicate Invite Sent** | Multiple active tokens for same user | Unique index constraint updates existing token and extends expiry |

---

## 6. Testing Strategy & Verification Plan
- **Unit Tests**: Token generation, expiry validation, and permission checks.
- **Integration Tests**: Full flow of inviting user, accepting token, creating membership row in test database.
- **E2E Tests**: Playwright test simulating user A sending invite and user B clicking link to join workspace.

---

## 7. Phased Rollout & Milestones
- [ ] **Milestone 1**: DB Schema Migration & Repository layer + Unit Tests (PR #1)
- [ ] **Milestone 2**: Core Invitation Service & Server Action Endpoints (PR #2)
- [ ] **Milestone 3**: UI Dialog & Client-side Validation (PR #3)
- [ ] **Milestone 4**: Background Worker & Email Template integration (PR #4)
- [ ] **Milestone 5**: Telemetry, Audit Logs & Production Deployment (PR #5)
