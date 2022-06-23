ARG ARCH=
FROM bayrell/alpine_php_fpm:7.4-10${ARCH}

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