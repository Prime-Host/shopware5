FROM php:7.2-fpm
MAINTAINER Nordloh <info@nordloh-webdesign.de>

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /var/run/sshd /var/log/php-fpm \
 && apt-get update \
 && apt-get install -y cron python-setuptools wget curl git nano vim sudo unzip \ 
    openssh-server openssl zsh supervisor mariadb-client

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \ 
    libicu-dev \ 
    libjpeg62-turbo-dev \ 
    libmcrypt-dev \ 
    libpng-dev \ 
    libxslt1-dev \ 
    libpq-dev \
    sudo

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions

RUN docker-php-ext-install \
  dom \ 
  gd \ 
  intl \ 
  mbstring \ 
  mysqli \
  pdo_mysql \ 
  pdo_pgsql \
  pgsql \
  xsl \ 
  zip \ 
  soap \ 
  bcmath \ 
  pcntl \ 
  sockets 

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true \
 && cp /root/.oh-my-zsh/themes/bira.zsh-theme /root/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i 's/%m/%M/g' /root/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i s:/root/.oh-my-zsh:\$HOME/.oh-my-zsh:g /root/.zshrc \
 && sed -i 's/robbyrussell/prime-host/g' /root/.zshrc \
 && echo "DISABLE_UPDATE_PROMPT=true" >> /root/.zshrc \
 && echo "set encoding=utf-8" >> /root/.vimrc \
 && echo "set fileencoding=utf-8" >> /root/.vimrc \
 && cp -r /root/.oh-my-zsh /etc/skel/. \
 && cp /root/.zshrc /etc/skel/. \
 && cp /root/.vimrc /etc/skel/. \
 && mkdir /root/container-scripts /root/container-scripts/prime-host /root/container-scripts/custom \
 && apt-get --purge autoremove -y \
 && echo "cd /usr/share/nginx/www" >> /root/.zshrc \
 && sed -i "s|access.log = /proc/self/fd/2|access.log = /proc/self/fd/1|g" /usr/local/etc/php-fpm.d/docker.conf

# config and startup files 
ADD ./shopware.ini /usr/local/etc/php/conf.d/shopware.ini
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./start.sh /bin/prime-host/start.sh

CMD ["/bin/bash", "/bin/prime-host/start.sh"]
