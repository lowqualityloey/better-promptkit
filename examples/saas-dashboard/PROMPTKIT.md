# Project Profile: WorkHub Analytics (B2B SaaS Dashboard)

**Project Type**: Multi-tenant B2B Analytics SaaS  
**Status**: Active Development (v0.8.0 → v1.0.0)  
**Team Size**: 3 engineers  
**Last Updated**: 2026-09-08

---

## 1. Project Overview

**Domain**: B2B team analytics and productivity insights  
**Target Users**: Product managers, team leads, and executives tracking project health  
**Core Value**: Real-time workspace analytics with customizable dashboards

### Key Features
- Multi-tenant workspace isolation with team invitations
- Real-time collaborative dashboards
- Role-based access control (Owner, Admin, Member, Viewer)
- Export to PDF and CSV
- Webhook integrations for Slack/Teams

---

## 2. Technology Stack

### Frontend
- **Framework**: Next.js 15.0.1 (App Router, React Server Components)
- **Language**: TypeScript 5.6 (strict mode enabled)
- **Styling**: Tailwind CSS v4 + CSS custom properties
- **UI Components**: Radix UI primitives + custom design system
- **State Management**: TanStack Query v5 (server cache) + Zustand (client state)
- **Forms**: React Hook Form + Zod validation
- **Testing**: Vitest (unit) + Playwright (E2E)

### Backend
- **Runtime**: Node.js 20 LTS
- **Database**: PostgreSQL 16 with Row-Level Security (RLS)
- **ORM**: Drizzle ORM 0.33
- **Auth**: Supabase Auth (magic link + OAuth)
- **API**: tRPC v11 + Next.js Server Actions
- **Cache**: Redis 7 (session store + query cache)

### Infrastructure
- **Hosting**: Vercel (frontend + edge functions)
- **Database**: Supabase (managed PostgreSQL)
- **CI/CD**: GitHub Actions
- **Monitoring**: Sentry + Vercel Analytics

---

## 3. Monorepo Structure & Workspace Topology

This is a **Turborepo pnpm monorepo** with the following workspace packages:

```
workhub/
├── apps/
│   ├── web/                    # Next.js frontend (@workhub/web)
│   └── docs/                   # Documentation site (@workhub/docs)
├── packages/
│   ├── ui/                     # Shared React components (@workhub/ui)
│   ├── db/                     # Drizzle schema & migrations (@workhub/db)
│   ├── api/                    # tRPC routers & procedures (@workhub/api)
│   ├── auth/                   # Auth utilities & session mgmt (@workhub/auth)
│   ├── config/                 # Shared configs (tsconfig, eslint) (@workhub/config)
│   └── types/                  # Shared TypeScript types (@workhub/types)
└── tooling/
    ├── eslint/                 # ESLint configurations
    └── typescript/             # TypeScript configurations
```

### Package Import Boundaries (Non-Negotiable)
1. **UI Layer** (`@workhub/ui`) MUST NOT import from `@workhub/db` or `@workhub/api`
2. **Database Layer** (`@workhub/db`) MUST NOT import from `@workhub/ui` or framework code
3. **Auth Layer** (`@workhub/auth`) may only import from `@workhub/types` and `@workhub/db`
4. **API Layer** (`@workhub/api`) may import from `@workhub/db`, `@workhub/auth`, `@workhub/types`

---

## 4. Active Commands

All commands are workspace-scoped using Turborepo filters.

### Development
```bash
# Start all development servers
pnpm dev

# Start specific workspace
pnpm --filter @workhub/web dev
pnpm --filter @workhub/docs dev
```

### Testing & Quality
```bash
# Run the full monorepo test suite
pnpm test

# Run tests for specific workspace
pnpm --filter @workhub/web test
pnpm --filter @workhub/api test

# Run E2E tests (requires running dev server)
pnpm --filter @workhub/web test:e2e

# Type checking (workspace-scoped)
pnpm --filter @workhub/web typecheck
pnpm --filter @workhub/api typecheck

# Linting
pnpm lint
pnpm --filter @workhub/web lint

# Format check
pnpm format:check
```

### Database
```bash
# Generate migration from schema changes
pnpm --filter @workhub/db db:generate

# Push schema to database (dev only)
pnpm --filter @workhub/db db:push

# Apply migrations
pnpm --filter @workhub/db db:migrate

# Open Drizzle Studio
pnpm --filter @workhub/db db:studio
```

### Build & Deploy
```bash
# Build all apps and packages
pnpm build

# Build specific workspace
pnpm --filter @workhub/web build

# Verify production build works
pnpm --filter @workhub/web start
```

---

## 5. Non-Negotiable Guardrails

