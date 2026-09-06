# Universal Agent Setup Protocol

## Purpose
Ensure any modern AI coding assistant or CLI (Antigravity, Claude Code, Gemini CLI, Cursor, Windsurf, GitHub Copilot, Aider, Roo Code) is equipped with Better-PromptKit's workflows, protocols, and senior engineering standards by updating the appropriate root briefing configuration file.

---

## Supported AI Ecosystem Files

| Assistant / Environment | Configuration Target File |
| :--- | :--- |
| **Claude Code** | `CLAUDE.md` |
| **Gemini CLI / Antigravity** | `GEMINI.md` or `AGENTS.md` |
| **Cursor IDE** | `.cursorrules` or `.cursor/rules/promptkit.mdc` |
| **Windsurf IDE** | `.windsurfrules` |
| **GitHub Copilot** | `.github/copilot-instructions.md` |
| **Aider / Open-Source Agents** | `CONVENTIONS.md` or `AGENTS.md` |

---

## Preconditions
1. Better-PromptKit is located in `.promptkit/` (recommended) or `promptkit/` relative to the workspace root.
2. Standard shell utilities or file tools are available.

If no known agent configuration file exists in the repository root, create `AGENTS.md` as the universal standard fallback.

---

## Execution Steps

### 1. Identify Workspace & Configuration Files
Inspect the repository root for existing agent configuration files:
- Check for: `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, `.cursorrules`, `.cursor/rules/`, `.windsurfrules`, `.github/copilot-instructions.md`.
- If none exist, default to creating `./AGENTS.md`.

### 2. Verify Existing Integration
Check if the target configuration file already contains `PromptKit Engineering Operating System` or `<!-- PROMPTKIT_START -->`:
- If the configuration is already present and up to date, report status to the developer and transition immediately to active session mode.
- If missing or outdated, proceed to Step 3.

### 3. Ensure Project Documentation Directories Exist
Ensure the host repository contains documentation directories so generated artifacts are tracked by Git:
- `docs/adrs/` — Architectural Decision Records
- `docs/specs/` — Technical RFC Specifications
- `docs/rca/` — Root Cause Analysis Incident Post-Mortems
- `docs/spikes/` — Technical Spikes & Benchmarks
- `docs/design/` — Design Token Specs & UI Architecture
- `docs/data/` — Database Models & Schema Specifications
- `docs/auth/` — Authentication & Authorization Matrices
- `docs/api/` — API Contracts & Error Specifications

If `PROMPTKIT.md` does not exist in the project root, copy `.promptkit/templates/project-profile-template.md` to `./PROMPTKIT.md` for project-specific rules and commands. If `DESIGN.md` is desired for custom visual identity, copy `.promptkit/templates/design-profile-template.md` to `./DESIGN.md`.

### 4. Inject PromptKit Core Directives
Append or merge the following directive block into the detected configuration file(s):

```markdown
<!-- PROMPTKIT_START -->
## Better-PromptKit Engineering Operating System
Better-PromptKit is active in this workspace (`./.promptkit` or `./promptkit`). Follow these protocols, workflows, and quality gates during pair-programming, design, code generation, and review:

### Fast Shorthand Triggers (Collision-Free)
Activate workflows anytime with these namespaced triggers:
- `pk:tutor` (or `pk:tutor beginner`, `pk:tutor architect`) — Socratic mentorship & 3-tier progressive hints (never dump unsolicited code).
- `pk:grill` — Intensive Staff Engineer architecture interview and defense drill.
- `pk:plan` — Spec-Driven Architecture & feature planning (domain models, API contracts, failure modes).
- `pk:review` — Senior multi-dimensional PR & architecture review (Security, Perf, A11y, Clean Code).
- `pk:debug` — Hypothesis-driven scientific debugging & root cause analysis (5-Whys).
- `pk:data` (or `pk:db`) — Relational database modeling, indexing strategies, RLS, and transaction boundaries.
- `pk:auth` — Authentication flows, cookie security, session management, and RBAC/ABAC matrices.
- `pk:api` — Frontend-backend handshake, unified error envelopes, and contract generation.
- `pk:spike` (or `pk:research`) — Technical spikes, benchmarks, and multi-vector trade-off matrices.
- `pk:design` — Modern UI/UX, Design Tokens, and WCAG 2.2 Level AA accessibility.
- `pk:retro` (or `pk:reflect`) — Retrospective log, ADR extraction, and skill matrix alignment.

### Workflows & Protocols Reference
- **Tutor**: `.promptkit/workflows/tutor.md`
- **Plan**: `.promptkit/workflows/plan.md`
- **Review**: `.promptkit/workflows/review.md`
- **Debug**: `.promptkit/workflows/debug.md`
- **Data**: `.promptkit/workflows/data.md`
- **Auth**: `.promptkit/workflows/auth.md`
- **API**: `.promptkit/workflows/api.md`
- **Research**: `.promptkit/workflows/research.md`
- **Design System**: `.promptkit/workflows/design-system.md`
- **Reflect**: `.promptkit/workflows/reflect.md`
- **Quality Gate (DoD)**: `.promptkit/protocols/code-quality-gate.md`
- **Context Sync**: `.promptkit/protocols/context-sync.md`
- **Project Profile & Rules**: `./PROMPTKIT.md` (if present)
- **Visual Identity & Brand**: `./DESIGN.md` (if present)

### Project Artifact Output Paths
All generated project documentation must be saved to the host project:
- ADRs: `docs/adrs/`
- Technical Specs: `docs/specs/`
- Post-Mortems: `docs/rca/`
- Spikes: `docs/spikes/`
- Design Specs: `docs/design/`
- Data Models: `docs/data/`
- Auth Specs: `docs/auth/`
- API Contracts: `docs/api/`
<!-- PROMPTKIT_END -->
```

### 5. Initialize Context & Welcome Developer
After updating configuration:
1. Run `.promptkit/protocols/context-sync.md` to detect active technologies, inspect `./PROMPTKIT.md`, and check recent git status.
2. Ask the developer which workflow they wish to activate:
   - `[pk:tutor]` — Explore a concept, debug together, or build mental models.
   - `[pk:plan]` — Design an architecture, draft an RFC/spec, or break down a feature.
   - `[pk:review]` — Conduct a Senior-level code & architecture audit on recent changes.
   - `[pk:debug]` — Perform systematic root cause analysis on a defect.
   - `[pk:data]` — Design relational schemas, indexes, and RLS policies.
   - `[pk:auth]` — Architect authentication, cookies, and RBAC matrices.
   - `[pk:api]` — Define frontend-backend contracts and error envelopes.
   - `[pk:spike]` — Run a technical spike comparing libraries/patterns.
   - `[pk:design]` — Design accessible UI components with modern tokens.
   - `[pk:retro]` — Run a retro on completed work, capture insights, and generate ADRs.

---

## Completion Criteria
- Root agent file (`CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, or `.cursorrules`) contains valid Better-PromptKit pointers.
- Project `docs/` directories are initialized.
- The assistant is oriented to use `pk:` triggers, Socratic rules, and senior engineering workflows.
