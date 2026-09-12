# Changelog

All notable changes to PromptKit OS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [1.3.0] - 2026-09-12

### Added
- **Mechanical Directive Token Measurement Utilities**: Added `scripts/measure-tokens.ps1` (PowerShell) and `scripts/measure-tokens.sh` (POSIX Bash) to calculate exact character, word, and estimated token counts (~4 chars/token heuristic) of the injected agent directive block, validating the ~89.5% static context reduction vs monolithic 18.5k-token prompt packs without adding runtime dependencies.

### Changed
- **Lean Initial Directory Scaffolding**: Refactored `init.ps1` and `init.sh` to scaffold only 4 essential core directories upfront (`docs/tasks`, `docs/specs`, `docs/adrs`, `docs/tests`), deferring specialized workflow folders (`docs/auth`, `docs/data`, `docs/releases`, etc.) to on-demand creation when invoked.
- **Production-Grade First-Task Demonstration**: Replaced the toy "React calculator" prompt in `README.md` with an authenticated 24-hour expiring invite link API feature demonstrating Level 1 ceremony, RED test failure observation, and minimal workflow routing.

### Fixed
- **CI Test Harness Alignment**: Updated `.github/workflows/ci.yml` Linux and Windows dry-run initialization assertions to match streamlined core directories and integrated `scripts/measure-tokens.*` into automated script syntax verification suites.

---

## [1.2.0] - 2026-09-12

### Added
- **Ironclad Red-to-Green TDD Enforcement**: Added Step 2.5 to `workflows/test.md` mandating that agents observe and record test failure (`RED`) with the expected assertion error before touching production code.
- **Adaptive Ceremony & Model-Tiering Matrix**: Added risk-to-model mapping in `workflows/route.md` (Level 0 $\rightarrow$ Fast/Economy tier, Level 1 $\rightarrow$ Balanced tier, Level 2/3 $\rightarrow$ Frontier Reasoning tier) to eliminate token waste while preventing under-reasoning defect loops.
- **Zero-Dependency Git Worktree Sandbox Scripts**: Added `scripts/isolate-worktree.ps1` (PowerShell) and `scripts/isolate-worktree.sh` (Bash) enabling safe branch sandboxing (`create`, `list`, `merge`, `remove`) without workspace pollution. Automatically appends `.worktrees/` to `.gitignore`.
- **Pattern D Subagent Delegation Protocol**: Codified isolated worktree execution in `protocols/subagent-delegation.md` for high-risk, multi-file refactors.
- **Full-Stack Feature Blueprint**: Added `examples/fullstack-feature/README.md` showcasing an enterprise Organization Invitations feature spanning Gherkin AC, Expand-Contract migrations, 8-state tactile UI tokens, and verification proof tables.
- **Expanded IDE Runtime Auto-Detection**: Updated `init.ps1` and `init.sh` to auto-detect Cursor (`.cursor/rules/promptkit.mdc` and `.cursorrules`), Cline / Roo Code (`.clinerules`), Trae (`.traerules`), and OpenCode (`.opencode/rules.md`).
- **Pillar 2 Quality Gate Check**: Added `Observable Red-to-Green Execution` requirement in `protocols/code-quality-gate.md`.

### Changed
- Updated `README.md` Overview table with **Adaptive Ceremony & Model Tiering** dimension.
- Expanded `docs/BENCHMARKS.md` with Section 6 detailing token savings and risk mitigation by model class.

---

## [1.1.0] - 2026-09-11

### Added
- **Tactile Anti-Slop UI Aesthetic Foundations**: Codified engineered matte paper grounds, 1px ruler-drawn hairlines over blur, the 5% signal accent rule, macrostructure rhythm diversity, and honest copy standards in `workflows/design-system.md`.
- **Chromatic Dual-Mode Theme Presets**: Integrated concrete OKLCH color token palettes for *Cobalt Dev-Tool* (technical SaaS / precision dashboards) and *Hum Warm Editorial* (knowledge bases / boutique SaaS) across both light and dark modes.
- **Mandatory 8-State Component Contract**: Codified strict interaction state requirements (`default`, `hover`, `:focus-visible`, `:active`, `disabled`, `loading`, `error`, `success`) across design workflows, templates, and quality gates.
- **Zero-Byte Native Font Philosophy**: Standardized on native system font stacks (`system-ui`, `ui-monospace`, `ui-serif`) with `font-feature-settings: "tnum" 1` and `text-wrap: balance` (0 KB download, 0ms CLS).
- **Universal Iconify Catalog Guidelines**: Standardized icon lookup using the Iconify catalog with single-family consistency and `simple-icons` for tech marks without mandating npm runtime packages.
- **Pillar 6 Quality Gate Checks**: Added 8-state component contract, honest copy, and single icon family checks to `protocols/code-quality-gate.md`.

---

## [1.0.0] - 2026-09-05

### Added
- **Just-In-Time (JIT) Filesystem Architecture**: Lightweight ~40-line directive router (~650 tokens) injected into agent directives (`AGENTS.md`), saving >95% static token overhead over monolithic prompt packs.
- **Adaptive Level 0–3 Task Ceremony**: Adaptive scaling from Level 0 (direct answer, zero ceremony) to Level 3 (release-critical, full provenance).
- **Living State & Milestone Persistence**: Git-tracked markdown memory in `docs/STATE.md` and `docs/tasks/` preventing session amnesia and context rot.
- **Expand-Contract Database Migration Governance**: Safe zero-downtime schema evolution rules in `workflows/data.md` preventing destructive drops.
- **20 Specialized Engineering Workflows**: High-craft workflows covering planning (`pk:plan`), scientific debugging (`pk:debug`), surgical remediation (`pk:fix`), profiling (`pk:perf`), auth (`pk:auth`), API contracts (`pk:api`), testing (`pk:test`), atomic commits (`pk:commit`), PR descriptions (`pk:pr`), and release engineering (`pk:ship`).
- **Socratic Mentorship Engine**: Mentorship and progressive 3-tier hints via `pk:tutor`.
- **Zero-Lock-In Foundation**: 100% pure Markdown protocols and native shell scripts (`init.sh`, `init.ps1`) with zero npm runtime packages, zero binary daemons, and zero vendor lock-in.
