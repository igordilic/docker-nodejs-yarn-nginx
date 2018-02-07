FROM alpine:edge

MAINTAINER Igor Ilic

ENV NGINX_VERSION nginx-1.13.5

RUN apk upgrade && \
      apk update && \
      apk add --no-cache --virtual .build-deps \
      openssl-dev \
      nodejs-npm \
      gcc \
      yarn \
      linux-headers \
      gnupg \
      pcre-dev \
      wget \
      build-base && \
      mkdir -p /tmp/src && \
      cd /tmp/src && \
      wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
      tar -zxvf ${NGINX_VERSION}.tar.gz && \
      cd /tmp/src/${NGINX_VERSION} && \
      ./configure \
          --with-http_ssl_module \
          --with-http_gzip_static_module \
          --conf-path=/etc/nginx/nginx.conf \
          --prefix=/etc/nginx \
          --http-log-path=/var/log/nginx/access.log \
          --error-log-path=/var/log/nginx/error.log \
          --sbin-path=/usr/local/sbin/nginx && \
      make && \
      make install && \
      apk del build-base && \
      rm -rf /tmp/src && \
      rm -rf /root/.cache && \
      rm -rf /var/cache/apk/*

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]

