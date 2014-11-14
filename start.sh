#!/bin/bash

export CASSANDRA_HOME=/usr/share/cassandra
export CASSANDRA_CONF=/etc/cassandra/conf

NAME="cassandra"
pid_file=/var/run/cassandra/cassandra.pid
CASSANDRA_PROG=/usr/sbin/cassandra

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Check ip address
IP=`hostname --ip-address`
SEEDS=`env | grep CASS[[:digit:]]_PORT_9042_TCP_ADDR | sed 's/CASS[[:digit:]]_PORT_9042_TCP_ADDR=//g' | sed -e :a -e N -e 's/\n/,/' -e ta`

if [ -z "$SEEDS" ]; then
  SEEDS=$IP
fi

echo "Listening on: "$IP
echo "Found seeds: "$SEEDS

# Setup Cassandra
sed -i -e "s/^listen_address.*/listen_address: $IP/" ${CASSANDRA_CONF}/cassandra.yaml
sed -i -e "s/^rpc_address.*/rpc_address: $IP/" ${CASSANDRA_CONF}/cassandra.yaml
sed -i -e "s/- seeds:.*/- seeds: \"$SEEDS\"/" ${CASSANDRA_CONF}/cassandra.yaml
sed -i -e "s/# JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=<public name>\"/ JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=$IP\"/" ${CASSANDRA_CONF}/cassandra-env.sh

# fix agent library failed to init: instrument
sed -i -e "s/jamm-0.2.6/jamm-0.2.8/" ${CASSANDRA_HOME}/cassandra.in.sh

# Cassandra startup
echo -n "Starting Cassandra: "
$CASSANDRA_PROG -f -p $pid_file

