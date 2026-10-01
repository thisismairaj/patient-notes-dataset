# NBME Clinical Patient Notes — Stretch Dataset

Real clinical patient history notes (42,146 of them), extracted and profiled as the
**Stretch** dataset (unstructured text, requires extraction) for a team brief comparing
Databricks and Snowflake as a data platform. Sibling repos cover the other slots:
[data-lab2](https://github.com/thisismairaj/data-lab2) (BRFSS health-survey build,
core comparison), [yelp-dataset](https://github.com/thisismairaj/yelp-dataset)
(Secondary, semi-structured), [fhir-dataset](https://github.com/thisismairaj/fhir-dataset)
(deeply nested + streaming ingestion).

## What this is

[NBME's Clinical Patient Notes](https://www.kaggle.com/c/nbme-score-clinical-patient-notes/data)
Kaggle competition data: real free-text clinical notes written during standardized-patient
medical exams, one row per note, referencing 10 distinct clinical case scenarios.

| | |
|---|---|
| Rows | **42,146** |
| Columns | `pn_num`, `case_num`, `pn_history` (the free text) |
| Blanks | 0 |
| Case scenarios | 10 |
| Note length | 30–950 characters, avg 818 |

## The brief's actual bar for this slot

Per the brief, Stretch just needs: *"Bring in a file-based dataset and extract
something usable from it,"* described (row counts/blanks/ranges), with cost/time
recorded — and it's explicitly optional/droppable if it costs time. This repo is
deliberately lean, not a full medallion pipeline like the Primary/Secondary datasets
got.

## What was extracted

Real structured facts pulled out of free text via SQL regex — no ML needed for this
scope:

| Field | Found in |
|---|---|
| Age | 82.3% of notes |
| Gender | 38.3% |
| ROS section present (Review of Systems) | 44.1% |
| PMH section present (Past Medical History) | 50.3% |
| FH / SH sections (Family / Social History) | also extracted |

Yields aren't 100% because not every note uses the same labeled-shorthand style
(`ros:`, `pmh:`) — some are full prose instead. That's expected, not a bug.

## A real bug, caught and fixed

The original row count recorded here was **wrong**: 295,008, from `wc -l` on the raw
CSV. That's wrong because `pn_history` contains embedded newlines inside quoted CSV
fields, so physical line count isn't the same as logical record count.

Databricks' own CSV reader (even with `multiLine => true`) *also* got it wrong —
84,033 rows, with 33,572 showing as blank `pn_history` that don't actually exist —
a real quote-escaping edge case in the messy real-world clinical text.

**Resolved by cross-checking two independent parsers** (Python's `csv` module and
pandas), which agreed exactly: **42,146 rows, 0 nulls**. Fixed by converting the file
to JSONL locally (no CSV quoting ambiguity possible) before loading it.

## Layout

```
sql/databricks/     bronze load + regex extraction
scripts/db_run.py   runs SQL against Databricks via the Statement Execution API
data/raw/           local staging for the Kaggle CSV
```

## Running it

1. Get `patient_notes.csv` from [Kaggle](https://www.kaggle.com/c/nbme-score-clinical-patient-notes/data)
   (competition rules apply — not redistributed here)
2. `scripts/db_run.py sql/databricks/01_bronze_extract.sql` (reads from a Databricks
   Unity Catalog volume — update the paths for your own workspace)

## License

Code in this repo: no restriction. The underlying Kaggle competition data is **not**
included — get it from Kaggle directly, subject to the competition's own terms.
