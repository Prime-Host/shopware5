FROM primehost/ubuntu-core:18.04
MAINTAINER Prime-Host <info@nordloh-webdesign.de>

ARG DEBIAN_FRONTEND=noninteractive

# install nginx and php
RUN apt-get update \
 && apt-get -y install mysql-client nginx \
 && apt-get --purge autoremove -y \
 && echo "cd /var/www/html" >> /root/.zshrc

# nginx site conf, Supervisor Config, Create www folder and index.php, Startup Script
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./shopware.conf /etc/nginx/conf.d/shopware.conf
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./nginx-start.sh /bin/prime-host/nginx-start.sh

EXPOSE 80

CMD ["/bin/bash", "/bin/prime-host/nginx-start.sh"]
