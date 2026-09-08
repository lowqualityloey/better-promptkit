# Execution-Control Validator Fixtures

These fixtures are synthetic and local-only. They contain no real commit, release, remote, or deployment identifiers.

- `valid/` contains a completed Task Record with linked scope-change, checkpoint, handoff, and `docs/STATE.md` projection evidence. Both validators must return `VALID|RECORDS=4|ROOT=.` with exit code 0.
- `invalid/` contains the original compound readiness, policy-limitation, active-task, transition, and scope-change failures. Both validators must return nonzero and the same 13 diagnostic lines.
- `cases/` contains isolated synthetic roots for readiness fields, duplicate active tasks, illegal transitions, hard checkpoints, valid `blocked`/`paused`/`aborted` states, scope expansion, handoffs, blockers, completion evidence, traceability, revision and STATE projections, and timer limitations. The valid stop-state rows return exit code 0; negative rows isolate one supported diagnostic category.
- `expected/` contains the tab-separated `cases.tsv` manifest plus one shared summary and diagnostic contract per isolated case. Bash and PowerShell consume the same expected files.
- `expected-valid.txt`, `expected-invalid.txt`, and `expected-invalid-summary.txt` remain the shared regression contract for the original roots.

Run the paired harnesses from the repository root:

```text
bash scripts/tests/run-execution-control-fixtures.sh
pwsh -NoProfile -File .\scripts\tests\run-execution-control-fixtures.ps1
```

The harnesses invoke the native validator for each platform, capture expected nonzero failure status, normalize semantic diagnostics, and snapshot fixture/repository hashes plus Git status before and after each run. Temporary capture files are created outside the repository.

Execution-control validation is durable evidence only; it cannot observe live chat duration or approve external actions.
