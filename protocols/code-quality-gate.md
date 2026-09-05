# Senior Code Quality Gate Protocol

## Purpose
Define the non-negotiable definition-of-done (DoD) and engineering quality bar for all code written, reviewed, or mentored within Better-PromptKit. This protocol acts as a pre-flight checklist before any code is committed, submitted for PR, or marked complete.

---

## The 6 Pillars of Senior Code Quality

```
┌─────────────────────────────────────────────────────────────┐
│                  SENIOR CODE QUALITY GATE                   │
├──────────────┬──────────────┬──────────────┬────────────────┤
│ 1. Type      │ 2. Testing   │ 3. Security  │ 4. Performance │
│    Safety    │    Pyramid   │    Hygiene   │    & Latency   │
├──────────────┼──────────────┼──────────────┼────────────────┤
│ 5. Clean     │ 6. Accessi-  │ 7. Resilience│ 8. Observabi-  │
│    Arch & DX │    bility    │    & Errors  │    lity & Logs │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

---

## Pre-Commit Verification Checklist

### 1. Type Safety & Contract Integrity
- [ ] Zero `any` or loose casting without explicit type guards (`isType`) or Zod/Valibot schema validation.
- [ ] Discriminated unions used for polymorphic states (e.g., `Idle | Loading | Success<T> | Error<E>`).
- [ ] API responses and external inputs validated at boundary layers using runtime schemas.
- [ ] Immutable data structures favored (`readonly`, `as const`, immutable update patterns).

### 2. Testing Pyramid & Test Quality
- [ ] **Unit Tests**: Pure business logic, utilities, state reducers, and domain algorithms tested in isolation with 100% path coverage for edge cases (null, empty, boundary numbers, unexpected types).
- [ ] **Integration Tests**: Database queries, API handlers, service boundaries tested with realistic fixtures or testcontainers.
- [ ] **E2E / Component Tests**: Critical user flows and interaction states verified with tools like Playwright or React Testing Library (testing behavior, not implementation details).
- [ ] Tests are deterministic (no flaky time/race dependencies) and cleanly isolated.

### 3. Security Hygiene & Defense-in-Depth
- [ ] **Injection Prevention**: Parameterized queries / ORM bindings used; zero raw SQL or unescaped HTML string interpolation.
- [ ] **Authentication & Authorization**: Explicit RBAC / ABAC checks on every server endpoint / mutation.
- [ ] **Secrets & Sensitive Data**: Zero hardcoded API keys, tokens, or PII; environment variables validated at startup.
- [ ] **Input Sanitization & Rate Limiting**: All public endpoints bounded by rate limiters and payload size limits.
- [ ] **Zero Data Loss & Safe Migrations**: Database schema modifications follow the Expand-Contract pattern (no single-step destructive drops or truncates); all delete queries are strictly bounded.

### 4. Performance & Efficiency
- [ ] **Frontend**: Zero unnecessary re-renders; proper memoization (`useMemo`, `useCallback`, atomic selectors); images optimized (modern formats, responsive sizes); Core Web Vitals (LCP, INP, CLS) respected.
- [ ] **Backend**: N+1 query problems eliminated via eager loading or dataloaders; database queries indexed; expensive operations cached (Redis/Memory) with explicit TTLs.
- [ ] **Bundle & Memory**: Tree-shaking verified; event listeners, intervals, and WebSocket subscriptions cleaned up on teardown.

### 5. Clean Architecture & Maintainability
- [ ] **Separation of Concerns**: UI components are presentation-focused; business logic resides in hooks/services/domain entities; data fetching resides in query hooks or repository adapters.
- [ ] **DRY vs. WET**: Duplication abstracted only when domain semantics match; premature abstractions avoided.
- [ ] **Self-Documenting Code**: Clear, intent-revealing naming for variables and functions. Comments explain *why*, not *what*.

### 6. Accessibility (a11y) & UX Standards
- [ ] Semantic HTML tags used (`<main>`, `<nav>`, `<article>`, `<button>`, `<dialog>`).
- [ ] Full keyboard navigability (focus states visible, tab traps avoided, escape keys handled).
- [ ] ARIA attributes applied accurately according to WAI-ARIA 1.2 patterns (Radix/Aria primitives preferred).
- [ ] Color contrast meets WCAG 2.2 Level AA (minimum 4.5:1 for normal text).

### 7. Resilience & Error Handling
- [ ] Errors handled gracefully with informative user feedback, not silent failures or cryptic crashes.
- [ ] Network requests and async tasks protected by timeout abort controllers and retry policies with jittered backoff.
- [ ] Error boundaries in place to catch runtime UI failures without crashing the entire app.

### 8. Observability & Telemetry
- [ ] Structured logging used (contextual JSON logs with correlation IDs, not raw `console.log`).
- [ ] Clean instrumentation: All temporary debug probes (`[DEBUG-xxxx]`) verified removed (`git grep "DEBUG-"`).
- [ ] Metrics or audit events dispatched for critical business actions (e.g., checkout, role change, data export).

---

## Protocol Execution in Pair-Programming
Before completing any coding task or finishing a Better-PromptKit session:
1. Run static analyzers (`tsc --noEmit`, `eslint`, `biome check`, or commands in `./PROMPTKIT.md`).
2. Run test suites (`npm test`, `pytest`, `cargo test`, or commands in `./PROMPTKIT.md`).
3. Audit against the checklist above.
4. If any gate fails, address it before declaring the task done.
