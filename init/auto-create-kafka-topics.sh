#!/bin/bash

# List of topics with their configurations
declare -A topics=(
    ["get-file-details"]="--partitions 1 --replication-factor 1"
    ["file-details"]="--partitions 2 --replication-factor 1"
)

# Wait for Kafka to be ready
sleep 10

# Iterate through the topics and create them
for topic in "${!topics[@]}"; do
    echo "Creating topic: $topic with config: ${topics[$topic]}"
    kafka-topics --create --if-not-exists \
        --bootstrap-server kafka:19092 \
        --command-config /etc/kafka/secrets/client.properties \
        --topic "$topic" ${topics[$topic]}
done

# List all topics to verify
echo "Listing all topics:"
kafka-topics --list \
    --bootstrap-server kafka:19092 \
    --command-config /etc/kafka/secrets/client.properties
