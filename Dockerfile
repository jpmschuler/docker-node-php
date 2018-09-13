FROM php:7.1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install -y gnupg
RUN apt-get install -y nodejs npm openssh-client git
RUN npm install -g grunt