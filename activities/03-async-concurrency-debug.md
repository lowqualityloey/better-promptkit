# Activity 03: Diagnosing Asynchronous Concurrency & Memory Leaks

## Overview
Investigate and resolve a critical, intermittent bug in a real-time collaborative workspace app: when users switch rapidly between projects, the UI intermittently displays stale project data, CPU usage climbs to 100%, and Node.js logs warn of `MaxListenersExceededWarning` and eventual Out-Of-Memory (OOM) crashes.

---

## The Mystery Symptoms

1. **Stale Data Glitch**: Fast typing or fast tab clicking occasionally renders data from the previous tab over the current tab.
2. **Memory Leak**: Memory footprint grows by 35MB per tab switch and is never garbage collected.
3. **Event Listener Saturation**: `MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 project_updated listeners added`.

---

## Simulation Steps

### Step 1: Scientific Hypothesis Formulation (`workflow debug`)
1. Activate the debug workflow: `activate the debug workflow for async race condition and memory leak`.
2. Construct a minimal reproduction script simulating rapid tab switches in an automated loop.
3. Draft 3 falsifiable hypotheses regarding the root cause (e.g., missing `AbortController` signal cancellation, un-unsubscribed WebSocket listener, closure retaining large object references).

### Step 2: Diagnostic Instrumentation & Falsification
1. Instrument the lifecycle hooks or event emitters with counter logs:
   - Check if listener registration count matches teardown count.
   - Trace unresolved promises when tab IDs change before completion.
2. Confirm the root cause using the 5 Whys.

### Step 3: Implement Surgical Remediation
1. Introduce cancellation tokens (`AbortController`) to automatically cancel in-flight network promises when a new request is dispatched or the component unmounts.
2. Ensure event emitter subscriptions are cleanly deregistered in the teardown/cleanup phase.
3. Replace mutable shared closures with scoped, immutable state transitions.

### Step 4: Write Automated Regression Test
1. Write a Vitest/Jest unit test that triggers 50 simulated concurrent aborts and verifies:
   - Only the latest promise updates the final state.
   - Event listener count remains exactly zero after teardown.

### Step 5: Post-Mortem Documentation (`templates/rca-postmortem-template.md`)
1. Fill out a Root Cause Analysis post-mortem capturing the timeline, 5 Whys, and preventative measures.

---

## Success Criteria
- [ ] Reproducible failing test created before fixing the bug.
- [ ] Zero race conditions or stale updates under high-concurrency simulation.
- [ ] Memory leak eliminated and verified via memory profiling or listener counter assertions.
- [ ] RCA document created in `notes/spikes/` or project docs.
