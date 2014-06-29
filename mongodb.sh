#!/bin/bash

echo "Replica Set => $REPL_SET"
mongod --config /etc/mongod.conf --smallfiles --replSet "$REPL_SET"
