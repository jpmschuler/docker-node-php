FROM php:7.4-cli-alpine
# install gnupg for validity checking of external repos
RUN apk add --no-cache npm openssh-client git zip unzip rsync composer patch

# Tell docker that all future commands should run as the appuser user
RUN addgroup -S dockergroup && adduser -S dockeruser -G dockergroup -s /bin/bash
USER dockeruser

RUN npm config set prefix '/home/dockeruser/.npm-global'

USER dockeruser
WORKDIR /home/dockeruser