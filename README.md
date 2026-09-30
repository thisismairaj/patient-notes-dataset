# NBME Clinical Patient Notes — Stretch Dataset

Stretch slot (unstructured text, requires extraction) for the brief being worked on
in `D:\data-lab2`, `D:\yelp-dataset`, `D:\fhir-dataset`. Real clinical patient notes,
**42,146 rows** (corrected from an initial wrong `wc -l`-based count of 295,008 - see
`docs/scope_and_gaps.md`/`docs/learning_log.md`). See `docs/scope_and_gaps.md` for
what the brief actually requires here (deliberately less than the other repos -
Stretch is optional and lean by design).

## Layout
- `docs/` — scope/gaps, learning log
- `sql/databricks/` — bronze + extraction SQL
- `data/raw/` — local staging (git-ignored)
