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
# $2 user mongodb username
# $3 user mongodb password

if [ "$1" == "setup" ]
then
  echo "Performing Initial Setup"
  echo "db.createUser({ user: '$2', pwd: '$3', roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }, { role: 'readWriteAnyDatabase', db: 'admin' }] })" > /tmp/setup.js
  
  mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --noauth 2>&1 > /dev/null &
  mongod_pid=$!
  
  wait $mongod_pid
  
  mongo admin /tmp/setup.js
  
  kill $mongod_pid
  exit 0
fi

mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --auth
