#!/bin/bash

# change php user
sed -i s/www-data/$PRIMEHOST_USER/g /usr/local/etc/php-fpm.d/*

# make all user changes only on first creation or if the user changed
if [ ! -f /home/$PRIMEHOST_USER ]; then
  # Create custom ssh_user with sudo privileges
  useradd -m -d /home/$PRIMEHOST_USER -G root -s /bin/zsh $PRIMEHOST_USER \
  && usermod -a -G $PRIMEHOST_USER $PRIMEHOST_USER \
  && usermod -a -G sudo $PRIMEHOST_USER

  # Set passwords for the custom user and root
  echo "$PRIMEHOST_USER:$PRIMEHOST_PASSWORD" | chpasswd
  echo "root:$PRIMEHOST_PASSWORD" | chpasswd
fi

# Enviroment Variables for cronjob and backup folder
printenv > /etc/environment
sed -i s,/root,/home/$PRIMEHOST_USER,g /etc/environment
if [ ! -f /home/$PRIMEHOST_USER/backup ]; then
    mkdir /home/$PRIMEHOST_USER/backup
fi

unset PRIMEHOST_USER PRIMEHOST_PASSWORD PRIMEHOST_DOMAIN

# start all the services
/usr/bin/supervisord

