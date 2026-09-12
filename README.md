# Better-PromptKit

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![CI](https://github.com/lowqualityloey/better-promptkit/actions/workflows/ci.yml/badge.svg)](https://github.com/lowqualityloey/better-promptkit/actions)
[![GitHub](https://img.shields.io/badge/GitHub-lowqualityloey%2Fbetter--promptkit-black.svg)](https://github.com/lowqualityloey/better-promptkit)

The open-source Engineering Operating System for AI coding assistants (Claude Code, Antigravity, Cursor, Windsurf, GitHub Copilot, Cline, Roo Code, Trae, OpenCode, Gemini CLI, and Aider).

Better-PromptKit equips your coding assistant with disciplined engineering workflows: spec-driven architecture, living session state, phased Expand-Contract zero-downtime database migrations, empirical debugging, and atomic Conventional Commits without colliding with IDE slash commands.

---

## Overview: Who It Is For & Why

| Dimension | Details |
| :--- | :--- |
| **What is it?** | A modular, instruction-based engineering operating system that lives in your repository as `.promptkit/`. |
| **Who it is for** | Developers pairing with AI coding agents who want structured specs, living project state, non-breaking schema migrations, and clean git history. |
| **Who it is NOT for** | Developers looking for an autocomplete inline plugin, a CLI binary, or an npm dependency. Better-PromptKit is pure markdown protocols and prompts. |
| **Why it is better** | Replaces unguided "vibe coding" and token-wasting guess-and-patch loops with systematic, hypothesis-driven development workflows. Structured workflows are designed to reduce redundant back-and-forth by enforcing one-pass planning, artifact reuse, and surgical fixes over guess-and-patch loops. |
| **Key differences** | Namespaced triggers (`pk:` prefix), guardrails against single-step destructive schema drops (phased Expand-Contract policy), Socratic guidance that avoids unsolicited code dumps, and monorepo workspace isolation (scoped `--filter` commands). |
| **Token Efficiency** | **Zero Static Token Bloat**: Injects only a ~40-line router (~650 tokens) into your agent directives. Full workflows are read Just-In-Time (JIT) from local files only when triggered. See [`docs/BENCHMARKS.md`](./docs/BENCHMARKS.md). |
| **Durable State Persistence** | **Cross-Session Memory**: State is never lost when chat sessions compact or reset. All active milestones, tasks in flight, and architectural invariants persist directly in Git-tracked markdown (`docs/STATE.md` and `docs/tasks/`). Run `pk:checkpoint` and resume in any fresh session via `pk:route`. |
| **Adaptive Ceremony & Model Tiering** | **Scales with Risk**: Bypasses heavy templates for daily tweaks (Level 0/1) while reserving deep reasoning, Task Records, and verification gates for schema, auth, and release risks (Level 2/3). Matches LLM model tiers to task risk to prevent token waste. |
| **Enforced Done-Gates** | **Not Inert Advice**: PromptKit enforces verifiable engineering done-gates: strict milestone git boundaries (blocking dirty working tree transitions), automated pre-commit secret leak scans (`pk:commit`), and required Gherkin Acceptance Criteria verification proof. |

---

## Start Here: Most Work Is Level 1

Getting started with Better-PromptKit takes three simple steps:

1. **Install & Initialize**: Run `./.promptkit/init.sh` (or `.\.promptkit\init.ps1` on Windows) to scaffold `./docs/`, `./PROMPTKIT.md`, and host directives.
2. **Inspect `PROMPTKIT.md`**: Review or customize project-specific commands, test runners, and architectural invariants in `./PROMPTKIT.md` (or run `pk:onboard` for passive stack discovery).
3. **Prompt Naturally**: Enter your task naturally or route explicitly with `pk:route`. The assistant announces its ceremony level upfront (e.g. `[Better-PromptKit: Level 1 (Standard) — Localized bug fix. No Task Record required.]`). Most ordinary engineering tasks (bug fixes, isolated component tweaks, small features) are **Level 1 (Standard)** and do **not** require a formal Task Record file (`docs/tasks/<task-id>.md`).

### First Task Example

Try pasting this copyable prompt into your AI assistant right after setup:

> "Build a simple React calculator in the existing app. Keep this at Better-PromptKit Level 1 unless inspection finds schema, authentication, public-contract, or multi-component risk. Use only the minimum relevant workflow and run targeted verification."

For authoritative Level 0–3 classification, escalation, downgrade, and Task Record rules, see [`workflows/route.md`](./workflows/route.md). To get up and running in 5 minutes, see [Quick Start](#quick-start-60-seconds) or [`QUICKSTART.md`](./QUICKSTART.md).

---

## Quick Start (60 Seconds)

**New to PromptKit?** → See **[FAQ.md](./FAQ.md)** for the 12 most common questions  
**Getting started?** → See **[QUICKSTART.md](./QUICKSTART.md)** for a 5-minute guided tour  
**Release History?** → See **[CHANGELOG.md](./CHANGELOG.md)** for version notes and release provenance  
**Full-Stack Example?** → See **[examples/fullstack-feature/](./examples/fullstack-feature/README.md)** for an end-to-end production feature walkthrough  
**Existing project?** → See **[ADOPTION-GUIDE.md](./docs/ADOPTION-GUIDE.md)** for gradual adoption  
**Visual learner?** → See **[WORKFLOW-MAP.md](./docs/WORKFLOW-MAP.md)** for decision trees and diagrams  
**Token economics & benchmarks?** → See **[BENCHMARKS.md](./docs/BENCHMARKS.md)** for architecture and context window analysis  
**Want to know more?** → See **[INTERESTING-FACTS.md](./docs/INTERESTING-FACTS.md)** for unique insights and design principles

> [!TIP]
> **Start with just 2 workflows.** You do not need to learn all 20 workflows. Use `pk:debug` (stops guess-and-patch loops) and `pk:checkpoint` (eliminates session amnesia) to get 80% of the value immediately. Everything else is modular and on-demand.

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
- **`./PROMPTKIT.md`**: Project architectural profile containing your active commands, stack constraints, task tracker selector, and monorepo workspace topology.
- **`./docs/STATE.md`**: The living project tracker recording active milestones, tasks in flight, and locked architectural invariants.
- **`.github/pull_request_template.md`**: Staff-level Pull Request template with Gherkin acceptance criteria checklists, Expand-Contract database safety gates, and automated test evidence tables.
- **`.github/ISSUE_TEMPLATE/task.md`**: Standardized task specification issue template for opening structured Gherkin work units directly in GitHub web UI or CLI.
- **Agent Directives**: Injects or updates an idempotent directive block in `AGENTS.md` (or `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`).
- **Just-In-Time (JIT) Workflow Injection**: Zero static token bloat. Workflows are loaded into agent context on-demand from local filesystem files only when triggered (avoiding 18k+ token monolithic prompt injection).
- **Zero-Token Label Provisioning (Optional)**: Provision standardized repository labels (`priority/p0-p3`, `type:*`, `area:*`) with zero token burn using `pwsh -File .promptkit/scripts/setup-github-labels.ps1` (or `bash .promptkit/scripts/setup-github-labels.sh`).
- **Zero Lock-In**: Installs zero binaries, adds zero npm dependencies, and runs zero background daemons.

---

## Maintainer Guidance: Release-Evidence Lifecycle

The release-evidence policy applies only to maintainers evaluating candidates for the Better-PromptKit repository. It documents how Better-PromptKit evaluates a candidate and records an approval decision; it does not impose Better-PromptKit Conventional Commit, SemVer, release-note, changelog, tag, remote, publication, deployment, or rollback requirements on repositories that consume Better-PromptKit.

For detailed maintainer release governance, candidate evaluation rules, workflow ownership, validation commands, and contribution expectations, see [`CONTRIBUTING.md`](./CONTRIBUTING.md).

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

| Command | Workflow File | Status | Output Target | Description |
| :--- | :--- | :--- | :--- | :--- |
| `pk:route` | [`workflows/route.md`](./workflows/route.md) | Core 🧪 | Conversation | Interactive lifecycle decision matrix and workflow triage. |
| `pk:tutor` | [`workflows/tutor.md`](./workflows/tutor.md) | Core 🧪 | Conversation | Socratic mentorship using 3-tier hints; guides without dumping code. |
| `pk:grill` | [`workflows/tutor.md`](./workflows/tutor.md) (alias) | Core 🧪 | Conversation | Architecture defense drill implemented via `tutor.md`. |
| `pk:plan` | [`workflows/plan.md`](./workflows/plan.md) | Core 🧪 | `docs/specs/` | Spec-driven architecture, module depth, and zero-downtime migrations. |
| `pk:onboard` | [`workflows/onboard.md`](./workflows/onboard.md) | Core | `PROMPTKIT.md`, `docs/STATE.md` | Brownfield intake: scans manifests, workspaces, and scaffolds guardrails. |
| `pk:tasks` | [`workflows/tasks.md`](./workflows/tasks.md) | Core 🧪 | `docs/tasks/` or `gh` | Decomposes specs into atomic 1-4h tasks with Gherkin AC. |
| `pk:data` | [`workflows/data.md`](./workflows/data.md) | Core 🧪 | `docs/data/` | Schema design, composite indexing, RLS policies, and migrations. |
| `pk:auth` | [`workflows/auth.md`](./workflows/auth.md) | Core 🧪 | `docs/auth/` | Cookie security flags, OAuth PKCE flows, and RBAC/ABAC capability matrix. |
| `pk:api` | [`workflows/api.md`](./workflows/api.md) | Core | `docs/api/` | Contract envelopes, cursor pagination, and mutation idempotency. |
| `pk:test` | [`workflows/test.md`](./workflows/test.md) | Core | `docs/tests/` | Testing pyramid seam allocation, data factories, and monorepo `--filter`. |
| `pk:design` | [`workflows/design-system.md`](./workflows/design-system.md) | Core | `docs/design/` | Anti-slop UI tokens, WCAG 2.2 AA accessibility, and mobile ergonomics. |
| `pk:spike` | [`workflows/research.md`](./workflows/research.md) | Core | `docs/spikes/` | Technical risk spikes comparing options against a boring baseline. |
| `pk:debug` | [`workflows/debug.md`](./workflows/debug.md) | Core 🧪 | `docs/rca/` | Scientific debugging: fast reproduction loop, tagged logs, and 5-Whys. |
| `pk:fix` | [`workflows/fix.md`](./workflows/fix.md) | New 🧪 | Code repair | Surgical remediation of known findings with security-first ordering. |
| `pk:perf` | [`workflows/perf.md`](./workflows/perf.md) | Core | `docs/perf/` | Baseline quantification, EXPLAIN ANALYZE, flamegraphs, and deltas. |
| `pk:review` | [`workflows/review.md`](./workflows/review.md) | Core | Review report | Two-axis review: Spec Fidelity vs Technical Standards (Fowler's smells). |
| `pk:commit` | [`workflows/commit.md`](./workflows/commit.md) | Core | Git history | Atomic Conventional Commits, single-concern staging, and secret scanning. |
| `pk:pr` | [`workflows/pr.md`](./workflows/pr.md) | Core | PR body / `gh pr` | Pull request descriptions with test evidence and rollback procedures. |
| `pk:ship` | [`workflows/ship.md`](./workflows/ship.md) | Core 🧪 | `docs/releases/` | Runtime env validation (Zod/T3), migration ordering, and smoke tests. |
| `pk:checkpoint` | [`workflows/checkpoint.md`](./workflows/checkpoint.md) | Core | `docs/STATE.md` | Session compaction, invariant locking, and fresh chat handover prompt. |
| `pk:retro` | [`workflows/reflect.md`](./workflows/reflect.md) | Core | `docs/adrs/` & journal | Post-feature retrospective: extracts decisions into standard MADRs. |

*Status Legend: All 20 workflows pass CI structural link validation (`validate-references.sh`). Workflows marked with 🧪 also undergo automated behavioral prompt-contract testing (`run-behavioral-contract-tests.sh`).*

---

## How the Assistant Operates

You do not need to memorize commands. You can prompt naturally (e.g., *"This checkout endpoint throws 500 errors"* or *"Design a multi-tenant user table"*), and the assistant auto-routes to the proper workflow.

### 1. Task Ceremony Levels (Level 0–3 Execution)

- **Level 0 — Direct**: Questions, explanations, doc typos, formatting, or syntax lookups. Executed directly with zero workflow ceremony or Task Record creation.
- **Level 1 — Standard**: Ordinary localized bug fixes, small self-contained features, or single-component changes modifying source files without schema/data, auth, authorization, public contract, or multi-component risks. Uses natural workflow routing (`pk:debug`, `pk:test`) with lightweight inline/`STATE.md` tracking; does NOT require a Task Record file (`docs/tasks/<task-id>.md`).
- **Level 2 — Controlled**: Work involving relational schema/data migrations, authentication, authorization, breaking public contracts, multiple components, or meaningful architectural risk. Requires a canonical Local Task Record at `docs/tasks/<task-id>.md` and formal specification (`pk:plan`, `pk:data`, `pk:auth`) before implementation.
- **Level 3 — Release-Critical**: Production releases, deployments, tag creation, or high-impact contract changes. Requires Level 2 evidence plus candidate evaluation (`pk:ship`), contract evidence, QA review, and explicit human authorization.
- External issues and board statuses remain optional references or mappings. They do not replace the Local Task Source, and a passing validator does not approve a remote action.

For authoritative Level 0–3 classification, escalation, downgrade, and Task Record rules, see [`workflows/route.md`](./workflows/route.md).

### 2. Subagent Delegation (Parallel Fan-Out)

In multi-agent environments (Antigravity, Claude Code, Cursor background agents), the assistant follows [`protocols/subagent-delegation.md`](./protocols/subagent-delegation.md):
- **Offloaded to Subagents**: Multi-candidate architectural benchmarks (`pk:spike`), dual-axis PR reviews (`pk:review`), brownfield codebase surveys (`pk:onboard`), and codebase scans touching >3 files.
- **Retained in Main Thread**: Direct developer conversation, small localized edits (<10 lines), atomic commits (`pk:commit`), and pull request submission (`pk:pr`).
- **Compact Synthesis**: Subagents return 5-15 line synthesized reports with file paths and line numbers instead of dumping raw tool output into parent context.

### 3. Native MCP Discovery & Graceful Degradation

- **Tooling Precedence**: Native MCP Tools $\rightarrow$ Terminal CLI Commands $\rightarrow$ Manual Human Prompt.
- **Auto-Discovery**: When running in MCP-capable environments (Antigravity, Cursor, Claude Desktop), the assistant automatically prioritizes structured tool calls (e.g., `github-mcp-server`) over terminal commands (`gh`), preventing terminal pager hangs.
- **Zero Lock-In Fallback**: If no MCP servers are configured, the assistant seamlessly falls back to standard terminal CLI utilities.

### 4. Standardized Human Action Callouts

- **Zero Action-Blindness**: Whenever the assistant halts a turn requiring human decision, PR review, or local actions, it terminates the message with a high-contrast `> [!IMPORTANT]` callout (`### 🛑 Action Required From You:`). If blocked, it emits `> [!WARNING]` (`### ⚠️ Blocked: Waiting on Human Input`).

---

## How Enforcement Actually Works

PromptKit is an instruction layer, not a compiler, sandbox, runtime orchestrator, or live-generation timer. Its controls have different authorities:

1. **Protocol guidance**: Workflows classify work, require readiness, define checkpoints, and preserve ownership boundaries.
2. **Optional host gating**: IDE hooks or host controls may provide prompts or tool gating when available, but capability varies by host.
3. **Durable Markdown records**: Task, checkpoint, handoff, scope-change, and evidence records preserve what happened and what must happen next.
4. **Local and CI validation**: Reference checks and execution-control validators test durable repository evidence. They are read-only and cannot observe live chat duration or forcibly terminate generation.
5. **Human approval**: People remain authoritative for scope exceptions, commits, pull requests, tags, releases, publication, deployment, and rollback.

A passing validator or CI job proves only that the recorded evidence is internally consistent. It never approves a version, authorizes a remote action, or replaces review by the owning workflow and human decision-maker.

> [!NOTE]
> PromptKit makes AI assistants **systematic and disciplined**, not mechanically deterministic. Think of it as engineering standards for a junior developer: they follow the playbook most of the time, but you still review their PRs.

### Continuous Integration & Automated Validation

Repository CI validates structural integrity and protocol compliance across Linux (Bash) and Windows (PowerShell) environments:

- **Script Syntax & Quality**: Validates Bash (`bash -n`) and PowerShell syntax for setup and validation scripts.
- **Initialization Safety & Idempotency**: Tests `init.sh` and `init.ps1` to ensure non-destructive directive updates and safe error handling on malformed markers.
- **Behavioral Prompt-Contract Tests**: Executes scenario suites verifying Level 0–3 classification, fast-path rules, Expand-Contract policy, and router consistency.
- **Execution-Control Fixtures**: Validates task and state tracker schema formatting, evidence references, and handoff contracts.
- **CI-Triage Fixtures**: Tests failure classification, remediation tracking, and diagnostic record structures.
- **Release Record Validation**: Ensures strict schema and evidence linkage compliance for release evaluation records.
- **Reference & Structural Validation**: Scans all workflow files, templates, protocols, and activities for valid cross-document links and template completeness.

---

## How PromptKit Differs from Other Tools

| Dimension | Single-File Directives | Static Prompt Packs | Autonomous Multi-Agent Swarms | **Better-PromptKit** |
| :--- | :--- | :--- | :--- | :--- |
| **Scope** | Tool-specific instruction endpoint | Workflow templates for one tool | Multi-agent unmonitored loops | Cross-tool engineering OS with 20 lifecycle workflows |
| **Token Overhead** | Minimal initial overhead | High monolithic bloat (~18k tokens inlined) | Higher aggregate token cost from multi-agent pipeline calls | **~650 tokens JIT baseline** (unused workflows consume 0 tokens) |
| **Persistence** | Per-session only | Per-session only | Hidden cache directories prone to context exhaustion | Git-tracked `docs/STATE.md` survives context resets & fresh chats |
| **Execution Model** | Unstructured chat | Manual template pasting | Background loop until timeout or crash | Disciplined human-in-the-loop pairing (Levels 0–3) |
| **Database Safety** | No schema guardrails | Varies | Risk of destructive drops in unmonitored edits | Expand-Contract only (phased, non-breaking migrations) |
| **Multi-Agent** | Single agent | Single agent | Unmonitored recursive agent spawns | Subagent delegation with compact synthesis (~98% parent context payload reduction) |
| **Done-Gates** | Trust the model | Trust the model | Fragile timeout heuristics | Artifact gates + Gherkin verification + CI + human review |
| **Lock-in** | Tool-specific format | Tool-specific format | Framework-specific runtime & daemons | Pure markdown, works with any AI coding assistant |

---

## Repository Layout

```text
better-promptkit/
├── .github/
│   └── workflows/
│       └── ci.yml               # Maintainer CI (script syntax, initialization dry-run/idempotency, workflow structure, reference validation, fixture harnesses, and behavioral-contract tests)
├── FAQ.md                       # The 12 questions every developer asks before adopting
├── QUICKSTART.md                # 5-minute introduction with 4 core workflows
├── init.ps1                     # Setup script for Windows (PowerShell)
├── init.sh                      # Setup script for Linux/macOS (Bash)
├── LICENSE                      # Open-source MIT License
├── docs/
│   ├── WORKFLOW-MAP.md          # Visual decision trees and Mermaid diagrams
│   ├── ADOPTION-GUIDE.md        # Incremental adoption for existing projects
│   ├── INTERESTING-FACTS.md     # Unique insights and design principles
│   └── DESIGN-MD-FAQ.md         # FAQ on custom DESIGN.md usage & safety
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
│   ├── state-tracker-template.md   # Scaffolds docs/STATE.md as a synchronized projection
│   ├── execution-task-record-template.md # Canonical Controlled Work Task Record
│   ├── friction-evaluation-template.md    # Adaptation friction evaluation & improvement
│   ├── execution-scope-change-template.md # Approved scope expansion/change record
│   ├── execution-handoff-template.md # Receiver-validated session or role handoff
│   ├── data-model-spec.md          # Relational schema & RLS specification
│   ├── auth-matrix-template.md     # Auth architecture & RBAC capability matrix
│   ├── api-contract-spec.md        # API endpoint contract & error code catalog
│   ├── test-plan-template.md       # Upfront test strategy & pyramid seam specification
│   ├── release-checklist.md        # Release engineering & zero-downtime deploy checklist
│   ├── release-evaluation-template.md # Release candidate evaluation & approval
│   ├── ci-triage-template.md       # CI classification & remediation tracking
│   ├── contract-impact-evidence-template.md # Contract impact evidence & breaking guidance
│   ├── pull-request-template.md    # High-signal Pull Request description & safety checklist
│   ├── github-issue-template.md    # Standardized native GitHub issue template (.github/ISSUE_TEMPLATE/task.md)
│   ├── perf-audit-template.md      # Performance audit report & before/after delta spec
│   ├── issue-task-template.md      # Staff-level GitHub Issue template with Gherkin AC
│   ├── adr-template.md             # MADR standard Architectural Decision Record
│   ├── tech-spec-template.md       # Engineering RFC / Technical Specification
│   ├── rca-postmortem-template.md  # Blameless Post-Mortem & Incident RCA
│   ├── code-review-checklist.md    # Senior Developer PR Review Checklist
│   ├── design-tokens-spec.md       # Design System & Token Specification
│   └── spike-template.md           # Technical Spike & Benchmark Evaluation Template
├── examples/                    # Real-world production examples
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
├── scripts/                     # Validation and maintenance utilities
│   ├── setup-github-labels.sh          # Bash: Provision standardized GitHub labels (priority, type, area)
│   ├── setup-github-labels.ps1         # PowerShell: Provision standardized GitHub labels (priority, type, area)
│   ├── validate-references.sh          # Bash: Check all workflow→template references
│   ├── validate-references.ps1         # PowerShell: Check all workflow→template references
│   ├── validate-execution-control.sh   # Bash: Read-only Task/STATE evidence validator
│   ├── validate-execution-control.ps1  # PowerShell: Read-only Task/STATE evidence validator
│   ├── validate-ci-triage.sh           # Bash: CI classification record validator
│   ├── validate-ci-triage.ps1          # PowerShell: CI classification record validator
│   ├── validate-release-records.sh     # Bash: Release evaluation & approval validator
│   ├── validate-release-records.ps1    # PowerShell: Release evaluation & approval validator
│   └── tests/run-execution-control-fixtures.* # Paired regression and isolated fixture harnesses
└── activities/                  # Interactive simulation katas & system design drills
    ├── README.md                   # Interactive simulation catalog
    ├── 01-system-design-spike.md         # High-throughput webhook engine design
    ├── 02-refactoring-clean-arch.md      # Refactoring monolith to Clean Architecture
    ├── 03-async-concurrency-debug.md     # Concurrency race conditions & memory leaks
    ├── 04-accessible-design-system.md    # Accessible, tokenized component library
    └── create-research-workflow.md       # Create custom research workflow templates
```

---

## Customizing Your Project: The 3 Living Files

Better-PromptKit keeps universal workflows separated from your repository's specific rules through three living files:

### 1. `PROMPTKIT.md` (Engineering Guardrails & Stack Constraints)
Scaffolded automatically during initialization from `templates/project-profile-template.md`. This file tells the assistant your project's non-negotiable boundaries:
* **Project Domain & Users**: Contextual overview so the assistant grasps business context.
* **Active Commands**: Explicit test runner (`pnpm test:e2e`), typecheck (`pnpm tsc --noEmit`), and linter commands.
* **Pluggable Task Tracking**: Configurable task tracking system (`Local Markdown`, `GitHub Issues`, `GitHub Projects v2`, `Obsidian Kanban`, `Linear`, or `Jira`) with zero vendor lock-in.
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

### 3. `docs/STATE.md` (Synchronized Project State Projection)
Scaffolded automatically during initialization from `templates/state-tracker-template.md`. `docs/STATE.md` is a synchronized projection maintained by `pk:checkpoint`, not a competing task source. For Controlled Work, the canonical `docs/tasks/<task-id>.md` Task Record remains authoritative; external issues, dated breakdowns, and conversational claims are supporting references only.
* **Current Position & Milestone**: Active epic, overall health and status (`ACTIVE`, `BLOCKED`, `STABILIZING`), target release, and current working branch.
* **Progress Tracking**: Hierarchical checklist with atomic task status (`[x]` Done, `[/]` In Progress, `[ ]` Queued, `[!]` Blocked).
* **Locked Architectural Invariants**: Non-negotiable decisions made during pairing sessions that future sessions must not regress.
* **Session Continuity**: Updated by `pk:checkpoint`, `pk:tasks`, and `pk:onboard` to eliminate AI context degradation and maintain persistent memory across fresh chats.

---

## Host & External Tool Composition

Better-PromptKit coexists cleanly with host-specific instruction files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`), external skill libraries (such as `skills.sh`), host `/skill` commands, and complementary specification systems (Spec Kit, BMad).

### Authority & Governance Boundary

- **Specialized Assistance**: External skills and host tools provide domain-specific knowledge, code generation assistance, or specialized refactoring helpers.
- **PromptKit Authority**: Better-PromptKit remains authoritative for **Level 0–3 task classification**, lifecycle routing, required verification evidence, Task Record requirements, release boundaries, and human authorization.
- **Non-Bypass Rule**: External skills must act as subordinate helpers. They must **never** silently commit, push, merge, tag, publish, deploy, or bypass required verification gates.
- **Behavioral Variation**: Host agents enforce instructions with varying degrees of fidelity. Better-PromptKit provides protocol standards, but host enforcement depends on the AI agent host.

### Host Compatibility Matrix

| Environment / Tool | Configuration Integration | Repo / CI Validation | Actual Host Behavior Verification |
| :--- | :---: | :---: | :---: |
| **Claude Code** | ✅ `CLAUDE.md` | ✅ CI Syntax & Reference Checks | ⚠️ Dependent on Claude Code runtime |
| **Antigravity / Gemini CLI** | ✅ `AGENTS.md` / `GEMINI.md` | ✅ CI Behavioral Contract Tests | ⚠️ Dependent on Gemini runtime |
| **Cursor IDE** | ✅ `.cursorrules` / `.cursor/rules/` | ✅ CI Syntax & Reference Checks | ⚠️ Dependent on Cursor Agent runtime |
| **Windsurf IDE** | ✅ `.windsurfrules` | ✅ CI Syntax & Reference Checks | ⚠️ Dependent on Cascade runtime |
| **GitHub Copilot** | ✅ `.github/copilot-instructions.md` | ✅ CI Syntax & Reference Checks | ⚠️ Dependent on Copilot runtime |
| **Aider** | ✅ `CONVENTIONS.md` | ✅ CI Syntax & Reference Checks | ⚠️ Dependent on Aider runtime |
| **External Skills (skills.sh / `/skill`)** | ✅ Subordinate helper rules | ✅ Reference Checks | ⚠️ Execution varies by skill implementation |

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
