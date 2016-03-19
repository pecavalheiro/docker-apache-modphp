FROM ubuntu:latest

MAINTAINER Pedro Cavalheiro <pedrohc@gmail.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
apache2 \
libapache2-mod-php5 \
curl \
php-apc \
php-pear \
php5-curl \
php5-dev \
php5-gd \
php5-mcrypt \
php5-mysqlnd \
lynx-cur

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
RUN sed -i "s/display_errors = Off/display_errors = On/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# update php extensions
ADD 20-mcrypt.ini /etc/php5/apache2/conf.d/20-mcrypt.ini

COPY src/ /var/www/public

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
