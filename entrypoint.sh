#!/bin/bash

# the config file to use for the DDNS update service
CONFIG_FILE="/etc/kea-ddns/kea-dhcp-ddns.conf"

# if the following environment variables are not set, then use some defaults
if [ -z ${DDNS_PORT+x} ]; then 
    DDNS_PORT="53001"
fi
if [ -z ${DDNS_IP+x} ] || [ "$DDNS_IP" = "0.0.0.0" ]; then 
    # use the network interface
    DDNS_IP=`awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127.0.0.1`
fi
echo "DDNS_PORT: $DDNS_PORT"
echo "DDNS_IP: $DNS_IP"

# Create config file for control agent from template
sed s/%%%DDNS_PORT%%%/$DDNS_PORT/g $CONFIG_FILE.tmpl | sed s/%%%DDNS_IP%%%/$DDNS_IP/g > $CONFIG_FILE

# Start the DDNS Server
/usr/sbin/kea-dhcp-ddns -c $CONFIG_FILE
