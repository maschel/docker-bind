# Docker BIND image
![stars](https://img.shields.io/docker/stars/maschel/bind.svg) ![pulls](https://img.shields.io/docker/pulls/maschel/bind.svg) ![build](https://img.shields.io/docker/automated/maschel/bind.svg) ![status](https://img.shields.io/docker/build/maschel/bind.svg)  
Docker image with BIND DNS Server on alpine linux.
## Usage
`docker run \`  
`-d \`  
`--name bind \`  
`-v /srv/docker/bind:/data/bind \`  
`maschel/bind`  
### Passing parameters to named
Additional named parameters can be appended to the run command.
`docker run maschel/bind <parameters>`

## Volumes
* `/data/bind` Directory in wich BIND config files are placed.

## Configuration
By default the BIND server will be setup as a recursing name server. The default **named.conf** can be found in the **/etc** folder inside the mounted */data/biund* volume. An example of a authorative setup is included in the **named.conf.example.authorative** file.
## Docker-compose

```
version: "3"

services:
  bind:
    container_name: bind
    image: maschel/bind
    restart: unless-stopped
    ports:
    - "53:53/udp"
    - "53:53/tcp"
    volumes:
      - /srv/docker/bind:/data/bind
```

## License
[MIT LICENSE](./LICENSE) - Copyright (c) 2018 Geoffrey Mastenbroek

