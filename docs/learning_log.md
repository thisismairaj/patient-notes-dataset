# Learning log — NBME Clinical Patient Notes (Stretch)

## Day (2026-09-30) — a wrong row count made it into docs and a commit, caught and fixed

**`wc -l` is not a reliable row count for CSV files with embedded newlines in quoted
fields.** Recorded "295,008 rows" from `wc -l` early on - genuinely wrong, and it had
already been committed to docs and a git commit message before the error was caught.
`pn_history` contains real embedded newlines inside quotes (visible in the very first
row previewed), so physical line count overcounts logical records substantially.

**Databricks' own CSV reader, even with `multiLine => true`, mis-parsed this file
too** - 84,033 rows loaded, with 33,572 showing as blank `pn_history` that don't
actually exist in the source. Real, messy clinical text apparently has at least one
case of an unescaped internal quote character that splits a single logical record
into two rows for Spark's CSV reader, even in multi-line mode.

**Resolved by cross-checking with two independent, mature parsers, not by trusting
either number.** Python's built-in `csv` module and pandas both independently landed
on exactly 42,146 rows with 0 nulls - agreement between two differently-implemented
parsers is much stronger evidence than either one alone. Fixed the actual load by
converting to JSONL locally (a format with no CSV quoting ambiguity) and loading that
into Databricks instead of fighting the CSV reader's edge case - same reliable
line-based pattern already proven working for Yelp and FHIR bronze.

**The `CAST('' AS INT)` bug from earlier in this project (BRFSS's `to_date`/ANSI mode
issue) showed up again, same root cause, different function.** `regexp_extract`
returns `''` (empty string) on no match, not NULL - `CAST('' AS INT)` throws under
ANSI mode. Fixed with `try_cast(nullif(x, '') AS INT)` before it was ever run, not
after a failure this time - recognized the pattern from having hit it before.

**Real extraction yields, once the row count was actually correct:** of 42,146 notes,
age found in 82.3%, gender in 38.3%, ROS section in 44.1%, PMH section in 50.3% -
honest partial yields. Not every note follows the same shorthand convention; some are
terse bullet lists, some are full prose, confirmed by looking at real examples before
building the extraction rules.
