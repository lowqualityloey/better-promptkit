# Architectural Decision Record (ADR): [Short Title of Decision]

- **Status**: [Draft | Proposed | Accepted | Rejected | Superseded by ADR-XXX]
- **Deciders**: [List of engineers / stakeholders involved]
- **Date**: [YYYY-MM-DD]
- **Technical Story / Ticket**: [Link or issue ID]

---

## Context and Problem Statement
[Describe the context and the problem being solved. What forces are at play? What business or technical constraints exist? Keep this clear and objective.]

---

## Decision Drivers
- [Driver 1, e.g., Need sub-50ms read latency for user feeds]
- [Driver 2, e.g., TypeScript strict type-safety across client and server boundaries]
- [Driver 3, e.g., Team familiarity and low operational overhead]
- [Driver 4, e.g., Zero vendor lock-in for critical core data]

---

## Considered Options
1. **Option 1**: [Name of Approach 1, e.g., PostgreSQL with JSONB and pgvector]
2. **Option 2**: [Name of Approach 2, e.g., Dedicated MongoDB Cluster]
3. **Option 3**: [Name of Approach 3, e.g., Supabase / Managed PostgreSQL with Pinecone]

---

## Decision Outcome
**Chosen Option**: **Option 1 ([Name of Chosen Approach])** because [succinct summary of why this option is superior given our decision drivers].

### Positive Consequences
- [Positive 1, e.g., Single database engine to back up, monitor, and scale]
- [Positive 2, e.g., ACID transactional consistency across relational metadata and vector embeddings]
- [Positive 3, e.g., Existing Prisma ORM integration works without extra drivers]

### Negative Consequences & Trade-Offs
- [Negative 1, e.g., High-dimensional vector search index requires more RAM allocation on DB server]
- [Mitigation for Negative 1, e.g., Upgrade RDS instance size when index exceeds 100,000 items]

---

## Pros and Cons of the Options

### Option 1: [Name]
- **Good**, because [pro 1]
- **Good**, because [pro 2]
- **Bad**, because [con 1]

### Option 2: [Name]
- **Good**, because [pro 1]
- **Bad**, because [con 1]
- **Bad**, because [con 2]

### Option 3: [Name]
- **Good**, because [pro 1]
- **Bad**, because [con 1]

---

## Implementation & Migration Notes
- [Step 1: Database migration script]
- [Step 2: Update repository interface contracts]
- [Step 3: Update documentation and CI integration test fixtures]

---

## Links & References
- [Link 1 to RFC / Spike notes in `./docs/specs/` or `./docs/spikes/`]
- [Link 2 to official benchmark / docs]
