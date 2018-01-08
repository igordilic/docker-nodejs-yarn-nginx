FROM alpine:edge

MAINTAINER Igor Ilic

ENV NGINX_VERSION nginx-1.13.5

RUN apk upgrade && \
      apk update && \
      apk add --no-cache \
      openssl-dev \
      bash \
      nodejs-npm \
      gcc \
      g++ \
      yarn \
      python2 \
      linux-headers \
      binutils-gold \
      gnupg \
      libstdc++ \
      pcre-dev \
      zlib-dev \
      wget \
      build-base && \
      python -m ensurepip && \
      rm -r /usr/lib/python*/ensurepip && \
      pip install --upgrade pip setuptools && \
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

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]

