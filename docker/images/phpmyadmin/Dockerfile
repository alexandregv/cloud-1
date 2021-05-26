FROM alpine:3.12.7

LABEL maintainer="aguiot--@student.42.fr"

# dockerize setup
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# php + php-fpm setup for phpmyadmin (see https://wiki.alpinelinux.org/wiki/PhpMyAdmin)
RUN apk add php7 php7-phar php7-fpm php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-mbstring

WORKDIR /var/www/phpmyadmin

# phpmyadmin setup
ENV PHPMYADMIN_VERSION 5.1.0
ADD https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-english.tar.gz pma.tar.gz
RUN tar zxvf pma.tar.gz --strip-components=1

# user setup
RUN adduser -D -g 'phpmyadmin' phpmyadmin && \
	mkdir -p /var/www/phpmyadmin && \
	chown -R phpmyadmin:phpmyadmin /var/www/phpmyadmin && \
	chown -R phpmyadmin:phpmyadmin /var/log/php7
USER phpmyadmin

# copy and test php-fpm conf
COPY www.conf /etc/php7/php-fpm.d/www.conf
RUN php-fpm7 --test

# phpmyadmin config (fetches env vars)
COPY config.inc.php /var/www/phpmyadmin/config.inc.php

EXPOSE 9000/tcp

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
