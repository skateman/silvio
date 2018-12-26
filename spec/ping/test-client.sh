#!/bin/sh

HOST="$(ip route | awk 'NR==1 {print $3}')"
/usr/bin/silvio-client ws://$HOST:8080 $1
