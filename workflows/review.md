# Review Workflow (Two-Axis Senior Code & Architecture Review)

## Fast Shorthand
Trigger anytime with: `pk:review` (or `/pk-review`)

## Mission
Conduct a thorough, multi-dimensional Senior/Staff Software Engineer review on uncommitted changes, branches, or PR diffs.

Review across **two orthogonal axes**:
1. **Spec Fidelity**: Does the change faithfully implement what the issue, PR, or user spec requested without scope creep or missed constraints?
2. **Standards & Code Quality**: Does the change adhere to documented project standards, Martin Fowler's code smell baseline, OWASP security, performance, accessibility, and zero accidental data loss?

---

## Why Two Axes?
A pull request can fail in two completely distinct ways:
- **Standards Pass, Spec Fail**: Code conforms to all lint rules, architectural patterns, and type constraints, but implements the wrong business behavior or omits critical edge cases.
- **Spec Pass, Standards Fail**: Code implements every requested feature, but introduces code smells, security vulnerabilities, or performance regressions.

Reporting them separately ensures neither axis masks the other.

---

## Mandatory Pre-Flight Guardrails

### 1. Diff Baseline Pinning
Establish and validate the diff comparison baseline before reviewing:
```bash
git rev-parse <fixed-point>                    # Confirm reference exists (e.g. main, origin/main, HEAD~3)
git diff <fixed-point>...HEAD                  # Extract three-dot comparison against merge-base
git log <fixed-point>..HEAD --oneline          # Inspect commit history
```
If the diff is empty or the reference fails to resolve, halt and resolve the baseline before continuing.

### 2. Accidental Data Loss Audit (STOP AND VERIFY)
> [!CAUTION]
> **MANDATORY BLOCKING AUDIT**: Review every migration, script, and database call for irreversible data loss.
>
> Any finding matching the following criteria is automatically flagged as **🚨 [BLOCKING]**:
> - **Destructive Migrations**: `DROP TABLE`, `DROP COLUMN`, `TRUNCATE`, or destructive type alterations without a backward-compatible, multi-phase migration strategy (Expand-Contract Pattern).
> - **Unbounded Deletions**: SQL `DELETE` without a strict `WHERE` clause, or bulk cascade deletions missing soft-delete flags.
> - **Filesystem & Cloud Storage Destruction**: Un-versioned object deletions (`rm -rf`, bucket purge scripts) without backup confirmation.
> - **Hard Resets**: In-code process automation running destructive Git resets or database purges.

---

## Review Severity Framework

```
┌─────────────────────────────────────────────────────────────┐
│                 REVIEW COMMENT SEVERITY TIERS               │
├───────────────┬─────────────────────────────────────────────┤
│ 🚨 [BLOCKING]  │ Data loss risk, security vulnerability,     │
│               │ broken spec contract, race condition, or    │
│               │ broken build/test. Must be fixed before PR. │
├───────────────┼─────────────────────────────────────────────┤
│ ⚠️ [IMPORTANT]│ Performance degradation, missing error case,│
│               │ poor test coverage, code smell, or a11y bug.│
├───────────────┼─────────────────────────────────────────────┤
│ 💡 [SUGGEST]  │ Architectural elegance, idiomatic refactor, │
│               │ DX improvement, or naming clarity.          │
├───────────────┼─────────────────────────────────────────────┤
│ 👏 [PRAISE]   │ Clean pattern, great test, or clever design. │
└───────────────┴─────────────────────────────────────────────┘
```

---

## Evaluation Axes

### Axis 1: Spec Fidelity Review
Review the diff against the originating specification, issue description, or PR requirements:
- [ ] **Missing Requirements**: What requirements did the spec ask for that are omitted or only partially implemented?
- [ ] **Scope Creep**: Does the diff include unasked-for behavior, speculative abstractions, or unrelated changes?
- [ ] **Flawed Implementations**: Which requirements look implemented on the surface, but fail boundary conditions, error flows, or business rules?

---

### Axis 2: Standards & Code Quality Review

Audit the diff against documented project standards (`PROMPTKIT.md`, `CODING_STANDARDS.md`), plus the universal **Martin Fowler Code Smell Baseline**:

#### Martin Fowler Code Smell Baseline
1. **Mysterious Name**: Variable, function, or class name obscures intent.  
   $\rightarrow$ *Remedy*: Rename to reveal the domain concept or responsibility.
2. **Duplicated Code**: Identical or near-identical logic appears across multiple hunks.  
   $\rightarrow$ *Remedy*: Extract a shared pure function, hook, or utility.
3. **Feature Envy**: A function or method reaches into another object's fields more than its own.  
   $\rightarrow$ *Remedy*: Move the method onto the object owning the data.
4. **Data Clumps**: The same 3-4 fields or parameters continually travel together.  
   $\rightarrow$ *Remedy*: Bundle them into a dedicated type, struct, or interface.
5. **Primitive Obsession**: Raw strings or numbers representing domain concepts (e.g., currency, status, ID).  
   $\rightarrow$ *Remedy*: Introduce branded types, enums, or value objects.
