#!/bin/bash
# COPIED/MODIFIED from the redis server gen-certs util
# https://github.com/redis/redis/blob/cc0091f0f9fe321948c544911b3ea71837cf86e3/utils/gen-test-certs.sh

# Generate some test certificates which are used by the regression test suite:
#
#   tls/ca.{crt,key}          Self signed CA certificate.
#   tls/redis.{crt,key}       A certificate with no key usage/policy restrictions.
#   tls/client.{crt,key}      A certificate restricted for SSL client usage.
#   tls/server.{crt,key}      A certificate restricted for SSL server usage.
#   tls/redis.dh              DH Params file.

# Altere aqui o path desejado
application="Redis"
ca_cert_cn="Redis Local Certificate Authority"

tlsPath="/usr/local/etc/redis/tls"
mkdir -p "$tlsPath"

name_app_lowercase=$(echo "$application" | tr '[:upper:]' '[:lower:]')

cat > "$tlsPath/openssl.cnf" <<_END_
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = 127.0.0.1
DNS.3 = redis-ssl
DNS.4 = redis-ui
[server_cert]
keyUsage = critical, digitalSignature, keyAgreement, keyEncipherment
nsCertType = server
basicConstraints = CA:FALSE
[client_cert]
keyUsage = critical, digitalSignature, keyAgreement, keyEncipherment
nsCertType = client
_END_

generate_cert() {
  local name="$1"
  local cn="$2"
  local opts="$3"

  local keyfile="$tlsPath/${name}.key"
  local certfile="$tlsPath/${name}.crt"

  [ -f "$keyfile" ] || openssl genrsa -out "$keyfile" 2048
  openssl req \
    -new -sha256 \
    -subj "/O=$application/CN=${cn}" \
    -key "$keyfile" | \
    openssl x509 \
      -req -sha256 \
      -CA "$tlsPath/ca.crt" \
      -CAkey "$tlsPath/ca.key" \
      -CAserial "$tlsPath/ca.txt" \
      -CAcreateserial \
      -days 365 \
      ${opts} \
      -out "$certfile"
}

[ -f "$tlsPath/ca.key" ] || openssl genrsa -out "$tlsPath/ca.key" 4096
openssl req \
  -x509 -new -nodes -sha256 \
  -key "$tlsPath/ca.key" \
  -days 3650 \
  -subj "/O=$application/CN=$ca_cert_cn" \
  -out "$tlsPath/ca.crt"

generate_cert server "$application-Server-only" "-extfile $tlsPath/openssl.cnf -extensions server_cert"
generate_cert client "$application-Client-only" "-extfile $tlsPath/openssl.cnf -extensions client_cert"
generate_cert $name_app_lowercase "$application-Generic-cert" "-extfile $tlsPath/openssl.cnf -extensions v3_req"

[ -f "$tlsPath/$name_app_lowercase.dh" ] || openssl dhparam -out "$tlsPath/$name_app_lowercase.dh" 2048

# Ouput esperado:
#   - ca.crt
#   - ca.key
#   - ca.txt
#   - client.crt
#   - client.key
#   - openssl.cnf
#   - redis.crt
#   - redis.dh
#   - redis.key
#   - server.crt
#   - server.key
