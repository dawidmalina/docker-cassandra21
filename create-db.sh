#!/bin/bash

if [ "x$1" == "x" ]; then
    echo "Provide keyspace name"
    exit 1;
fi

REPLICAS=$2
if [ "x$REPLICAS" == "x" ]; then
    echo "Default: 1 replicas"
    REPLICAS=1
fi

[[ $1 =~ ^[-0-9]+$ ]] && echo "Keyspace name should not be a number" && exit 1

NAME=$1
IP=$(head -1 /etc/hosts |awk '{print $1}')

echo "${IP} - keyspace name $1"

cqlsh ${IP} 9042 -e "CREATE KEYSPACE ${NAME} WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'DC1' : ${REPLICAS} }"
