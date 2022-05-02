#!/bin/sh
set -e

#cat /etc/os-release

echo "## Instalando dependencias..."
apt-get update
apt-get install -y openssl dos2unix bash
apt autoremove -y 

chmod -R 777 /usr/local/share/scripts
chmod -R 777 /usr/local/etc/redis/tls

echo "## Generate Certificates..."

dos2unix -n "/usr/local/share/scripts/gen-redis-certs.sh" "/usr/local/share/scripts/gen-redis-certs.sh"
bash "/usr/local/share/scripts/gen-redis-certs.sh"

echo "## List certificates"
ls -la /usr/local/etc/redis

echo "## Executando Redis Server"
redis-server "/usr/local/etc/redis/redis.conf" --save 20 1 --loglevel notice

