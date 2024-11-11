ARG ARCH=
FROM bayrell/alpine_php_fpm:8.3-2${ARCH}

ADD files /
ADD src/latest.zip /root/latest.zip
