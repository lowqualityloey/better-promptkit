# Production Release Checklist: [Version / Release Name]

- **Release Version / Tag**: `v[X.Y.Z]`
- **Deploy Lead**: [Your Name / Team]
- **Target Environment**: [Production / Staging]
- **Release Date**: [YYYY-MM-DD HH:MM UTC]
- **Commit SHA**: `[commit-hash]`

---

## 1. Pre-Flight Verification

- [ ] All code merged to `main` with approved PR review (`pk:review`).
- [ ] All automated tests passing in CI (`pnpm test`, `pnpm test:e2e`).
- [ ] Build succeeds with zero bundle size alerts (`pnpm build`).
- [ ] Git tag created and pushed: `git tag -a vX.Y.Z -m "..." && git push origin vX.Y.Z`.

---

## 2. Environment Variables & Secrets Audit

| Variable Name | Required Scope | Verified in Prod Dashboard | Validated via `env.ts` |
| :--- | :--- | :---: | :---: |
| `DATABASE_URL` | Server Only | [ ] | [ ] |
| `SESSION_SECRET` | Server Only | [ ] | [ ] |
| `STRIPE_SECRET_KEY` | Server Only | [ ] | [ ] |
| `NEXT_PUBLIC_APP_URL` | Public Client | [ ] | [ ] |

---

## 3. Database Migration Sequencing

- **Migration Present**: [Yes / No]
- **Migration Type**: [Expand Phase (Additive) | Contract Phase (Cleanup) | None]

### Sequencing Execution Plan
1. [ ] **Step 1**: [Run migrations before deploy / Deploy code first]
   - Command: `pnpm db:migrate:deploy`
2. [ ] **Step 2**: Trigger application code deployment.
3. [ ] **Step 3**: Verify active application pods report healthy status.

---

## 4. Post-Deployment Smoke Testing

| Probe Target | Verification Command / URL | Expected Output | Actual Result |
| :--- | :--- | :--- | :--- |
| **System Health** | `GET /api/health` | `HTTP 200 { "status": "ok" }` | Pass / Fail |
| **Authentication Flow** | Synthetic login test | Session cookie set and redirected | Pass / Fail |
| **Critical User Flow** | [e.g., Create invitation or checkout] | Resource persisted in DB | Pass / Fail |
| **Client Bundle Check** | Production URL in incognito | Zero unhandled browser console errors| Pass / Fail |

---

## 5. Post-Release Observation Window (15 Minutes)

- [ ] Sentry / error tracking inspected: zero new unhandled exception spikes.
- [ ] P99 latency within baseline thresholds (< 250ms).
- [ ] Database connection pool utilization healthy (< 60%).

---

## 6. Rollback Runbook (In Event of Incident)

- **Application Rollback Command / Action**:
  - [e.g., Redeploy previous deployment ID via platform CLI / Vercel dashboard / git checkout]
- **Database Action**:
  - [e.g., Schema is in Expand phase and fully backwards-compatible; no database rollback required]
- **Sign-off**:
  - Release Status: [Successful | Rolled Back | Investigating]
  - Notes: [Any follow-up items or technical debt to track]
