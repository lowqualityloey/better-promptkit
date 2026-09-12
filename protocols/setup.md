# Universal Agent Setup Protocol

## Purpose
Ensure any modern AI coding assistant or CLI (Antigravity, Claude Code, Gemini CLI, Cursor, Windsurf, GitHub Copilot, Aider, Roo Code) is equipped with PromptKit OS workflows, protocols, and senior engineering standards by updating the appropriate root briefing configuration file.

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
1. PromptKit OS is located in `.promptkit/` (recommended) or `promptkit/` relative to the workspace root.
2. Standard shell utilities or file tools are available.

If no known agent configuration file exists in the repository root, create `AGENTS.md` as the universal standard fallback.

---

## Execution Steps

### 1. Identify Workspace & Configuration Files
Inspect the repository root for existing agent configuration files:
- Check for: `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, `.cursorrules`, `.cursor/rules/`, `.windsurfrules`, `.github/copilot-instructions.md`.
- If none exist, default to creating `./AGENTS.md`.

### 2. Verify Existing Integration
Check if the target configuration file already contains `PromptKit OS: Engineering Operating System` or `<!-- PROMPTKIT_START -->`:
- If the configuration is already present and up to date, report status to the developer and transition immediately to active session mode.
- If missing or outdated, proceed to Step 3.

### 3. Ensure Project Documentation Directories Exist
Ensure the host repository contains documentation directories so generated artifacts are tracked by Git:
- `docs/adrs/`: Architectural Decision Records
- `docs/specs/`: Technical RFC Specifications
- `docs/rca/`: Root Cause Analysis Incident Post-Mortems
- `docs/spikes/`: Technical Spikes & Benchmarks
- `docs/design/`: Design Token Specs & UI Architecture
- `docs/data/`: Database Models & Schema Specifications
- `docs/auth/`: Authentication & Authorization Matrices
- `docs/api/`: API Contracts & Error Specifications
- `docs/tests/`: Test Plans, Seam Allocations & Test Matrices
- `docs/perf/`: Performance Audits, Query Execution Plans & Profiling Reports
- `docs/tasks/`: Task Breakdowns, Issue Drafts & Milestone Trackers
- `docs/releases/`: Release Checklists, Rollback Decision Logs & Verification Reports

If `PROMPTKIT.md` does not exist in the project root, copy `.promptkit/templates/project-profile-template.md` to `./PROMPTKIT.md` for project-specific rules and commands. If `DESIGN.md` is desired for custom visual identity, copy `.promptkit/templates/design-profile-template.md` to `./DESIGN.md`. If `docs/STATE.md` does not exist, copy `.promptkit/templates/state-tracker-template.md` to `./docs/STATE.md` for living project state tracking.

### 4. Inject PromptKit Core Directives
Append or merge the following directive block into the detected configuration file(s):

```markdown
<!-- PROMPTKIT_START -->
## PromptKit OS: Engineering Operating System
PromptKit OS is active in this workspace (`./.promptkit` or `./promptkit`). Follow these protocols, workflows, and quality gates during pair-programming, design, code generation, and review:

