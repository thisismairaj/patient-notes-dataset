# Scope and gaps — NBME Clinical Patient Notes (Stretch)

## Source
Kaggle: `nbme-score-clinical-patient-notes` (https://www.kaggle.com/c/nbme-score-clinical-patient-notes/data)
`patient_notes.csv`: 295,008 rows (295,009 lines - 1 header, confirmed via `wc -l`),
34.97 MB compressed.

Columns: `pn_num` (note ID), `case_num` (which clinical case scenario), `pn_history`
(the free-text clinical note itself).

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
