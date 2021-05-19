#!/bin/bash

# the config file to use for the DDNS update service
CONFIG_FILE="/etc/kea-ddns/kea-dhcp-ddns.conf"

# if the following environment variables are not set, then use some defaults
if [ -z ${DDNS_PORT+x} ]; then 
    DDNS_PORT="53001"
fi
if [ -z ${DDNS_IP_ADDRESS+x} ]; then 
    DNS_SERVER="127.0.0.53"
fi
logger "DDNS_PORT: $DDNS_PORT"
logger "DNS_SERVER: $DNS_SERVER"

# Create config file for control agent from template
sed s/%%%DDNS_PORT%%%/$DDNS_PORT/g $CONFIG_FILE.tmpl | sed s/%%%DNS_SERVER%%%/$DNS_SERVER/g > $CONFIG_FILE

# Start the DDNS Server
/usr/sbin/kea-dhcp-ddns -c $CONFIG_FILE