### Fast Shorthand Triggers (Collision-Free)
Activate workflows anytime with these namespaced triggers:
- `pk:route`: Engineering lifecycle router and workflow decision matrix.
- `pk:tutor` (or `pk:tutor beginner`, `pk:tutor architect`): Socratic mentorship & 3-tier progressive hints (avoids unsolicited code dumps).
- `pk:grill`: Intensive Staff Engineer architecture interview and defense drill.
- `pk:plan`: Spec-Driven Architecture & feature planning (domain models, API contracts, failure modes).
- `pk:onboard`: Brownfield codebase intake: scan repository, extract scripts, and auto-populate PROMPTKIT.md.
- `pk:tasks` (or `pk:issue`, `pk:kanban`): Decompose RFC specs into atomic GitHub issues with Gherkin Acceptance Criteria and Kanban sync.
- `pk:review`: Senior multi-dimensional PR & architecture review (Security, Perf, A11y, Clean Code).
- `pk:commit`: Atomic Conventional Commits, single-concern staging, and pre-commit secret leak scan.
- `pk:pr`: High-signal PR descriptions, verification evidence compilation, data safety checklist, and GitHub CLI creation.
- `pk:debug`: Hypothesis-driven scientific debugging & root cause analysis (5-Whys).
- `pk:perf` (or `pk:profile`): Empirical performance profiling, latency SLAs, EXPLAIN ANALYZE, and delta verification.
- `pk:data` (or `pk:db`): Relational database modeling, indexing strategies, RLS, and transaction boundaries.
- `pk:auth`: Authentication flows, cookie security, session management, and RBAC/ABAC matrices.
- `pk:api`: Frontend-backend handshake, unified error envelopes, and contract generation.
- `pk:test`: Upfront testing strategy, seam allocation, and mock boundaries.
- `pk:ship`: Release engineering, migration sequencing, runtime env checks, and rollbacks.
- `pk:spike` (or `pk:research`): Technical spikes, benchmarks, and multi-vector trade-off matrices.
- `pk:design`: Modern UI/UX, Design Tokens, and WCAG 2.2 Level AA accessibility.
- `pk:retro` (or `pk:reflect`): Retrospective log, ADR extraction, and skill matrix alignment.
- `pk:checkpoint` (or `pk:handoff`): Session state compaction, invariant locking, docs/STATE.md update, and fresh chat handover prompt.

### Task Ceremony Levels & Smart Auto-Route
PromptKit OS adapts ceremony based on task risk and impact:
- **Level 0 (Direct / Zero Overhead)**: Trivial documentation fixes, syntax lookups, formatting, or single-line tweaks. Direct execution (`understand → change → verify`) with zero ceremony.
- **Level 1 (Standard)**: Localized bug fixes or small self-contained features. Standard workflow execution (`pk:debug`, `pk:test`) with lightweight inline planning; no formal task record file required.
- **Level 2 (Controlled)**: Architecture, relational data/schema migrations, auth, permissions, breaking public API contracts, or multi-component changes. Requires formal Task Record (`docs/tasks/<task-id>.md`) and spec (`pk:plan`, `pk:data`, `pk:auth`, `pk:api`).
- **Level 3 (Release-Critical)**: Production releases, deployments, high-impact contract changes, or tag generation. Requires full candidate evaluation (`pk:ship`), QA review, and explicit human authorization.

For authoritative Level 0–3 classification, escalation, downgrade, and Task Record rules, see [`workflows/route.md`](../workflows/route.md).

- **Anti-Slop Output**: Deliver all status updates, plans, and diff explanations in structured, scannable markdown (tables, checklists, short bullet points). Never output unstructured conversational essay walls.
- **Absolute Secret Hygiene**: Never output, request, or paste raw secrets/keys in chat; mandate `.env.example` templates and local `.env`.
- **Native MCP Tooling Discovery**: Auto-detect active MCP servers (e.g. GitHub MCP) and prioritize structured MCP tool calls over shell commands. Fall back gracefully to standard CLI (`gh`, `git`) when MCP is absent.
- **Standardized Human Action Callouts**: Whenever halting a turn for user decision, review, or local actions (e.g. merging PRs, populating `.env`), end the response with a `> [!IMPORTANT]` callout titled `### 🛑 Action Required From You:`. If blocked, use `> [!WARNING]` titled `### ⚠️ Blocked: Waiting on Human Input`.

