#!/bin/bash

if [ ! -z "$REPL_SET" ]
then
  echo "Replica Set => $REPL_SET"
  echo "replSet=$REPL_SET" >> /etc/mongod.conf
fi

if [ "$1" -eq "setup" ]
then
  echo "Performing Initial Setup"
  echo "db.createUser({ user: '$2', pwd: '$2', roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }, { role: 'readWriteAnyDatabase', db: 'admin' }] })" > /tmp/setup.js
  
  mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --noauth 2>&1 > /dev/null &
  mongod_pid=$!
  
  wait $mongod_pid
  
  mongo admin /tmp/setup.js
else
  mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET" --auth
fi
