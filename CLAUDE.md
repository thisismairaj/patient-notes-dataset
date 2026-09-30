# Project: NBME Clinical Patient Notes — Stretch Dataset (brief)

## What this is
The **Stretch** slot for the same brief as the sibling repos (`D:\data-lab2` BRFSS,
`D:\yelp-dataset` Secondary, `D:\fhir-dataset`). Per the brief itself, Stretch needs
FAR less than the other two got: "Bring in a file-based dataset and extract something
usable from it" - one checkbox, not a full medallion pipeline. It's also explicitly
optional/droppable if it costs time. Do NOT over-build this one.

**Data:** Kaggle competition `nbme-score-clinical-patient-notes` -
https://www.kaggle.com/c/nbme-score-clinical-patient-notes/data. Real clinical patient
history notes written by medical students/standardized-patient exams - genuine
unstructured free text (confirmed real: authentic typos, real clinical shorthand),
not synthetic.

## Rules (same as sibling repos, condensed)
- Never invent numbers - real runs only.
- No secrets in code.
- Commit after each working step.
- Keep this one lean - the brief's own bar for Stretch is low, don't gold-plate it.

## How to teach me
Simple English, explain new concepts, one step at a time, ask a checkpoint question
before moving on. Skip re-explaining anything already covered in the sibling repos.
