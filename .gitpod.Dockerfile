FROM alpine

WORKDIR /var/www/html

USER root

RUN apk --update upgrade && apk update && apk add curl ca-certificates && update-ca-certificates --fresh && apk add openssl

USER root

RUN apk --update add \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
        nginx \
        gzip \
        php7 \
        php7-dom \
        php7-ctype \
        php7-curl \
        php7-fpm \
        php7-gd \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqli \
        php7-mysqlnd \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        php7-posix \
        php7-session \
        php7-xml \
        php7-iconv \
        php7-phar \
        php7-openssl \
        php7-zlib \
        php7-zip \
    && rm -rf /var/cache/apk/*


RUN apk add mysql mysql-client bash nginx ca-certificates && \
    apk add -u musl && \
    mkdir -p /var/lib/mysql && \
    mkdir -p /etc/mysql/conf.d && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /var/run/mysql/ 

ADD docker/nginx_test.conf /etc/nginx/
ADD docker/php-fpm.conf /etc/php/
ADD docker/my.cnf /etc/mysql/
ADD docker/default.conf /etc/nginx/conf.d/
ADD docker/run.sh /
RUN chmod +x /run.sh

USER root

RUN wget -qO- https://download.revive-adserver.com/revive-adserver-4.2.1.tar.gz | tar xz --strip 1 \
    && chown -R nobody:nobody . \
    && rm -rf /var/cache/apk/*

COPY nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx

EXPOSE 80

EXPOSE 3306
WORKDIR /var/www/html

VOLUME ["/var/www/html", "/var/www/html/logs", "/var/lib/mysql", "/etc/mysql/conf.d/"]
CMD ["/run.sh"]

#CMD php-fpm7 && nginx -g 'daemon off;'

# FROM gitpod/workspace-full

# USER gitpod

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && \
#     sudo apt-get install -yq bastet && \
#     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
