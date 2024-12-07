CREATE KEYSPACE IF NOT EXISTS covid WITH REPLICATION = { 
    'class' : 'SimpleStrategy',
    'replication_factor' : '1' 
};

-- ==================================================================
-- 1)
-- Find certain countries and their number of confirmed, recovered 
-- and death observations for a certain timespan.
-- ==================================================================
DROP TABLE IF EXISTS covid.date_and_country;
CREATE TABLE IF NOT EXISTS covid.date_and_country (
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY(country, date)
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