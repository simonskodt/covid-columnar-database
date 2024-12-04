# Columnar Database: Cassandra

In this repository, we use the columnar database Apache Cassandra on a COVID dataset to extract and compare the performance of different queries.

Cassandra is a NoSQL column-oriented database, ideal for horizontal scalability. With today's amount of big data, it is important being able to scale out in a distributed fashion.

## Covid-19 Dataset

The dataset we use is available on [Kaggle](https://www.kaggle.com/datasets/gauravduttakiit/covid-19).

The dataset contains 8 CSV files, of which we will primarily work with the `countries-aggregated.csv` file. This file contains time series data tracking COVID-19 cases, including confirmed, recovered, and death counts.

## Setup Test Environment

The [test-setup](./test-setup) folder allows you to set up a small `.cql` database and inspect it.

Cassandra can either be set up with Docker or using the tarball from the official Cassandra website. The Docker setup is explained in the above directory, but for the tarball setup, you need to export the following in the `.zshrc` or `bash_profile` on a Mac:

```sh
export=CASSANDRA_HOME=<path_to_cassandra_root_folder>
export PATH=$PATH:CASSANDRA_HOME/bin
export JAVA_HOME=<path_to_jdk_root_folder> # most likely already there
```

We found the Docker setup is the easiest to configure for M1-M4 Macs. After executing `docker pull cassandra:latest`, three shell scripts: `run.sh`, `run-db-in-shell.sh`, and `stop.sh` orchestrate the Docker commands to run the Cassandra container, start an interactive CQL session in the terminal, and when finished, stop and remove the Docker container and network.

## Environments

The Cassandra Query Language (CQL) can be run from either the terminal, VSCode, or other external DB software providers. We use a mix of the two mentioned, but also RazorSQL, which has native support for Cassandra.

The connection string for these services uses IP 127.0.0.1 and port 9042. When running `run-db-in-shell.sh`, you might encounter this error message:

```
Connection error: ('Unable to connect to any servers', {'127.0.0.1:9042': ConnectionRefusedError(111, "Tried connecting to [('127.0.0.1', 9042)]. Last error: Connection refused")})
```

This occurs because the Cassandra container needs time to initialize. You will typically need to wait 10-30 seconds, and you can check if it is running either through the Docker Desktop app or by using this terminal command:

```sh
docker ps -f name=cassandra
```
