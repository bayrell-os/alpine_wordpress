if [ ! -z $DOCUMENT_ROOT ]; then

	if [ ! -d $DOCUMENT_ROOT ]; then
		mkdir $DOCUMENT_ROOT
	fi

	if [ -z "$(ls -A $DOCUMENT_ROOT)" ]; then
		cd /src
		unzip /root/latest.zip > /dev/null
		mv wordpress/* $DOCUMENT_ROOT
		rmdir wordpress
		cp /root/nginx.conf $DOCUMENT_ROOT/nginx.conf
		chown -R www:www $DOCUMENT_ROOT
	fi

	sed -i "s|root /var/www/html;|root ${DOCUMENT_ROOT};|g" /etc/nginx/sites-available/99-app.conf
	
	if [ -f "${DOCUMENT_ROOT}/nginx.conf" ]; then
		sed -i "s|%WORDPRESS_NGINX_FILE%|include ${DOCUMENT_ROOT}/nginx.conf;|g" /etc/nginx/sites-available/99-app.conf
	else
		sed -i "s|%WORDPRESS_NGINX_FILE%||g" /etc/nginx/sites-available/99-app.conf
	fi
	
else

	if [ -z "$(ls -A /var/www/html)" ]; then
		cd /src
		unzip /root/latest.zip > /dev/null
		mv wordpress/* /var/www/html
		rmdir wordpress
		cp /root/nginx.conf $DOCUMENT_ROOT/nginx.conf
		chown -R www:www /var/www/html
	fi

	if [ -f /var/www/html/nginx.conf ]; then
		sed -i "s|%WORDPRESS_NGINX_FILE%|include /var/www/html/nginx.conf;|g" /etc/nginx/sites-available/99-app.conf
	else
		sed -i "s|%WORDPRESS_NGINX_FILE%||g" /etc/nginx/sites-available/99-app.conf
	fi
	
fi
