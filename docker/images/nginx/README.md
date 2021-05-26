# NGINX

### Web Server and Reverse Proxy

It's the entrypoint of the stack. It accepts HTTP requests on port 443 (HTTPS), and forwards it to php-fpm (wordpress, phpmyadmin).

It connectes to these services via the `nginx` network, and can read their data via the `wordpress-data` and `phpmyadmin-data` volumes.

The domain name can be configured with the `DOMAIN_NAME` environment variable.

The upstreams configuration is based on a template (`default.conf.tmpl`), and parsed by [Dockerize](https://github.com/jwilder/dockerize) at runtime.
Check it inside the container, at `/etc/nginx/conf.d/default.conf`. (Use `make nginx.shell` to open a shell inside the container)
