# Research Workflow (Technical Spikes & Trade-Off Evaluation)

## Fast Shorthand
Trigger anytime with: `pk:spike` or `pk:research` (or `/pk-spike`)

## Mission
Guide the developer through conducting thorough, evidence-based **Technical Spikes**, architectural investigations, library evaluations, and technology trade-off analyses. Produce actionable, peer-reviewable research artifacts that de-risk major engineering decisions.

---

## The Senior Research Framework

```
┌─────────────────────────────────────────────────────────────┐
│                 TECHNICAL SPIKE EVALUATION                  │
├──────────────────────────────┬──────────────────────────────┤
│ 1. Problem & Spike Question  │ 2. Candidate Alternatives    │
│    Specific hypothesis to test│    Compare 2-4 technologies  │
├──────────────────────────────┼──────────────────────────────┤
│ 3. Multi-Vector Matrix       │ 4. Prototype & Benchmark     │
│    Performance, DX, Risk     │    Proof-of-concept evidence │
├──────────────────────────────┼──────────────────────────────┤
│ 5. Synthesis & Trade-Offs    │ 6. Actionable Recommendation │
│    Honest pros, cons, costs  │    Clear decision & next step│
└──────────────────────────────┴──────────────────────────────┘
```

---

## Preconditions
- Developer needs to evaluate competing frameworks, libraries, database strategies, or architectural patterns.
- Target storage directory: `./docs/spikes/` (or designated in `PROMPTKIT.md`).

---

## Workflow Steps

### Step 1: Formulate the Core Research Question & Scope
1. Define the exact spike objective:
   - Example: *"Should we adopt TanStack Router over Next.js App Router for our internal dashboard, considering SSR requirements, bundle size, and complex nested search params?"*
2. Define the decision criteria:
   - What factors are critical? (e.g., Latency, Type-safety, Community longevity, Bundle size, Migration cost).
3. Set a timebox:
   - Avoid infinite research rabbit holes. Set an explicit scope boundary.

### Step 2: Identify Candidate Approaches
Select 2-4 viable candidates for evaluation:
- Candidate A (Current baseline or default approach)
- Candidate B (Leading alternative / modern industry standard)
- Candidate C (Lightweight / emerging specialized solution)

### Step 3: Multi-Vector Comparative Matrix
Evaluate candidates systematically across standard engineering dimensions:

| Evaluation Dimension | Candidate A: [Name] | Candidate B: [Name] | Candidate C: [Name] |
| :--- | :--- | :--- | :--- |
| **Type Safety & DX** | Partial / Loose | Full end-to-end inference | High |
| **Runtime Performance & Memory** | High overhead (~150kb) | Zero-runtime / Ultra light | Medium (~45kb) |
| **Ecosystem & Maintenance** | Massive community | Fast-growing, modern | Niche / Solo maintainer |
| **Migration / Learning Curve** | Low (familiar) | Moderate (new paradigm) | High |
| **Failure Modes & Edge Cases** | Known workarounds | Good error boundaries | Limited docs for edge cases |
| **Cost / Licensing** | MIT Open Source | MIT Open Source | Commercial / AGPL |

### Step 4: Build a Targeted Proof of Concept (PoC)
1. Design a minimal sandbox or branch testing the critical risk:
   - Test the hardest integration point or highest-risk constraint (e.g., dynamic nested routing, streaming data serialization, database query under 10k rows).
2. Measure concrete data:
   - Benchmark throughput / latency (ms).
   - Inspect build bundle impact (kB gzip).
   - Evaluate developer ergonomics and type ergonomics.

### Step 5: Document Sources & Validate Claims
1. Cite official documentation, benchmark repositories, or RFC discussions.
2. Flag any assumptions, uncertainties, or upcoming library breaking changes (e.g., major version alpha/beta).
3. Cross-reference claims with source code or runtime experiments.

### Step 6: Generate Spike Document & Final Recommendation
Save the research note to `./docs/spikes/YYYY-MM-DD-spike-<topic-slug>.md` with:
- **Executive Summary & Recommendation**: Clear verdict with primary rationale.
- **Trade-Off Summary**: What do we gain, and what do we sacrifice?
- **Proof-of-Concept Findings**: Code snippets and benchmark numbers.
- **Migration / Adoption Plan**: If adopted, what are the actionable next steps?

If the research leads to a permanent architectural decision, transition to `pk:retro` to generate an ADR in `./docs/adrs/`.

---

## Completion Criteria
- Research question clearly answered with empirical evidence.
- Comparative trade-off matrix completed.
- Formal research artifact saved to `./docs/spikes/`.
- Developer has high confidence in selecting the path forward.
