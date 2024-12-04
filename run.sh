network_output=$(docker network create cassandra 2>&1)

if [ network_output == "Error response from daemon: network with name cassandra already exists" ]; then
    echo "Network 'cassandra' already exists."
else
    echo "Network 'cassandra' created."
fi

if [ -z "$(docker ps -q -f name=cassandra)" ]; then
    echo "Cassandra container is not running. Starting a new one..."
    docker run --rm -d --name cassandra --hostname cassandra --network cassandra -p 9042:9042 cassandra
    echo "Cassandra has started."
else
    echo "Cassandra container is already running."
fi

echo "Coping file into container..."
docker cp test-setup/data.cql cassandra:/data.cql