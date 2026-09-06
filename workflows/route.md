# Workflow Router (Lifecycle Decision Matrix)

## Fast Shorthand
Trigger anytime with: `pk:route` (or `/pk-route`)

## Mission
Quickly orient the developer and AI agent to the right workflow, template, and quality gate based on the current engineering state.

Eliminate decision fatigue and guesswork by mapping every software development stage to a specialized, staff-level development protocol.

---

## Preconditions
- Developer is starting a new task, facing an architectural dilemma, debugging an issue, or preparing a pull request.
- Can be activated at any point during a pairing session to pivot into the proper workflow.

---

## The Engineering Lifecycle Decision Matrix

Find your current engineering context below and activate the corresponding workflow:

| Current Context / Problem | Recommended Trigger | Primary Artifact Output | Core Value Delivered |
| :--- | :--- | :--- | :--- |
| **New Feature or Inception** | `pk:plan` | `docs/specs/` | Modular RFC spec, deletion test, threat modeling |
| **Relational Database Design** | `pk:data` | `docs/data/` | UUIDv7 keys, composite indexes, RLS policies |
| **Auth, Cookies & Permissions**| `pk:auth` | `docs/auth/` | HttpOnly cookies, OAuth PKCE, RBAC matrix |
| **API Contract & Handshake** | `pk:api` | `docs/api/` | Error envelopes, cursor pagination, typed clients |
| **Upfront Test Planning** | `pk:test` | `docs/tests/` | Pyramid seams, test data factories, mock boundaries |
| **UI, Styling & Design System**| `pk:design` | `docs/design/` | WCAG 2.2 AA contrast, design tokens, anti-slop UI |
| **Unproven Tech or Benchmark** | `pk:spike` | `docs/spikes/` | Sharpest-risk test, baseline comparison, ADR |
| **Defect, Bug or Regression** | `pk:debug` | `docs/rca/` | Red loop first, tagged probes, 5-Whys post-mortem |
| **Pre-Merge Pull Request Audit**| `pk:review` | Review report | Two-axis review: Spec Fidelity vs Technical Standards |
| **Atomic Git Staging & Commit** | `pk:commit` | Git History | Conventional Commits, single-concern staging, secret leak check |
| **Pull Request Description**   | `pk:pr`     | PR Body / `gh pr`    | Verification evidence, migration safety check, rollback plan |
| **Context Bloat & Handover**    | `pk:checkpoint`| Conversation / Notes | Session state compaction, invariant locking, fresh chat prompt |
| **Zero-Downtime Deployment**    | `pk:ship`   | `docs/releases/` | Runtime env validation, Expand-Contract migrations |
| **Post-Implementation Retro**   | `pk:retro`  | `docs/adrs/` & journal| MADR records, progress journal, skill matrix updates |
| **Learning & Socratic Coaching**| `pk:tutor`  | Conversation / Notes | 3-tier progressive hints, conceptual mental models |
| **Architecture Defense Drill**  | `pk:grill`  | Conversation / Notes | Staff Engineer Devil's Advocate stress-testing |

---

## Visual Lifecycle Flow

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

## Diagnostic Questions for Ambiguous Tasks

When a developer asks for help without specifying a command, the assistant should evaluate these 3 triage questions:

1. **What phase of the change are you in?**
   - *Pre-code*: Are we clarifying requirements (`pk:plan`), evaluating an unknown library (`pk:spike`), or designing schemas (`pk:data` / `pk:auth` / `pk:api`)?
   - *Active coding*: Are we building tests (`pk:test`), styling components (`pk:design`), or investigating broken behavior (`pk:debug`)?
   - *Post-code*: Are we auditing code quality (`pk:review`), staging atomic commits (`pk:commit`), opening a pull request (`pk:pr`), shipping to production (`pk:ship`), or capturing decisions (`pk:retro`)?
   - *Session pause / Handover*: Are we experiencing context window bloat or switching to a fresh chat window (`pk:checkpoint`)?

2. **Is there an active broken state?**
   - If yes: Immediately recommend `pk:debug`. Stop writing speculative code until a deterministic reproduction loop (<3 seconds) is established.

3. **Are you looking for an answer, or looking to build mental models?**
   - If learning or stuck on a concept: Activate `pk:tutor` to receive 3-tier progressive hints instead of unsolicited solution dumping.

---

## Smart Auto-Route Protocol & Guardrails

When working in an environment with Better-PromptKit, the developer may prompt using natural language without specifying a `pk:` shorthand. The assistant must evaluate incoming requests according to this two-tier routing policy:

### Tier 1: Fast-Path (Zero Overhead Guardrail)
If the request is:
- A conceptual question, syntax lookup, or library query (e.g., "How does `useId` work in React 19?")
- A quick single-line or small localized tweak (e.g., "Rename this variable to `userEmail`")
- A simple code explanation, formatting, or lightweight helper request

**Action**: Answer directly, concisely, and immediately. Do **not** trigger a workflow ceremony, do **not** write files to `docs/`, and do **not** add unnecessary process overhead. Preserve tokens and developer velocity.

### Tier 2: Substantive Protocol Auto-Route
If the request involves non-trivial engineering changes (new features, crashes, schema changes, auth, API modifications, or releases):

**Action**:
1. Announce the active workflow in a single brief line:
   `[Better-PromptKit: Auto-routed to pk:<workflow>]`
2. Automatically adhere to that workflow's quality gates, pre-conditions, and artifact outputs:
   - **Bugs, errors, broken tests, unexpected behavior**: Auto-route to `pk:debug`. Establish the reproduction loop before proposing any fix.
   - **New features, cross-component additions, new pages**: Auto-route to `pk:plan`. Create the RFC spec before writing code.
   - **Database tables, migrations, RLS policies, indexing**: Auto-route to `pk:data`. Enforce Expand-Contract sequencing.
   - **Login, session tokens, cookies, permissions**: Auto-route to `pk:auth`. Establish the capability matrix first.
   - **API routes, endpoints, contracts, error envelopes**: Auto-route to `pk:api`. Define schema types and envelope formats first.
   - **Test suites, unit/integration splits, mock boundaries**: Auto-route to `pk:test`. Allocate pyramid seams before code.
   - **PR review, diff audit, refactoring assessment**: Auto-route to `pk:review`. Audit against spec fidelity and Fowler smells.
   - **Git commits, staging changes, commit message generation**: Auto-route to `pk:commit`. Scan for secret leaks and format Conventional Commit.
   - **Pull requests, PR descriptions, or opening a PR**: Auto-route to `pk:pr`. Compile verification evidence and format PR description.
   - **Context bloat, chat lag, session handover, or pausing**: Auto-route to `pk:checkpoint`. Compress working state and generate handover prompt.
   - **Production deployment, env vars, rollback prep**: Auto-route to `pk:ship`. Run runtime env validation and release checklist.



