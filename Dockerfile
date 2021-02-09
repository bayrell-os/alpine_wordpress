ARG ARCH=
FROM bayrell/alpine_php_fpm:7.4-3${ARCH}

RUN cd ~; \
	apk update; \
	apk add php7-mysqlnd php7-mysqli; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'

ADD files /src/files
RUN cd ~; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/latest.zip /root/; \
	cp -rf /src/files/nginx.conf /root/; \
	rm -rf /src/files; \
	rm -rf /var/www/html; \
	chmod +x /root/run.sh; \
	echo 'Ok'