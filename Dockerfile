FROM php:7.1

RUN apt-get install -y apt-utils

# fix locales to utf-8
RUN apt-get update && apt-get install -y locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# install gnupg for validity checking of external repos
RUN apt-get install -y gnupg

# add node v10 repo:
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# install node, unzip, ssh tools and ruby
RUN apt-get install -y nodejs npm openssh-client git p7zip zip unzip xz-utils ruby ruby-dev jq

# install grunt
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
