#!/bin/sh
set -e

echo "Lendo arquivos dos certificados e carregando para o Json"

useSSL=$(echo "${REDIS_TLS_ENABLED}" | tr '[:upper:]' '[:lower:]')

echo "####### USE SSL = ${useSSL}."

if [ "$useSSL" = "yes" ]; then
  chmod -R 777 /usr/local/etc/redis
  tlsCertRead=$(cat ${TLS_CRT} | sed -z 's/\n/"\\n"/g' | sed -z 's/"//g')
  tlsKeyRead=$(cat ${TLS_KEY} | sed -z 's/\n/"\\n"/g' | sed -z 's/"//g')
  tlsCaRead=$(cat ${TLS_CA} | sed -z 's/\n/"\\n"/g' | sed -z 's/"//g')
  tlsRejectUnauthorized=true
  tlsWithoutCert=false
  cluster=false
else
  tlsCertRead=""
  tlsKeyRead=""
  tlsCaRead=""
  tlsRejectUnauthorized=false
  tlsWithoutCert=false
  cluster=false
fi;

cat > "/settings/.p3xrs-conns.json" <<END
{
  "list": [
    {
      "name": "redis-ssl-$useSSL-container",
      "host": "${REDIS_URL}",
      "port": ${REDIS_PORT},
      "password": "${REDIS_PASSWORD}",
      "id": "P3Xid037071870810100087c74e40a795ee",
      "tlsCrt": "${tlsCertRead}",
      "tlsKey": "${tlsKeyRead}",
      "tlsCa": "${tlsCaRead}",
      "tlsWithoutCert": ${tlsWithoutCert},
      "tlsRejectUnauthorized": ${tlsRejectUnauthorized},
      "nodes": [],
      "cluster": ${cluster}
    }
  ],
  "license": ""
}
END

echo "####### Executa Redis UI."
p3x-redis