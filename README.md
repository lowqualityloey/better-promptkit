# Better-PromptKit: Senior Engineering AI Operating System

[![Standard: Senior Developer](https://img.shields.io/badge/Standard-Senior%20%2F%20Staff%20Engineer-purple.svg)](#)
[![Pedagogy: Socratic Mentorship](https://img.shields.io/badge/Pedagogy-Socratic%203--Tier%20Hints-blue.svg)](#)
[![Triggers: Conflict--Free](https://img.shields.io/badge/Triggers-Namespace%20pk%3A-brightgreen.svg)](#)
[![Design: WCAG 2.2 AA & Tokens](https://img.shields.io/badge/Design-WCAG%202.2%20AA%20%2B%20Tokens-green.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Ecosystem: Multi-Agent](https://img.shields.io/badge/Ecosystem-Claude%20%7C%20Gemini%20%7C%20Cursor%20%7C%20Copilot%20%7C%20Windsurf-orange.svg)](#)

**Better-PromptKit** is a production-grade **AI Engineering, Mentorship, and Reflection Framework** designed to bridge the gap between junior exploratory coding and Senior/Staff-level software craftsmanship.

It equips your AI coding assistant (Antigravity, Claude Code, Gemini CLI, Cursor, Windsurf, Copilot, Aider) with structured engineering protocols, spec-driven workflows, Socratic mentorship rules, and retrospective knowledge management—**without polluting your codebase or colliding with your IDE's native slash commands**.

---

## 🏛️ System Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                BETTER-PROMPTKIT ECOSYSTEM                               │
├──────────────────────────┬───────────────────────────────┬──────────────────────────────┤
│ 📋 PROTOCOLS             │ ⚡ SENIOR WORKFLOWS            │ 🗂️ TEMPLATES & PROFILES      │
│ - Universal Setup        │ - Socratic Tutor (pk:tutor)   │ - MADR Architecture Records  │
│ - Context Sync           │ - Staff Drill (pk:grill)      │ - RFC Technical Specs        │
│ - Quality Gate (DoD)     │ - Spec-Driven Plan (pk:plan)  │ - Blameless Post-Mortems     │
│ - Project Profile        │ - Senior Review (pk:review)   │ - Senior PR Checklists       │
│                          │ - Scientific Debug (pk:debug) │ - Design Tokens Specification│
│                          │ - Tech Spikes (pk:spike)      │ - Project Profile Template   │
│                          │ - Design System (pk:design)   │                              │
│                          │ - Retro & Reflect (pk:retro)  │                              │
├──────────────────────────┴───────────────────────────────┴──────────────────────────────┤
│ 📂 HOST PROJECT INTEGRATION LAYER                                                       │
│ - Engine: .promptkit/ (Workflows & Protocols) │ - Config: ./PROMPTKIT.md (Guardrails)   │
│ - Documentation: ./docs/adrs/, ./docs/specs/, ./docs/rca/, ./docs/spikes/ (Tracked in Git)│
├─────────────────────────────────────────────────────────────────────────────────────────┤
│ 🧠 DEVELOPER KNOWLEDGE BASE & LABS                                                      │
│ - Competency Matrix (Junior → Staff) │ - Progressive Retrospective Journal & OKRs       │
│ - Interactive Simulations (Distributed Systems, Concurrency Debugging, Clean Arch)      │
│ - Real-World Reference Examples (Drizzle, Supabase Auth, TanStack Router)               │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start Guide

You can integrate Better-PromptKit into any project in under 30 seconds using either a Git Submodule or a direct clone.

### Option A: As a Git Submodule (Recommended)
Keeps Better-PromptKit cleanly linked to upstream updates without dirtying your project's commit history:
```bash
# Inside your project root:
git submodule add https://github.com/lowqualityloey/better-promptkit .promptkit
```

### Option B: As a Direct Clone / Template Copy
```bash
# Inside your project root:
git clone https://github.com/lowqualityloey/better-promptkit .promptkit
```

---

### Initialize with 1 Click

Run the zero-dependency initialization script for your platform:

**Windows (PowerShell):**
```powershell
.\.promptkit\init.ps1
```

**Linux / macOS (Bash):**
```bash
./.promptkit/init.sh
```

**Or via Conversational AI:**
Simply tell your assistant:
> *"Read `.promptkit/protocols/setup.md` to initialize Better-PromptKit in this workspace."*

#### What Initialization Does Automatically:
1. Detects your active AI editor/CLI (`CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`).
2. Injects conflict-free `pk:` triggers and senior engineering protocols.
3. Scaffolds a project profile (`PROMPTKIT.md`) where you can set tech stack overrides and non-negotiables.
4. Creates host project documentation folders (`./docs/adrs/`, `./docs/specs/`, `./docs/rca/`, `./docs/spikes/`) so your architectural artifacts are tracked in your project's Git repository.

---

## ⚡ Fast Shorthand Triggers (Collision-Free)

All Better-PromptKit triggers use the `pk:` namespace prefix to ensure **zero collisions** with Antigravity, Cursor, or IDE native slash commands (`/grill-me`, `/goal`, `/schedule`, etc.):

| Command Trigger | Purpose & Senior Engineering Bar | Output Artifact Path |
| :--- | :--- | :--- |
| `pk:tutor` | Socratic 3-tier progressive hints (Mental model $\rightarrow$ Architecture $\rightarrow$ Micro-snippet). Never dumps unsolicited code. | Personal second brain |
| `pk:tutor beginner` | Low-friction Socratic coaching with plain-English analogies and immediate error translation. | Personal second brain |
| `pk:tutor architect` | Invariant stress-testing, failure mode analysis, and distributed system trade-offs. | `docs/adrs/` |
| `pk:grill` | Intensive Staff Engineer interview & defense drill (devil's advocate probing). | Verbal defense / journal |
| `pk:plan` | Spec-Driven Development (SDDD): defines domain boundaries, schema validation, and PR breakdown. | `docs/specs/` |
| `pk:review` | Senior PR audit: categorized into `[BLOCKING]`, `[IMPORTANT]`, `[SUGGEST]`, `[PRAISE]`. | Review debrief / report |
| `pk:debug` | Hypothesis-driven scientific debugging, reproduction isolation, and 5-Why RCA. | `docs/rca/` |
| `pk:spike` | Technical research spikes, benchmarks, and multi-vector trade-off matrices. | `docs/spikes/` |
| `pk:design` | Modern tokenized UI (Tailwind v4), headless primitives (Radix/Aria), and WCAG 2.2 AA. | `docs/design/` |
| `pk:retro` | Post-coding retrospective: captures trade-offs, scaffolds ADRs, and logs progress. | `docs/adrs/` & journal |

---

## 📁 Repository Layout

```text
better-promptkit/
├── init.ps1                     # 1-Click setup script for Windows (PowerShell)
├── init.sh                      # 1-Click setup script for Linux/macOS (Bash)
├── LICENSE                      # Open-source MIT License
├── protocols/
│   ├── setup.md                 # Universal multi-agent configuration protocol
│   ├── context-sync.md          # Tech stack, PROMPTKIT.md & git auto-detection
│   └── code-quality-gate.md     # Non-negotiable definition-of-done & pre-commit gate
├── workflows/
│   ├── tutor.md                 # Socratic mentorship & 3-tier progressive hints (pk:tutor, pk:grill)
│   ├── plan.md                  # Spec-Driven Development (SDDD) & RFC design (pk:plan)
│   ├── review.md                # Senior multi-dimensional PR & architecture review (pk:review)
│   ├── debug.md                 # Hypothesis-driven debugging & root cause analysis (pk:debug)
│   ├── research.md              # Technical spikes & trade-off evaluation matrix (pk:spike)
│   ├── design-system.md         # UI/UX, Design Tokens, and WCAG 2.2 accessibility (pk:design)
│   └── reflect.md               # Deep engineering retrospectives & ADR generation (pk:retro)
├── templates/
│   ├── project-profile-template.md # Scaffolds PROMPTKIT.md for custom project guardrails
│   ├── adr-template.md          # MADR standard Architectural Decision Record
│   ├── tech-spec-template.md    # Engineering RFC / Technical Specification
│   ├── rca-postmortem-template.md # Blameless Post-Mortem & Incident RCA
│   ├── code-review-checklist.md # Senior Developer PR Review Checklist
│   └── design-tokens-spec.md    # Modern Design System & Token Specification
├── examples/
│   ├── sample-progress-journal.md # Real-world retrospective entries (Shelf full-stack app)
│   └── sample-learning-plan.md    # Real-world engineering OKRs & mental model notes
├── notes/
│   ├── README.md                # Second Brain knowledge management guide
│   ├── learning-plan.md         # Blank template for engineering OKRs & practice katas
│   ├── progress-journal.md      # Blank template for progressive retro logs
│   ├── skill-matrix.md          # Software Engineering Competency Matrix (L1 → L4)
│   ├── adrs/                    # Local ADR directory (for standalone vault mode)
│   └── spikes/                  # Local Spikes directory (for standalone vault mode)
└── activities/
    ├── README.md                # Interactive simulation catalog
    ├── 01-system-design-spike.md      # High-throughput webhook engine design
    ├── 02-refactoring-clean-arch.md   # Refactoring monolith to Clean Architecture
    ├── 03-async-concurrency-debug.md  # Concurrency race conditions & memory leaks
    └── 04-accessible-design-system.md # Accessible, tokenized component library
```

---

## 🎯 The 3 Pedagogical Pillars of Better-PromptKit

### 1. 3-Tier Progressive Hinting
Better-PromptKit prevents the cognitive erosion caused by indiscriminate AI code-copying. It delivers guidance in 3 graduated tiers:
- **Tier 1 (Mental Model)**: Concept diagrams, data flow, and Socratic questions.
- **Tier 2 (Structural Blueprint)**: State machines, interface contracts, and pseudocode logic.
- **Tier 3 (Targeted Micro-Snippet)**: Minimal 3-5 line syntax demonstration of edge cases; the engineer writes the actual implementation.

### 2. Spec-Driven Engineering
Senior engineers design contracts and consider failure modes before writing implementations. The `pk:plan` workflow establishes domain boundaries, database schemas, and threat vectors upfront.

### 3. Separation of Engine and Project History
Workflows output project artifacts directly into your project's `./docs/` folder (`./docs/adrs/`, `./docs/specs/`, `./docs/rca/`), ensuring your team's architectural decisions are preserved in your project's Git repository while `.promptkit/` remains an independent engine.

---

## 🛠️ Multi-Agent Compatibility Table

| AI Environment | Setup File Generated | Trigger Syntax |
| :--- | :--- | :--- |
| **Antigravity / Gemini CLI** | `AGENTS.md` / `GEMINI.md` | `pk:tutor`, `pk:plan`, `pk:review` |
| **Claude Code** | `CLAUDE.md` | `claude` (reads CLAUDE.md automatically) |
| **Cursor IDE** | `.cursorrules` / `.cursor/rules/` | Cursor Agent automatically references rules |
| **Windsurf IDE** | `.windsurfrules` | Cascade auto-detects rules |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Copilot Chat automatically references instructions |
| **Aider** | `CONVENTIONS.md` | `aider --read .promptkit/workflows/tutor.md` |

---

## 📄 License
Released under the [MIT License](./LICENSE). Created by [Jonel (lowqualityloey)](https://github.com/lowqualityloey).
