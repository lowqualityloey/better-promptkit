# Better PromptKit

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
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

## Fast Shorthand Triggers

All triggers use the `pk:` prefix to avoid collisions with native slash commands in Antigravity or Cursor:

| Command | Purpose | Output Location |
| :--- | :--- | :--- |
| `pk:tutor` | Socratic mentorship using 3-tier progressive hints. Guides the developer instead of dumping unsolicited code. | Conversation / Notes |
| `pk:tutor beginner` | Socratic coaching with plain-language explanations and immediate error translation. | Conversation / Notes |
| `pk:tutor architect` | Invariant stress-testing, failure mode analysis, and distributed systems trade-offs. | `docs/adrs/` |
| `pk:grill` | Staff-level architecture defense drill challenging assumptions and edge cases. | Conversation / Notes |
| `pk:plan` | Spec-driven architecture: deep module design, Expand-Contract zero-downtime database migrations, and TDD milestones. | `docs/specs/` |
| `pk:review` | Two-axis review: Spec Fidelity vs. Technical Standards (Martin Fowler's 12 code smells), with data loss prevention audits. | Review report |
| `pk:debug` | Scientific debugging: 10-tier feedback loop hierarchy, "no red loop, no Phase 2" gate, tagged logs (`[DEBUG-xxxx]`), and 5-Whys. | `docs/rca/` |
| `pk:data` | Relational database design: primary keys, composite indexing, Row-Level Security (RLS) policies, and transaction boundaries. | `docs/data/` |
| `pk:auth` | Authentication architecture: cookie security (HttpOnly, SameSite), OAuth PKCE, session management, and RBAC/ABAC matrices. | `docs/auth/` |
| `pk:api` | Frontend-backend handshake: unified error envelopes, cursor/offset pagination, mutation idempotency, and contract types. | `docs/api/` |
| `pk:test` | Upfront testing strategy: pyramid seam allocation (Unit vs. Real DB vs. E2E), modular data factories, and mock boundaries. | `docs/tests/` |
| `pk:ship` | Release engineering: fail-fast runtime env checks (Zod/T3), Expand-Contract migration ordering, smoke tests, and rollbacks. | `docs/releases/` |
| `pk:spike` | Technical research spikes: tests the sharpest risk first, compares against the boring baseline, with direct ADR export. | `docs/spikes/` |
| `pk:design` | UI design: anti-slop guidelines, WCAG 2.2 AA contrast/keyboard compliance, React runtime performance, and `DESIGN.md` brand tokens. | `docs/design/` |
| `pk:retro` | Post-implementation retrospective: extracts architectural decisions into MADRs and logs progress. | `docs/adrs/` & journal |

---

## Repository Layout

```text
better-promptkit/
├── init.ps1                     # Setup script for Windows (PowerShell)
├── init.sh                      # Setup script for Linux/macOS (Bash)
├── LICENSE                      # Open-source MIT License
├── protocols/
│   ├── setup.md                 # Universal multi-agent configuration protocol
│   ├── context-sync.md          # Tech stack, PROMPTKIT.md, DESIGN.md & git auto-detection
│   └── code-quality-gate.md     # Non-negotiable definition-of-done & pre-commit gate
├── workflows/
│   ├── tutor.md                 # Socratic mentorship & 3-tier progressive hints (pk:tutor, pk:grill)
│   ├── plan.md                  # Spec-Driven Development & deep modular design (pk:plan)
│   ├── review.md                # Two-axis PR & Fowler smell review with data safety audit (pk:review)
│   ├── debug.md                 # Empirical feedback-loop debugging & root cause analysis (pk:debug)
│   ├── data.md                  # Relational schema design, composite indexes & RLS (pk:data)
│   ├── auth.md                  # Authentication, cookie security & RBAC/ABAC (pk:auth)
│   ├── api.md                   # API contracts, error envelopes & idempotency (pk:api)
│   ├── test.md                  # Upfront test strategy, seam allocation & mock boundaries (pk:test)
│   ├── ship.md                  # Release engineering, runtime env checks & rollbacks (pk:ship)
│   ├── research.md              # Technical spikes & sharpest-risk benchmark matrix (pk:spike)
│   ├── design-system.md         # Anti-slop UI, Design Tokens, and WCAG 2.2 accessibility (pk:design)
│   └── reflect.md               # Engineering retrospectives & ADR generation (pk:retro)
├── templates/
│   ├── project-profile-template.md # Scaffolds PROMPTKIT.md for custom project guardrails
│   ├── design-profile-template.md  # Scaffolds DESIGN.md for brand identity & visual tokens
│   ├── data-model-spec.md          # Relational schema & RLS specification
│   ├── auth-matrix-template.md     # Auth architecture & RBAC capability matrix
│   ├── api-contract-spec.md        # API endpoint contract & error code catalog
│   ├── test-plan-template.md       # Upfront test strategy & pyramid seam specification
│   ├── release-checklist.md        # Release engineering & zero-downtime deploy checklist
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
