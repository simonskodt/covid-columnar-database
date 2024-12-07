-- ==================================================================
-- Basic Queries
-- ==================================================================

-- Select all records from table
SELECT *
FROM countries_aggregated;

-- Count number of records (can be compared against initial csv file)
SELECT COUNT(*) 
FROM countries_aggregated;

-- Afghanistan in certain days, the allow filtering is for enabling
-- filtering on non-primary key columns (worse performance)
SELECT * 
FROM countries_aggregated
WHERE country = 'Afghanistan' 
		AND date >= '2020-01-22' 
		AND date <= '2020-01-31' 
		allow filtering;

-- NOT ALLOWED
-- Group by is currently only supported on of the primary key
SELECT country, SUM(confirmed) AS total_confirmed
FROM countries_aggregated
GROUP BY country;

-- ==================================================================
-- Table Aggregated by Country
-- ==================================================================

-- Total confirmed cases by country
SELECT country, SUM(confirmed) AS total_confirmed
FROM countries_aggregated_by_country
GROUP BY country;

-- Total recovered and deaths by country
SELECT country, SUM(recovered) AS total_recovered, SUM(deaths) AS total_deaths
FROM countries_aggregated_by_country
GROUP BY country;

-- Daily cases for Denmark
SELECT date, confirmed
FROM countries_aggregated_by_country
WHERE country = 'Denmark'
ORDER BY date;

-- ==================================================================
-- Table Aggregated by Country and Confirmed
-- ==================================================================

-- Countries with total confirmed, recovered, and death cases
SELECT *
FROM countries_aggregated_sum

-- Countries ordered by with total confirmed cases
SELECT country, SUM(confirmed) AS total_confirmed
FROM countries_aggregated_sum_order_by_confirmed
ORDER BY total_confirmed;
