#!/bin/bash

echo "🚀 \033[1;33mRUNNING CQLSH COMMANDS ON CONTAINER\033[0m\n"

# Check for the test flag (-t)
use_test_file=false
while getopts "t" opt; do
    case $opt in
        t)
            use_test_file=true
            ;;
        *)
            ;;
    esac
done

# Execute data.cql file
echo "Executing CQL inside container for .cql file..."
docker exec -it cassandra cqlsh -f /data.cql
if [ $? -ne 0 ]; then
    echo "\033[1;31m\nCONNECTION ERROR: Unable to connect to any servers.\033[0m\n\033[1m> Try again in a short time.\033[0m"
    exit 1
fi

echo "\033[1;32m\nCONNECTION READY\033[0m \n\n\033[1mProceeding with next steps...\033[0m"

sleep 1

# Execute the COPY command for the covid table
if [ "$use_test_file" = false ]; then
    echo "Executing COPY command..."
    docker exec -it cassandra cqlsh -e "
    COPY covid.countries_aggregated (id, date, country, confirmed, recovered, deaths) 
    FROM '/countries-aggregated-with-uuid.csv' WITH HEADER = TRUE;"
fi

# Staring interactive session in terminal
echo "\033[1;32m\nSUCCESSFUL COPY\033[0m \n\n\033[1mStarting interactive CQL session...\033[0m"
docker exec -it cassandra cqlsh