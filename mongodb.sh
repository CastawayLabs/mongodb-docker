#!/bin/bash

# Rsyslog setup
if [ ! -z "$RSYSLOG" ]
then
  echo "Adding RSYSLOGD configuration"
  
  echo "$RSYSLOG" >> /etc/rsyslog.conf
fi

# Setup Replica Set
if [ "$1" == "setupReplicaSet" ]
then
  echo "Performing Replica Setup"
  
  mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --noauth &
  mongod_pid=$!
  
  echo "Sleeping 5 secs for mongodb to become available... "
  sleep 5
  
  echo "printjson(rs.initiate({ _id: '$REPL_SET', members: [{ _id: 0, host: '$(hostname)' }] }));" > /tmp/initiate_mongo.js
  
  mongo "$2" /tmp/initiate_mongo.js
  echo "Sleeping 5 secs for mongodb to initiate replica set..."
  sleep 5
  
  echo "printjson(rs.status());" > /tmp/initiate_mongo.js
  mongo "$2" /tmp/initiate_mongo.js
  
  kill $mongod_pid
  sleep 2
  
  exit 0
fi

# Setup mongodb user
# $1 'setup' to do setup
# $2 the database to set up .. e.g. 'admin'
# Note, pass in a volume with /tmp/setup.js file.

if [ "$1" == "setup" ]
then
  echo "Performing Initial Setup"
  
  mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --noauth &
  mongod_pid=$!
  
  echo "Sleeping 5 secs for mongodb to become available... "
  sleep 5
  
  mongo "$2" /tmp/setup.js
  
  kill $mongod_pid
  sleep 2
  
  exit 0
fi

mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --auth
