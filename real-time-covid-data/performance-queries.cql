-- ==================================================================
-- Queries for Testing Performance
-- ==================================================================

-- ==================================================================
-- EXPECTED POOR PERFORMANCE
-- Measure the approx average time taken for the query to run
SELECT country, date, MAX(confirmed)
FROM covid.performance_version_1
WHERE country IN ('Bahamas', 'Bahrain', 'Bangladesh', 'Morocco',
        'Mozambique', 'Netherlands', 'Papua New Guinea') 
		AND confirmed > 1000
ALLOW FILTERING;
-- Bahamas	2021-04-20	8194946

-- QUERY TIME on Apple M1 Pro (16GB RAM) using the RazorDB IDE
-- Average query time (10 initial runs): 0.6774 seconds

-- 0.816, 0.645, 0.967, 0.656, 0.676, 0.572, 0.604, 0.675, 0.632, 0.531
-- Lowest observed time after many more runs: 0.269 seconds
-- ==================================================================

-- ==================================================================
-- EXPECTED BETTER PERFORMANCE
SELECT country, date, MAX(confirmed)
FROM covid.performance_version_2
WHERE country IN ('Bahamas', 'Bahrain', 'Bangladesh', 'Morocco',
        'Mozambique', 'Netherlands', 'Papua New Guinea') 
		AND confirmed > 1000;
-- Bahamas	2021-04-20	8194946

-- QUERY TIME on Apple M1 Pro (16GB RAM) using the RazorDB IDE
-- Average query time (10 initial runs): 0.0744

-- 0.069, 0.048, 0.076, 0.1, 0.088, 0.034, 0.106, 0.088, 0.063, 0.072
-- Lowest observed time after many more runs: 0.02
-- ==================================================================

