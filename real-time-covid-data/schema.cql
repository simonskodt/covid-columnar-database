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
-- 6)
-- Find country and total number of deaths by continent.
-- ==================================================================
DROP TABLE IF EXISTS covid.country_total_deaths_by_continent;
CREATE TABLE IF NOT EXISTS covid.country_total_deaths_by_continent (
    continent TEXT,
    country TEXT,
    total_confirmed BIGINT,
    total_recovered BIGINT,
    total_deaths BIGINT,
    PRIMARY KEY((continent), country)
);
-- N.B: None of these two indexes worked, SASI need imports, that we
-- do not want to spend time on.

-- i) Secondary index on country.
-- CREATE INDEX IF NOT EXISTS covid.country_total_deaths_by_continent ON covid.country_total_deaths_by_continent (country);
-- ii) SASI index for like operation on countries.
-- CREATE CUSTOM INDEX IF NOT EXISTS country_index ON covid.country_total_deaths_by_continent (country)
-- USING 'org.apache.cassandra.index.sasi.SASIIndex';

-- ==================================================================
-- 7)
-- Find the dates of the first X days with confirmed Covid-19 by 
-- country, in ascending date order.
-- ==================================================================
DROP TABLE IF EXISTS covid.first_date_confirmed_by_country;
CREATE TABLE IF NOT EXISTS covid.first_date_confirmed_by_country (
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY((country), confirmed, date)
) WITH CLUSTERING ORDER BY (confirmed ASC, date ASC);

-- ==================================================================
-- 8)
-- Find the country and the associated date with the highest number 
-- of daily recovered. 
-- ==================================================================
DROP TABLE IF EXISTS covid.highest_recovered_by_country;
CREATE TABLE IF NOT EXISTS covid.highest_recovered_by_country (
    date DATE,
    country TEXT,
    total_recovered INT,
    PRIMARY KEY((country))
);

-- Using plain dataset and max.
DROP TABLE IF EXISTS covid.highest_recovered_using_max_by_country;
CREATE TABLE IF NOT EXISTS covid.highest_recovered_using_max_by_country (
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY((country), recovered)
);

-- ==================================================================
-- 9)
-- Find the global date, confirmed, recovered and deaths by id (and
-- possible filter on date), in ascending date order. 
-- ==================================================================
DROP TABLE IF EXISTS covid.global_stats_by_id;
CREATE TABLE IF NOT EXISTS covid.global_stats_by_id (
    timeid TIMEUUID,
    date DATE,
    confirmed INT,
    recovered INT,
    deaths INT,
    increase_rate DOUBLE,
    PRIMARY KEY((timeid), date)
) WITH CLUSTERING ORDER BY (date ASC);
-- Not necessary because of natural ordering, but best practice for
-- future inserts.

-- The TIMEUUID is simply another common way of encoding a unique id
-- for a row. It allows for both capturing uniqueness and time, and 
-- can be inserted with simple functions like now()

-- ==================================================================
-- 10)
-- Find increase rate of confirmed cases by date.
-- ==================================================================
DROP TABLE IF EXISTS covid.worldwide_increase_rate;
CREATE TABLE IF NOT EXISTS covid.worldwide_increase_rate (
    date DATE,
    confirmed INT,
    recovered INT,
    deaths INT,
    increase_rate DOUBLE,
    PRIMARY KEY((date))
);
-- Date is in this time series data ensured to be unique with a single
-- row to be written per day. 

-- Secondary index on increase_rate for avg calculation performance.
-- We should have used the SSTable-Attached Secondary Index (SASI) or
-- the Storage-Attached Indexing (SAI) instead of a normal secondary
-- index. Secondary index should not really be used in Cassandra, and
-- instead the data design should properly be done in another way.
CREATE INDEX ON covid.worldwide_increase_rate (increase_rate);





-- ==================================================================
-- Schemas for Testing Performance
-- ==================================================================

-- Expected poor performance given query with filter on non-primary
-- keys
DROP TABLE IF EXISTS covid.performance_version_1;
CREATE TABLE IF NOT EXISTS covid.performance_version_1 (
    id UUID,
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY((id))
);

-- Expected better performance
DROP TABLE IF EXISTS covid.performance_version_2;
CREATE TABLE IF NOT EXISTS covid.performance_version_2 (
    id UUID,
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY((country), confirmed)
) WITH CLUSTERING ORDER BY (confirmed ASC);
