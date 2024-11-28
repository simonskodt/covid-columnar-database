# 1: Commands to run to be able to setup Cassandra

Based on the given link: [Cassandra Quickstart](https://cassandra.apache.org/_/quickstart.html)

### Setup

```sh
docker pull cassandra:latest
```

```sh
# Start cassandra
docker network create cassandra

docker run --rm -d --name cassandra --hostname cassandra --network cassandra cassandra
```

### Create a file

Check the `data.sql` file.

### Load and run interactive shell

```sh
# Load data with CQLSH
docker run --rm --network cassandra -v "$(pwd)/data.cql:/scripts/data.cql" -e CQLSH_HOST=cassandra -e CQLSH_PORT=9042 -e CQLVERSION=3.4.6 nuvo/docker-cqlsh
```

```sh
# Interactive CQLSH
docker run --rm -it --network cassandra nuvo/docker-cqlsh cqlsh cassandra 9042 --cqlversion='3.4.5'
```

### Cleaning up

```sh
docker kill cassandra
docker network rm cassandra
```

### Examples of reading/writing data in CQLSH

```cql
SELECT * FROM store.shopping_cart;
```

```cql
INSERT INTO store.shopping_cart (userid, item_count) VALUES ('4567', 20);
```

# 2: Commands to run to be able to setup Cassandra

```sh
docker cp test-setup/data.cql cassandra:/data.cql
docker exec -it cassandra cqlsh -f /data.cql
docker exec -it cassandra cqlsh
```
