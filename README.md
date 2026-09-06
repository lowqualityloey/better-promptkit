# Better PromptKit

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![CI](https://github.com/lowqualityloey/better-promptkit/actions/workflows/ci.yml/badge.svg)](https://github.com/lowqualityloey/better-promptkit/actions)
[![GitHub](https://img.shields.io/badge/GitHub-lowqualityloey%2Fbetter--promptkit-black.svg)](https://github.com/lowqualityloey/better-promptkit)

Engineering workflows, mentorship protocols, and quality gates for developers pairing with AI coding assistants (Antigravity, Claude Code, Gemini CLI, Cursor, Windsurf, GitHub Copilot, and Aider).

Better-PromptKit equips your coding assistant with structured development protocols: spec-driven architecture, hypothesis-led debugging, two-axis code reviews, and Socratic mentorship without polluting project commit history or colliding with IDE slash commands.

---

## Quick Start

Add Better-PromptKit to your repository as a git submodule or direct clone:

### Option A: Git Submodule (Recommended)
```bash
git submodule add https://github.com/lowqualityloey/better-promptkit .promptkit
```

### Option B: Direct Clone
```bash
git clone https://github.com/lowqualityloey/better-promptkit .promptkit
```

---

### Run Initialization

Run the setup script for your platform:

**Windows (PowerShell):**
```powershell
.\.promptkit\init.ps1
```

**macOS / Linux (Bash):**
```bash
./.promptkit/init.sh
```

**Or via Conversational AI:**
Tell your assistant:
> *"Read `.promptkit/protocols/setup.md` to initialize Better-PromptKit in this workspace."*

#### What the initialization script does:
1. Detects your active AI editor or CLI configuration (`CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`).
2. Injects conflict-free `pk:` triggers into your agent briefing file.
3. Scaffolds `PROMPTKIT.md` for project tech stack rules, and links `DESIGN.md` if present for visual brand identity.
4. Creates documentation folders (`docs/adrs/`, `docs/specs/`, `docs/rca/`, `docs/spikes/`, `docs/design/`, `docs/data/`, `docs/auth/`, `docs/api/`, `docs/tests/`, `docs/releases/`) so architectural decisions stay tracked in your project's repository.

---

### Updating Better-PromptKit

When new workflows, quality gates, or presets are released, pull the latest changes and re-run initialization:

**If installed via Git Submodule:**
```bash
git submodule update --remote .promptkit
./.promptkit/init.sh     # or .\.promptkit\init.ps1 on Windows
```

**If installed via Direct Clone:**
```bash
git -C .promptkit pull
./.promptkit/init.sh     # or .\.promptkit\init.ps1 on Windows
```

The initialization script is idempotent: it refreshes your agent directives in place without duplicating blocks or touching existing project specs.

---

## Fast Shorthand Triggers

All triggers use the `pk:` prefix to avoid collisions with native slash commands in Antigravity or Cursor:

| Command | Purpose | Output Location |
| :--- | :--- | :--- |
| `pk:route` | Engineering lifecycle router and interactive workflow decision matrix. | Conversation / Specs |
| `pk:tutor` | Socratic mentorship using 3-tier progressive hints. Guides the developer instead of dumping unsolicited code. | Conversation / Notes |
| `pk:tutor beginner` | Socratic coaching with plain-language explanations and immediate error translation. | Conversation / Notes |
| `pk:tutor architect` | Invariant stress-testing, failure mode analysis, and distributed systems trade-offs. | `docs/adrs/` |
| `pk:grill` | Staff-level architecture defense drill challenging assumptions and edge cases. | Conversation / Notes |
| `pk:plan` | Spec-driven architecture: deep module design, Expand-Contract zero-downtime database migrations, and TDD milestones. | `docs/specs/` |
| `pk:review` | Two-axis review: Spec Fidelity vs. Technical Standards (Martin Fowler's 12 code smells), with data loss prevention audits. | Review report |
| `pk:commit` | Atomic Conventional Commits: single-concern staging, Conventional Commits v1.0.0, and secret leak scanning. | Git History |
| `pk:pr` | Pull Request descriptions: verification evidence compilation, data safety checklist, and GitHub CLI creation. | PR Body / `gh pr` |
| `pk:debug` | Scientific debugging: 10-tier feedback loop hierarchy, "no red loop, no Phase 2" gate, tagged logs (`[DEBUG-xxxx]`), and 5-Whys. | `docs/rca/` |
| `pk:data` | Relational database design: primary keys, composite indexing, Row-Level Security (RLS) policies, and transaction boundaries. | `docs/data/` |
| `pk:auth` | Authentication architecture: cookie security (HttpOnly, SameSite), OAuth PKCE, session management, and RBAC/ABAC matrices. | `docs/auth/` |
| `pk:api` | Frontend-backend handshake: unified error envelopes, cursor/offset pagination, mutation idempotency, and contract types. | `docs/api/` |
| `pk:test` | Upfront testing strategy: pyramid seam allocation (Unit vs. Real DB vs. E2E), modular data factories, and mock boundaries. | `docs/tests/` |
| `pk:ship` | Release engineering: fail-fast runtime env checks (Zod/T3), Expand-Contract migration ordering, smoke tests, and rollbacks. | `docs/releases/` |
| `pk:spike` | Technical research spikes: tests the sharpest risk first, compares against the boring baseline, with direct ADR export. | `docs/spikes/` |
| `pk:design` | UI design: anti-slop guidelines, WCAG 2.2 AA contrast/keyboard compliance, React runtime performance, and `DESIGN.md` brand tokens. | `docs/design/` |
| `pk:retro` | Post-implementation retrospective: extracts architectural decisions into MADRs and logs progress. | `docs/adrs/` & journal |
| `pk:checkpoint` | Session checkpoint & handover: state compaction, invariant locking, and fresh chat handover prompt. | Conversation / Notes |

---

## Smart Auto-Route with Guardrails (Triggers Are Optional)

You do not need to memorize `pk:` triggers. When Better-PromptKit is active in your project, the assistant automatically routes plain-English requests using a two-tier policy:

> [!TIP]
> **Zero-Memorization**: Ask naturally (e.g., *"This checkout endpoint throws a 500 error"* or *"Design a multi-tenant user table"*). The assistant recognizes your intent, announces the protocol, and enforces its engineering quality gate.

### 1. Fast-Path (Zero Token Overhead)
For simple queries, syntax lookups, quick explanations, formatting, or single-line tweaks, the assistant responds directly and concisely. It does **not** trigger workflow ceremonies or write unnecessary documentation, keeping token consumption minimal and developer velocity high.

### 2. Protocol Auto-Route (Substantive Engineering)
For non-trivial changes (features, crashes, schema changes, auth flows, releases), the assistant announces the active protocol and enforces its quality gates:
* **Errors, crashes, test failures**: Auto-routes to `pk:debug` (reproduces before patching).
* **New features, cross-component additions**: Auto-routes to `pk:plan` (creates an RFC spec first).
* **Databases & migrations**: Auto-routes to `pk:data` (enforces Expand-Contract ordering).
* **Auth, cookies, session security**: Auto-routes to `pk:auth` (builds a capability matrix).
* **API contracts & endpoints**: Auto-routes to `pk:api` (types and error envelopes).
* **Testing strategy & seams**: Auto-routes to `pk:test` (seam allocation before code).
* **Code review & PR audits**: Auto-routes to `pk:review` (two-axis quality check).
* **Git commits & staging**: Auto-routes to `pk:commit` (atomic staging, secret scan, Conventional Commits).
* **Pull requests & PR descriptions**: Auto-routes to `pk:pr` (verification evidence, data safety, PR body).
* **Context bloat & handovers**: Auto-routes to `pk:checkpoint` (session compaction, zero-loss chat handover).
* **Production deployment & env vars**: Auto-routes to `pk:ship` (validates runtime env and rollback steps).

If you ever want an interactive overview of all workflows, simply run `pk:route` or ask the assistant to route your task.

### How Auto-Routing Looks in Practice

#### Fast-Path (Trivial Query)
> **Developer**: *"How do I format an ISO date string in TypeScript without external libraries?"*
>
> **Assistant**:
> Use the native `Intl.DateTimeFormat` API:
> ```typescript
> export function formatDate(isoDate: string): string {
>   return new Intl.DateTimeFormat('en-US', { dateStyle: 'medium' }).format(new Date(isoDate));
> }
> ```
> *(Direct response. Zero ceremony, zero extra tokens.)*

#### Substantive Auto-Route (Non-Trivial Feature)
> **Developer**: *"We need to add email verification before users can invite team members."*
>
> **Assistant**:
> `[Better-PromptKit: Auto-routed to pk:auth]`
>
> Before implementing changes, establishing the session verification capability matrix in `docs/auth/email-verification-matrix.md`:
> 1. **Threat Model**: Prevent unverified session state escalation via invite links.
> 2. **Session Invariant**: Store `email_verified_at: timestamptz | null`.
> 3. **Capability Boundary**: Restrict `teams:invite` permission to verified owners and admins.
> *(Enforces senior engineering discipline before any application code is touched.)*

---

## Lifecycle Workflow Router

Trigger anytime with `pk:route`. Navigate across the entire engineering lifecycle without guessing:

```text
               [ Inception & Architecture ]
                            │
                         pk:plan
                            │
     ┌──────────────────────┼──────────────────────┐
     ▼                      ▼                      ▼
  pk:data                pk:auth                 pk:api
(Relational Schema)    (Session & RBAC)    (Endpoints & Types)
     │                      │                      │
     └──────────────────────┼──────────────────────┘
                            │
                     [ Implementation ]
                            │
     ┌──────────────────────┼──────────────────────┐
     ▼                      ▼                      ▼
  pk:test               pk:design               pk:spike
(Pyramid & Mocks)     (Tokens & A11y)      (Risk Spikes)
     │                      │                      │
     └──────────────────────┼──────────────────────┘
                            │
               [ Verification & Merge ]
                            │
     ┌──────────────────────┴──────────────────────┐
     ▼                                             ▼
  pk:debug                                     pk:review
(Empirical Root Cause)                   (Two-Axis Code Audit)
     │                                             │
     └──────────────────────┬──────────────────────┘
                            │
                        pk:commit
             (Atomic Conventional Commits)
                            │
                         pk:pr
             (High-Signal PR Descriptions)
                            │
                     [ Release & Ops ]
                            │
                         pk:ship
             (Zero-Downtime Deploy & Rollback)
                            │
             [ Knowledge Capture & Handover ]
                            │
     ┌──────────────────────┴──────────────────────┐
     ▼                                             ▼
  pk:retro                                   pk:checkpoint
(MADR & Journals)                       (Zero-Loss Chat Handover)
```

---

## Repository Layout

```text
better-promptkit/
├── .github/
│   └── workflows/
│       └── ci.yml               # Maintainer CI (syntax, dry-run & anti-slop checks)
├── init.ps1                     # Setup script for Windows (PowerShell)
├── init.sh                      # Setup script for Linux/macOS (Bash)
├── LICENSE                      # Open-source MIT License
├── protocols/
│   ├── setup.md                 # Universal multi-agent configuration protocol
│   ├── context-sync.md          # Tech stack, PROMPTKIT.md, DESIGN.md & git auto-detection
│   └── code-quality-gate.md     # Non-negotiable definition-of-done & pre-commit gate
├── workflows/
│   ├── route.md                 # Lifecycle decision matrix & workflow triage (pk:route)
│   ├── tutor.md                 # Socratic mentorship & 3-tier progressive hints (pk:tutor, pk:grill)
│   ├── plan.md                  # Spec-Driven Development & deep modular design (pk:plan)
│   ├── review.md                # Two-axis PR & Fowler smell review with data safety audit (pk:review)
│   ├── commit.md                # Atomic Conventional Commits & staging hygiene (pk:commit)
│   ├── pr.md                    # High-signal pull request descriptions & evidence audit (pk:pr)
│   ├── debug.md                 # Empirical feedback-loop debugging & root cause analysis (pk:debug)
│   ├── data.md                  # Relational schema design, composite indexes & RLS (pk:data)
│   ├── auth.md                  # Authentication, cookie security & RBAC/ABAC (pk:auth)
│   ├── api.md                   # API contracts, error envelopes & idempotency (pk:api)
│   ├── test.md                  # Upfront test strategy, seam allocation & mock boundaries (pk:test)
│   ├── ship.md                  # Release engineering, runtime env checks & rollbacks (pk:ship)
│   ├── research.md              # Technical spikes & sharpest-risk benchmark matrix (pk:spike)
│   ├── design-system.md         # Anti-slop UI, Design Tokens, and WCAG 2.2 accessibility (pk:design)
│   ├── reflect.md               # Engineering retrospectives & ADR generation (pk:retro)
│   └── checkpoint.md            # Session state compaction & handover prompt (pk:checkpoint)
├── templates/
│   ├── project-profile-template.md # Scaffolds PROMPTKIT.md for custom project guardrails
│   ├── design-profile-template.md  # Scaffolds DESIGN.md for brand identity & visual tokens
│   ├── data-model-spec.md          # Relational schema & RLS specification
│   ├── auth-matrix-template.md     # Auth architecture & RBAC capability matrix
│   ├── api-contract-spec.md        # API endpoint contract & error code catalog
│   ├── test-plan-template.md       # Upfront test strategy & pyramid seam specification
│   ├── release-checklist.md        # Release engineering & zero-downtime deploy checklist
│   ├── pull-request-template.md    # High-signal Pull Request description & safety checklist
│   ├── adr-template.md             # MADR standard Architectural Decision Record
│   ├── tech-spec-template.md       # Engineering RFC / Technical Specification
│   ├── rca-postmortem-template.md  # Blameless Post-Mortem & Incident RCA
│   ├── code-review-checklist.md    # Senior Developer PR Review Checklist
│   ├── design-tokens-spec.md       # Design System & Token Specification
│   └── spike-template.md           # Technical Spike & Benchmark Evaluation Template
├── examples/
│   ├── sample-progress-journal.md  # Retrospective entries from the Shelf full-stack app
│   └── sample-learning-plan.md     # Engineering OKRs & mental model notes
├── notes/
│   ├── README.md                   # Knowledge base guide
│   ├── learning-plan.md            # Template for engineering OKRs & practice katas
│   ├── progress-journal.md         # Template for progressive retro logs
│   ├── skill-matrix.md             # Software Engineering Competency Matrix (L1 → L4)
│   ├── adrs/                       # Local ADR directory (for standalone vault mode)
│   └── spikes/                     # Local Spikes directory (for standalone vault mode)
└── activities/
    ├── README.md                   # Interactive simulation catalog
    ├── 01-system-design-spike.md         # High-throughput webhook engine design
    ├── 02-refactoring-clean-arch.md      # Refactoring monolith to Clean Architecture
    ├── 03-async-concurrency-debug.md     # Concurrency race conditions & memory leaks
    └── 04-accessible-design-system.md    # Accessible, tokenized component library
```

---

## Core Engineering Principles

### 1. Three-Tier Progressive Hints
Instead of dumping complete solutions, the assistant guides developers through progressive hints:
- **Tier 1 (Mental Model)**: Concept diagrams, data flow, and Socratic guiding questions.
- **Tier 2 (Structural Blueprint)**: State machines, interface contracts, and pseudocode logic.
- **Tier 3 (Targeted Micro-Snippet)**: Minimal syntax demonstration of the specific edge case. The engineer writes the implementation.

### 2. Spec-Driven Architecture and Zero-Downtime Evolution
Plans specify interface contracts, module depth (John Ousterhout's deletion test), and failure modes before writing code. Database modifications follow the **Expand-Contract (Parallel Run) pattern** so changes deploy without downtime or breaking active connections.

### 3. Empirical Feedback Loops and Scientific Debugging
The `pk:debug` workflow requires establishing a fast (<3s), deterministic, red-capable command before generating hypotheses. Developers isolate load-bearing reproductions, tag debug logs with unique prefixes (`[DEBUG-xxxx]`), and remove all probes before merging.

### 4. Two-Axis Review and Anti-Slop Design
Reviews evaluate **Spec Fidelity** (missing requirements, scope creep) separately from **Technical Standards** (Fowler's 12 code smells, OWASP, a11y, performance) so neither axis masks the other. Frontends follow WCAG 2.2 AA contrast rules, keyboard navigability, and custom brand tokens from `DESIGN.md`.

### 5. Accidental Data Loss Prevention and Isolated History
Destructive operations (dropping tables, broad deletions, hard git resets) trigger a mandatory halt-and-verify step. All generated project documentation is stored in your project's `./docs/` folder, keeping team history in your git repository while `.promptkit/` remains an upgradeable submodule.

### 6. Atomic Conventional Commits and Secret Leak Prevention
The `pk:commit` workflow enforces single-concern atomic commits instead of bundling unrelated changes. Before staging, it scans for secret leaks (`.env`, credentials) and temporary debug probes (`[DEBUG-xxxx]`), formatting high-signal messages strictly according to the Conventional Commits v1.0.0 standard.

---

## Ecosystem and Framework Scope

Better-PromptKit operates on two complementary levels:

### 1. Universal Engineering Protocols (Language-Agnostic)
The core architectural principles apply across any tech stack (TypeScript, Python, Go, Rust, Java):
- Spec-Driven Development and deep module boundaries (`pk:plan`)
- Relational schema design, composite index ordering, and transaction boundaries (`pk:data`)
- Cookie security flags, OAuth PKCE flows, and capability-based RBAC (`pk:auth`)
- Unified error envelopes, pagination conventions, and idempotency (`pk:api`)
- Testing pyramid seam allocations and mock boundaries (`pk:test`)
- Empirical reproduction loops and scientific debugging (`pk:debug`)
- Atomic Conventional Commits and pre-flight staging (`pk:commit`)
- Zero-loss session checkpoints and context compaction (`pk:checkpoint`)
- Zero-downtime Expand-Contract migration sequencing (`pk:ship`)

### 2. First-Class Battle-Tested Presets
While protocols remain universal, workflows and scaffolding provide tailored templates and detection presets for the modern fullstack web ecosystem:
- **Frontend**: React 19, Next.js (App Router), Tailwind CSS (v3 / v4), Radix UI, Headless UI.
- **Database & Auth**: PostgreSQL, Supabase (Auth + Row-Level Security), Prisma, Drizzle ORM, Kysely.
- **API & Handshake**: tRPC, Next.js Server Actions, Zod, OpenAPI.

---

## Customizing Project Guardrails

Better-PromptKit separates universal workflow protocols from project-specific rules. You customize your assistant's behavior using two root configuration files:

### 1. `PROMPTKIT.md` (Engineering Guardrails & Stack Constraints)
Scaffolded automatically during initialization from `templates/project-profile-template.md`. This file tells the assistant your project's non-negotiable boundaries:
- **Project Domain & Users**: Contextual overview so the assistant grasps business context.
- **Active Commands**: Explicit test runner (`pnpm test:e2e`), typecheck (`pnpm tsc --noEmit`), and linter commands.
- **Non-Negotiable Guardrails**: Hard architectural invariants (e.g., zero `any` in TypeScript, no business logic in React components, mandatory database check constraints).
- **Artifact Storage**: Destination paths for all generated specs (`docs/specs/`, `docs/data/`, `docs/auth/`, etc.).

### 2. `DESIGN.md` (Visual Brand & Anti-Slop Authority)
Optional brand identity file created from `templates/design-profile-template.md`. Serves as the supreme visual authority for all UI generation (`pk:design`, `pk:review`):
- **Color Tokens**: Neutral base, primary brand tone, and deliberate focal accents.
- **Anti-Slop Directives**: Explicit bans on generic AI aesthetics (no purple-to-cyan gradients, no glowing backdrops, no uniform pill badges).
- **Typography & Numerics**: Heading fonts, widow prevention (`text-wrap: balance`), and mandatory `tabular-nums` for financial tables and timers.
- **Surfaces & Radii**: Hierarchy rules (`rounded-md` controls, `rounded-lg` containers) and elevation dose caps.
- **Mobile Ergonomics**: Minimum $44 \times 44\text{px}$ touch targets and single-column mobile reflow.

---

## Multi-Agent Compatibility

| Environment | Briefing File Configured | Trigger Syntax |
| :--- | :--- | :--- |
| **Antigravity / Gemini CLI** | `AGENTS.md` / `GEMINI.md` | `pk:tutor`, `pk:plan`, `pk:review` |
| **Claude Code** | `CLAUDE.md` | Reads `CLAUDE.md` automatically |
| **Cursor IDE** | `.cursorrules` / `.cursor/rules/` | Cursor Agent references rules automatically |
| **Windsurf IDE** | `.windsurfrules` | Cascade auto-detects rules |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Copilot Chat references instructions |
| **Aider** | `CONVENTIONS.md` | `aider --read .promptkit/workflows/tutor.md` |

---

## License
Released under the [MIT License](./LICENSE). Created by [Jonel (lowqualityloey)](https://github.com/lowqualityloey).
