#!/bin/bash

set -eu

docker rm -f node-web-app || true
docker build -t vladlan/node-web-app .

#--rm		Automatically remove the container when it exits
#-t tty - allocate a terminal so you can directly interact with the docker command
#-i - interactive - connects STDIN to the allocated terminal. Any command you enter after this via your keyboard goes into the terminal
docker run -ti --name=node-web-app -p 49160:6069 --volumes-from vsftpd-docker vladlan/node-web-app