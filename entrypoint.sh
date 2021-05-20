#!/bin/bash

# the config file to use for the DDNS update service
CONFIG_FILE="/etc/kea-ddns/kea-dhcp-ddns.conf"

# See if the DEBUG level was set and that it is an integer
if [ -z ${DEBUG+x} ]; then
    echo "Debug not set, daemons will be started with debugging disabled"
    DEBUG_LEVEL=10
elif [ ! -z "${DEBUG##*[!0-9]*}" ]; then
    DEBUG_LEVEL="$DEBUG"
    DEBUGGING=YES
    echo "Daemons will be started with debugging at level $DEBUG_LEVEL"
    # set a bs value so the config doesnt bomb out
else
    echo "Debug is not an integer value, daemons will be started with debugging disabled"
    DEBUG_LEVEL=10
fi

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

# set the debug level in the config file
sed -i s/%%%DEBUG_LEVEL%%%/$DEBUG_LEVEL/g $CONFIG_FILE


# Start the DDNS Server
if [ -z ${DEBUGGING+x} ]; then
    /usr/sbin/kea-dhcp-ddns -c $CONFIG_FILE
else
    /usr/sbin/kea-dhcp-ddns -d -c $CONFIG_FILE
fi

