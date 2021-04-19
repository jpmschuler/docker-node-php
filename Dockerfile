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

# add node v12 repo:
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

# install node, unzip, ssh tools and ruby
RUN apt-get update && apt-get install -y \
    nodejs openssh-client git p7zip zip unzip libzip-dev xz-utils ruby ruby-dev jq \
    zlib1g-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev g++ \
    rsync imagemagick libmagickwand-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN apt-get install -y \
        ca-certificates \
        fonts-liberation \
        libappindicator3-1 \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgbm1 \
        libgcc1 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        lsb-release \
        wget \
        xdg-utils && \
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

# install composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"
RUN php /tmp/composer-setup.php
RUN php -r "unlink('/tmp/composer-setup.php');"
RUN mv composer.phar /usr/bin/composer

USER dockeruser
WORKDIR /home/dockeruser