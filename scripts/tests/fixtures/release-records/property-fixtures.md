# Release-record property fixtures

PR B uses seven independent tab-separated fixture files:

- `property-01.tsv`: eligible evidence and maintenance declarations.
- `property-02.tsv`: bounded, reproducible, candidate-inclusive ranges.
- `property-03.tsv`: latest approved baseline resolution.
- `property-04.tsv`: evidence-driven impact classification.
- `property-05.tsv`: greatest impact and First Release candidate policy.
- `property-06.tsv`: preliminary provenance and prerelease promotion.
- `property-07.tsv`: approval justification and version/tag alignment.

Each row is `case-id<TAB>entity-kind<TAB>field<TAB>value`. A property owns all of its input cases and can be executed independently. Values use `NONE` for an absent value, comma-separated lists for ordered collections, and semicolons for property-03 record collections.

Run both local harnesses from the repository root:

```text
bash scripts/tests/run-release-record-properties.sh
pwsh -NoProfile -File .\scripts\tests\run-release-record-properties.ps1
```

Both harnesses use seed `20260908` and run 100 iterations for every property. They read only these committed fixtures, keep generated histories, evidence, SemVer values, QA outcomes, and action logs in memory, and do not invoke Git, network, release, publication, deployment, or rollback operations. Passing property evidence never authorizes an external release action.

PR C extends the fixture set with:

- `property-08.tsv`: one normalized effective set shared by candidate and note derivation, including merge, squash, duplicate, full-revert, partial-revert, and maintenance cases.
- `property-09.tsv`: derives impact projections from the effective item set before evaluating empty-range defer, no-contract-change approval, invalid decision, and impactful-range controls.
- `property-10.tsv`: exact-once public and maintenance notes, unpublished draft changelog entries, duplicate/full-revert exclusion, and breaking-guidance coverage.
- `property-11.tsv`: unsupported classification and inaccurate-note blockers, correction/re-review, no-re-review blocking, clean QA pass, and a clean-path unresolved-final-blocker control.
- `property-12.tsv`: shared Evaluation ID, derived candidate range membership, tag/version, valid SemVer and precedence, approval rationale, QA/note linkage, malformed core records, and action-request consistency cases.

The paired harnesses now run Properties 1-12. Property 8 captures one canonical normalized serialization and passes that exact snapshot to both candidate and note projections. Property 9 derives the empty-range impact list from its effective item IDs and rejects mismatched projection metadata. Property 11 blocks approval when a final blocker remains unresolved even when initial QA is clean. Property 12 derives candidate occurrence and end-position facts from the ordered range, validates all core SemVer values and shared IDs, and records external action requests without invoking them. Properties 9-12 keep external actions as data-only requests and require an empty in-memory action log.
