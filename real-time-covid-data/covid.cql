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