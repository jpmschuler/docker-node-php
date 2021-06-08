FROM php:7.4-cli-alpine
# install gnupg for validity checking of external repos
RUN apk add --no-cache npm openssh-client git zip unzip rsync composer patch automake bash

RUN npm install -g n
RUN n stable

# Tell docker that all future commands should run as the appuser user
RUN addgroup -S dockergroup && adduser -S dockeruser -G dockergroup -s /bin/bash
USER dockeruser

RUN npm config set prefix '/home/dockeruser/.npm-global'
ENV PATH=/home/dockeruser/.npm-global/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN npm cache clean -f
RUN npm install -g npm@latest

USER dockeruser
WORKDIR /home/dockeruser