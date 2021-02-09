if [ ! -d /var/www/html ]; then
	mkdir /var/www/html
fi
if [ -z "$(ls -A /var/www/html)" ]; then
	cd /var/www
	unzip /root/latest.zip > /dev/null
	mv wordpress/* html
	rmdir wordpress
	cp /root/nginx.conf /var/www/html/nginx.conf
	chown -R www:www /var/www/html
fi