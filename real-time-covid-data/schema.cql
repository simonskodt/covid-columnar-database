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
-- Find the countries with the highest or lowest total of confirmed, 
-- recovered and deaths.
-- ==================================================================
DROP TABLE IF EXISTS covid.ranking_total_cases;
CREATE TABLE IF NOT EXISTS covid.ranking_total_cases (
    country TEXT,
    total_confirmed BIGINT,
    total_recovered BIGINT,
    total_deaths BIGINT,
    PRIMARY KEY(total_confirmed)
);

-- ==================================================================
-- 3)
-- Find the province/state, population as well as the lat and long 
-- for a second-level administrative division (Admin2).
-- ==================================================================
DROP TABLE IF EXISTS covid.administrative;
CREATE TABLE IF NOT EXISTS covid.administrative (
    uid INT,
    admin2 TEXT,
    province_state TEXT,
    lat DOUBLE,
    long DOUBLE,
    population BIGINT,
    PRIMARY KEY(UID, admin2)
);

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
