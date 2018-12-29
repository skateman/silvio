#!/bin/bash

export CRYSTAL_ENV="test"

set -e
set -o pipefail
set -x

# Set up the database
bundle install
bin/rake db:drop db:migrate
ruby << EOF
require './config/boot.rb'
n = Network.create(:name => 'network', :address => '192.168.99.0', :netmask => '255.255.255.0')
Client.create(:name => 'client1', :address => '192.168.99.1', :network => n, :token => "123456")
Client.create(:name => 'client2', :address => '192.168.99.2', :network => n, :token => "654321")
EOF

# Create static binaries and run the server
shards build --static
bin/silvio-server &

# Build and run the client containers
IMAGE=$(docker build --force-rm -q -f spec/ping/Dockerfile .)
CLIENT_1=$(docker run --rm -d --privileged -e TOKEN=123456 $IMAGE)
CLIENT_2=$(docker run --rm -d --privileged -e TOKEN=654321 $IMAGE)

sleep 5

# Do the ping
docker exec $CLIENT_1 ping -c 1 192.168.99.2
docker exec $CLIENT_2 ping -c 1 192.168.99.1

# Clean up
docker stop $CLIENT_1 $CLIENT_2
kill %1
sleep 1

bin/rake db:drop
docker rmi $IMAGE

set +x
