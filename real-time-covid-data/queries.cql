-- ==================================================================
-- Basic Testing Queries
-- ==================================================================

-- Select all records from table
SELECT *
FROM covid.stats_by_country_and_timespan;
-- WARNING: Bad practice with * operand without where-clause

-- Count number of records (can be compared against initial csv file)
SELECT COUNT(*) 
FROM covid.stats_by_country_and_timespan;

-- ==================================================================
-- 1)
-- Find number of confirmed, recovered, and death observations by
-- country and certain timespan.
-- ==================================================================

-- Italy in certain days
SELECT date, confirmed, deaths, recovered
FROM covid.stats_by_country_and_timespan
WHERE country = 'Italy'
		AND date >= '2020-02-22'
		AND date <= '2020-06-28';

-- China and Italy in beginning of Covid-19
SELECT country, date, confirmed, deaths, recovered
FROM covid.stats_by_country_and_timespan
WHERE country IN ('Italy', 'China') 
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
WHERE total_confirmed = 80625120; 
-- US

SELECT MIN(total_confirmed) AS total_confirmed
FROM covid.ranking_total_cases;

SELECT country, total_confirmed
FROM covid.ranking_total_cases
WHERE total_confirmed = 1;
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

-- ==================================================================
-- 5)
-- Find the first day that a country experienced Covid-19.
-- ==================================================================

SELECT country, confirmed, date
FROM covid.covid_first_day
WHERE country = 'Denmark' AND confirmed > 0
LIMIT 1;
-- 2020-02-27

SELECT country, confirmed, date
FROM covid.covid_first_day
WHERE country = 'Turkey' AND confirmed > 0
LIMIT 1;
-- 2020-03-11

-- ==================================================================
-- 6)
-- Find the country and the associated date with the highest number 
-- of daily recovered. 
-- ==================================================================

SELECT MAX(total_recovered)
FROM covid.highest_daily_recovered;
-- 30974748

SELECT date
FROM covid.highest_daily_recovered
WHERE total_recovered = 30974748;
-- 2021-08-04	India

-- ==================================================================
-- 7)
-- Find global entries by id and filter on the date.
-- ==================================================================

SELECT date, confirmed, recovered, deaths
FROM covid.worldwide_with_id
WHERE id IN (1b423c48-8a3c-41d3-bfae-41a678e97a8e,
             b3962296-6ea4-4132-9240-1854c178ad0d,
             6b4bf98b-f94b-46e8-96d4-4c0023031837,
             92f8fce8-bc8f-4f48-aed0-4b7cc90fc13d,
             7d0a4e87-1aa6-4b40-b289-f96dcdc379f7)
         AND date >= '2020-11-01' 
         AND date <= '2020-11-30';

-- ==================================================================
-- 8)
-- Find the average increase rate of confirmed cases.
-- ==================================================================

SELECT AVG(increase_rate)
FROM covid.worldwide_increase_rate;
