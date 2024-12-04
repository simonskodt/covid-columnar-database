echo "Executing CQL inside container for .cql file..."
docker exec -it cassandra cqlsh -f /data.cql
sleep 1

echo "Starting interactive CQL session..."
docker exec -it cassandra cqlsh