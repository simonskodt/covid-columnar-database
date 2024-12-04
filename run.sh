#!/bin/bash

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

# Print which cql file is used
if [ "$use_test_file" = true ]; then
    echo "🚀 \033[1;32mRUNNING TEST SETUP CASE\033[0m\n"
else
    echo "🚀 \033[1;34mRUNNING COVID CASE\033[0m\n"
fi

# Check if cassandra docker network exists
network_output=$(docker network create cassandra 2>&1)

if [ "$network_output" == "Error response from daemon: network with name cassandra already exists" ]; then
    echo "Network 'cassandra' already exists."
else
    echo "Network 'cassandra' created."
fi

# Set the file path based on the flag
if [ "$use_test_file" = true ]; then
    file_path="test-setup/test.cql"
else
    file_path="real-time-covid-data/schema.cql"
fi

csv_file="real-time-covid-data/covid-data/countries-aggregated-with-uuid.csv"

# Check is cassandra docker container exists
if [ -z "$(docker ps -q -f name=cassandra)" ]; then
    echo "Cassandra container is not running. Starting a new one..."
    docker run --rm -d --name cassandra \
        --hostname cassandra --network cassandra -p 9042:9042 cassandra
        # Mounting did not work
        # -v $(pwd)/$csv_file:/mnt/countries-aggregated-with-uuid.csv \
        # -v $(pwd)/$file_path:/mnt/data.cql cassandra
    echo "Cassandra has started."
else
    echo "Cassandra container is already running."
fi


# Copy file into container
echo "\033[1;32m\nDOCKER NETWORK AND CONTAINER READY\033[0m \n\n\033[1mCopying files into container...\033[0m"
docker cp "$file_path" cassandra:/schema.cql
docker cp "$csv_file" cassandra:/countries-aggregated-with-uuid.csv

echo "\033[1;32m\nSUCCESSFUL COPY\033[0m \n\n\033[1m⏭️  Ready to proceed with run-cqlsh script...\033[1m"
