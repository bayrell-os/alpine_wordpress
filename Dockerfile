ARG ARCH=
FROM bayrell/alpine_php_fpm:7.3-6${ARCH}

RUN cd ~; \
	apk update; \
	apk add php7-mysqlnd php7-mysqli php7-dom php7-gd php7-simplexml; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'

ADD src/latest.zip /root/latest.zip
ADD files /src/files
RUN cd ~; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/nginx.conf /root/; \
	rm -rf /src/files; \
	rm -rf /var/www/html; \
	chmod +x /root/run.sh; \
	echo 'Ok'