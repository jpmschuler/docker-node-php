FROM php:7.4

#RUN apt-get install -y apt-utils

# fix locales to utf-8
RUN apt-get update && apt-get install -y locales
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# install gnupg for validity checking of external repos
RUN apt-get update && apt-get install -y gnupg

# add node v16 repo:
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

# install node, unzip, ssh tools and ruby
RUN apt-get update && apt-get install -y \
    nodejs openssh-client git p7zip zip unzip libzip-dev xz-utils ruby ruby-dev jq \
    zlib1g-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev g++ \
    rsync imagemagick libmagickwand-dev  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists


RUN docker-php-ext-configure zip && \
    docker-php-ext-install gd  && \
    docker-php-ext-install soap && \
    docker-php-ext-install zip

RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

RUN useradd -ms /bin/bash dockeruser

RUN npm config set prefix '/home/dockeruser/.npm-global'
RUN npm install -g npm@latest
RUN npm install -g pnpm fixpack

# add node-gyp and headers \
RUN export NODEVERSION=$(node --version); mkdir -p /home/root/node-headers/; curl -k -o /home/root/node-headers/node-${NODEVERSION}-headers.tar.gz -L https://nodejs.org/download/release/${NODEVERSION}/node-${NODEVERSION}-headers.tar.gz; npm config set tarball /home/root/node-headers/node-${NODEVERSION}-headers.tar.gz

# install composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"
RUN php /tmp/composer-setup.php
RUN php -r "unlink('/tmp/composer-setup.php');"
RUN mv composer.phar /usr/bin/composer
RUN ln -s /usr/local/bin/php /usr/local/bin/php7.4

USER dockeruser
WORKDIR /home/dockeruser
ENV PATH=/home/dockeruser/.npm-global/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
