#!/usr/bin/env bash

COUCHBASE_CLUSTER_RAM_SIZE=${COUCHBASE_CLUSTER_RAM_SIZE:=1024}
COUCHBASE_PORT=${COUCHBASE_PORT:=8091}
COUCHBASE_DATA_PATH=${COUCHBASE_DATA_PATH:=/var/lib/couchbase/data}
COUCHBASE_INDEX_PATH=${COUCHBASE_INDEX_PATH:=/var/lib/couchbase/index}
COUCHBASE_NODE_HOSTNAME=${COUCHBASE_NODE_HOSTNAME:=}
COUCHBASE_ADMIN_USERNAME=${COUCHBASE_ADMIN_USERNAME:=couchbase}
COUCHBASE_ADMIN_PASSWORD=${COUCHBASE_ADMIN_PASSWORD:=couchbase}
COUCHBASE_SERVICES=${COUCHBASE_SERVICES:=data,index,query}
COUCHBASE_TIMEOUT=${COUCHBASE_TIMEOUT:=30}

mkdir -p $COUCHBASE_DATA_PATH
mkdir -p $COUCHBASE_INDEX_PATH

echo "Launching Couchbase server instance"

couchbase-server -- -noinput & > /dev/stdout
PID=$!

echo "Waiting for Couchbase server to come online"

START=$(date +%s)
while ! nc -vz localhost 8091 > /dev/null 2>&1; do
    if [ "$(($(date +%s) - $START))" -gt "$COUCHBASE_TIMEOUT" ]; then
        echo "Couchbase server hasn't started in 30 seconds, halting"
        exit 1;
    fi
    sleep 1
    echo -n "."
done
echo
echo "Couchbase server is online, proceeding"

CLUSTER_INIT_COMMAND="couchbase-cli cluster-init -c localhost:8091 \
    --cluster-username=$COUCHBASE_ADMIN_USERNAME \
    --cluster-password=$COUCHBASE_ADMIN_PASSWORD \
    --cluster-port=$COUCHBASE_PORT \
    --services=$COUCHBASE_SERVICES \
    --cluster-ramsize=$COUCHBASE_CLUSTER_RAM_SIZE"

NODE_INIT_COMMAND="couchbase-cli node-init -c localhost:8091 \
    --node-init-data-path=$COUCHBASE_DATA_PATH \
    --node-init-index-path=$COUCHBASE_INDEX_PATH \
    -u $COUCHBASE_ADMIN_USERNAME -p $COUCHBASE_ADMIN_PASSWORD"

if [ ! -z $COUCHBASE_NODE_HOSTNAME ]; then
    NODE_INIT_COMMAND="$NODE_INIT_COMMAND \
        --node-init-hostname=$COUCHBASE_NODE_HOSTNAME"
fi

$NODE_INIT_COMMAND || exit 1
$CLUSTER_INIT_COMMAND || exit 1

echo "Killing current Couchbase instance to become one"

kill $PID

echo "Becoming Couchbase server process. Please allow up to 30 seconds for service to start."

exec couchbase-server -- -noinput
