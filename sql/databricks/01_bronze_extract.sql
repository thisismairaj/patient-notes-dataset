-- Rebuilt after discovering Databricks' CSV reader (even with multiLine=>true)
-- mis-parses this file's real, messy clinical text (produced 84,033 rows against a
-- true count of 42,146 - confirmed via 2 independent parsers, Python csv + pandas,
-- both agreeing exactly, 0 nulls). Converted to JSONL locally instead - same reliable
-- line-based pattern already proven for Yelp/FHIR, no CSV quoting ambiguity possible.

CREATE OR REPLACE TABLE workspace.patient_notes_bronze.patient_notes AS
SELECT
  parsed.pn_num, parsed.case_num, parsed.pn_history,
  'patient_notes.jsonl' AS _source_file, current_timestamp() AS _loaded_at
FROM (
  SELECT from_json(value, 'STRUCT<pn_num:INT, case_num:INT, pn_history:STRING>') AS parsed
  FROM read_files('/Volumes/workspace/patient_notes_bronze/landing/patient_notes.jsonl', format => 'text')
);

-- Extraction: age, gender, and which clinical shorthand sections are present.
-- try_cast, not CAST - regexp_extract returns '' (not NULL) on no match, and CAST('' AS
-- INT) throws under ANSI mode (same bug class as an earlier to_date issue in the BRFSS
-- project) - nullif() turns '' into NULL first, then try_cast is just defensive backup.
CREATE OR REPLACE TABLE workspace.patient_notes_gold.patient_notes_extracted AS
SELECT
  pn_num, case_num,
  try_cast(nullif(regexp_extract(pn_history, '(\\d{1,3})[- ]?(?:year|yo|y\\.?o\\.?)', 1), '') AS INT) AS age_extracted,
  CASE WHEN pn_history RLIKE '(?i)\\bmale\\b' AND pn_history NOT RLIKE '(?i)\\bfemale\\b' THEN 'male'
       WHEN pn_history RLIKE '(?i)\\bfemale\\b' THEN 'female'
       ELSE NULL END AS gender_extracted,
  (pn_history RLIKE '(?i)ros:') AS has_ros_section,
  (pn_history RLIKE '(?i)pmh:') AS has_pmh_section,
  (pn_history RLIKE '(?i)fh:') AS has_fh_section,
  (pn_history RLIKE '(?i)sh:') AS has_sh_section,
  length(pn_history) AS note_length_chars
FROM workspace.patient_notes_bronze.patient_notes;

-- ---- Describe it ----
SELECT count(*) FROM workspace.patient_notes_bronze.patient_notes;                                  -- expect 42146
SELECT count(*) FROM workspace.patient_notes_bronze.patient_notes WHERE pn_history IS NULL OR pn_history = '';
SELECT count(DISTINCT case_num) AS distinct_cases FROM workspace.patient_notes_bronze.patient_notes;
SELECT min(length(pn_history)), max(length(pn_history)), avg(length(pn_history)) FROM workspace.patient_notes_bronze.patient_notes;

SELECT
  count(*) AS total,
  count(age_extracted) AS age_found,
  count(gender_extracted) AS gender_found,
  count(*) FILTER (WHERE has_ros_section) AS ros_found,
  count(*) FILTER (WHERE has_pmh_section) AS pmh_found
FROM workspace.patient_notes_gold.patient_notes_extracted;
