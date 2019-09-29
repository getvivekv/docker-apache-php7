FROM ubuntu:18.04
LABEL maintainer="getvivekv@gmail.com"
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install git apache2 php php-curl php-zip php-mysql php-imap php-mbstring curl libapache2-mod-php php-json cron nano supervisor wget vim
RUN a2enmod rewrite && \
    sed -ie 's/\;date\.timezone\ =/date\.timezone\ =\ America\/New_York/g' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/memory_limit = .*/memory_limit = '1G'/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/max_execution_time = 30/max_execution_time = '300'/' /etc/php/7.2/apache2/php.ini
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --filename=composer && \
    mv composer /usr/local/bin/composer && \
    rm -f composer-setup.php && \
    rm -f /var/www/html/index.html
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ADD config/start.sh /start.sh
ADD config/init.sh /init.sh
ADD config/foreground.sh /etc/apache2/foreground.sh
ADD config/supervisord.conf /etc/supervisord.conf
ADD config/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
RUN chmod 755 /start.sh && \
    chmod 755 /etc/apache2/foreground.sh
CMD ["/bin/bash", "/start.sh"]