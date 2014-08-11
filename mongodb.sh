#!/bin/bash

# Add replica set to mongodb config
if [ ! -z "$REPL_SET" ]
then
  echo "Replica Set => $REPL_SET"
  echo "replSet=$REPL_SET" >> /etc/mongod.conf
fi

# Rsyslog setup
if [ ! -z "$RSYSLOG" ]
then
  echo "Adding RSYSLOGD configuration"
  
  echo "$RSYSLOG" >> /etc/rsyslog.conf
fi

# Setup mongodb user
# $1 'setup' to do setup
# $2 the database to set up .. e.g. 'admin'
# $3 user mongodb username
# $4 user mongodb password
# $5 user roles.. e.g. for admin "{ role: 'userAdminAnyDatabase', db: 'admin' }, { role: 'readWriteAnyDatabase', db: 'admin' }"

if [ "$1" == "setup" ]
then
  echo "Performing Initial Setup"
  echo "db.createUser({ user: '$3', pwd: '$4', roles: [$5] })" > /tmp/setup.js
  
  mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --noauth &
  mongod_pid=$!
  
  echo "Sleeping 5 for mongodb to become available... "
  sleep 5
  
  mongo "$2" /tmp/setup.js
  
  kill $mongod_pid
  exit 0
fi

mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --auth
