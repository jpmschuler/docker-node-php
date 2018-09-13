FROM php:7.0

RUN apt-get update && apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y nodejs npm openssh-client
RUN npm install -g grunt