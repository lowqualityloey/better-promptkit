# Subagent Delegation & Parallel Execution Protocol

## Purpose
Define the operational rules for delegating engineering tasks to background subagents versus executing them in the primary conversation thread. This protocol protects the parent agent's context window from token exhaustion, minimizes hallucinations caused by context clutter, and accelerates complex tasks through parallel execution.

---

## 1. The Context Preservation Law

```
┌─────────────────────────────────────────────────────────────┐
│                 THE CONTEXT PRESERVATION LAW                │
├─────────────────────────────────────────────────────────────┤
│ The parent agent context is precious, finite, and reserved  │
│ for high-altitude reasoning, architectural invariants, and  │
│ direct user alignment.                                      │
│                                                             │
│ High-volume exploration, file scraping, heavy test logs,    │
│ and multi-branch spikes must be offloaded to subagents.     │
└─────────────────────────────────────────────────────────────┘
```

When an agent reads dozens of files, runs large test suites, or scrapes web documentation directly in the main thread, the context window fills with low-signal noise. This results in:
- Severe token lag and slow response times.
- Instruction drift (ignoring earlier rules and non-negotiables).
- Premature context compaction and loss of nuanced decisions.

---

## 2. Delegation Decision Matrix

Evaluate your upcoming task against this triage before executing:

| Task Characteristics | Execution Target | Rationale |
| :--- | :--- | :--- |
| **Broad Codebase Survey** (inspecting >3 files or unfamiliar folders) | **Subagent** | Keeps raw file dumps out of the parent conversation. |
| **External Documentation / Web Search** (API docs, GitHub issues) | **Subagent** | Eliminates long HTML/markdown search dumps. |
| **Parallel Risk Spikes** (evaluating Library A vs Library B) | **Subagent (Parallel)** | Enables concurrent exploration in `pk:spike`. |
| **Two-Axis PR Audits** (Spec Fidelity vs Fowler Code Smells) | **Subagent (Parallel)** | Enables independent, unbiased reviews in `pk:review`. |
| **Long-Running Test / Linter Runs** (full CI simulation) | **Subagent / Task** | Prevents terminal scrollback from cluttering context. |
| **Direct User Interaction & Alignments** | **Main Thread Only** | Subagents must never prompt the human developer directly. |
| **Small Localized Edits** (<10 lines, single file tweaks) | **Main Thread Only** | Spawning a subagent introduces unnecessary latency overhead. |
| **Git Staging, Commits & PR Submission** (`pk:commit`, `pk:pr`) | **Main Thread Only** | Requires unified workspace visibility and secret verification. |
| **Strategic Architectural Decisions** (`pk:plan`, ADR writing) | **Main Thread Only** | Parent agent must lock invariants into project memory. |

---

## 3. The 4-Part Subagent Briefing Contract

When invoking a subagent, provide a crisp, self-contained prompt adhering to this 4-part structure:

### 1. Role & Persona
Define a specialized role with clear capabilities:
- Examples: `Codebase Researcher`, `API Contract Auditor`, `Benchmark Analyst`, `Accessibility Inspector`.

### 2. File & Directory Boundaries
Set explicit bounds so the subagent does not wander across the repo:
- Allowed paths: `src/features/billing/`, `docs/specs/`, `packages/db/`
- Excluded paths: `node_modules/`, `dist/`, `.git/`

### 3. Concrete Actionable Objective
State the precise question to answer or experiment to run:
- Good: "Find all usages of `getUserSession` and report if any call sites omit tenant ID validation."
- Bad: "Look around the codebase and check auth."

### 4. Compact Synthesis Requirement (Mandatory)
Strictly forbid raw dumps. Require the subagent to return a compact 5-15 line synthesized markdown summary:
- **Findings**: What was discovered (with exact file paths and line numbers).
- **Risks / Invariants**: What constraints must be respected.
- **Actionable Recommendation**: 1-3 concrete next steps.

---

## 4. Multi-Agent Coordination Patterns

### Pattern A: Parallel Research Spike (Fan-Out / Fan-In)
When running `pk:spike` to evaluate competing architectures:
```text
                    [ Parent Agent: pk:spike ]
                                │
                 ┌──────────────┴──────────────┐
                 ▼                             ▼
        [ Subagent 1: Drizzle ]      [ Subagent 2: Prisma ]
        - Inspect schema syntax      - Inspect schema syntax
        - Benchmark cold starts      - Benchmark cold starts
                 │                             │
                 └──────────────┬──────────────┘
                                ▼
                    [ Parent Agent Synthesis ]
                    - Compiles trade-off matrix
                    - Writes ADR to docs/adrs/
```

### Pattern B: Dual-Axis Review
When running `pk:review` on a substantial pull request:
1. **Subagent 1 (Spec Fidelity)**: Compares modified files against `docs/specs/` to catch missing requirements or scope creep.
2. **Subagent 2 (Technical Standards)**: Audits diff against Fowler's 12 code smells, security hygiene, and `DESIGN.md`.
3. **Parent Agent**: Merges both reports side-by-side into the final PR review.

---

## 5. Failure Recovery & Timeout Handling

- If a subagent returns incomplete information or encounters a tool error, do not spawn another subagent blindly.
- Inspect the subagent's returned error message.
- If the task is small, execute the remaining check directly in the main thread.
- If the task is still large, refine the briefing prompt with narrower file boundaries and re-invoke once.
