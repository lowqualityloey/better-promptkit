# Implementation Plan — Changes A & B (Token Reduction)

**Date**: 2026-09-13 · **Branch**: `arena/01a097be-promptkit-os`
**Parent analysis**: [`docs/token-efficiency-review.md`](../token-efficiency-review.md)
**Baseline at `258cf8c`**: behavioral contract tests `Passed: 56 | Failed: 0`;
`validate-references.sh` → *"All references valid"*; init safety tests pass.

---

## STATUS — what was actually landed

| Item | State |
| :--- | :--- |
| **Change A** (A1 directive, A2 setup.md, A3 route.md) | ✅ **Implemented** — `refactor(directive): classify ceremony levels inline…` |
| **A4** + orphaned-harness CI wiring | ✅ **Implemented** — `test(ci): enforce release-record documentation examples…` |
| **Change B** (extract from `ship.md`) | ⏸️ **Deferred** — blocked per §3.0; needs an owner decision between B1 (repoint 6 assertions in 2 test files) and B2 (leave a concept stub in `ship.md`, zero test edits) |
| **Changes C & D** | ⏸️ Out of scope, separate commits |

Directive measured after A: **1,929 tokens** (`measure-tokens.sh`, budget passes; **71 tokens**
headroom — hence the new CI budget assertion).

Full local gate after A, all green: `run-behavioral-contract-tests`, `run-init-safety-tests`,
`run-execution-control-fixtures`, `run-execution-control-properties`, `run-ci-triage-fixtures`,
`run-release-record-properties`, `release-records.examples`, `validate-references`,
`measure-tokens`, both `validate-release-records` fixture roots, the grandfather-filtered
self-validation, and the `init.sh` dry-run + idempotency check (with `$KIT_DIR_REL` correctly
substituted in the generated `AGENTS.md`).

**Not locally verified**: the two new PowerShell CI steps. `pwsh` is unavailable in this sandbox,
so `release-records.examples.ps1` and `measure-tokens.ps1` are unexercised here. The `.sh` twins
pass, and `measure-tokens.ps1:109` / `.sh:93` both `exit 1` on budget overrun, so the steps are
expected to pass — but this is the one gap CI itself must confirm.

---

## 0. Correction to the earlier estimate

The review projected the directive would land at **~1,817 tokens**. I prototyped the actual
replacement text and ran the repo's own budget assertion against it:

```
$ bash scripts/measure-tokens.sh      # run on a /tmp copy of the template
  • Characters:       7665
  • Estimated Tokens: ~1916 tokens
  ✅ Verification Passed: Directive (1916 tokens) adheres to the <= 2000 token budget.
```

**The directive grows 1,882 → 1,916 (+34), it does not shrink.** My 250-token estimate for the
compact Level table was optimistic. It still passes, but headroom is thin: **84 tokens**.
Per-task savings are essentially unchanged (they are dominated by removing the `route.md` load),
but the directive budget must be re-asserted in CI rather than assumed.

---

## 1. Constraint matrix — what the existing tests lock

Established by grepping `scripts/tests/run-behavioral-contract-tests.sh`. This is the hard part
of the plan; every edit below is designed around it.

| File | Assertions | Binding constraint |
| :--- | :---: | :--- |
| `workflows/route.md` | **18** | Ceremony section must **stay**. L84 requires `workflows/route\.md.*is the canonical authority`; L33/39/46 require `Level 0 — Direct`, `Level 1 — Standard`, `Level 2 — Controlled` (em-dash form); L34 `understand → change → verify`; L40 `does .*not.* trigger Level 2 Controlled Work`; L47 `docs/tasks/<task-id>\.md`; L55 `human authorization`; L59–62 downgrade guardrails; L66 `Canonical Mapping & Legacy Compatibility`; L67 `sole authority for Level`; L74 `treat release and evidence work as Level 3` |
| `templates/agent-directive-template.md` | 6 | All target guardrail prose (`Fast-Path (Zero Overhead)`, `Native MCP & Interactive Turn Prompts`, `Dual-Compatible Telemetry Status Cards`, `### 💡 Next Recommended Step`, `📊 **Milestone**:`, `Project Database & Harness Isolation`). **None touch the path list** → the path list is free to replace |
| `protocols/setup.md` | 2 | Must retain heading `Progressive Loading Policy` and `Level 1 (Standard).*Minimal loading path`. Editing step 1 touches neither |
| `workflows/ship.md` | **0** in `run-behavioral-contract-tests.sh`, but **6 in `scripts/tests/release-records.examples.sh`** | ⚠️ **This is the blocker for Change B — see §3.0.** `git grep 'ship\.md#'` → no inbound anchor links, so the move is *link*-safe, but it is not *test*-safe |
| `scripts/tests/release-records.examples.sh` | 6 on `ship.md` | `assert_file_text` + the `documentation_examples` loop use `grep -Fqi` on **both** `$requirement` **and** `$evidence` (logical **AND**). All 6 ship.md examples reference text that lives **only** inside lines 189–347 |
| `README.md` | 1 (L83) | Must keep linking `workflows/route.md` as canonical — untouched by this plan |

