CREATE KEYSPACE IF NOT EXISTS covid WITH REPLICATION = { 
    'class' : 'SimpleStrategy',
    'replication_factor' : '1' 
};

-- ==================================================================
-- 1)
-- Find number of confirmed, recovered, and death observations by
-- country and certain timespan.
-- ==================================================================
DROP TABLE IF EXISTS covid.stats_by_country_and_timespan;
CREATE TABLE IF NOT EXISTS covid.stats_by_country_and_timespan (
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY((country), date)
);

-- ==================================================================
-- 2)
-- Find total number of confirmed cases by country.
-- ==================================================================
DROP TABLE IF EXISTS covid.total_confirmed_by_country;
CREATE TABLE IF NOT EXISTS covid.total_confirmed_by_country (
    country TEXT,
    total_confirmed BIGINT,
    total_recovered BIGINT,
    total_deaths BIGINT,
    PRIMARY KEY((country), total_confirmed)
);

-- ==================================================================
-- 3)
-- Find given number of deaths and date by country, in descending 
-- order.
-- ==================================================================
DROP TABLE IF EXISTS covid.number_of_deaths_by_country;
CREATE TABLE IF NOT EXISTS covid.number_of_deaths_by_country (
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY((country), deaths)
)  WITH CLUSTERING ORDER BY (deaths DESC);

-- ==================================================================
-- 4)
-- Find the province/state, population as well as the lat and long 
-- by country iso3 code.
-- ==================================================================
DROP TABLE IF EXISTS covid.reference_info_by_iso3_country_code;
CREATE TABLE IF NOT EXISTS covid.reference_info_by_iso3_country_code (
    uid INT,
    iso3 TEXT,
    admin2 TEXT,
    province_state TEXT,
    lat DOUBLE,
    long DOUBLE,
    population BIGINT,
    PRIMARY KEY((iso3), uid)
);
-- N.B: If iso3 was empty, we replace with the string 'NUL'.

-- ==================================================================
-- 5)
-- Find the province/state and population by second-level administra-
-- tive division (Admin2), in descending order by population.
-- ==================================================================
DROP TABLE IF EXISTS covid.province_info_by_admin2;
CREATE TABLE IF NOT EXISTS covid.province_info_by_admin2 (
    uid INT,
    iso3 TEXT,
    admin2 TEXT,
    province_state TEXT,
    lat DOUBLE,
    long DOUBLE,
    population BIGINT,
    PRIMARY KEY((iso3), population, admin2)
) WITH CLUSTERING ORDER BY (population DESC);
-- N.B: If population was empty, we replace with 'NUL".
--      If admin2 was empty, the value 0.

-- ==================================================================
-- 4)
-- Find the continent with the least overall number of deaths.
-- ==================================================================
DROP TABLE IF EXISTS covid.countries_by_continents;
CREATE TABLE IF NOT EXISTS covid.countries_by_continents (
    continent TEXT,
    country TEXT,
    total_confirmed BIGINT,
    total_recovered BIGINT,
    total_deaths BIGINT,
    PRIMARY KEY(continent, country, total_deaths)
);

-- ==================================================================
-- 5)
-- Find the first day that a country experienced Covid-19.
-- ==================================================================
DROP TABLE IF EXISTS covid.covid_first_day;
CREATE TABLE IF NOT EXISTS covid.covid_first_day (
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY(country, confirmed, date)
);

-- ==================================================================
-- 6)
-- Find the country and the associated date with the highest number 
-- of daily recovered. 
-- ==================================================================
DROP TABLE IF EXISTS covid.highest_daily_recovered;
CREATE TABLE IF NOT EXISTS covid.highest_daily_recovered (
    date DATE,
    country TEXT,
    total_recovered INT,
    PRIMARY KEY(total_recovered)
);

-- ==================================================================
-- 7)
-- Find global entries by id and filter on the date.
-- ==================================================================
DROP TABLE IF EXISTS covid.worldwide_with_id;
CREATE TABLE IF NOT EXISTS covid.worldwide_with_id (
    id UUID,
    date DATE,
    confirmed INT,
    recovered INT,
    deaths INT,
    increase_rate DOUBLE,
    PRIMARY KEY(id, date)
);
-- Not necessary because of natural ordering.
-- WITH CLUSTERING ORDER BY (confirmed DESC);

-- ==================================================================
-- 8)
-- Find the average increase rate of confirmed cases.
-- ==================================================================
DROP TABLE IF EXISTS covid.worldwide_increase_rate;
CREATE TABLE IF NOT EXISTS covid.worldwide_increase_rate (
    date DATE,
    confirmed INT,
    recovered INT,
    deaths INT,
    increase_rate DOUBLE,
    PRIMARY KEY(date)
);

-- Index on increase_rate for avg calculation performance.
CREATE INDEX ON covid.worldwide_increase_rate (increase_rate);
