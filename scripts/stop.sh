#!/bin/bash

# Build other envvars
source <(sed -E -n 's/[^#]+/export &/ p' /opt/dockerized-infrastructure/.env)

# Check user
PUID=`id -u ${DOCKER_USER}`
MYID=`id -u`
if [ "${PUID}" != "${MYID}" ]; then
    echo "Please run this script as the same user (${DOCKER_USER}) declared in the .env file."
    exit 1
fi

# Stop the containers
docker-compose -f /opt/dockerized-infrastructure/docker-compose.yml --env-file /opt/dockerized-infrastructure/.env down