**Consequence for Change A**: it is **additive to the directive**, not a move *out of*
`route.md`. `route.md` keeps full canonical text; the directive gains a decision-grade summary so
classification no longer requires loading 6,962 tokens.

---

## 2. Change A — make Level classification free (3 edits)

### A1. `templates/agent-directive-template.md` — replace lines 59–85

Current: `### Workflows & Protocols Reference` + 26 explicit path entries (~345 tok).
Replace with a convention block **plus** the compact ceremony table:

```markdown
### Workflows & Protocols Reference
Load lazily by convention — never preload:
- Workflow: `$KIT_DIR_REL/workflows/<trigger>.md` (e.g. `pk:plan` -> `workflows/plan.md`)
- Protocols: `$KIT_DIR_REL/protocols/{setup,context-sync,code-quality-gate,subagent-delegation}.md`
- Router: load `$KIT_DIR_REL/workflows/route.md` only when routing is ambiguous or
  Level 3 escalation/downgrade rules are needed
- Project files: `./PROMPTKIT.md`, `./DESIGN.md`, `./docs/STATE.md` (if present)

### Task Ceremony Levels (classify here — do not load route.md to decide)
Declare on line 1 of Turn 1: `[PromptKit OS: Level <0-3> (<Name>) — <1-line reason>]`
- **L0 Direct**: questions, lookups, doc typos, formatting, non-risky 1-line edits.
  `understand -> change -> verify`. No task record. Risk-before-size: 1-line security/data
  edits escalate.
- **L1 Standard**: localized bug fix, small self-contained feature, no schema/auth/breaking
  contract. Inline planning; no Task Record file.
- **L2 Controlled**: schema/migrations, auth, permissions, public contracts, multi-component.
  Requires `docs/tasks/<task-id>.md` + spec before implementation.
- **L3 Release-Critical**: release, tag, deploy, high-impact contract change. Requires L2
  evidence + `pk:ship` + explicit human approval.
- **Escalate** immediately if scope grows into persistent data, auth, public contracts, or
  multiple components. `workflows/route.md` remains the canonical authority for these rules
  and for downgrade guardrails.
```

Lines 87+ (`### Project Artifact Output Paths`) unchanged.

> Note the banner changes to `[PromptKit OS: …]` from `[Better-PromptKit: …]`. That is Change D
> leaking in. If you want A strictly scoped, keep the existing banner string here and handle the
> rename separately.

### A2. `protocols/setup.md` — rewrite line 63

```diff
-1. **Initial context**: Load setup/entry guidance and `.promptkit/workflows/route.md`.
+1. **Initial context**: Load setup/entry guidance. Classify the task using the Level 0–3 table
+   in the injected directive — do not load `.promptkit/workflows/route.md` for classification.
+   Load `route.md` only when routing is genuinely ambiguous, or when Level 3 escalation /
+   downgrade guardrails are needed.
```

Keeps the `Progressive Loading Policy` heading (test L80) and the Level 1 line (test L81) intact.

### A3. `workflows/route.md` — add a one-line pointer, delete nothing

Insert immediately after line 19 (the canonical-authority declaration):

```markdown
> A decision-grade summary of Levels 0–3 ships in the injected directive so agents can classify
> without loading this file. This document remains the canonical authority; where the summary and
> this file differ, this file wins.
```

This preserves every assertion in the matrix above (all 18 target text that stays).

### A4. Optional but recommended — guard the budget in CI

With only **84 tokens** of headroom, add one step to `.github/workflows/ci.yml` (Linux job):

```yaml
- name: Assert Directive Token Budget
  run: bash scripts/measure-tokens.sh | grep -q 'Verification Passed'
```

This reuses the existing script — no new machinery, one line. Without it, the next directive edit
can silently breach 2,000 tokens.

---

## 3. Change B — extract Better-PromptKit release evaluation

### 3.0 ⚠️ BLOCKER — the original B plan breaks a passing test, silently

The first draft of this plan called B "genuinely low-risk: zero behavioral assertions on
`ship.md`." **That was wrong.** I had only grepped `run-behavioral-contract-tests.sh`. There is a
second harness, `scripts/tests/release-records.examples.sh`, with 6 assertions on
`workflows/ship.md`.

