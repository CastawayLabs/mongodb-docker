#!/bin/bash

mongod --config /etc/mongod.conf --smallfiles --replSet ${REPL_SET}
