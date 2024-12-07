#!/bin/bash

echo "🚀 \033[1;33mRUNNING CQLSH COMMANDS ON CONTAINER\033[0m\n"

# Check for the test flag (-t) and auto-retry flag (-a)
use_test_file=false
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

execute_cql() {
    docker exec -it cassandra cqlsh -f /schema.cql 2>&1 # > /dev/null 
}

execute_remaining_cql() {
    # Execute the COPY command for the covid tables
    if [ "$use_test_file" = false ]; then
        echo "Executing COPY commands..."

        # ============================================
        # INSERT FUTURE TABLES HERE
        # ============================================

        # date_and_country
        docker exec -it cassandra cqlsh -e "
            COPY covid.date_and_country (date, country, confirmed, recovered, deaths) 
            FROM '/countries-aggregated.csv' WITH HEADER = TRUE;"

        # ranking_total_cases
        docker exec -it cassandra cqlsh -e "
            COPY covid.ranking_total_cases (country, total_confirmed, total_recovered, total_deaths) 
            FROM '/countries-aggregated-sum.csv' WITH HEADER = TRUE;"

        # admin2
        docker exec -it cassandra cqlsh -e "
            COPY covid.administrative (uid, admin2, province_state, lat, long, population) 
            FROM '/reference-filtered.csv' WITH HEADER = TRUE;"

        # countries_by_continents
        docker exec -it cassandra cqlsh -e "
            COPY covid.countries_by_continents (continent, country, total_confirmed, total_recovered, total_deaths) 
            FROM '/countries-aggregated-sum-continents.csv' WITH HEADER = TRUE;"

        # covid_first_day
        docker exec -it cassandra cqlsh -e "
            COPY covid.covid_first_day (date, country, confirmed, recovered, deaths) 
            FROM '/countries-aggregated.csv' WITH HEADER = TRUE;"

        # highest_daily_recovered
        docker exec -it cassandra cqlsh -e "
            COPY covid.highest_daily_recovered (date, country, total_recovered) 
            FROM '/countries-aggregated-max-recovered.csv' WITH HEADER = TRUE;"

        # worldwide_month
        docker exec -it cassandra cqlsh -e "
            COPY covid.worldwide_with_id (id, date, confirmed, recovered, deaths, increase_rate) 
            FROM '/worldwide-aggregate-with-uuid.csv' WITH HEADER = TRUE;"

        # 
        docker exec -it cassandra cqlsh -e "
            COPY covid.worldwide_increase_rate (date, confirmed, recovered, deaths, increase_rate) 
            FROM '/worldwide-aggregate.csv' WITH HEADER = TRUE;"
    fi

    # Staring interactive session in terminal
    echo "\033[1;32m\nSUCCESSFUL COPY OF TABLES\033[0m \n\n\033[1mStarting interactive CQL session...\033[0m"
    docker exec -it cassandra cqlsh
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
    echo "\033[1;33mAuto-retry enabled. Trying to connect...\033[0m\n"
    waiting_ui &
    ui_pid=$!
    while ! execute_cql; do
        sleep 5
    done
    kill $ui_pid
    echo  "\n\033[1;32m\nCONNECTION READY\033[0m \n\n\033[1mProceeding with next steps...\033[0m"
    execute_remaining_cql
else
    echo "Executing CQL inside container for .cql file..."
    execute_cql

    if [ $? -ne 0 ]; then
        echo "\033[1;31m\nCONNECTION ERROR: Unable to connect to any servers.\033[0m\n\033[1m> Try again in a short time.\033[0m"
        exit 1
    fi
    echo "\033[1;32m\nCONNECTION READY\033[0m \n\n\033[1mProceeding with next steps...\033[0m"

    execute_remaining_cql
fi