### Type Safety
- ✅ Zero `any` types without explicit runtime validation (Zod schemas)
- ✅ All API responses validated with `zod` at runtime boundaries
- ✅ Discriminated unions for all polymorphic state (loading, success, error)
- ✅ `strict: true` in all tsconfig.json files

### Database & Data Integrity
- ✅ All tables use UUIDv7 primary keys for time-ordered distributed IDs
- ✅ All foreign keys have explicit `ON DELETE` behavior (CASCADE or RESTRICT)
- ✅ Row-Level Security (RLS) policies enforce multi-tenant isolation
- ✅ Database migrations follow Expand-Contract pattern (zero-downtime)
- ✅ All `DELETE` queries MUST have bounded `WHERE` clauses
- ✅ Soft deletes for user-generated content (add `deleted_at` timestamp)

### Authentication & Security
- ✅ Sessions stored in HttpOnly, Secure, SameSite=Lax cookies (never localStorage)
- ✅ All tRPC procedures and Server Actions enforce auth checks
- ✅ RBAC capability matrix enforced at API layer, not UI layer
- ✅ Secrets managed via environment variables with runtime validation (Zod)
- ✅ User input sanitized against XSS (use `dangerouslySetInnerHTML` only with DOMPurify)

### Frontend Standards
- ✅ Server Components by default; Client Components only when interactive
- ✅ No business logic in React components (extract to hooks or services)
- ✅ All forms use React Hook Form + Zod validation
- ✅ Optimistic UI updates for mutations (TanStack Query)
- ✅ Loading states use Suspense boundaries + skeleton loaders
- ✅ Error boundaries catch runtime errors gracefully

### Accessibility (WCAG 2.2 AA)
- ✅ Semantic HTML tags (`<main>`, `<nav>`, `<article>`, `<button>`)
- ✅ Full keyboard navigation (focus visible, no keyboard traps)
- ✅ Color contrast ratio ≥ 4.5:1 for normal text
- ✅ Touch targets ≥ 44×44px on mobile
- ✅ ARIA attributes on custom interactive elements (prefer Radix primitives)

### Performance
- ✅ Core Web Vitals targets: LCP < 2.5s, INP < 200ms, CLS < 0.1
- ✅ Database queries indexed on filter/join columns
- ✅ N+1 queries eliminated (use Drizzle `.with()` relations)
- ✅ Images optimized with Next.js `<Image>` component
- ✅ Bundle analyzed; dynamic imports for heavy dependencies

### Testing
- ✅ Unit tests for business logic (pure functions, utilities)
- ✅ Integration tests for API routes and database queries
- ✅ E2E tests for critical user flows (signup, workspace creation, dashboard)
- ✅ Tests do NOT mock away the actual failure surface

### Git & Commits
- ✅ Atomic commits following Conventional Commits format
- ✅ No secrets committed (pre-commit hook scans for `.env` patterns)
- ✅ Feature branches merge to `main` via squash merge after PR approval

---

## 6. Project Artifact Output Paths

All Better-PromptKit generated artifacts are saved to:

- **Technical Specs**: `docs/specs/`
- **ADRs**: `docs/adrs/`
- **Task Breakdowns**: `docs/tasks/`
- **Data Models**: `docs/data/`
- **Auth Specs**: `docs/auth/`
- **API Contracts**: `docs/api/`
- **Test Plans**: `docs/tests/`
- **Performance Audits**: `docs/perf/`
- **RCA Post-Mortems**: `docs/rca/`
- **Design Specs**: `docs/design/`
- **Spikes**: `docs/spikes/`
- **Release Checklists**: `docs/releases/`
- **State Tracker**: `docs/STATE.md`

---

## 7. Environment Variables

Runtime environment validation enforced via `@t3-oss/env-nextjs`:

```typescript
// Required at build time
DATABASE_URL              // PostgreSQL connection string
NEXT_PUBLIC_SUPABASE_URL  // Supabase project URL
NEXT_PUBLIC_SUPABASE_ANON_KEY

// Required at runtime
SUPABASE_SERVICE_ROLE_KEY // Server-side admin key
REDIS_URL                  // Redis connection string
SENTRY_DSN                 // Error tracking
```

Server will refuse to start if any required variable is missing or malformed.

---

## 8. Known Constraints & Limitations

- Vercel free tier limits: 100GB bandwidth/month, 100 serverless invocations/day
- Supabase free tier: 500MB database storage, 2GB bandwidth/month
- Redis cache TTL set to 5 minutes (balance freshness vs. cost)
- File uploads limited to 5MB per file (Vercel function payload limit)
- Real-time updates use polling (WebSockets deferred to v2.0)

---

## 9. Contact & Escalation

- **Tech Lead**: @alice (architecture decisions, database design)
- **Frontend Lead**: @bob (UI/UX, accessibility)
- **DevOps**: @charlie (CI/CD, infrastructure, monitoring)
