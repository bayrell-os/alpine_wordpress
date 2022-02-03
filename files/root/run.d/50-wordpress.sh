if [ ! -d $DOCUMENT_ROOT ]; then
	mkdir $DOCUMENT_ROOT
fi
if [ ! -d /var/www/html ]; then
	ln -s $DOCUMENT_ROOT /var/www/html
fi
if [ -z "$(ls -A /var/www/html)" ]; then
	cd /var/www
	unzip /root/latest.zip > /dev/null
	mv wordpress/* html
	rmdir wordpress
	cp /root/nginx.conf /var/www/html/nginx.conf
	chown -R www:www $DOCUMENT_ROOT
fi