6. **Repeated Switches**: The same `switch` or `if/else` chain on a type or status appears in multiple files.  
   $\rightarrow$ *Remedy*: Replace with polymorphism or a centralized lookup map.
7. **Shotgun Surgery**: A single logical business change requires edits scattered across many unrelated files.  
   $\rightarrow$ *Remedy*: Re-group and co-locate cohesive modules.
8. **Divergent Change**: One file is frequently modified for multiple unrelated business reasons.  
   $\rightarrow$ *Remedy*: Split the module along single-responsibility boundaries.
9. **Speculative Generality**: Generic hooks, config flags, or abstractions added for unrequested future needs.  
   $\rightarrow$ *Remedy*: Delete unused abstractions and inline the code (YAGNI).
10. **Message Chains**: Deep dereferencing walks (`a.getB().getC().getD()`).  
    $\rightarrow$ *Remedy*: Apply the Law of Demeter; encapsulate the walk behind a root method.
11. **Middle Man**: A class or helper that does nothing except delegate to another module.  
    $\rightarrow$ *Remedy*: Remove the middleman; call the target module directly.
12. **Refused Bequest**: A subclass or implementation that ignores or overrides most inherited behavior.  
    $\rightarrow$ *Remedy*: Replace inheritance with composition.

#### The 6 Core Technical Pillars
- **Architecture & Cohesion**: Single responsibility, clean module boundaries, minimal coupling.
- **Correctness & Concurrency**: Async race protection (`AbortController`), unhandled promise rejection safety, atomic state updates.
- **Security & Safety**: Runtime schema validation (Zod), parameterized queries (SQL injection immunity), sanitized HTML (XSS prevention), secret/PII redaction.
- **Performance & Resources**: Eliminated N+1 queries, indexed lookups, memoized expensive computations, teardown of event listeners/timers/subscriptions.
- **Accessibility (a11y) & UX**: WCAG 2.2 AA compliance, semantic HTML (`<button>`, `<main>`, `<nav>`), keyboard navigation, clear focus rings, ARIA labels.
- **Testing & Observability**: Tests asserting observable behavior at the real seam, failure-mode test cases, structured logging with correlation IDs.

---

## Review Report Output Format

```markdown
# Senior Code Review: <PR Title or Feature Name>

## Executive Summary
- **Overall Verdict**: [Approved | Changes Requested | Discussion Required]
- **Fixed Point Baseline**: `git diff <base>...HEAD` (<N> files changed, +<X> / -<Y>)
- **Spec Fidelity**: [Clean Match | Scope Creep Detected | Missing Requirements]
- **Technical Standards**: [High Quality | Minor Code Smells | Blocking Issues Found]

---

## Axis 1: Spec Fidelity
*(Review against originating issue / technical specification)*

### Missing / Partial Requirements
- **`docs/specs/feature-x.md:L42`**: Missing rate-limiting fallback on tier downgrade.
  - *Detail*: Spec mandates a 429 response with `Retry-After`, but current implementation silently drops the request.

### Scope Creep / Unrequested Behavior
- None detected.

### Implementation Discrepancies
- **`src/services/billing.ts:L88`**: Discount calculation applies before tax instead of after.

---

## Axis 2: Standards & Code Quality
*(Review against project standards, OWASP, Fowler smells, and data safety)*

### 🚨 [BLOCKING]
- **`prisma/migrations/20260906_drop_user_column/migration.sql:L3`**: Irreversible column drop.
  - *Risk*: `DROP COLUMN phone_number` without an Expand-Contract transition will break rolling zero-downtime deployments.
  - *Required Fix*: Retain column as nullable/deprecated until next major deployment.

### ⚠️ [IMPORTANT]
- **`src/hooks/useProjectFilter.ts:L34`**: [Repeated Switches / Race Condition]
  - *Finding*: Filter triggers asynchronous fetch without an `AbortController`. Rapid filter clicks cause stale resolution.
  - *Remedy*: Pass `signal` to fetch client.

### 💡 [SUGGEST]
- **`src/components/UserBadge.tsx:L12`**: [Primitive Obsession]
  - *Finding*: Role passed as raw string `string`.
  - *Remedy*: Use `UserRole` enum or branded union type.

### 👏 [PRAISE]
- **`src/lib/auth/token.ts:L55`**: Flawless timing-safe buffer comparison preventing timing attacks.

---

## Socratic Debrief & Next Steps
1. Guide the author on resolving `🚨 [BLOCKING]` items first.
2. Confirm all fixes pass the Quality Gate in `.promptkit/protocols/code-quality-gate.md`.
```

---

## Completion Criteria
- Dual-axis evaluation completed (Spec Fidelity vs. Technical Standards).
- Zero unaddressed `🚨 [BLOCKING]` data loss or security issues.
- All code smells linked to actionable refactoring remedies.
- Verification tests pass against `.promptkit/protocols/code-quality-gate.md`.
