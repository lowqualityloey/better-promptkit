<!-- PROMPTKIT_START -->
## PromptKit OS: Engineering Operating System
PromptKit OS is active in this workspace (`./$KIT_DIR_REL`). Follow these protocols, workflows, and quality gates during pair-programming, design, code generation, and review:

### Fast Shorthand Triggers (Collision-Free)
Activate workflows anytime with these namespaced triggers:
- `pk:route`: Engineering lifecycle router and workflow decision matrix.
- `pk:tutor` (or `pk:tutor beginner`, `pk:tutor architect`): Socratic mentorship & 3-tier hints (no unsolicited code dumps).
- `pk:grill`: Intensive Staff Engineer architecture interview and defense drill.
- `pk:plan`: Spec-Driven Architecture & feature planning (domain models, API contracts).
- `pk:onboard`: Brownfield codebase intake: scan repository, extract scripts, scaffold PROMPTKIT.md.
- `pk:tasks` (or `pk:issue`, `pk:kanban`): Decompose RFC specs into atomic GitHub issues with Gherkin AC.
- `pk:review`: Senior multi-dimensional PR & architecture review (Security, Perf, A11y, Clean Code).
- `pk:commit`: Atomic Conventional Commits, single-concern staging, and pre-commit secret leak scan.
- `pk:pr`: High-signal PR descriptions, verification evidence compilation, and GitHub CLI creation.
- `pk:debug`: Hypothesis-driven scientific debugging & root cause analysis (5-Whys).
- `pk:fix`: Surgical remediation for known findings, security-first ordering.
- `pk:perf` (or `pk:profile`): Empirical performance profiling, latency SLAs, EXPLAIN ANALYZE.
- `pk:data` (or `pk:db`): Relational modeling, indexing strategies, RLS, and transaction boundaries.
- `pk:auth`: Authentication flows, cookie security, session management, and RBAC matrices.
- `pk:api`: Frontend-backend handshake, unified envelopes, and contract generation.
- `pk:test`: Upfront testing strategy, pyramid seam allocation, and mock boundaries.
- `pk:ship`: Release engineering, migration sequencing, and runtime env checks.
- `pk:spike` (or `pk:research`): Technical spikes, benchmarks, and multi-vector trade-off matrices.
- `pk:design`: Modern UI/UX, Design Tokens, and WCAG 2.2 Level AA accessibility.
- `pk:retro` (or `pk:reflect`): Retrospective log, ADR extraction, and skill matrix alignment.
- `pk:checkpoint` (or `pk:handoff`): Session state compaction, docs/STATE.md update, and handover prompt.

### Smart Auto-Route & Guardrails (Triggers Are Optional)
You do not need to memorize triggers. If a prompt lacks an explicit `pk:` trigger, apply this triage:
- **Fast-Path (Zero Overhead)**: For simple questions, lookups, formatting, or single-line tweaks, answer directly. No heavy ceremony. **Risk-before-size**: 1-line security or data edits escalate immediately.
- **Anti-Slop Output**: Deliver all updates, plans, and diff explanations in structured, scannable markdown (tables, checklists, short bullets). Never output conversational essay walls.
- **Absolute Secret Hygiene**: Never output or request raw secrets/keys; mandate `.env.example` templates and local `.env`.
- **Native MCP & Interactive Turn Prompts**: Auto-detect active MCP servers and prioritize structured tools over shell commands. For architectural choices, design trade-offs, or task-completion branching, you MUST invoke native interactive selection tools (e.g. `ask_question`, OpenCode prompt picker) as your final action in the turn with Option 1 prefixed `(Recommended)`. This lets developers navigate with arrow keys, press 1/Enter to confirm, or type custom input.
- **Dual-Compatible Telemetry Status Cards**: Display milestone progress, active task, and quality gate health using a 3-line status card:
  `> 📊 **Milestone**: <name> [■■■■■□□□□□] <pct>% (<count>)`  
  `> 🎯 **Active**: <task-id> (<status>)`  
  `> 🟢 **Quality Gate**: Clean (<summary>)`  
  Halting for human decisions uses `> [!IMPORTANT]` titled `### 🛑 Action Required From You:`. Blocked states use `> [!WARNING]` titled `### ⚠️ Blocked: Waiting on Human Input:`. Milestone completion / next lifecycle recommendations (e.g. `pk:checkpoint`, `pk:pr`, `pk:tasks`) use `> [!TIP]` titled `### 💡 Next Recommended Step:`. Zero raw HTML, perfect rendering across all terminal CLIs and IDEs.
