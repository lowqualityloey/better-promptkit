# Review Workflow (Senior Code & Architecture Review)

## Fast Shorthand
Trigger anytime with: `pk:review` (or `/pk-review`)

## Mission
Conduct a thorough, multi-dimensional Senior/Staff Software Engineer code and architecture review on uncommitted changes, branches, or PR diffs. Provide constructive, high-leverage feedback categorized by severity, ensuring code meets production-grade standards for security, performance, accessibility, resilience, and maintainability.

---

## Review Severity Framework

```
┌─────────────────────────────────────────────────────────────┐
│                 REVIEW COMMENT SEVERITY TIERS               │
├───────────────┬─────────────────────────────────────────────┤
│ 🚨 [BLOCKING]  │ Security vulnerability, data loss risk, race │
│               │ condition, memory leak, or broken contract. │
├───────────────┼─────────────────────────────────────────────┤
│ ⚠️ [IMPORTANT]│ Performance degradation, missing error case,│
│               │ poor test coverage, or a11y violation.      │
├───────────────┼─────────────────────────────────────────────┤
│ 💡 [SUGGEST]  │ Architectural elegance, idiomatic refactor, │
│               │ DX improvement, or naming clarity.          │
├───────────────┼─────────────────────────────────────────────┤
│ 👏 [PRAISE]   │ Clean pattern, great test, or clever design. │
└───────────────┴─────────────────────────────────────────────┘
```

---

## Preconditions
- Uncommitted code changes (`git diff`), a branch comparison, or specific files are ready for review.
- Access to `.promptkit/templates/code-review-checklist.md` and `.promptkit/protocols/code-quality-gate.md`.
- Active project rules in `./PROMPTKIT.md` (if present) are reviewed for non-negotiable standards.

---

## Workflow Steps

### Step 1: Ingest Diffs & Understand Intent
1. Run `git status` and `git diff` on the target files or commits.
2. Identify the intent of the change:
   - What feature is being added, bug fixed, or subsystem refactored?
   - What are the acceptance criteria?

### Step 2: Multi-Dimensional Evaluation

Evaluate the code across the 6 Senior Review Pillars:

#### 1. Architecture & Design
- Is there a clear separation of concerns (Presentation vs. Domain Logic vs. Data Access)?
- Does the code introduce unnecessary coupling or leaky abstractions?
- Are single responsibility and dependency inversion principles respected?

#### 2. Correctness, Concurrency & Edge Cases
- Are null, undefined, empty array, and boundary values handled defensively?
- Are async operations protected against race conditions, out-of-order responses, and unhandled promise rejections?
- Are database transactions properly scoped and atomic?

#### 3. Security & Safety (OWASP Audit)
- Is all user input validated with strict runtime schemas (e.g., Zod)?
- Are database queries parameterized against SQL injection?
- Are endpoints protected by proper authentication and role-based authorization checks?
- Are secrets, tokens, or PII prevented from leaking into client bundles or logs?

#### 4. Performance & Resource Management
- Are there N+1 database queries, un-indexed lookups, or unbounded pagination?
- On the frontend: Are components causing unnecessary re-renders? Are heavy computations memoized? Are assets lazy-loaded?
- Are event listeners, streams, intervals, and WebSocket subscriptions cleaned up on teardown?

#### 5. Accessibility (a11y) & UX Integrity
- Are semantic HTML tags used appropriately (`<button>`, `<main>`, `<dialog>`)?
- Are interactive elements accessible via keyboard (tab order, focus ring, Enter/Space/Escape keys)?
- Do form inputs have explicit `<label>` bindings and ARIA error announcements?

#### 6. Test Quality & Maintainability
- Do unit tests cover edge cases and failure modes (not just the happy path)?
- Do tests avoid testing implementation details (testing behavior through public interfaces)?
- Are variable, function, and component names clear, unambiguous, and intent-revealing?

### Step 3: Structure & Deliver the Review Report
Format the review using structured markdown:

```markdown
## Senior Code Review Summary
- **Overall Quality**: [Production-Ready | Needs Minor Polish | Changes Required]
- **Files Reviewed**: [List of files]
- **Highlights**: [What was done well]

### Key Findings & Recommendations

#### 🚨 Blocking Issues
- **`src/services/auth.ts:L45`**: Potential token leak in error handler.
  - *Rationale*: Catch block serializes full request headers including `Authorization` bearer token into unencrypted console logs.
  - *Recommendation*: Sanitize headers before logging or use structured logging with automated redactors.

#### ⚠️ Important Improvements
- **`src/hooks/useDashboardData.ts:L28`**: Missing abort controller on dynamic filter fetch.
  - *Rationale*: Rapid filter toggling causes out-of-order network resolution (race condition).
  - *Recommendation*: Use `AbortController` or TanStack Query cancellation signals.

#### 💡 Suggestions & Polish
- **`src/components/MetricCard.tsx:L12`**: Consider extracting variant styling to a CVA (Class Variance Authority) map for cleaner readability.

#### 👏 Commendations
- Excellent use of discriminated unions for the async state reducer in `src/state/editor.ts`.
```

### Step 4: Socratic Review Debrief
1. Walk through the findings with the developer.
2. Ask guiding questions to help the developer remediate blocking issues:
   - *"How might we restructure this hook so that rapid user clicks don't display stale data?"*
3. Verify fixes against `.promptkit/protocols/code-quality-gate.md`.

---

## Completion Criteria
- Comprehensive review report generated with clear severities and actionable recommendations.
- Blocking security, performance, and correctness issues identified and resolved.
- Code satisfies the Senior Code Quality Gate.
