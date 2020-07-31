#!/bin/bash

# make all user changes only on first creation or if the user changed
if [ ! -f /home/$PRIMEHOST_USER ]; then
  # Create custom ssh_user with sudo privileges
  useradd -m -d /home/$PRIMEHOST_USER -G root -s /bin/zsh $PRIMEHOST_USER \
  && usermod -a -G $PRIMEHOST_USER $PRIMEHOST_USER \
  && usermod -a -G sudo $PRIMEHOST_USER

  # Set passwords for the custom user and root
  echo "$PRIMEHOST_USER:$PRIMEHOST_PASSWORD" | chpasswd
  echo "root:$PRIMEHOST_PASSWORD" | chpasswd

  # Custom user for nginx 
  sed -i s/www-data/$PRIMEHOST_USER/g /etc/nginx/nginx.conf
  sed -i s/localhost/$PRIMEHOST_DOMAIN-php/g /etc/nginx/nginx.conf
  sed -i s/localhost/$PRIMEHOST_DOMAIN-php/g /etc/nginx/conf.d/shopware.conf
  chown -R ${PRIMEHOST_USER}:${PRIMEHOST_USER} /var/www/html
fi

# start all the services
/usr/bin/supervisord