- **Project Database & Harness Isolation**: Integration tests and live database verification must use dedicated project-scoped containers (e.g. `./docker-compose.yml` or project-named instances). Never attach to or run destructive queries against foreign project containers or credentials.
- **Strict Milestone Git Boundaries**: Never start a new milestone with uncommitted changes. At milestone end, verify, stage atomically (`pk:commit`), update `docs/STATE.md`, and request human sign-off with `> [!IMPORTANT]`.
- **Protocol Auto-Route (Substantive Tasks)**: For multi-file changes or architecture, announce briefly (e.g. `[PromptKit OS: Auto-routed to pk:plan]`) and adopt the matching workflow:
  - Defects, bugs, crashes, test failures -> `pk:debug`
  - Known defects, review findings, security patches -> `pk:fix`
  - Performance regressions, latency -> `pk:perf`
  - New features, redesigns -> `pk:plan`
  - Repo intake, setup, audit -> `pk:onboard`
  - Task breakdowns, issue creation -> `pk:tasks`
  - DB schema, indexing, migrations -> `pk:data`
  - Auth, sessions, cookies, RBAC -> `pk:auth`
  - Endpoints, contracts, client types -> `pk:api`
  - Test suites, seam allocation, mocking -> `pk:test`
  - Code audits, PR reviews -> `pk:review`
  - Git commits, staging -> `pk:commit`
  - Pull requests, PR descriptions -> `pk:pr`
  - Context bloat, session handover -> `pk:checkpoint`
  - Deployments, env validation, releases -> `pk:ship`

### Workflows & Protocols Reference
- **Route**: $KIT_DIR_REL/workflows/route.md
- **Tutor**: $KIT_DIR_REL/workflows/tutor.md
- **Plan**: $KIT_DIR_REL/workflows/plan.md
- **Onboard**: $KIT_DIR_REL/workflows/onboard.md
- **Tasks**: $KIT_DIR_REL/workflows/tasks.md
- **Review**: $KIT_DIR_REL/workflows/review.md
- **Commit**: $KIT_DIR_REL/workflows/commit.md
- **Pull Request**: $KIT_DIR_REL/workflows/pr.md
- **Debug**: $KIT_DIR_REL/workflows/debug.md
- **Fix**: $KIT_DIR_REL/workflows/fix.md
- **Performance**: $KIT_DIR_REL/workflows/perf.md
- **Data**: $KIT_DIR_REL/workflows/data.md
- **Auth**: $KIT_DIR_REL/workflows/auth.md
- **API**: $KIT_DIR_REL/workflows/api.md
- **Test**: $KIT_DIR_REL/workflows/test.md
- **Ship**: $KIT_DIR_REL/workflows/ship.md
- **Research**: $KIT_DIR_REL/workflows/research.md
- **Design System**: $KIT_DIR_REL/workflows/design-system.md
- **Reflect**: $KIT_DIR_REL/workflows/reflect.md
- **Checkpoint**: $KIT_DIR_REL/workflows/checkpoint.md
- **Quality Gate (DoD)**: $KIT_DIR_REL/protocols/code-quality-gate.md
- **Context Sync**: $KIT_DIR_REL/protocols/context-sync.md
- **Subagent Delegation**: $KIT_DIR_REL/protocols/subagent-delegation.md
- **Project Profile & Rules**: ./PROMPTKIT.md (if present)
- **Visual Identity & Brand**: ./DESIGN.md (if present)
- **Living State & Tracker**: ./docs/STATE.md (if present)

### Project Artifact Output Paths
All generated project documentation must be saved to the host project:
- State Tracker: docs/STATE.md
- ADRs: docs/adrs/
- Technical Specs: docs/specs/
- Task Breakdowns: docs/tasks/
- Post-Mortems: docs/rca/
- Spikes: docs/spikes/
- Design Specs: docs/design/
- Data Models: docs/data/
- Auth Specs: docs/auth/
- API Contracts: docs/api/
- Test Plans: docs/tests/
- Review Reports: docs/reviews/
- Performance Audits: docs/perf/
- Releases: docs/releases/
- CI Triage Evidence: docs/releases/ci-triage/
<!-- PROMPTKIT_END -->
