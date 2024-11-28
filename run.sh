if [ -z "$(docker ps -q -f name=cassandra)" ]; then
    echo "Cassandra container is not running. Starting a new one..."
    docker run --name cassandra -d cassandra
else
    echo "Cassandra container is already running."
fi

docker cp test-setup/data.cql cassandra:/data.cql
docker exec -it cassandra cqlsh -f /data.cql
docker exec -it cassandra cqlsh