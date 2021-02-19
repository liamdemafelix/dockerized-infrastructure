# dockerized-infrastructure

This is my personal server dockerized for everyone's convenience (primarily mine, as I tend to switch servers almost every month).

# Applications

> TODO: List applications

# Pre-requisites

* A clean Ubuntu LTS server
* Root SSH access
* Git (`apt-get install git -y`)

# Setting Up

1. Clone this repository to `/opt/dockerized-infrastructure`.
```
git clone https://github.com/liamdemafelix/dockerized-infrastructure.git /opt/dockerized-infrastructure
```
2. Change your shell's working directory to the newly-created folder:
```
cd /opt/dockerized-infrastructure
```
3. Copy the sample `infrastructure.env` file to `.env` for editing
```
cp infrastructure.env .env
```
4. **IMPORTANT**: Edit the `.env` file to reflect your settings. Please note that `DOCKER_USER` must **not** exist on the system, as it will be automatically created. Additionally, if the paths in the `.env` file already exist, ensure that you `chown` them to `DOCKER_USER` **AFTER** `setup.sh` has run.
5. Run the setup script:
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