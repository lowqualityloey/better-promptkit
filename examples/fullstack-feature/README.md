# End-to-End Feature Reference: Organization Invitations

This directory demonstrates a real-world, production-grade feature developed using PromptKit OS's engineering operating system.

It models an enterprise SaaS feature (**Organization Member Invitations with RBAC & Expiry**) across every lifecycle phase:
1. **Spec & Acceptance Criteria** (`docs/specs/organization-invitations.md`)
2. **Expand-Contract Database Migration** (`docs/data/organization-invitations-migration.md`)
3. **8-State Tactile UI Component Tokens** (`docs/design/invitation-modal-tokens.md`)
4. **Verification & Test Evidence Matrix** (`docs/tests/invitation-verification-evidence.md`)
5. **Staff-Level PR Specification** (`pull-request-evidence.md`)

---

## Lifecycle Phase Mapping

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        PROMPTKIT OS LIFECYCLE                           │
├─────────────────────────────────────────────────────────────────────────┤
│ 1. pk:plan   ──► docs/specs/organization-invitations.md                 │
│ 2. pk:data   ──► docs/data/organization-invitations-migration.md        │
│ 3. pk:design ──► docs/design/invitation-modal-tokens.md                 │
│ 4. pk:verify ──► docs/tests/invitation-verification-evidence.md         │
│ 5. pk:pr     ──► pull-request-evidence.md (PR Template)                 │
└─────────────────────────────────────────────────────────────────────────┘
```

### 1. Specification (`docs/specs/organization-invitations.md`)
- **Domain Model**: `Invitation`, `OrganizationMember`, `User`, `Role` (Owner, Admin, Member, Billing).
- **Gherkin Scenarios**:
  - `Scenario: Admin invites a new user with Member role`
  - `Scenario: Non-admin attempt rejected with 403 Forbidden`
  - `Scenario: Duplicate pending invitation throttled with idempotent 200 OK`
  - `Scenario: Expired invitation (7 days) fails redemption with 410 Gone`
- **Security & Threat Model**: Rate limiting (10 invites / min / org), cryptographically secure tokens (`crypto.randomBytes(32)`), tenant isolation invariants.

### 2. Expand-Contract Database Migration (`docs/data/organization-invitations-migration.md`)
- Demonstrates zero-downtime database evolution:
  - **Phase 1 (Expand)**: Add `organization_invitations` table with composite index `(org_id, email)` and partial unique index on pending tokens.
  - **Phase 2 (Dual-Write)**: Application writes new invitations and checks validity.
  - **Phase 3 (Contract)**: Prune obsolete legacy invite columns after 14-day observation window.

### 3. Tactile UI Component Tokens (`docs/design/invitation-modal-tokens.md`)
- Adheres to the anti-slop **5% Signal Rule**, engineered matte paper ground, and ruler-drawn hairlines over blur.
- Implements the **Mandatory 8-State Interactive Contract**:
  1. `default`: Crisp 1px border (`oklch(90% 0.018 75)`).
  2. `hover`: Ground lift, no cartoon bounce.
  3. `:focus-visible`: 2px offset ring in signal cobalt (`oklch(52% 0.22 250)`).
  4. `:active`: Slight inset press.
  5. `disabled`: Reduced opacity (0.45), non-clickable cursor.
  6. `loading`: Spinner with `aria-busy="true"` and label preserved for screen readers.
  7. `error`: Explicit inline error announcement with `role="alert"`.
  8. `success`: Dismiss animation with transient confirmation toast.

### 4. Verification Evidence Matrix (`docs/tests/invitation-verification-evidence.md`)
- Concrete test outputs proving all Gherkin criteria pass:
  - Unit tests: 100% path coverage on token expiration and hash verification.
  - Integration tests: Multi-tenant database boundary verification.
  - E2E tests: Playwright keyboard navigation and focus-trap modal tests.

### 5. Pull Request Evidence (`pull-request-evidence.md`)
- Demonstrates staff-level PR description populated with verifiable data, zero hand-waving, and safety guarantees.
