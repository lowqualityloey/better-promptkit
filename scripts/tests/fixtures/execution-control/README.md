# Execution-Control Validator Fixtures

These fixtures are synthetic and local-only. They contain no real commit, release, remote, or deployment identifiers.

- `valid/` contains a completed Task Record with linked scope-change, checkpoint, handoff, and `docs/STATE.md` projection evidence. Both validators must return `VALID|RECORDS=4|ROOT=.` with exit code 0.
- `invalid/` contains readiness, policy-limitation, active-task, transition, and scope-change failures. Both validators must return nonzero and the same diagnostic lines.

Run from the repository root:

```text
bash scripts/validate-execution-control.sh --root scripts/tests/fixtures/execution-control/valid --strict
pwsh -NoProfile -File .\scripts\validate-execution-control.ps1 -Root .\scripts\tests\fixtures\execution-control\valid -Strict
```

The validator is read-only. Fixture tests also snapshot hashes and Git status to ensure execution does not mutate records or repository state.
