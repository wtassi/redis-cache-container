#!/bin/bash
set -e

chmod -R 777 /usr/local/share/scripts
apt-get update
apt-get install -y redis-tools

useSSL=$(echo "${REDIS_TLS_ENABLED}" | tr '[:upper:]' '[:lower:]')

result="PING"
condition=0

# Para execução com SSL
if [ "$useSSL" = "yes" ]; then
  echo "######### Connecting with SSL.."
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
      ping) || result="## FALHA NA CONEXAO."

    echo "RESULT = $result"
    if [ "$result" == "PONG" ]; then
      condition=1
    else
      sleep 15
    fi
  done;
fi;

# Para exeução sem SSL
if [ "$useSSL" = "false" ]; then
  echo "######### Connecting without SSL.."
  while [ $condition == 0 ]
  do
    result=$(redis-cli -h ${REDIS_URL} \
      -p ${REDIS_PORT} \
      -n 0 \
      -a ${REDIS_PASSWORD} \
      ping);

    if [ "$result" == "PONG" ]; then
      condition=1
    else
      sleep 5
    fi
    echo "RESULT = $result"
  done;
fi;
