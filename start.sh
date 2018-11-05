#!/bin/bash

set -eu

#if container exists - remove
docker rm -f node-web-app || true
docker build -t vladlan/node-web-app .

#--rm		Automatically remove the container when it exits
#-t tty - allocate a terminal so you can directly interact with the docker command
#-i - interactive - connects STDIN to the allocated terminal. Any command you enter after this via your keyboard goes into the terminal
#docker run -d --name=node-web-app -p 49160:6069 --volumes-from vsftpd-docker vladlan/node-web-app
#docker run -dit --restart unless-stopped --name=vsftpd-docker -p 32021:21 -p 32022-32041:32022-32041 -v FtpVolume:/var/lib/ftp/incoming vsftpd-anonymous-upload-docker
docker run -d --name=node-web-app -p 49160:6069 --mount src='/var/ftp/pub',target=/var/lib/ftp/incoming,type=bind  vladlan/node-web-app

