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
-- Find total number of confirmed cases by country.
-- ==================================================================

-- For single country
SELECT total_confirmed
FROM covid.total_confirmed_by_country
WHERE country = 'Sweden';
-- 2495996

-- For multiple countries (careful: on different partitions)
SELECT country, total_confirmed
FROM covid.total_confirmed_by_country
WHERE country IN ('Botswana', 'Norway', 'Tunisia');
-- Botswana	305859
-- Norway	1419507
-- Tunisia	1038668

-- Find country with max total confirmed.
SELECT MAX(total_confirmed) AS total_confirmed
FROM covid.total_confirmed_by_country;

SELECT country, total_confirmed
FROM covid.total_confirmed_by_country
WHERE total_confirmed = 80625120; 
-- US

-- Find country with min total confirmed.
SELECT MIN(total_confirmed) AS total_confirmed
FROM covid.ranking_total_cases;

SELECT country, total_confirmed
FROM covid.ranking_total_cases
WHERE total_confirmed = 1;
-- Micronesia

-- Find 5 highest min total confirmed by country.
SELECT total_confirmed
FROM covid.total_confirmed_by_country
WHERE country = 'Russia';

-- ==================================================================
-- 3)
-- Find given number of deaths and date by country, in descending 
-- order.
-- ==================================================================

-- Find 5 records for a country.
SELECT date, deaths
FROM covid.number_of_deaths_by_country
WHERE country = 'Senegal'
LIMIT 5;
-- 2022-03-23	1988
-- 2022-04-16	1965
-- 2022-04-02	1964
-- 2022-03-10	1962
-- 2022-03-06	1961

-- Find 1 record for a country.
SELECT date, deaths
FROM covid.number_of_deaths_by_country
WHERE country = 'Luxembourg' 
LIMIT 1;

-- ==================================================================
-- 4)
-- Find the province/state, population as well as the lat and long 
-- by country iso3 code.
-- ==================================================================

-- Find for iso 'BRA': Brazil.
SELECT province_state, lat, long, population
FROM covid.reference_info_by_iso3_country_code
WHERE iso3 = 'BRA';

-- ==================================================================
-- 5)
-- Find the province/state and population by second-level administra-
-- tive division (Admin2), in descending order by population.
-- ==================================================================

SELECT province_state, population
FROM covid.reference_info_by_admin2
WHERE iso3 = 'USA' AND population > 20000000;
--          	329466283
-- California	39512223
-- Texas	    28995881
-- Florida	    21477737

-- ==================================================================
-- 6)
-- Find country and total number of deaths by continent.
-- ==================================================================

-- Get all deaths for European countries.
SELECT country, total_deaths
FROM covid.country_total_deaths_by_continent
WHERE continent = 'Europe';

-- Get the Asian countries that starting with A or B.
-- Scuffed way, but works. Indexes would have been preferred.
SELECT country, total_deaths
FROM covid.country_total_deaths_by_continent
WHERE continent = 'Asia'
        AND country >= 'A' AND country < 'C';

-- ==================================================================
-- 7)
-- Find the dates of the first X days with confirmed Covid-19 by 
-- country, in ascending date order.
-- ==================================================================

SELECT date
FROM covid.first_date_confirmed_by_country
WHERE country = 'Denmark' AND confirmed > 0
LIMIT 1;
-- 2020-02-27

SELECT date
FROM covid.first_date_confirmed_by_country
WHERE country = 'Turkey' AND confirmed > 0
LIMIT 2;
-- 2020-03-11
-- 2020-03-12

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
