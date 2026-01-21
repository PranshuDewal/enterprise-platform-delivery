-- Duplicate detection
SELECT id, COUNT(*) AS dup_count
FROM target_table
GROUP BY id
HAVING COUNT(*) > 1;

-- Null threshold check for critical fields
SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN critical_field IS NULL THEN 1 ELSE 0 END) AS null_count,
  ROUND(100.0 * SUM(CASE WHEN critical_field IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS null_pct
FROM target_table;

-- Referential integrity check
SELECT t.*
FROM target_table t
LEFT JOIN reference_table r ON t.ref_id = r.id
WHERE r.id IS NULL;

-- Source vs Target reconciliation counts
SELECT
  (SELECT COUNT(*) FROM source_table) AS source_count,
  (SELECT COUNT(*) FROM target_table) AS target_count;

-- Basic outlier check (example numeric field)
SELECT *
FROM target_table
WHERE numeric_measure < 0 OR numeric_measure > 1000000;
