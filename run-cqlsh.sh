#!/bin/bash

echo "🚀 \033[1;33mRUNNING CQLSH COMMANDS ON CONTAINER\033[0m\n"

# Check for the test flag (-t) and auto-retry flag (-a)
use_test_file=true
auto_retry=true
while getopts "ta" opt; do
    case $opt in
        t)
            use_test_file=true
            ;;
        a)
            auto_retry=false
            ;;
        *)
            ;;
    esac
done

# Function to execute CQL file
execute_cql() {
    docker exec -it cassandra cqlsh -f /data.cql > /dev/null 2>&1
}

waiting_ui() {
    local delay=0.2
    local spinstr='|/-\'
    local msg="Waiting for connection"
    printf "\033[1;33m$msg\033[0m "
    while true; do
        for i in $(seq 0 3); do
            printf "\r$msg ${spinstr:$i:1}"
            sleep $delay
        done
    done
}

# Execute CQL file with auto-retry if enabled
if [ "$auto_retry" = true ]; then
    echo "\033[1;33mAuto-retry enabled. Trying to connect...\033[0m"
    waiting_ui &
    ui_pid=$!
    while ! execute_cql; do
        sleep 5
    done
    kill $ui_pid
    echo  "\n\033[1;32m\nCONNECTION READY\033[0m \n\n\033[1mProceeding with next steps...\033[0m"
else
    echo "Executing CQL inside container for .cql file..."
    execute_cql
    if [ $? -ne 0 ]; then
        echo "\033[1;31m\nCONNECTION ERROR: Unable to connect to any servers.\033[0m\n\033[1m> Try again in a short time.\033[0m"
        exit 1
    fi
    echo "\033[1;32m\nCONNECTION READY\033[0m \n\n\033[1mProceeding with next steps...\033[0m"

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
fi