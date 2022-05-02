#!/bin/sh
set -e

chmod -R 777 /usr/local/etc/redis

echo "Lendo arquivos dos certificados e carregando para o Json"
tlsCertRead=$(cat ${TLS_CRT} | sed -z 's/\n/"\\n"/g' | sed -z 's/"//g')
tlsKeyRead=$(cat ${TLS_KEY} | sed -z 's/\n/"\\n"/g' | sed -z 's/"//g')
tlsCaRead=$(cat ${TLS_CA} | sed -z 's/\n/"\\n"/g' | sed -z 's/"//g')

cat > "/settings/.p3xrs-conns.json" <<END
{
  "list": [
    {
      "name": "redis-ssl-local-container",
      "host": "${REDIS_URL}",
      "port": ${REDIS_PORT},
      "password": "${REDIS_PASSWORD}",
      "id": "P3Xid037071870810100087c74e40a795ee",
      "tlsCrt": "${tlsCertRead}",
      "tlsKey": "${tlsKeyRead}",
      "tlsCa": "${tlsCaRead}",
      "tlsWithoutCert": false,
      "tlsRejectUnauthorized": true,
      "nodes": [],
      "cluster": false
    }
  ],
  "license": ""
}
END

echo "## Executa Redis UI."
p3x-redis