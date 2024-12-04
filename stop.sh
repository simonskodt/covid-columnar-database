echo "Stopping 'cassandra' container..."
docker stop cassandra

echo "Removing docker network 'cassandra'..."
docker network rm cassandra