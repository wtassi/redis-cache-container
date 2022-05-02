#!/bin/bash
set -e

chmod -R 777 /usr/local/share/scripts
apt-get update
apt-get install -y redis-tools

result="PING"
condition=0

while [ $condition == 0 ]
do
  result=$(redis-cli -h ${REDIS_URL} \
    -p ${REDIS_PORT} \
    -n 0 \
    -a ${REDIS_PASSWORD} \
    --cert ${TLS_CRT} \
    --key ${TLS_KEY}\
    --cacert ${TLS_CA} \
    --tls \
    ping);

  if [ "$result" == "PONG" ]; then
     condition=1
  else
    sleep 15
  fi
  echo "RESULT = $result"
done;
