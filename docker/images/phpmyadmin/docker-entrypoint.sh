#!/bin/sh

# Wait for database
dockerize -wait tcp://"$DB_HOST":3306 -timeout 30s

# Test FPM configuration and exit if invalid
#if ! php-fpm7 --test; then
#	echo "FPM configuration file is invalid, exiting."
#	exit 1
#fi

# Make sure logfiles exist
touch /var/log/php7/access.log /var/log/php7/error.log

# Start php-fpm via dockerize, becoming PID 1
exec dockerize -stdout /var/log/php7/access.log -stderr /var/log/php7/error.log php-fpm7 --nodaemonize
