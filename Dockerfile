ARG ARCH=
FROM bayrell/alpine_php_fpm:7.4${ARCH}

RUN cd ~; \
	apk update; \
	apk add php7-mysqlnd php7-mysqli php7-dom php7-gd php7-simplexml php7-exif php7-fileinfo php7-pecl-imagick php7-zip php7-iconv php7-xml php7-xmlrpc php7-xmlreader php7-simplexml php7-xmlwriter php7-opcache php7-pecl-apcu php7-pecl-mcrypt php7-soap; \
	rm -rf /var/cache/apk/*; \
	echo 'Ok'

ADD src/latest.zip /root/latest.zip
ADD files /src/files
RUN cd ~; \
	sed -i 's|php_admin_value[max_execution_time] = .*|php_admin_value[max_execution_time] = 300|g' /etc/php7/php-fpm.d/www.conf; \
	sed -i 's|max_execution_time = .*|max_execution_time = 300|g' /etc/php7/php.ini; \
	echo 'fastcgi_read_timeout 300;' >> /etc/nginx/fastcgi_params; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/nginx.conf /root/; \
	rm -rf /src/files; \
	rm -rf /var/www/html; \
	chmod +x /root/run.sh; \
	echo 'Ok'