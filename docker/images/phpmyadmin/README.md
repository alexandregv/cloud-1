# phpMyAdmin + php-fpm

### Database UI + PHP

This container holds the phpMyAdmin installation, and the associated php-fpm process, which will be reached by NGINX to execute PMA's php files.

It uses the `nginx` network to do so, but also the `mariadb` network to connect to the database.  

The phpMyAdmin installation can be configured with all the `PMA_*` environment variables (see `docker-compose.yaml`), as well as the database connection with the `DB_*` variables.
