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

CREATE TABLE covid.countries_aggregated_by_country (
    id UUID,
    country TEXT,
    date DATE,
    confirmed INT,
    recovered INT,
    deaths INT,
    PRIMARY KEY (country, date)
);