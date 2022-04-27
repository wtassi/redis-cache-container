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
tlsPath="./tls"
mkdir -p "$tlsPath"

generate_cert() {
    local name="$1"
    local cn="$2"
    local opts="$3"

    local keyfile="$tlsPath/${name}.key"
    local certfile="$tlsPath/${name}.crt"

    [ -f "$keyfile" ] || openssl genrsa -out "$keyfile" 2048
    openssl req \
        -new -sha256 \
        -subj "/O=Redis/CN=$cn" \
        -key "$keyfile" | \
        openssl x509 \
            -req -sha256 \
            -CA "$tlsPath/ca.crt" \
            -CAkey "$tlsPath/ca.key" \
            -CAserial "$tlsPath/ca.txt" \
            -CAcreateserial \
            -days 365 \
            $opts \
            -out "$certfile"
}

[ -f "$tlsPath/ca.key" ] || openssl genrsa -out "$tlsPath/ca.key" 4096
openssl req \
    -x509 -new -nodes -sha256 \
    -key "$tlsPath/ca.key" \
    -days 3650 \
    -subj '/O=Redis/CN=Redis Local Certificate Authority' \
    -out "$tlsPath/ca.crt"

cat > "$tlsPath/openssl.cnf" <<_END_
[ server_cert ]
keyUsage = digitalSignature, keyEncipherment
nsCertType = server
[ client_cert ]
keyUsage = digitalSignature, keyEncipherment
nsCertType = client
_END_

generate_cert server "Redis-Server-only" "-extfile $tlsPath/openssl.cnf -extensions server_cert"
generate_cert client "Redis-Client-only" "-extfile $tlsPath/openssl.cnf -extensions client_cert"
generate_cert redis "Redis-Generic-cert"

[ -f "$tlsPath/redis.dh" ] || openssl dhparam -out "$tlsPath/redis.dh" 2048

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
