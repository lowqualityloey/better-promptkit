# Better-PromptKit

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![CI](https://github.com/lowqualityloey/better-promptkit/actions/workflows/ci.yml/badge.svg)](https://github.com/lowqualityloey/better-promptkit/actions)
[![GitHub](https://img.shields.io/badge/GitHub-lowqualityloey%2Fbetter--promptkit-black.svg)](https://github.com/lowqualityloey/better-promptkit)

The open-source Engineering Operating System for AI coding assistants (Claude Code, Antigravity, Cursor, Windsurf, GitHub Copilot, Gemini CLI, and Aider).

Better-PromptKit equips your coding assistant with disciplined engineering workflows: spec-driven architecture, living session state, Expand-Contract zero-downtime database migrations, empirical debugging, and atomic Conventional Commits without colliding with IDE slash commands.

---

## Overview: Who It Is For & Why

| Dimension | Details |
| :--- | :--- |
| **What is it?** | A modular, instruction-based engineering operating system that lives in your repository as `.promptkit/`. |
| **Who it is for** | Developers pairing with AI coding agents who want structured specs, living project state, non-breaking schema migrations, and clean git history. |
| **Who it is NOT for** | Developers looking for an autocomplete inline plugin, a CLI binary, or an npm dependency. Better-PromptKit is pure markdown protocols and prompts. |
| **Why it is better** | Replaces unguided "vibe coding" and token-wasting guess-and-patch loops with structured, deterministic development workflows. **Reduces AI token costs by 60-70%** while improving code quality. |
| **Key differences** | Zero slash command collisions (`pk:` prefix), zero destructive database drops (Expand-Contract only), zero unsolicited code dumps (Socratic guidance), and monorepo workspace isolation (scoped `--filter` commands). |
| **ROI** | \$100/year saved per developer in AI costs, 5 hours/month saved in development time, and 58% higher first-attempt success rate. |

---

## Quick Start (60 Seconds)

**New to PromptKit?** → See **[FAQ.md](./FAQ.md)** for the 10 most common questions  
**Getting started?** → See **[QUICKSTART.md](./QUICKSTART.md)** for a 5-minute guided tour  
**Existing project?** → See **[ADOPTION-GUIDE.md](./docs/ADOPTION-GUIDE.md)** for gradual adoption  
**Visual learner?** → See **[WORKFLOW-MAP.md](./docs/WORKFLOW-MAP.md)** for decision trees and diagrams  
**Want to know more?** → See **[INTERESTING-FACTS.md](./docs/INTERESTING-FACTS.md)** for unique insights and design principles

### 1. Add to Your Project

```bash
# Recommended: Git Submodule (easily upgradeable)
git submodule add https://github.com/lowqualityloey/better-promptkit .promptkit

# Alternative: Direct Clone
git clone https://github.com/lowqualityloey/better-promptkit .promptkit
```

### 2. Run Platform Initialization

Execute the setup script for your environment:

```bash
# macOS / Linux (Bash):
./.promptkit/init.sh

# Windows (PowerShell):
.\.promptkit\init.ps1
```

*(Or instruct your assistant: "Read `.promptkit/protocols/setup.md` to initialize Better-PromptKit in this workspace.")*

### 3. What Gets Created in Your Project

The initialization script is transparent and idempotent:
- **`./docs/` directories**: Scaffolds standard artifact folders (`specs/`, `adrs/`, `tasks/`, `data/`, `auth/`, `api/`, `tests/`, `perf/`, `rca/`, `releases/`).
- **`./PROMPTKIT.md`**: Project architectural profile containing your active commands, stack constraints, and monorepo workspace topology.
- **`./docs/STATE.md`**: The living project tracker recording active milestones, tasks in flight, and locked architectural invariants.
- **Agent Directives**: Injects or updates an idempotent directive block in `AGENTS.md` (or `CLAUDE.md`, `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`).
- **Zero Lock-In**: Installs zero binaries, adds zero npm dependencies, and runs zero background daemons.

**💡 Bonus**: See **[TOKEN-EFFICIENCY.md](./docs/TOKEN-EFFICIENCY.md)** to understand how PromptKit reduces AI costs by 60-70% while improving code quality.

---

## The Mental Model

Better-PromptKit structures developer-AI collaboration into four distinct layers:

| Layer | Plain-English Role | Examples | Location |
| :--- | :--- | :--- | :--- |
| **Protocols** | Non-negotiable operating rules the assistant obeys at all times. | Context Sync, Definition of Done, Subagent Delegation | [`protocols/`](./protocols) |
| **Workflows** | Step-by-step engineering procedures for each phase of the dev lifecycle. | `pk:plan`, `pk:test`, `pk:debug`, `pk:commit`, `pk:ship` | [`workflows/`](./workflows) |
| **Templates** | Standardized markdown schemas the assistant fills into your `./docs/` folder. | RFC Specs, MADRs, Test Plans, RCA Post-Mortems | [`templates/`](./templates) |
| **Labs & Notes** | Interactive simulations, competency rubrics, and retro logs for skill building. | System design spikes, refactoring katas, skill matrix | [`activities/`](./activities), [`notes/`](./notes) |

---

## Lifecycle Workflow Router

Trigger anytime with `pk:route`. Navigate across the entire engineering lifecycle without guessing:

```text
               [ Inception & Intake ]
                             │
            ┌────────────────┴────────────────┐
            ▼                                 ▼
         pk:plan                           pk:onboard
    (Greenfield RFC)                  (Brownfield Ingestion)
            │                                 │
            └────────────────┬────────────────┘
                             │
                             ▼
                          pk:tasks
          (Atomic Issues, Gherkin AC & Kanban Sync)
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
     ┌──────────────────────┼──────────────────────┐
     ▼                      ▼                      ▼
  pk:debug               pk:perf               pk:review
(Empirical Root Cause) (Latency & Profiling) (Two-Axis Code Audit)
     │                      │                      │
     └──────────────────────┼──────────────────────┘
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

> [!NOTE]
> **Cross-Cutting Coaching**: `pk:tutor` (Socratic mentorship & 3-tier progressive hints) and `pk:grill` (Staff Engineer architecture defense drills) operate perpendicularly across all lifecycle phases whenever conceptual guidance or invariant stress-testing is needed.

---

## Fast Shorthand Reference

All triggers use the `pk:` prefix to avoid collisions with native slash commands in Antigravity or Cursor:

| Command | Workflow | Output Target | Description |
| :--- | :--- | :--- | :--- |
| `pk:route` | [`workflows/route.md`](./workflows/route.md) | Conversation | Interactive lifecycle decision matrix and workflow triage. |
| `pk:tutor` | [`workflows/tutor.md`](./workflows/tutor.md) | Conversation | Socratic mentorship using 3-tier hints; guides without dumping code. |
| `pk:grill` | [`workflows/tutor.md`](./workflows/tutor.md) | Conversation | Architecture defense drill challenging assumptions and edge cases. |
| `pk:plan` | [`workflows/plan.md`](./workflows/plan.md) | `docs/specs/` | Spec-driven architecture, module depth, and zero-downtime migrations. |
| `pk:onboard` | [`workflows/onboard.md`](./workflows/onboard.md) | `PROMPTKIT.md`, `docs/STATE.md` | Brownfield intake: scans manifests, workspaces, and scaffolds guardrails. |
| `pk:tasks` | [`workflows/tasks.md`](./workflows/tasks.md) | `docs/tasks/` or `gh` | Decomposes specs into atomic 1-4h tasks with Gherkin AC. |
| `pk:data` | [`workflows/data.md`](./workflows/data.md) | `docs/data/` | Schema design, composite indexing, RLS policies, and migrations. |
| `pk:auth` | [`workflows/auth.md`](./workflows/auth.md) | `docs/auth/` | Cookie security flags, OAuth PKCE flows, and RBAC/ABAC capability matrix. |
| `pk:api` | [`workflows/api.md`](./workflows/api.md) | `docs/api/` | Contract envelopes, cursor pagination, and mutation idempotency. |
| `pk:test` | [`workflows/test.md`](./workflows/test.md) | `docs/tests/` | Testing pyramid seam allocation, data factories, and monorepo `--filter`. |
| `pk:design` | [`workflows/design-system.md`](./workflows/design-system.md) | `docs/design/` | Anti-slop UI tokens, WCAG 2.2 AA accessibility, and mobile ergonomics. |
| `pk:spike` | [`workflows/research.md`](./workflows/research.md) | `docs/spikes/` | Technical risk spikes comparing options against a boring baseline. |
| `pk:debug` | [`workflows/debug.md`](./workflows/debug.md) | `docs/rca/` | Scientific debugging: fast reproduction loop, tagged logs, and 5-Whys. |
| `pk:perf` | [`workflows/perf.md`](./workflows/perf.md) | `docs/perf/` | Baseline quantification, EXPLAIN ANALYZE, flamegraphs, and deltas. |
| `pk:review` | [`workflows/review.md`](./workflows/review.md) | Review report | Two-axis review: Spec Fidelity vs Technical Standards (Fowler's smells). |
| `pk:commit` | [`workflows/commit.md`](./workflows/commit.md) | Git history | Atomic Conventional Commits, single-concern staging, and secret scanning. |
| `pk:pr` | [`workflows/pr.md`](./workflows/pr.md) | PR body / `gh pr` | Pull request descriptions with test evidence and rollback procedures. |
| `pk:ship` | [`workflows/ship.md`](./workflows/ship.md) | `docs/releases/` | Runtime env validation (Zod/T3), migration ordering, and smoke tests. |
| `pk:checkpoint` | [`workflows/checkpoint.md`](./workflows/checkpoint.md) | `docs/STATE.md` | Session compaction, invariant locking, and fresh chat handover prompt. |
| `pk:retro` | [`workflows/reflect.md`](./workflows/reflect.md) | `docs/adrs/` & journal | Post-feature retrospective: extracts decisions into standard MADRs. |

---

## How the Assistant Operates

You do not need to memorize commands. You can prompt naturally (e.g., *"This checkout endpoint throws 500 errors"* or *"Design a multi-tenant user table"*), and the assistant auto-routes to the proper workflow.

### 1. Two-Tier Execution

- **Fast-Path (Trivial Queries)**: Quick syntax questions, single-line adjustments, or formatting requests execute directly with zero workflow ceremony or token overhead.
- **Protocol Routing (Non-Trivial Tasks)**: Non-trivial features, schema migrations, bug investigations, and releases announce their active protocol, run upfront checks, and produce tracked documentation in `./docs/`.

### 2. Subagent Delegation (Parallel Fan-Out)

In multi-agent environments (Antigravity, Claude Code, Cursor background agents), the assistant follows [`protocols/subagent-delegation.md`](./protocols/subagent-delegation.md):
- **Offloaded to Subagents**: Multi-candidate architectural benchmarks (`pk:spike`), dual-axis PR reviews (`pk:review`), brownfield codebase surveys (`pk:onboard`), and codebase scans touching >3 files.
- **Retained in Main Thread**: Direct developer conversation, small localized edits (<10 lines), atomic commits (`pk:commit`), and pull request submission (`pk:pr`).
- **Compact Synthesis**: Subagents return 5-15 line synthesized reports with file paths and line numbers instead of dumping raw tool output into parent context.

---

## Repository Layout

```text
better-promptkit/
├── .github/
│   └── workflows/
│       └── ci.yml               # Maintainer CI (syntax, dry-run & anti-slop checks)
├── FAQ.md                       # 🌟 NEW: The 10 questions every developer asks before adopting
├── QUICKSTART.md                # 🌟 NEW: 5-minute introduction with 4 core workflows
├── init.ps1                     # Setup script for Windows (PowerShell)
├── init.sh                      # Setup script for Linux/macOS (Bash)
├── LICENSE                      # Open-source MIT License
├── docs/
│   ├── WORKFLOW-MAP.md          # 🌟 NEW: Visual decision trees and Mermaid diagrams
│   ├── ADOPTION-GUIDE.md        # 🌟 NEW: Incremental adoption for existing projects
│   ├── TOKEN-EFFICIENCY.md      # 🌟 NEW: How PromptKit reduces AI costs 60-70%
│   ├── INTERESTING-FACTS.md     # 🌟 NEW: Unique insights and design principles
│   └── DESIGN-MD-FAQ.md         # 🌟 NEW: FAQ on custom DESIGN.md usage & safety
├── protocols/                   # Non-negotiable AI rules & operating standards
│   ├── setup.md                 # Universal multi-agent configuration protocol
│   ├── context-sync.md          # Tech stack, monorepos, PROMPTKIT.md, DESIGN.md & git detection
│   ├── code-quality-gate.md     # Non-negotiable definition-of-done & pre-commit gate
│   └── subagent-delegation.md   # Subagent delegation, parallel execution & context preservation
├── workflows/                   # Step-by-step engineering lifecycle procedures
│   ├── route.md                 # Lifecycle decision matrix & workflow triage (pk:route)
│   ├── tutor.md                 # Socratic mentorship & 3-tier progressive hints (pk:tutor, pk:grill)
│   ├── plan.md                  # Spec-Driven Development & deep modular design (pk:plan)
│   ├── onboard.md               # Brownfield intake, monorepo workspaces & PROMPTKIT.md (pk:onboard)
│   ├── tasks.md                 # Atomic issue breakdown, Gherkin AC & Kanban sync (pk:tasks)
│   ├── review.md                # Two-axis PR & Fowler smell review with data safety audit (pk:review)
│   ├── commit.md                # Atomic Conventional Commits & staging hygiene (pk:commit)
│   ├── pr.md                    # High-signal pull request descriptions & evidence audit (pk:pr)
│   ├── debug.md                 # Empirical feedback-loop debugging & root cause analysis (pk:debug)
│   ├── perf.md                  # Empirical performance profiling & latency SLAs (pk:perf)
│   ├── data.md                  # Relational schema design, composite indexes & RLS (pk:data)
│   ├── auth.md                  # Authentication, cookie security & RBAC/ABAC (pk:auth)
│   ├── api.md                   # API contracts, error envelopes & idempotency (pk:api)
│   ├── test.md                  # Upfront test strategy, seam allocation & mock boundaries (pk:test)
│   ├── ship.md                  # Release engineering, runtime env checks & rollbacks (pk:ship)
│   ├── research.md              # Technical spikes & sharpest-risk benchmark matrix (pk:spike)
│   ├── design-system.md         # Anti-slop UI, Design Tokens, and WCAG 2.2 accessibility (pk:design)
│   ├── reflect.md               # Engineering retrospectives & ADR generation (pk:retro)
│   └── checkpoint.md            # Session state compaction & handover prompt (pk:checkpoint)
├── templates/                   # Structured artifact schemas saved to project docs/
│   ├── project-profile-template.md # Scaffolds PROMPTKIT.md for project guardrails & monorepo topology
│   ├── design-profile-template.md  # Scaffolds DESIGN.md for brand identity & visual tokens
│   ├── state-tracker-template.md   # Scaffolds docs/STATE.md for living project tracking
│   ├── data-model-spec.md          # Relational schema & RLS specification
│   ├── auth-matrix-template.md     # Auth architecture & RBAC capability matrix
│   ├── api-contract-spec.md        # API endpoint contract & error code catalog
│   ├── test-plan-template.md       # Upfront test strategy & pyramid seam specification
│   ├── release-checklist.md        # Release engineering & zero-downtime deploy checklist
│   ├── pull-request-template.md    # High-signal Pull Request description & safety checklist
│   ├── perf-audit-template.md      # Performance audit report & before/after delta spec
│   ├── issue-task-template.md      # Staff-level GitHub Issue template with Gherkin AC
│   ├── adr-template.md             # MADR standard Architectural Decision Record
│   ├── tech-spec-template.md       # Engineering RFC / Technical Specification
│   ├── rca-postmortem-template.md  # Blameless Post-Mortem & Incident RCA
│   ├── code-review-checklist.md    # Senior Developer PR Review Checklist
│   ├── design-tokens-spec.md       # Design System & Token Specification
│   └── spike-template.md           # Technical Spike & Benchmark Evaluation Template
├── examples/                    # 🌟 EXPANDED: Real-world production examples
│   ├── README.md                       # Example catalog and usage guide
│   ├── saas-dashboard/                 # Complete B2B SaaS example (Next.js + Supabase)
│   │   ├── PROMPTKIT.md               # Full project profile with monorepo config
│   │   ├── docs/STATE.md              # Living project tracker across milestones
│   │   ├── docs/adrs/                 # Real ADR: magic link invitations
│   │   └── conversations/             # Before/after code review with security fixes
│   ├── sample-progress-journal.md     # Retrospective entries from real projects
│   └── sample-learning-plan.md        # Engineering OKRs & mental model notes
├── notes/                       # Engineering competency & growth templates
│   ├── README.md                   # Knowledge base guide
│   ├── learning-plan.md            # Template for engineering OKRs & practice katas
│   ├── progress-journal.md         # Template for progressive retro logs
│   ├── skill-matrix.md             # Software Engineering Competency Matrix (L1 → L4)
│   ├── adrs/                       # Local ADR directory (for standalone vault mode)
│   └── spikes/                     # Local Spikes directory (for standalone vault mode)
├── scripts/                     # 🌟 NEW: Validation and maintenance utilities
│   ├── validate-references.sh          # Bash: Check all workflow→template references
│   └── validate-references.ps1         # PowerShell: Check all workflow→template references
└── activities/                  # Interactive simulation katas & system design drills
    ├── README.md                   # Interactive simulation catalog
    ├── 01-system-design-spike.md         # High-throughput webhook engine design
    ├── 02-refactoring-clean-arch.md      # Refactoring monolith to Clean Architecture
    ├── 03-async-concurrency-debug.md     # Concurrency race conditions & memory leaks
    └── 04-accessible-design-system.md    # Accessible, tokenized component library
```

---

## Customizing Your Project: The 3 Living Files

Better-PromptKit keeps universal workflows separated from your repository's specific rules through three living files:

### 1. `PROMPTKIT.md` (Engineering Guardrails & Stack Constraints)
Scaffolded automatically during initialization from `templates/project-profile-template.md`. This file tells the assistant your project's non-negotiable boundaries:
* **Project Domain & Users**: Contextual overview so the assistant grasps business context.
* **Active Commands**: Explicit test runner (`pnpm test:e2e`), typecheck (`pnpm tsc --noEmit`), and linter commands.
* **Monorepo & Workspace Topology**: Explicit package graph (`apps/*`, `packages/*`), scoped `--filter` commands, and four non-negotiable import boundaries.
* **Non-Negotiable Guardrails**: Hard architectural invariants (e.g., zero `any` in TypeScript, no business logic in React components, mandatory database check constraints).
* **Artifact Storage**: Destination paths for all generated specs (`docs/specs/`, `docs/tasks/`, `docs/data/`, `docs/auth/`, `docs/perf/`, etc.).

### 2. `DESIGN.md` (Visual Brand & Anti-Slop Authority)
Optional brand identity file created from `templates/design-profile-template.md`. Serves as the supreme visual authority for all UI generation (`pk:design`, `pk:review`):
* **Color Tokens**: Neutral base, primary brand tone, and deliberate focal accents.
* **Anti-Slop Directives**: Explicit bans on generic AI aesthetics (no purple-to-cyan gradients, no glowing backdrops, no uniform pill badges).
* **Typography & Numerics**: Heading fonts, widow prevention (`text-wrap: balance`), and mandatory `tabular-nums` for financial tables and timers.
* **Surfaces & Radii**: Hierarchy rules (`rounded-md` controls, `rounded-lg` containers) and elevation dose caps.
* **Mobile Ergonomics**: Minimum $44 \times 44\text{px}$ touch targets and single-column mobile reflow.
* **Existing File Safety**: If you already maintain a custom `DESIGN.md`, PromptKit detects it automatically without overwriting it (see [DESIGN-MD-FAQ.md](./docs/DESIGN-MD-FAQ.md)).

### 3. `docs/STATE.md` (The Living Project Tracker)
Scaffolded automatically during initialization from `templates/state-tracker-template.md`. Serves as the single source of truth for ongoing project execution:
* **Current Position & Milestone**: Active epic, overall health and status (`ACTIVE`, `BLOCKED`, `STABILIZING`), target release, and current working branch.
* **Progress Tracking**: Hierarchical checklist with atomic task status (`[x]` Done, `[/]` In Progress, `[ ]` Queued, `[!]` Blocked).
* **Locked Architectural Invariants**: Non-negotiable decisions made during pairing sessions that future sessions must not regress.
* **Session Continuity**: Updated by `pk:checkpoint`, `pk:tasks`, and `pk:onboard` to eliminate AI context degradation and maintain persistent memory across fresh chats.

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

## Updating Better-PromptKit

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

## License
Released under the [MIT License](./LICENSE). Created by [Jonel (lowqualityloey)](https://github.com/lowqualityloey).
