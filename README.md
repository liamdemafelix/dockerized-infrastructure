# dockerized-infrastructure

This is my personal server dockerized for everyone's convenience (primarily mine, as I tend to switch servers almost every month).

# Applications

> TODO: List applications

# Pre-requisites

* A clean Ubuntu LTS server
* Root SSH access

# Setting Up

1. Create the needed directory. You **must be on the `/opt/dockerized-infrastructure` folder**:
```
mkdir /opt/dockerized-infrastructure
```
2. Change your shell's working directory to the newly-created folder:
```
cd /opt/dockerized-infrastructure
```
3. Download the setup script and make it executable
```
wget https://github.com/liamdemafelix/dockerized-infrastructure/raw/main/setup.sh && chmod +x setup.sh
```
4. Download the sample environment file and name it as `.env`
```
wget https://github.com/liamdemafelix/dockerized-infrastructure/raw/main/infrastructure.env -O .env
```
5. **IMPORTANT**: Edit the `.env` file to reflect your settings. Please note that `DOCKER_USER` must **not** exist on the system, as it will be automatically created. Additionally, if the paths in the `.env` file already exist, ensure that you `chown` them to `DOCKER_USER` **AFTER** `setup.sh` has run.
6. Run the setup script:
```
./setup.sh
```

# License

The resources found in this repository are licensed under the [WTFPL - Do What the Fuck You Want to Public License](http://www.wtfpl.net/about/).

```
        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
                    Version 2, December 2004 

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 

 Everyone is permitted to copy and distribute verbatim or modified 
 copies of this license document, and changing it is allowed as long 
 as the name is changed. 

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 

  0. You just DO WHAT THE FUCK YOU WANT TO.
```