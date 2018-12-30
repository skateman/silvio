#!/bin/bash

export CRYSTAL_ENV="test"

set -e
set -o pipefail
set -x

# Create static binaries and run the server
shards build --static
bin/silvio-server &

sleep 5

# Create the test network and its clients
NETWORK=$(curl -XPOST -H "Content-Type: application/json" -d "{\"name\": \"test-net\", \"address\": \"192.168.99.0\", \"netmask\": \"255.255.255.0\"}" http://localhost:8090/networks)
NET_ID=$(echo $NETWORK | jq ".id")
CLIENT=$(curl -XPOST -H "Content-Type: application/json" -d "{\"name\": \"client-1\", \"address\": \"192.168.99.1\"}" http://localhost:8090/networks/$NET_ID/clients)
TOKEN_1=$(echo $CLIENT | jq -r ".token")
CLIENT=$(curl -XPOST -H "Content-Type: application/json" -d "{\"name\": \"client-2\", \"address\": \"192.168.99.2\"}" http://localhost:8090/networks/$NET_ID/clients)
TOKEN_2=$(echo $CLIENT | jq -r ".token")

# Build and run the client containers
IMAGE=$(docker build --force-rm -q -f spec/ping/Dockerfile .)
CLIENT_1=$(docker run --rm -d --privileged -e TOKEN=$TOKEN_1 $IMAGE)
CLIENT_2=$(docker run --rm -d --privileged -e TOKEN=$TOKEN_2 $IMAGE)

sleep 5

# Do the ping
docker exec $CLIENT_1 ping -c 1 192.168.99.2
docker exec $CLIENT_2 ping -c 1 192.168.99.1

# Clean up
docker stop $CLIENT_1 $CLIENT_2
kill %1
sleep 1

docker rmi $IMAGE

set +x
