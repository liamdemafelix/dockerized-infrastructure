#!/bin/bash

# Check if we're root
if [ "x$(id -u)" != 'x0' ]; then
    echo "Please run this script as root."
    exit 1
fi

# We only run on Ubuntu-based servers
if [ -e "/etc/os-release" ]; then
    type=$(grep "^ID=" /etc/os-release | cut -f 2 -d '=')
    if [ "$type" = "ubuntu" ]; then
        # Check if lsb_release is installed
        if [ -e '/usr/bin/lsb_release' ]; then
            release="$(lsb_release -s -r)"
            VERSION='ubuntu'            
        else
            echo "lsb_release is currently not installed, please install it:"
            echo "apt-get update && apt-get install lsb_release"
            exit 1
        fi
    else
        echo "Only Ubuntu servers are supported."
        exit 1
    fi
else
    echo "Only Ubuntu servers are supported."
    exit 1
fi

# Check if the working directory is correct
CURRENT_DIRECTORY=`pwd`
if [ "${CURRENT_DIRECTORY}" != "/opt/dockerized-infrastructure" ]; then
    echo "Your working directory must be /opt/dockerized-infrastructure."
    exit 1
fi

# Check if the .env file is present
if [ ! -f ".env" ]; then
    echo "The environment file does not exist."
    exit 1
fi

# Ensure we got an updated repository and system
apt-get update -y
apt-get upgrade -y
apt-get install wget curl zip unzip -y

# Set up the Docker repository
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update -y

# Set up the environment variables
source <(sed -E -n 's/[^#]+/export &/ p' ${CURRENT_DIRECTORY}/.env)

# Set up Docker
apt-get install docker-ce docker-ce-cli containerd.io -y
systemctl enable --now docker

# Set up docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.28.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Set up a user with Docker privileges
adduser --disabled-password --gecos "" ${DOCKER_USER}
usermod -aG docker ${DOCKER_USER}

# Create working directories and assign ownership to DOCKER_USER
mkdir -p /opt/containers/{sonarr,radarr,jackett,rutorrent,caddy}
mkdir -p /opt/containers/caddy/{config,data}
chown -R ${DOCKER_USER}:${DOCKER_USER} /opt/containers

# Get the host IP for Docker
HOST_IP=`ip -4 addr show scope global dev docker0 | grep inet | awk '{print \$2}' | cut -d / -f 1`

# Download the docker-compose.yml file and use the correct IDs
PUID=`id -u ${DOCKER_USER}`
PGID=`id -g ${DOCKER_USER}`
cp docker-compose.yml.sample docker-compose.yml
sed -i "s/%UID%/${PUID}/g" docker-compose.yml
sed -i "s/%GID%/${PGID}/g" docker-compose.yml
export HOST_IP=$HOST_IP && docker-compose --env-file /opt/dockerized-infrastructure/.env pull

# Fix permissions for this folder
chown -R ${DOCKER_USER}:${DOCKER_USER} /opt/dockerized-infrastructure

# Set up helper scripts
chmod +x /opt/dockerized-infrastructure/scripts/start.sh
ln -s /opt/dockerized-infrastructure/scripts/start.sh /usr/local/bin/start-containers
chmod +x /opt/dockerized-infrastructure/scripts/stop.sh
ln -s /opt/dockerized-infrastructure/scripts/stop.sh /usr/local/bin/stop-containers

# Done!
clear
echo "Setup complete. To start the containers, simply run 'start-containers'. To stop them, simply run 'stop-containers'."
exit 0