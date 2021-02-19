#!/bin/bash

# Get the host IP for Docker
HOST_IP=`ip -4 addr show scope global dev docker0 | grep inet | awk '{print \$2}' | cut -d / -f 1`

# Build other envvars
source <(sed -E -n 's/[^#]+/export &/ p' /opt/dockerized-infrastructure/.env)

# Check user
PUID=`id -u ${DOCKER_USER}`
MYID=`id -u`
if [ "${PUID}" != "${MYID}" ]; then
    echo "Please run this script as the same user (${DOCKER_USER}) declared in the .env file."
    exit 1
fi

# Initialize Caddy (to prevent hash-password from including the pull text)
docker run caddy caddy version

# Hash the password
RUTORRENT_PASSWORD=`docker run caddy caddy hash-password --plaintext ${RUTORRENT_PASS}`

# Build the new Caddyfile
rm -f /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed "s/%sonarr_host/${SONARR_HOST}/g" /opt/dockerized-infrastructure/caddy/Caddyfile > /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%sonarr_name%/${SONARR_CONTAINER_NAME}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%radarr_host%/${RADARR_HOST}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%radarr_name%/${RADARR_CONTAINER_NAME}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%jackett_host%/${JACKETT_HOST}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%jackett_name%/${JACKETT_CONTAINER_NAME}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%rutorrent_host%/${RUTORRENT_HOST}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%rutorrent_name%/${RUTORRENT_CONTAINER_NAME}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%rutorrent_user%/${RUTORRENT_USER}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new
sed -i "s/%rutorrent_pass%/${RUTORRENT_PASSWORD}/g" /opt/dockerized-infrastructure/caddy/Caddyfile.new

# Replace the Caddyfille
rm -f /opt/containers/caddy/Caddyfile
mv -f /opt/dockerized-infrastructure/caddy/Caddyfile.new /opt/containersr/caddy/Caddyfile

# Start the containers
export HOST_IP=$HOST_IP && docker-compose up -d