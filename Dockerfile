FROM php:7.1

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

# invstall composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/bin/composer

#install compass
RUN gem update --system
RUN gem install compass
