# Senior Software Engineer Competency Matrix

Use this matrix to assess your capabilities, identify growth gaps, and guide your deliberate practice sessions with your AI mentor.

```
┌─────────────────────────────────────────────────────────────┐
│                    ENGINEERING TIERS                        │
├───────────────┬─────────────────────────────────────────────┤
│ 🟢 L1 (Junior)│ Implements scoped tasks with guidance.      │
│ 🔵 L2 (Mid)   │ Owns features end-to-end; writes clean code.│
│ 🟣 L3 (Senior)│ Designs resilient systems, mentors others,  │
│               │ manages trade-offs, and enforces quality.   │
│ 🟡 L4 (Staff) │ Drives cross-cutting architecture, strategy,│
│               │ scalability, and organizational excellence. │
└───────────────┴─────────────────────────────────────────────┘
```

---

## 1. Architecture & System Design
- [ ] **L1**: Understands basic MVC / layered separation; implements basic API endpoints.
- [ ] **L2**: Designs normalized database schemas; manages state boundaries; structures modular features.
- [ ] **L3**: Implements Clean/Hexagonal Architecture; designs resilient distributed systems with caching, message queues, and circuit breakers; authors ADRs and RFCs.
- [ ] **L4**: Establishes enterprise domain boundaries (DDD); architects multi-region high-availability systems; optimizes global latency and infrastructure cost.

---

## 2. Frontend Engineering & Modern UI/UX
- [ ] **L1**: Writes functional semantic HTML, CSS, and basic component state.
- [ ] **L2**: Builds responsive UI with Tailwind/CSS Modules; manages server cache with TanStack Query; implements optimistic UI.
- [ ] **L3**: Architects tokenized Design Systems; ensures WCAG 2.2 Level AA accessibility compliance; optimizes Core Web Vitals (LCP, INP, CLS); builds compound headless primitives.
- [ ] **L4**: Leads micro-frontend / monorepo UI architecture; implements streaming server rendering and advanced asset delivery pipelines.

---

## 3. Backend, Data & API Engineering
- [ ] **L1**: Writes basic CRUD handlers and relational SQL queries.
- [ ] **L2**: Implements authentication (JWT/OAuth), relational transactions, and input validation schemas (Zod).
- [ ] **L3**: Designs type-safe contracts (OpenAPI 3.1, tRPC, GraphQL); eliminates N+1 queries; implements distributed rate limiting and idempotent workers.
- [ ] **L4**: Architects event-driven architectures (Kafka/SQS), database sharding/partitioning, and real-time synchronization engines.

---

## 4. Quality, Testing & Reliability
- [ ] **L1**: Writes basic unit tests for happy paths.
- [ ] **L2**: Writes integration tests with database fixtures; implements mock service workers (MSW).
- [ ] **L3**: Implements comprehensive testing pyramid (Unit, Integration, E2E via Playwright); performs mutation/property testing; writes blameless post-mortems and RCAs.
- [ ] **L4**: Establishes automated quality gates in CI/CD; designs chaos engineering experiments and disaster recovery drills.

---

## 5. Security & DevSecOps
- [ ] **L1**: Follows basic security guidelines; does not commit plaintext secrets.
- [ ] **L2**: Sanitizes user inputs against XSS and SQL injection; configures secure CORS and HTTP headers.
- [ ] **L3**: Implements least-privilege RBAC/ABAC; audits OWASP Top 10 vulnerabilities; manages automated secret rotation and container vulnerability scanning.
- [ ] **L4**: Drives zero-trust security architecture, compliance posture (SOC2/GDPR/HIPAA), and threat modeling workshops.
