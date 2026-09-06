# Ship Workflow (Release Engineering, Migration Sequencing & Rollback Protocols)

## Fast Shorthand
Trigger anytime with: `pk:ship` (or `/pk-ship`)

## Mission
Guide the developer through safe, reliable production releases, deployment sequencing, and verification.

Eliminate production deployment outages: missing or invalid environment variables at runtime, race conditions between database migrations and application code deployments, unverified releases, and panicked rollbacks.

---

## Preconditions
- Code has passed code review (`pk:review`) and testing gates (`pk:test`).
- Target storage directory: `./docs/releases/` in the host project.
- Access to `.promptkit/templates/release-checklist.md`.

---

## Core Release Engineering Pillars

### 1. Runtime Environment Variable Validation (Fail-Fast Boot)
Never allow an application with missing or malformed secrets to boot into production:

1. **Type-Safe Schema Validation at Startup**:
   - Validate `process.env` using Zod or `@t3-oss/env-nextjs` inside an `env.ts` configuration module imported at the application entrypoint:
     ```typescript
     // src/env.ts
     import { z } from 'zod';

     const serverEnvSchema = z.object({
       NODE_ENV: z.enum(['development', 'test', 'production']),
       DATABASE_URL: z.string().url(),
       SESSION_SECRET: z.string().min(32),
       STRIPE_SECRET_KEY: z.string().startsWith('sk_'),
     });

     const clientEnvSchema = z.object({
       NEXT_PUBLIC_APP_URL: z.string().url(),
     });

     export const env = {
       ...serverEnvSchema.parse(process.env),
       ...clientEnvSchema.parse(process.env),
     };
     ```
2. **Fail-Fast Crash**:
   - If a required secret is missing, the application process crashes immediately during initialization with an explicit error naming the missing variable. It must never fail hours later during an active user transaction.
3. **Client vs Server Boundary**:
   - Never prefix server secrets with `NEXT_PUBLIC_` or `VITE_`.
   - Audit client bundle outputs to verify zero server secret leakage.

---

### 2. Zero-Downtime Migration Sequencing
Database schema changes and application code updates do not deploy at the exact same instant. Follow the **Golden Deployment Rule**:

```
EXPAND PHASE (Additive Changes):
Step 1: Apply backwards-compatible database migration (new nullable columns/tables).
Step 2: Deploy new application code (writes to both old and new columns).
Result: Zero downtime. Both old and new application instances function concurrently.

CONTRACT PHASE (Destructive Cleanups):
Step 1: Deploy application code that completely stops reading/writing old column.
Step 2: Verify all old containers/pods are terminated and zero traffic references old schema.
Step 3: Apply database migration to drop deprecated column or table.
Result: Zero downtime. No running instance queries a deleted column.
```

- **Hard Rule**: Never combine an additive change (Expand) and a destructive drop (Contract) in the same release or migration script.

---

### 3. Staging and Preview Environment Parity
1. **Ephemeral Preview Deployments**:
   - Verify features in preview environments (Vercel previews, Supabase database branch, Railway staging) before merging to `main`.
2. **Data Sanitization**:
   - Non-production environments must use synthetic seed fixtures.
   - Never replicate unmasked production customer PII or payment records into staging environments.

---

### 4. Release Pre-Flight and Automated Smoke Testing
Before declaring a release complete, verify production behavior with active probes:

1. **Pre-Flight Sanity Check**:
   - Clean git tag generated: `vX.Y.Z`.
   - CI pipeline passed: lint, type-check, unit tests, integration tests.
   - Build artifact size verified (check for bundle size regressions).
2. **Automated Smoke Test Verification**:
   - Immediately after traffic shifts to the new release, run automated synthetic probes:
     - **Health Check**: `GET /api/health` returns `200 OK` with database ping latency.
     - **Critical Path Probe**: Synthetic test user authenticates, loads dashboard, and performs a read.
     - **Edge Cache Invalidation**: Verify stale CDN assets are purged.

---

### 5. Instant Rollback Protocol
When production metrics degrade post-release, do not guess or attempt complex live debugging in production. Follow the structured rollback protocol:

#### Rollback Decision Criteria
Trigger an immediate rollback if within 15 minutes of deployment:
- HTTP 5xx error rate spikes above 1%.
- P99 latency degrades by more than 50% from baseline.
- Core checkout, authentication, or data persistence flows fail in smoke tests.

#### Execution Runbook
1. **Application Code Rollback**:
   - Redeploy the previous verified commit SHA or platform deployment immediately (1-click rollback in Vercel, Railway, or Kubernetes).
2. **Database Reversion**:
   - Because all pre-deploy migrations follow the Expand phase, the database schema remains 100% compatible with the previous application version. **Do not roll back database schema during an active incident** unless the migration itself degraded database performance.
3. **Transition to Root Cause Analysis**:
   - After production stability is restored, trigger `pk:debug` in local development to reproduce the failure.

---

## Workflow Steps

### Step 1: Pre-Release Verification
1. Confirm all code passed review (`pk:review`) and quality gates (`pk:test`).
2. Verify that all required environment variables are provisioned in the production dashboard.

### Step 2: Determine Migration Sequencing
1. Check if the release contains database migrations:
   - If Expand phase: Execute migrations *before* deploying application code.
   - If Contract phase: Verify application code is deployed and verified *before* executing cleanup migrations.

### Step 3: Trigger Production Deployment
1. Create a version tag (`git tag -a vX.Y.Z -m "Release message"`).
2. Push to production deployment pipeline.

### Step 4: Execute Post-Deploy Smoke Testing
1. Run automated health check endpoints and inspect deployment logs.
2. Manually or synthetically verify the primary user journey in production.

### Step 5: Monitor and Sign-off
1. Monitor error tracking (Sentry / Datadog / CloudWatch) for 15 minutes post-deploy.
2. Complete and commit the release record to `./docs/releases/`.

---

## Anti-Patterns to Avoid

| Anti-Pattern | Consequence | Remedy |
| :--- | :--- | :--- |
| **Unvalidated Environment Variables** | Silent crashes hours after deploy when missing secrets are first accessed. | Validate all environment variables with Zod at application startup. |
| **Deploying Code and Migration Simultaneously** | Container start races against migration execution, causing broken queries during rolling update. | Follow the Golden Deployment Rule (Expand before deploy; Contract after deploy). |
| **Debugging Live in Production** | Extended customer downtime while developers scramble under pressure. | Roll back immediately; debug safely in local development using `pk:debug`. |
| **Untested Rollbacks** | Rollback fails because new schema broke backwards compatibility with old code. | Ensure every schema migration is backwards-compatible with previous application version. |
| **Skipping Smoke Tests** | Broken client bundles or routing errors discovered by customers instead of engineers. | Run automated smoke tests immediately post-deployment. |

---

## Completion Criteria
- Environment variables validated with startup schema checks.
- Migration sequencing planned and executed in correct phase order.
- Post-deployment smoke tests executed and passed.
- Release document saved to `./docs/releases/`.
