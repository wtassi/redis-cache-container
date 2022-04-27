# REDIS CACHE
FROM redis:6.2.0

ENV ALLOW_EMPTY_PASSWORD=yes

# Create folders
RUN mkdir /script && chmod -R 777 /script
RUN mkdir /tls && chmod -R 777 /tls

# Install and update libs
RUN apt-get update -y
RUN apt-get install -y openssl ca-certificates

# Copy ssl certs local generated and configs
COPY ./src/docker/redis/tls/ca.crt /usr/local/etc/redis/ca.crt
COPY ./src/docker/redis/tls/redis.crt /usr/local/etc/redis/redis.crt
COPY ./src/docker/redis/tls/redis.key /usr/local/etc/redis/redis.key
COPY ./src/docker/redis/redis.conf /usr/local/etc/redis/redis.conf
COPY ./src/docker/redis/entrypoint.sh /script/entrypoint.sh

# Install Certs
RUN update-ca-certificates

RUN chown -R redis:redis /usr/local/etc/redis
USER root

EXPOSE 6379 6380
