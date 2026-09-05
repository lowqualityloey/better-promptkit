# Senior Developer Pull Request Review Checklist

Use this checklist during PR reviews and self-audits to ensure the highest standard of engineering rigor.

---

## 1. Architectural & Domain Design
- [ ] **Single Responsibility**: Does each class, module, function, or component do exactly one thing well?
- [ ] **Layered Separation**: Is business logic strictly separated from UI rendering and database access?
- [ ] **Domain Boundaries**: Are models, entities, and value objects properly encapsulated?
- [ ] **Extensibility vs YAGNI**: Is the solution simple enough for current requirements without unnecessary speculative abstractions?

## 2. Type Safety & Schema Contracts
- [ ] **No `any` or Loose Casts**: Are types strictly declared without unsafe `as` assertions?
- [ ] **Runtime Validation**: Are all external inputs (API params, webhooks, query strings, localStorage) validated via Zod / Valibot schemas?
- [ ] **Discriminated Unions**: Are asynchronous or multi-variant states modeled with tagged unions?
- [ ] **Immutability**: Are state mutations pure and immutable?

## 3. Concurrency, Async & Error Resilience
- [ ] **Race Condition Prevention**: Are rapid asynchronous events, network fetches, and user clicks debounced, throttled, or protected by abort signals?
- [ ] **Resource Cleanup**: Are intervals, event listeners, streams, and WebSocket connections reliably torn down in unmount/finally blocks?
- [ ] **Graceful Degradation**: If an external dependency fails, does the user receive a helpful error message instead of a blank screen or crashed app?
- [ ] **Transaction Atomicity**: Are multiple database writes wrapped in atomic transactions?

## 4. Security Hygiene & Defense-in-Depth
- [ ] **Authentication & Authorization**: Is every endpoint protected by explicit user session and permission checks?
- [ ] **Injection Prevention**: Are all database queries parameterized (no raw template literal SQL)?
- [ ] **Data Sanitization**: Is HTML/Markdown rendered safely against XSS attacks?
- [ ] **Secrets & PII Hygiene**: Are sensitive fields (passwords, tokens, emails, phone numbers) excluded from public client payloads and logs?

## 5. Performance & Resource Efficiency
- [ ] **Database & Query Indexing**: Are all foreign keys and frequently filtered columns indexed? Are N+1 query patterns eliminated?
- [ ] **Frontend Rendering**: Are expensive calculations memoized? Does the component re-render only when its specific props change?
- [ ] **Bundle Size & Asset Optimization**: Are large third-party libraries dynamic-imported / code-split? Are images optimized and sized?

## 6. Accessibility (a11y) & UX Integrity
- [ ] **Semantic Markup**: Are standard HTML tags used for buttons, navigation, headings, and dialogs?
- [ ] **Keyboard Navigability**: Can every action be triggered via keyboard (Tab, Enter, Space, Escape, Arrows)?
- [ ] **Contrast & Focus**: Do focus rings stand out clearly? Does text meet WCAG 2.2 AA contrast ratios?
- [ ] **Screen Reader Support**: Do icons and buttons have accessible labels (`aria-label`, `sr-only`)?

## 7. Testing & Observability
- [ ] **Edge-Case Test Coverage**: Do tests verify boundary conditions, error responses, and invalid inputs?
- [ ] **Behavioral Tests**: Do tests assert observable behavior rather than private implementation details?
- [ ] **Structured Logging**: Are critical events logged with structured metadata and correlation IDs?
