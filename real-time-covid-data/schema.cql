CREATE KEYSPACE IF NOT EXISTS covid WITH REPLICATION = { 
    'class' : 'SimpleStrategy', 
    'replication_factor' : '1' 
};

USE covid;

CREATE TABLE IF NOT EXISTS countries_aggregated (
    id UUID PRIMARY KEY,
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT
);

CREATE TABLE IF NOT EXISTS countries_aggregated_by_country (
    country TEXT,
    date DATE,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY (country, date)
);

CREATE TABLE IF NOT EXISTS countries_aggregated_sum (
    country TEXT PRIMARY KEY,
    total_confirmed BIGINT,
    total_recovered BIGINT,
    total_deaths BIGINT
);

CREATE TABLE IF NOT EXISTS countries_aggregated_sum_order_by_confirmed (
    country TEXT,
    total_confirmed BIGINT PRIMARY KEY,
    total_recovered BIGINT,
    total_deaths BIGINT,
);