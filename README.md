# Run local Kafka with Docker Compose

### Versions

| Confluent Container Version   | Kafka Equivalent               |
|-------------------------------|--------------------------------|
| `confluentinc/cp-kafka:7.7.0` | `org.apache.kafka/kafka:3.7.0` |

### Guide

* [Introduction](#introduction)
* [Prequisites](#prerequisites)
  * [Install Docker](#install-docker)
  * [Clone this repository](#clone-this-repository)
  * [Change into the repository directory](#change-into-the-repository-directory)
* [Run a SASL Kafka cluster (with authentication)](#run-a-sasl-kafka-cluster-with-authentication)
  * [Client authentication](#client-authentication)
* [License](#license) 

## Introduction

This repository contains docker compose configuration to run a local Kafka cluster with Docker Compose.

We use similar configuration for local development of our Kafka UI and API product, [Kpow for Apache Kafka](https://factorhouse.io/kpow).

Two types of Kafka Cluster are supported, simple (no authentication) and SASL authenticated. 

See [kpow-local](https://github.com/factorhouse/kpow-local) for a more complex local configuration consisting of Kpow, Kafka, Schema, Connect, and ksqlDB.

### Access the Kafka cluster

To access this cluster you can:

1. Connect to the bootstrap on localhost / 127.0.0.1 (most likely non-docker applications)
2. Connect to the bootstrap on the Docker defined hosts (kakfa-1, kafka-2, kafka-3)
3. Connect to the bootstrap using `host.docker.internal` which is similar to (1)

#### Localhost bootstrap

Applications that are external to Docker can access the Kafka cluster via the Localhost bootstrap.

```
bootstrap: 127.0.0.1:9092,127.0.0.1:9093,127.0.0.1:9094
```

#### Docker host bootstrap

Containerized applications can connect to the Kafka cluster via the Docker Host bootstrap.

These docker hosts (kakfa-1, kafka-2, kafka-3) are defined within the comoose.yml.

When starting your Docker container, specify that it should share the `kafka-local_default` network.
 
```
docker run --network=kafka-local_default ...
```

Then connect to the hosts that are running on that network

```
bootstrap: kafka-1:19092,kafka-2:19093,kafka-3:19094 
```

#### host.docker.internal bootstrap

This is a good trick for running a docker container that connects back to a port open on the host machine.

`host.docker.internal` effective routes back to localhost.

```
bootstrap: host.docker.internal:9092,host.docker.internal:9093,host.docker.internal:9094 
```

## Run a SASL Kafka cluster (with authentication)

Use the `docker-compose-sasl-auth.yml` configuration to run a SASL authenticated cluster:

```
docker compose -f docker-compose-sasl-auth.yml up
```

Bootstrap configuration is the same as the simple cluster however clients must authenticate to connect. 

Authentication configuration is specified in [resources/docker/kafka_jaas.conf](resources/docker/kafka_jaas.conf).

### Client authentication

To connect a client to this client use the following connection settings:

```
security.protocol: SASL_PLAINTEXT
sasl.mechanism:    PLAIN
sasl.jaas.config:  org.apache.kafka.common.security.plain.PlainLoginModule required username="client" password="client-secret";
```

## License

This repository is released under the Apache 2.0 License.

Copyright © Factor House.
