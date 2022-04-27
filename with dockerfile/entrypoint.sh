#!/bin/sh
set -e

redis-server /usr/local/etc/redis/redis.conf --save 20 1 --loglevel notice