# Scope and gaps — NBME Clinical Patient Notes (Stretch)

## Source
Kaggle: `nbme-score-clinical-patient-notes` (https://www.kaggle.com/c/nbme-score-clinical-patient-notes/data)
`patient_notes.csv`: **42,146 rows** (corrected - see "row count correction" below),
34.97 MB compressed, 10 distinct clinical case scenarios (~4,215 notes/case), 0 blank
notes.

Columns: `pn_num` (note ID), `case_num` (which clinical case scenario), `pn_history`
(the free-text clinical note itself).

## Row count correction (2026-09-30)
Originally recorded as 295,008 rows via `wc -l` (295,009 lines - 1 header). That was
**wrong**: `pn_history` contains embedded newlines inside quoted CSV fields, so
physical line count is not the same as logical record count for this file -
`wc -l` massively overcounts. Databricks' own CSV reader (`read_files` with
`multiLine => true`) also got it wrong: 84,033 rows, with 33,572 showing as blank
`pn_history` that don't actually exist - its quote-handling mis-parses this real,
messy clinical text (likely an unescaped internal quote mark splitting single logical
records into two rows).

**Resolved via two independent parsers agreeing exactly**: Python's `csv` module and
pandas both give **42,146 rows, 0 nulls in pn_history**. Fixed by converting the file
to JSONL locally (no CSV quoting ambiguity possible) and loading that instead - same
reliable line-based pattern already proven for Yelp/FHIR bronze.

**Confirmed real, not synthetic**: genuine typos ("dispnea", "exersion", "dyaphoresis",
"mariguana"/"marijuanna" spelled two different ways in adjacent notes) and real
clinical documentation shorthand ("ros:", "pmh:", "fh:", "sh:") - authentic medical
student note-taking, not generated text.

## What the brief actually asks for here (Stretch, per docs/brief.md)
Just: "Bring in a file-based dataset and extract something usable from it," described
(row counts/blanks/ranges) and cost/time recorded. Explicitly optional/droppable if it
costs time. NOT the full medallion/quarantine/star-schema treatment the Secondary and
Primary-adjacent datasets got - deliberately kept lean here.

## Deviations from the brief
(none yet)
