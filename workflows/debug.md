# Debug Workflow (Hypothesis-Driven Root Cause Analysis)

## Fast Shorthand
Trigger anytime with: `pk:debug` (or `/pk-debug`)

## Mission
Guide the developer through **Scientific, Hypothesis-Driven Debugging** and systematic Root Cause Analysis (RCA). Move away from random trial-and-error changes ("shotgun debugging") to structured observation, reproduction isolation, hypothesis falsification, minimal root-cause fixes, and regression test prevention.

---

## The Scientific Debugging Loop

```
┌─────────────────────────────────────────────────────────────┐
│                 SCIENTIFIC DEBUGGING LOOP                   │
├─────────────────────────────────────────────────────────────┤
│ 1. Observe & Isolate Defect (Symptom vs. Cause)             │
│    Create minimal reproducible example / test case          │
├─────────────────────────────────────────────────────────────┤
│ 2. Formulate Falsifiable Hypotheses                         │
│    State explicit cause-and-effect assumptions              │
├─────────────────────────────────────────────────────────────┤
│ 3. Execute Falsification Experiments                        │
│    Use logs, breakpoints, or isolated assertions            │
├─────────────────────────────────────────────────────────────┤
│ 4. Identify Root Cause (5 Whys)                             │
│    Trace failure to the fundamental broken invariant        │
├─────────────────────────────────────────────────────────────┤
│ 5. Implement Minimal Surgical Fix                           │
│    Fix the underlying defect without collateral complexity  │
├─────────────────────────────────────────────────────────────┤
│ 6. Write Regression Test & Prevent Recurrence               │
│    Lock in the fix so the bug can never return              │
└─────────────────────────────────────────────────────────────┘
```

---

## Preconditions
- Developer is facing an active bug, test failure, race condition, memory leak, or unexpected runtime behavior.
- Access to terminal/debugger and project test runner.
- Access to `.promptkit/templates/rca-postmortem-template.md`.

---

## Workflow Steps

### Step 1: Characterize the Defect & Isolate Reproduction
1. Gather exact factual evidence:
   - **Observed Behavior**: What actually happened? (Include exact stack trace, error message, HTTP code, or visual glitch).
   - **Expected Behavior**: What should have happened according to specs/contracts?
   - **Preconditions / Triggers**: What sequence of user inputs, network states, or environment conditions triggers the bug?
2. Construct a **Minimal Reproducible Example (MRE)** or automated failing test:
   - Write a unit or integration test that reliably triggers the failure.

### Step 2: System Boundary & State Inspection
1. Trace the execution path:
   - Where does input enter the system?
   - Where does state mutate?
   - Where does the symptom first manifest?
2. Inspect runtime state:
   - Place targeted structured logs or debugger breakpoints immediately before the failure point.
   - Verify assumptions about variable types, nullability, promise resolution timing, or database state.

### Step 3: Formulate Falsifiable Hypotheses
Draft 2-3 concrete, testable hypotheses ranked by likelihood:
- *Hypothesis A*: "The token refresh promise rejects because the refresh token is consumed twice concurrently on page reload."
- *Hypothesis B*: "The state setter receives a stale closure because the `useEffect` dependency array is missing `workspaceId`."
- *Hypothesis C*: "The database query returns null because the UUID casing differs between PostgreSQL and the incoming API parameter."

### Step 4: Execute Falsification Tests
Test one hypothesis at a time:
- Do not change production code yet!
- Add temporary assertion or log output to prove or disprove the hypothesis.
- If a hypothesis is disproven, eliminate it cleanly and proceed to the next.

### Step 5: Root Cause Analysis (5 Whys)
Once the defect point is confirmed, drill down to the fundamental root cause:
1. *Why did the UI render blank?* — Because `data.user` was undefined.
2. *Why was `data.user` undefined?* — Because the API returned `{ error: 'Unauthorized' }`.
3. *Why did the API return Unauthorized?* — Because the authorization header was missing the `Bearer` prefix.
4. *Why was the prefix missing?* — Because a recent refactor to the HTTP client stripped the prefix in the interceptor.
5. *Why did tests not catch this?* — Because unit tests mocked the HTTP interceptor output directly instead of testing the interceptor itself.

### Step 6: Surgical Fix & Regression Lock-in
1. Guide the developer to write the minimal, cleanest fix addressing the root cause.
2. Verify that the automated failing test from Step 1 now passes.
3. Run the full test suite to ensure zero regressions in related features.
4. If this was a high-severity or production incident, draft an RCA post-mortem using `.promptkit/templates/rca-postmortem-template.md` and save to `./docs/rca/YYYY-MM-DD-rca-<incident-name>.md`.

---

## Anti-Patterns to Avoid
- ❌ **Shotgun Debugging**: Modifying multiple lines of code at once hoping something works.
- ❌ **Symptom Masking**: Wrapping errors in empty `try/catch` or adding `?.` null-checks without understanding why the value was null.
- ❌ **Skipping the Regression Test**: Fixing a bug without writing an automated test to prevent recurrence.

---

## Completion Criteria
- Root cause clearly identified and explained by the developer.
- Bug reliably fixed with minimal surgical code changes.
- Automated regression test committed to prevent future recurrence.
- Learning logged in `.promptkit/notes/progress-journal.md` with key takeaways.
