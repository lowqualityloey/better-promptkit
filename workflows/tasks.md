# Task Breakdown & Acceptance Criteria Workflow

## Fast Shorthand
Trigger anytime with: `pk:tasks` (or `/pk-tasks`, `pk:issue`, `pk:kanban`, `pk:task`)

## Mission
Transform architectural specifications (`pk:plan`), technical RFCs (`docs/specs/`), or user feature requests into atomic, single-responsibility GitHub issues with strict Acceptance Criteria (Gherkin format + checklists), technical invariant locking, priority tagging (`#priority/p0-p3`), copy-pasteable GitHub CLI (`gh issue create`) commands, and GitHub Projects v2 (Kanban) tracking.

Bridge the critical operational gap between high-level architectural design and hands-on coding. Prevent scope creep, untracked work, and forgotten edge cases before any code is written.

---

## Core Principle: No Acceptance Criteria, No Active Coding
An issue is only ready for implementation when its completion can be objectively proven through automated tests and explicit behavioral assertions. Vague tasks ("Build checkout page") are strictly forbidden.

---

## Preconditions
- A technical RFC spec exists in `docs/specs/`, or a concrete feature request has been described.
- Target architectural boundaries and data models are understood (via `pk:plan` or domain specs).

---

## 4-Phase Task Breakdown Protocol

```text
┌─────────────────────────────────────────────────────────────┐
│                     PK:TASKS LIFECYCLE                      │
├──────────────┬──────────────┬──────────────┬────────────────┤
│ Phase 1:     │ Phase 2:     │ Phase 3:     │ Phase 4:       │
│ Spec Triage  │ Atomic Task  │ AC & Invariant│ Local Storage │
│ & Boundaries │ Breakdown    │ Formulation  │ & Kanban Sync  │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

---

### Phase 1: Spec Triage & Scope Boundary

1. **Locate Source Requirements**:
   - Inspect `docs/specs/` for the latest technical specification.
   - If no spec exists, ask the user or run `pk:plan` first for substantive features.
2. **Define Phasing Strategy**:
   - **Full-Stack / Multi-Layer Features**: Group tasks into **TDD Phased Milestones** aligned with `pk:plan`:
     - **Milestone 1 (Contracts & Schema - RED)**: Database migrations, types, API contracts, failing integration tests.
     - **Milestone 2 (Core Domain Logic - GREEN)**: Service layer, domain logic, repository queries making tests pass.
     - **Milestone 3 (Presentation & A11y)**: Accessible UI components, forms, client state, loading/error boundaries.
     - **Milestone 4 (Hardening & Telemetry)**: End-to-end tests, telemetry logging, Contract migration cleanup.
   - **Localized Features (e.g. pure UI or single script)**: Use an adaptive flat list ordered strictly by dependency (Task 1 -> Task 2 -> Task 3).

---

### Phase 2: Atomic Task Decomposition & Sizing

1. **Apply the 1-to-4 Hour Sizing Rule**:
   - Every issue must represent a single, cohesive unit of work achievable in 1 to 4 hours.
   - If an issue requires more than 4 hours or touches multiple architectural layers at once, split it.
2. **Assign Priority Tags**:
   - `#priority/p0`: Blocker or critical path (data migrations, core security, authentication).
   - `#priority/p1`: High priority / core user flow.
   - `#priority/p2`: Medium priority / edge cases, enhancements, optimizations.
   - `#priority/p3`: Polish / nice-to-have, secondary styling adjustments.
3. **Assign Area & Type Labels**:
   - Component Area: `area:data`, `area:backend`, `area:frontend`, `area:auth`, `area:ui`, `area:perf`.
   - Issue Type: `type:feature`, `type:bug`, `type:refactor`, `type:test`.

---

### Phase 3: Acceptance Criteria & Invariant Formulation

For each decomposed task, fill out `.promptkit/templates/issue-task-template.md`:

1. **User Story / Intent**:
   - State the actor, capability, and value: `As a <user>, I want <action> so that <value>`.
2. **Technical Scope & Invariants**:
   - Exact files, endpoints, and database tables touched.
   - Non-negotiable invariants: Tenant Row-Level Security (RLS), Expand-Contract schema safety, input validation schemas, performance budgets.
   - Explicit "Out of Scope" declaration to prevent mid-flight scope creep.
3. **Verifiable Acceptance Criteria**:
   - **Happy Path (Gherkin)**: `Given <context>, When <action>, Then <outcome>`.
   - **Negative & Error Path**: Explicit assertions for 400 Bad Request, 401 Unauthorized, 403 Forbidden, 409 Conflict, or 429 Rate Limit.
   - **Boundary Conditions**: Empty states, maximum payload boundaries, concurrent double-submit guards.
4. **Automated Verification Command**:
   - Provide the exact test runner command that validates the criteria (e.g., `pnpm test path/to/feature.test.ts`).

---

### Phase 4: Local Storage & GitHub Projects Sync

1. **Persist Local Source of Truth**:
   - Save the complete breakdown to `docs/tasks/YYYY-MM-DD-<feature>-tasks.md`.
   - This provides offline resilience and protects against agent context compaction (`pk:checkpoint`).
2. **Generate GitHub CLI (`gh issue create`) Commands**:
   - Append ready-to-run CLI commands at the bottom of the document:
     ```bash
     gh issue create \
       --title "feat(cart): implement server-side discount validation" \
       --body-file docs/tasks/issue-01-discount-validation.md \
       --label "area:backend,priority:p1" \
       --milestone "M2: Core Domain Logic"
     ```
3. **GitHub Projects v2 & Kanban Sync (Optional)**:
   - If using GitHub Projects v2, link each created issue to your project board:
     ```bash
     gh project item-add <project-number> --owner <owner> --url <issue-url>
     ```
   - Track progress through standard Kanban status lanes:
     `To Do` -> `In Progress` -> `In Review` -> `Done`
   - For local Obsidian Kanban users, format cards matching the `kanban-project-planner` conventions:
     - `## To Do`: `- [ ] <Task description> #priority/pX`
     - `## In Progress`: `- [/] <Task description> #priority/pX`
     - `## Done`: `- [x] <Task description> #priority/pX ✅ YYYY-MM-DD`

---

## Completion Criteria
- Tasks decomposed into atomic 1-to-4 hour units with priority tags (`p0`-`p3`).
- Every task includes non-negotiable technical invariants and out-of-scope boundaries.
- Every task includes both happy path and negative/edge-case Acceptance Criteria.
- Automated verification commands provided for every testable task.
- Tasks document saved to `docs/tasks/` with copy-pasteable `gh issue create` commands.
