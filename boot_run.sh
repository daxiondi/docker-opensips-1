#!/bin/bash
# Program:
#       This program is install boot run script.
# History:
# 2016/04/08 Kyle Bai Release
#

MYSQL_PWD=${MYSQL_PWD:-"passwd"}
ADVERTISED_IP=${ADVERTISED_IP:-"127.0.0.1"}
ADVERTISED_PORT=${ADVERTISED_PORT:-"5060"}
HOST_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')

echo "Your IP : ${HOST_IP}"
echo -e "Your Advertised IP : ${ADVERTISED_IP}\n\n"

# Configure opensips.cfg
sed -i "s/advertised_address=.*/advertised_address=\"${ADVERTISED_IP}\"/g" /usr/local/etc/opensips/opensips.cfg
sed -i "s/alias=.*/alias=\"${ADVERTISED_IP}\"/g" /usr/local/etc/opensips/opensips.cfg
sed -i "s/socket=.*/socket=udp:${HOST_IP}:${ADVERTISED_PORT}/g" /usr/local/etc/opensips/opensips.cfg

# Starting OpenSIPS process
/usr/local/sbin/opensips -c
/usr/local/sbin/opensipsctl start
rsyslogd -n