Verified by applying B to a throwaway copy and running it:

```
$ bash scripts/tests/release-records.examples.sh
EXAMPLE_FAILURE|Missing documentation requirement 'Approved Release Record'
```

Pattern-level analysis of all 6 (`grep -Fqi`, both patterns must survive in `ship.md`):

| Example | Requirement | Evidence | Survives move? |
| :--- | :--- | :--- | :--- |
| `ship-record` | Approved Release Record | Draft Changelog Entries | ❌ both in-range only |
| `ship-blocked` | unresolved blocker | unapproved | ❌ evidence in-range only |
| `qa-rereview` | correction/re-review | Blocker review | ❌ both in-range only |
| `approval-alignment` | Approved Release Tag | Approved Release Version | ❌ requirement in-range only |
| `note-coverage` | Public Release Notes | exactly one | ❌ both in-range only |
| `no-side-effect` | External-action decisions | must not automatically run tag commands | ❌ both in-range only |

**All 6 break.** The script currently **passes** (`exit=0`, 5/5 examples PASS), so this is a real
regression, not a pre-existing failure.

**Why it is dangerous rather than merely annoying:** `release-records.examples.sh` is **not wired
into `.github/workflows/ci.yml`** (`grep release-records.examples .github/workflows/ci.yml` → no
match). Confirmed on the same prototype: after applying B, `run-behavioral-contract-tests` still
reported `Passed: 56 | Failed: 0` and `validate-references.sh` still passed. **CI would have gone
green on a broken system.**

Full CI/non-CI status of every harness:

| Harness | In CI? |
| :--- | :--- |
| `run-behavioral-contract-tests.sh` | ✅ |
| `run-init-safety-tests.sh` | ✅ |
| `run-execution-control-fixtures.sh` | ✅ |
| `run-execution-control-properties.sh` | ✅ |
| `run-ci-triage-fixtures.sh` | ✅ |
| `run-release-record-properties.sh` | ✅ |
| **`release-records.examples.sh`** | ❌ **NOT IN CI** |

### 3.0.1 Prerequisite — fix the CI gap first (do this regardless of B)

Add to both jobs in `.github/workflows/ci.yml`:

```yaml
- name: Run Release-Record Documentation Examples (Bash)
  run: bash scripts/tests/release-records.examples.sh
```

This is a **standalone, zero-risk win**: it puts a currently-passing, currently-unenforced test
under CI. Doing it *before* B means B's blast radius becomes visible instead of silent. Note the
`.ps1` twin (`release-records.examples.ps1`) has the same 6 assertions and needs the same wiring.

### 3.0.2 Revised B options

| Option | Mechanism | Token saving | Test impact | Recommendation |
| :--- | :--- | :--- | :--- | :--- |
| **B1 — Repoint the assertions** | Move 189–347 as planned; update the 6 `documentation_examples` rows in `release-records.examples.sh` **and** `.ps1` to point at `docs/internal/release-evaluation.md` | ~4,144 tok | 6 assertion *targets* change; intent preserved ("these concepts are documented") | ✅ **Preferred**, but only after §3.0.1 lands, and only with explicit sign-off — editing a test to match a refactor is a judgement call the owner should make |
| **B2 — Split ship.md, keep a stub section** | Move the detail out but leave a ~30-line stub in `ship.md` containing every asserted phrase (headings + one-line definitions) | ~3,300 tok | Zero test edits | ✅ Safer default if you don't want to touch tests |
| **B3 — Defer B entirely** | Do A only | 0 | Zero | Acceptable; A carries ~63% of the total savings |

**B2 is the conservative choice.** The 6 assertions are really checking that release-record
*concepts* are documented, so a stub that names each concept with a pointer satisfies both the
letter and the spirit, and it still removes ~80% of the dead weight. B1 saves ~850 more tokens but
requires editing 2 test files.

### 3.1 Move boundaries (unchanged, still verified)

### Step 1 — Move `workflows/ship.md` lines **189–347** → `docs/internal/release-evaluation.md`

Verified boundaries:

| Line | Content | Action |
| :--- | :--- | :--- |
| 185 | `### Canonical Artifact Linkage` | **stays** |
| 189 | `### Better-PromptKit Internal Release Evaluation` | move start |
| 347 | closing para: *"`pk:ship` records the evaluation, evidence, QA result…"* | move end |
| 349 | `---` | stays (now separates Canonical Artifact Linkage from Step 3) |
| 351 | `### Step 3: Trigger Production Deployment` | **stays** |

Moved payload: **159 lines / ~16.6 KB / ~4,144 tok**. Prepend a short front-matter block to the
new file (title, "applies to this repository only", pointer back to `workflows/ship.md`).

