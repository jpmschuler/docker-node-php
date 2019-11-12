FROM php:7.3

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
RUN apt-get install -y gnupg

# add node v10 repo:
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# add chrome repo
RUN curl -sS -L https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN apt-get update

# install node, unzip, ssh tools and ruby
RUN apt-get install -y \
    nodejs openssh-client git p7zip zip unzip libzip-dev xz-utils ruby ruby-dev jq \
    zlib1g-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev g++ \
    google-chrome-stable rsync imagemagick libmagickwand-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists
RUN docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install gd  && \
    docker-php-ext-install zip

RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

RUN useradd -ms /bin/bash dockeruser

RUN npm config set prefix '/home/dockeruser/.npm-global'
RUN npm install -g npm@latest
RUN npm install -g grunt


# install composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"
RUN php /tmp/composer-setup.php
RUN php -r "unlink('/tmp/composer-setup.php');"
RUN mv composer.phar /usr/bin/composer


# install compass
RUN gem update --system
RUN gem install compass


RUN ln -s /home/dockeruser/node_modules/chromedriver/lib/chromedriver/chromedriver /usr/local/bin/chromedriver

USER dockeruser
WORKDIR /home/dockeruser

RUN npm install chromedriver