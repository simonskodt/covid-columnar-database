-- ==================================================================
-- Basic Testing Queries
-- ==================================================================

-- Select all records from table
SELECT *
FROM covid.date_and_country;

-- Count number of records (can be compared against initial csv file)
SELECT COUNT(*) 
FROM covid.date_and_country;

-- ==================================================================
-- 1)
-- Find certain countries and their number of confirmed, recovered 
-- and death observations for a certain timespan.
-- ==================================================================

-- Italy in certain days
SELECT * 
FROM covid.date_and_country
WHERE country IN ('Italy')
		AND date >= '2020-02-22'
		AND date <= '2020-06-28';

-- China in beginning of Covid-19
SELECT * 
FROM covid.date_and_country
WHERE country IN ('China') 
	AND date <= '2020-06-28';

-- ==================================================================
-- 2)
-- Find the countries with the highest or lowest total of confirmed, 
-- recovered and deaths.
-- ==================================================================

SELECT MAX(total_confirmed) AS total_confirmed
FROM covid.ranking_total_cases;

SELECT country, total_confirmed
FROM covid.ranking_total_cases
WHERE total_confirmed = 22963151317; 
-- US

SELECT MIN(total_confirmed) AS total_confirmed
FROM covid.ranking_total_cases;

SELECT country, total_confirmed
FROM covid.ranking_total_cases
WHERE total_confirmed = 451; 
-- Micronesia

-- We did not manage to be able to find the max 5 countries for 
-- instance.

-- ==================================================================
-- 3)
-- Find the province/state, population as well as the lat and long 
-- for all the second-level administrative division (Admin2).
-- ==================================================================

SELECT province_state, lat, long, population
FROM covid.administrative;

-- ==================================================================
-- 4)
-- Find the overall number of deaths per country in a specific 
-- continent.
-- ==================================================================

SELECT country, total_deaths
FROM countries_by_continents
WHERE continent = 'Europe';

SELECT country, total_deaths
FROM countries_by_continents
WHERE continent = 'Asia';
