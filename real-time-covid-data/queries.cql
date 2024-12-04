-- ==================================================================
-- Basic Queries
-- ==================================================================


-- Select all records from table
SELECT *
FROM covid.countries_aggregated;

-- Count number of records (can be compared against initial csv file)
SELECT COUNT(*) 
FROM covid.countries_aggregated;

-- Afghanistan in certain days, the allow filtering is for enabling
-- filtering on non-primary key columns (worse performance)
SELECT * 
FROM covid.countries_aggregated
WHERE country = 'Afghanistan' 
		AND date >= '2020-01-22' 
		AND date <= '2020-01-31' 
		allow filtering;

-- NOT ALLOWED
-- Group by is currently only supported on of the primary key
SELECT country, SUM(confirmed) AS total_confirmed
FROM covid.countries_aggregated
GROUP BY country;

-- ==================================================================
-- Table Aggregated by Country
-- ==================================================================


-- Total confirmed cases by country
SELECT country, SUM(confirmed) AS total_confirmed
FROM covid.countries_aggregated_by_country
GROUP BY country;

-- Total recovered and deaths by country
SELECT country, SUM(recovered) AS total_recovered, SUM(deaths) AS total_deaths
FROM covid.countries_aggregated_by_country
GROUP BY country;

-- Daily cases for Denmark
SELECT date, confirmed
FROM covid.countries_aggregated_by_country
WHERE country = 'Denmark'
ORDER BY date;

-- ==================================================================
-- Table Aggregated by Country and Confirmed
-- ==================================================================

-- Top 5 highest countries with confirmed cases
SELECT country, SUM(confirmed) AS total_confirmed
FROM covid.countries_aggregated_by_country
GROUP BY country
ORDER BY total_confirmed DESC
LIMIT 5;

