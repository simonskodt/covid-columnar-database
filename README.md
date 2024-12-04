# Columnar Database: Cassandra

In this repository, we use the columnar database Apache Cassandra on a COVID dataset to extract and compare the performance of different queries.

Cassandra is a NoSQL column-oriented database, ideal for horizontal scalability. With today's amount of big data, being able to scale out in a distributed fashion is crucial.

## Setup Test Environment

The [test-setup](./test-setup) folder allows you to set up a small `.cql` database and inspect it.

It can either be set up with Docker or using the tarball from the official Cassandra website. The Docker setup is explained in the above directory, but for the tarball setup, you need to export the following in the `.zshrc` or `bash_profile` on a Mac:

```sh
export=CASSANDRA_HOME=<path_to_cassandra_root_folder>
export PATH=$PATH:CASSANDRA_HOME/bin
export JAVA_HOME=<path_to_jdk_root_folder> # most likely already there
```

## COVID Dataset

The dataset used can be found on [Kaggle](https://www.kaggle.com/datasets/gauravduttakiit/covid-19).

## Environments

The Cassandra Query Language (CQL) can be run from either the terminal, VSCode, or other external DB software providers. We use a mix of the two mentioned, but also RazorSQL, which has native support for Cassandra.

