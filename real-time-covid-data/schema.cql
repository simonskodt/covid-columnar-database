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
-- 10)
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