When auto-routing:
  - Defects, bugs, crashes, or test failures -> `pk:debug` (reproduce before patching)
  - Performance regressions, slow queries, or latency -> `pk:perf` (measure baseline first)
  - New features, redesigns, or multi-component additions -> `pk:plan` (spec and risk analysis first)
  - Existing repo intake, setup, or codebase audit -> `pk:onboard` (scan repo and scaffold PROMPTKIT.md)
  - Task breakdowns, issue creation, or Kanban cards -> `pk:tasks` (atomic issues and Gherkin AC)
  - Database schema, indexing, or migrations -> `pk:data` (Expand-Contract phased ordering)
  - Auth, sessions, cookies, or RBAC -> `pk:auth` (threat model and capability matrix)
  - Endpoints, contracts, or client types -> `pk:api` (envelope and schemas)
  - Test suites, seam allocation, or mocking -> `pk:test` (pyramid seam allocation)
  - Code audits or PR reviews -> `pk:review` (two-axis standard review)
  - Git commits or staging -> `pk:commit` (atomic conventional commits)
  - Pull requests or PR descriptions -> `pk:pr` (verification evidence and PR body)
  - Context bloat, chat lag, session handover, or pausing -> `pk:checkpoint` (sync docs/STATE.md & zero-loss handover)
  - Deployments, env validation, or releases -> `pk:ship` (pre-flight checks and rollback)
  When auto-routing a substantive task, announce it briefly in one sentence (e.g., "[PromptKit OS: Auto-routed to pk:plan]") and enforce its quality gate.

### Progressive Loading Policy
To optimize context window efficiency and minimize token overhead, agents must follow this progressive loading sequence:
1. **Initial context**: Load setup/entry guidance and `.promptkit/workflows/route.md`.
2. **After routing**: Load only the workflow or workflows relevant to the routed task.
3. **Artifact-on-demand**: Load templates only when required by the routed level or workflow.
4. **Level-specific behavior**:
   - **Level 0 (Direct)**: Direct execution and verification; do not load formal planning, release, CI, or artifact templates.
   - **Level 1 (Standard)**: Minimal loading path. Load relevant implementation/test/debug workflow; use inline planning; do not load Task Record (`docs/tasks/<task-id>.md`) or release material.
   - **Level 2 (Controlled)**: Load relevant planning/risk workflows and required Task Record/template material.
   - **Level 3 (Release-Critical)**: Load Level-2 material plus release-evidence and `pk:ship` guidance.
5. **Explicit request exception**: Load additional material when the developer explicitly asks for it.

Progressive loading is an instruction-efficiency policy to conserve context, not a runtime guarantee or hidden enforcement mechanism.

### Workflows & Protocols Reference
- **Route**: `.promptkit/workflows/route.md`
- **Tutor**: `.promptkit/workflows/tutor.md`
- **Plan**: `.promptkit/workflows/plan.md`
- **Onboard**: `.promptkit/workflows/onboard.md`
- **Tasks**: `.promptkit/workflows/tasks.md`
- **Review**: `.promptkit/workflows/review.md`
- **Commit**: `.promptkit/workflows/commit.md`
- **Pull Request**: `.promptkit/workflows/pr.md`
- **Debug**: `.promptkit/workflows/debug.md`
- **Performance**: `.promptkit/workflows/perf.md`
- **Data**: `.promptkit/workflows/data.md`
- **Auth**: `.promptkit/workflows/auth.md`
- **API**: `.promptkit/workflows/api.md`
- **Test**: `.promptkit/workflows/test.md`
- **Ship**: `.promptkit/workflows/ship.md`
- **Research**: `.promptkit/workflows/research.md`
- **Design System**: `.promptkit/workflows/design-system.md`
- **Reflect**: `.promptkit/workflows/reflect.md`
- **Checkpoint**: `.promptkit/workflows/checkpoint.md`
- **Quality Gate (DoD)**: `.promptkit/protocols/code-quality-gate.md`
- **Context Sync**: `.promptkit/protocols/context-sync.md`
- **Subagent Delegation**: `.promptkit/protocols/subagent-delegation.md`
- **Project Profile & Rules**: `./PROMPTKIT.md` (if present)
- **Visual Identity & Brand**: `./DESIGN.md` (if present)
- **Living State & Tracker**: `./docs/STATE.md` (if present)

