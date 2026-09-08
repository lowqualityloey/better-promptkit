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
