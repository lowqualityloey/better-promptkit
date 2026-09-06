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
| **Zero-Downtime Deployment** | `pk:ship` | `docs/releases/` | Runtime env validation, Expand-Contract migrations |
| **Post-Implementation Retro** | `pk:retro` | `docs/adrs/` & journal| MADR records, progress journal, skill matrix updates |
| **Learning & Socratic Coaching**| `pk:tutor` | Conversation / Notes | 3-tier progressive hints, conceptual mental models |
| **Architecture Defense Drill** | `pk:grill` | Conversation / Notes | Staff Engineer Devil's Advocate stress-testing |

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
                     [ Release & Ops ]
                            │
                         pk:ship
             (Zero-Downtime Deploy & Rollback)
                            │
                   [ Knowledge Capture ]
                            │
                         pk:retro
             (MADR Records & Progress Journal)
```

---

## Diagnostic Questions for Ambiguous Tasks

When a developer asks for help without specifying a command, the assistant should evaluate these 3 triage questions:

1. **What phase of the change are you in?**
   - *Pre-code*: Are we clarifying requirements (`pk:plan`), evaluating an unknown library (`pk:spike`), or designing schemas (`pk:data` / `pk:auth` / `pk:api`)?
   - *Active coding*: Are we building tests (`pk:test`), styling components (`pk:design`), or investigating broken behavior (`pk:debug`)?
   - *Post-code*: Are we auditing code quality before merging (`pk:review`), shipping to production (`pk:ship`), or capturing architectural decisions (`pk:retro`)?

2. **Is there an active broken state?**
   - If yes: Immediately recommend `pk:debug`. Stop writing speculative code until a deterministic reproduction loop (<3 seconds) is established.

3. **Are you looking for an answer, or looking to build mental models?**
   - If learning or stuck on a concept: Activate `pk:tutor` to receive 3-tier progressive hints instead of unsolicited solution dumping.