### Project Artifact Output Paths
All generated project documentation must be saved to the host project:
- State Tracker: `docs/STATE.md`
- ADRs: `docs/adrs/`
- Technical Specs: `docs/specs/`
- Task Breakdowns: `docs/tasks/`
- Post-Mortems: `docs/rca/`
- Spikes: `docs/spikes/`
- Design Specs: `docs/design/`
- Data Models: `docs/data/`
- Auth Specs: `docs/auth/`
- API Contracts: `docs/api/`
- Test Plans: `docs/tests/`
- Performance Audits: `docs/perf/`
- Releases: `docs/releases/`
<!-- PROMPTKIT_END -->
```

### 5. Initialize Context & Welcome Developer
After updating configuration:
1. Run `.promptkit/protocols/context-sync.md` to detect active technologies, inspect `./PROMPTKIT.md`, and check recent git status.
2. Ask the developer which workflow they wish to activate:
   - `[pk:route]`: Navigate workflows using the engineering lifecycle decision matrix.
   - `[pk:tutor]`: Explore a concept, debug together, or build mental models.
   - `[pk:plan]`: Design an architecture, draft an RFC/spec, or break down a feature.
   - `[pk:onboard]`: Ingest an existing codebase and generate a tailored PROMPTKIT.md.
   - `[pk:tasks]`: Decompose specs into atomic issues with Gherkin AC and GitHub Projects sync.
   - `[pk:review]`: Conduct a Senior-level code & architecture audit on recent changes.
   - `[pk:commit]`: Stage atomic changes, scan for secret leaks, and format Conventional Commits.
   - `[pk:pr]`: Compile high-signal pull request descriptions, verification evidence, and safe rollback plans.
   - `[pk:debug]`: Perform systematic root cause analysis on a defect.
   - `[pk:perf]`: Profile latency, run EXPLAIN ANALYZE, isolate bottlenecks, and verify performance deltas.
   - `[pk:data]`: Design relational schemas, indexes, and RLS policies.
   - `[pk:auth]`: Architect authentication, cookies, and RBAC matrices.
   - `[pk:api]`: Define frontend-backend contracts and error envelopes.
   - `[pk:test]`: Define upfront testing strategy, pyramid seam allocation, and mock boundaries.
   - `[pk:ship]`: Execute release checklist, runtime env checks, zero-downtime migration, and rollback plan.
   - `[pk:spike]`: Run a technical spike comparing libraries/patterns.
   - `[pk:design]`: Design accessible UI components with modern tokens.
   - `[pk:retro]`: Run a retro on completed work, capture insights, and generate ADRs.
   - `[pk:checkpoint]`: Compress active session context and generate a handover prompt for a fresh chat.

---

### Post-Setup Guidance: The 3-Step Day 1 Experience
1. **Initialize**: Run `./.promptkit/init.sh` (or `.\.promptkit\init.ps1` on Windows) to scaffold `./docs/`, `./PROMPTKIT.md`, and inject root agent directives.
2. **Inspect `PROMPTKIT.md`**: Review or customize project-specific commands, test runners, and architectural invariants in `./PROMPTKIT.md` (or run `pk:onboard` for passive stack discovery).
3. **Prompt Task**: Start pairing by prompting your task naturally or invoking a workflow (`pk:route`, `pk:debug`, `pk:plan`). The assistant declares its ceremony level upfront and proceeds with lightweight or controlled execution.

---

### Visual Callout Standards for Human Actions
To eliminate ambiguity and prevent pairing deadlocks, assistants must use standardized GitHub-Flavored Markdown Alerts at the end of turns requiring human attention:

#### 1. Human Action Required (`> [!IMPORTANT]`)
When halting for user decisions, code review, merge approval, or local credential setup:
```markdown
> [!IMPORTANT]
> ### 🛑 Action Required From You:
> - **[Decision / Task]**: [Concise, concrete explanation of decision or command needed]
```

#### 2. Blocked / Waiting on Input (`> [!WARNING]`)
When halted due to environment errors, missing credentials, or unresolvable test blockers:
```markdown
> [!WARNING]
> ### ⚠️ Blocked: Waiting on Human Input
> - **[Blocker]**: [Specific missing key, access right, or decision needed to resume]
```

---

## Completion Criteria
- Root agent file (`CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, or `.cursorrules`) contains valid PromptKit OS pointers.
- Project `docs/` directories are initialized.
- The assistant is oriented to use `pk:` triggers, Socratic rules, and senior engineering workflows.
