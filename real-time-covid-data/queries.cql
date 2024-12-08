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

SELECT AVG(confirmed)
FROM stats_by_country_and_timespan;

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
-- 8)
-- Find the highest number of recovered and the associated date by
-- country.
-- ==================================================================

-- i) One version with generated total recovered dataset.
SELECT date, total_recovered
FROM covid.highest_recovered_by_country
WHERE country = 'Bahamas';

-- ii) Another version with plain dataset and max.
SELECT date, MAX(recovered) AS total_recovered
FROM covid.highest_recovered_using_max_by_country
WHERE country = 'Bahamas';

-- Finding the overall highest number of recovered for all countries.
-- Expensive query in its general form, but this column family is not
-- expected to have more than around 200 nodes.
SELECT MAX(total_recovered)
FROM covid.highest_recovered_by_country;
-- 30974748

SELECT date
FROM covid.highest_recovered_by_country
WHERE total_recovered = 30974748;
-- 2021-08-04	India

-- ==================================================================
-- 9)
-- Find the global date, confirmed, recovered and deaths by id (and
-- possible filter on dates), in ascending date order. 
-- ==================================================================

-- Search for a single id.
SELECT date, confirmed, recovered, deaths
FROM covid.global_stats_by_id
WHERE timeid = 49534000-46e1-11ea-adbb-07b5f1785483;
-- 2020-02-04	23899	857	  492

-- Search for multiple id in a certain date range.
SELECT date, confirmed, recovered, deaths
FROM covid.global_stats_by_id
WHERE timeid IN (c70b0000-4df3-11ea-9e19-60d3d9e6fd83,
             88d9c000-8a75-11ea-b367-d7cfcb188490,
             289ec000-bd18-11ec-8a51-6924fdbf10c0)
         AND date >= '2020-11-01' 
         AND date <= '2020-11-30';

-- ==================================================================
-- 10)
-- Find increase rate of confirmed cases by date.
-- ==================================================================

SELECT increase_rate
FROM covid.worldwide_increase_rate
WHERE date = '2020-11-01';
-- 0.9488934124549951

-- Not good practice, but interesting to see the result.
SELECT AVG(increase_rate) AS increase_rate
FROM covid.worldwide_increase_rate;
-- 1.8104079476807133