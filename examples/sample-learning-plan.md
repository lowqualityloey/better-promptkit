# Sample Engineering Learning Plan & Roadmap

> **Note**: This is a real-world reference learning plan preserved from a production project (`Shelf`). Use this as a quality standard for structuring your own learning plans in `notes/learning-plan.md`.

---

## 1. High-Priority Focus Areas (Current Sprint / Week)
- [ ] **Architecture & Design**: Master Clean/Hexagonal boundaries and isolate domain logic from framework coupling.
- [ ] **Type Safety & Schemas**: Implement end-to-end runtime validation with strict Zod/Valibot schemas and discriminated unions.
- [ ] **Modern UI/UX & a11y**: Build WCAG 2.2 AA compliant composite primitives using Radix UI and Tailwind CSS v4.
- [ ] **Performance & Observability**: Eliminate N+1 query patterns and instrument structured OpenTelemetry tracing.

---

## 2. Active Projects & Practice Katas
- [x] **Project / Feature**: Shelf: scaffold PostgreSQL schema (`users`, `books`, `user_books`) with Drizzle ORM and build `/api/library` CRUD REST endpoints (`GET`, `POST`, `PATCH`, `DELETE`). (Issue #6).
- [x] **Project / Feature**: Shelf: configure client-side Supabase Auth client, session provider, encapsulated AuthGuard, and apiFetch Bearer token helper (Issue #11).
- [x] **Project / Feature**: Shelf: configure TanStack Router file-based routing, root layout, pathless authenticated shell, and dynamic route parameter validation (Issue #12).
- [x] **Project / Feature**: Shelf: build debounced Open Library search hook (useBookSearch) with derived state, payload mapping, and AbortController (Issue #13).
- [ ] **Senior Stretch Goal**: Enforce 1-5 star range on `rating` with a DB `CHECK` constraint, and add `notNull`/`default` discipline across `user_books`.
- [ ] **Consolidation Drill**: Re-implement the 3-table schema from memory (no docs) and re-derive the composite-PK rationale in one paragraph.

---

## 3. Deep-Dive Questions for My AI Mentor
1. *How does PostgreSQL optimize composite B-tree indexes compared to individual single-column indexes on high-cardinality filters?*
2. *What are the failure modes of optimistic UI updates during network partitioning, and how should client-side state reconcile without flashing stale data?*
3. *What are the architectural trade-offs between Event Sourcing and Traditional CRUD with Change Data Capture (CDC)?*

---

## 4. Key Takeaways & Mental Model Breakthroughs
- **Date: 2026-08-27 | Topic: Database schema design for a many-to-many domain (Drizzle ORM)**
  - *Core Insight*: Tables are split by "who owns the fact": shared reference data (`books`) vs personal layer (`user_books`). A join table's composite primary key `(userId, bookId)` enforces uniqueness at the database level, which is immune to the check-then-insert race condition that API-level checks can't prevent.
  - *Actionable Takeaway*: Enforce invariants (PK, FK, unique, check) in the database, not the app. Drizzle maps TS camelCase properties to snake_case DB columns via `pgTable`, uses `pgEnum` for enumerated columns, and exposes table-level constraints through the third-argument `extraConfig` callback.

---

## 5. Engineering Milestones & Evidence Checkpoints
- **Target Date: [YYYY-MM-DD]**: Deploy production-ready authentication flow with rate limiting and automated integration tests.
  - *Evidence of Mastery*: Full Playwright test suite passing + PR review checklist verified with zero blocking issues.
- **Target Date: [YYYY-MM-DD]**: Publish first Architectural Decision Record (ADR) detailing database schema normalization vs. caching strategy.
  - *Evidence of Mastery*: Documented ADR accepted in `./docs/adrs/`.
