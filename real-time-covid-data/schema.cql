CREATE KEYSPACE IF NOT EXISTS covid WITH REPLICATION = { 
    'class' : 'SimpleStrategy', 
    'replication_factor' : '1' 
};

CREATE TABLE IF NOT EXISTS covid.countries_aggregated (
    id UUID PRIMARY KEY,
    date DATE,
    country TEXT,
    confirmed INT,
    recovered INT,
    deaths INT
);

CREATE TABLE IF NOT EXISTS covid.countries_aggregated_by_country (
    country TEXT,
    date DATE,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY (country, date)
);

CREATE TABLE IF NOT EXISTS covid.total_confirmed_by_country (
    country TEXT,
    confirmed INT,
    date DATE,
    PRIMARY KEY (country)
);