**Target path is deliberate.** `scripts/validate-release-records.sh:88,677` scans only
`$ROOT/docs/releases` (excluding `ci-triage/`). Putting the file in `docs/internal/` keeps it out
of release-record validation; putting it in `docs/releases/` would make the validator try to
parse it as a release record and fail.

### Step 2 — Replace `ship.md` lines 189–347 with a pointer (~150 tok)

```markdown
### Better-PromptKit Internal Release Evaluation

This repository's release-candidate evaluation procedure (Evaluation ID, Version Source of
Truth, candidate-inclusive release range, Effective Change Set normalisation, SemVer
derivation, QA review, and Approved Release Record) is maintained separately in
[`docs/internal/release-evaluation.md`](../docs/internal/release-evaluation.md), because it
applies only to this repository and imposes no requirements on repositories that consume
PromptKit OS. Load it only when performing a release evaluation **in this repository**.
`pk:ship` Steps 3–5 and the production-safety guidance below remain in force regardless.
```

`ship.md` drops **8,292 → ~4,298 tokens (−48%)**.

---

## 3.9 ✅ Change A — empirically verified, not just reasoned

A was applied in full (A1 + A2 + A3, keeping the existing `[Better-PromptKit: …]` banner so A stays
scoped) to a throwaway copy at `/tmp/pkA`, and the real harnesses were run against it:

| Harness | Result on A prototype |
| :--- | :--- |
| `run-behavioral-contract-tests.sh` | **PASS** (all 18 route.md + 6 directive + 2 setup.md assertions) |
| `run-init-safety-tests.sh` | **PASS** (idempotency holds) |
| `run-execution-control-fixtures.sh` | **PASS** |
| `run-execution-control-properties.sh` | **PASS** |
| `run-ci-triage-fixtures.sh` | **PASS** |
| `run-release-record-properties.sh` | **PASS** |
| `validate-references.sh` | **PASS** |
| `release-records.examples.sh` (not in CI) | **PASS** |
| `measure-tokens.sh` | **1,917 tokens — Verification Passed** (≤ 2,000) |
| `init.sh` into `/tmp/test-project` (CI dry-run) | **PASS** — all 4 `docs/*` dirs, `PROMPTKIT.md`, `docs/STATE.md`, `AGENTS.md` created; directive present; new ceremony table injected (`grep -c` → 1); re-run marker count **1** |

**Conclusion: A does not break any existing check, including the one not wired into CI, and the
host-project install path still works.** The only behavioural change is intentional and is the
whole point: `route.md` is no longer preloaded for classification.

## 4. Projected result (recomputed with the measured 1,916)

| Path | Before | After | Saved |
| :--- | ---: | ---: | ---: |
| `pk:fix` | 12,861 | **5,933** | 6,928 (54%) |
| `pk:plan` | 24,666 | **17,738** | 6,928 (28%) |
| `pk:ship` | 24,761 | **13,839** | 10,922 (44%) |

---

## 5. Execution order & verification

Order matters: B is independent and low-risk, so land it first.

1. **B Step 1 + Step 2** → run `bash scripts/validate-references.sh .` (this is the check that proves the
   new relative link resolves and nothing else pointed at the moved text).
2. **A1 + A2 + A3** → run `bash scripts/measure-tokens.sh` and confirm
   `Verification Passed` at ≤ 2,000.
3. **Full gate**:
   ```bash
   bash scripts/tests/run-behavioral-contract-tests.sh   # expect Passed: 56 | Failed: 0
   bash scripts/validate-references.sh .                 # expect no broken links
   bash scripts/measure-tokens.sh                        # expect Verification Passed
   bash scripts/tests/run-init-safety-tests.sh           # expect idempotency holds
   bash scripts/validate-release-records.sh --root . --strict   # unchanged grandfather filter
   ```
4. `init.sh` into a scratch dir and confirm the injected `AGENTS.md` block is the new directive
   (the CI dry-run already does this; worth doing locally before pushing).

**Expected risk**: the highest-risk item is A1, because it edits the always-on payload that
`run-init-safety-tests.sh` byte-compares for idempotency. That test compares re-run output, not
specific content, so it should hold — but it is the one to watch.

**Rollback**: all four edits are confined to 4 files plus 1 new file. `git revert` of the two
commits restores the baseline exactly; no data migration is involved.

---

## 6. Deliberately out of scope

- Changes **C** (cross-reference tails, ~1,688 tok) and **D** (name normalisation) — separate
  commits, neither affects A or B's numbers materially.
- Any edit to the Level 0–3 model's semantics, `docs/releases/` content, or `scripts/`.
- New validators, schemas, or CI jobs beyond the single one-line budget assertion in A4.
