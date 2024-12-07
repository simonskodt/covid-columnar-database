-- ========================================
-- Test Performance of Queries
-- ========================================

-- Drop the index on the confirmed cases
DROP INDEX IF EXISTS countries_aggregated_confirmed_idx;

-- Measure the time taken for the query to run
SELECT * 
FROM countries_aggregated 
WHERE confirmed > 1000
allow filtering;
-- Query time: 0.02 to 0.04 on M1 Mac

-- Create an index on the confirmed cases
CREATE INDEX ON countries_aggregated (confirmed);

SELECT * 
FROM countries_aggregated
WHERE confirmed > 1000
allow filtering;
-- Query time: 0.02 to 0.04 on M1 Mac

