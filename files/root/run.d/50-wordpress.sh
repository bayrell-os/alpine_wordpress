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
		
		if [ ! -z $WWW_UID ] && [ ! -z $WWW_GID ]; then
			chown -R $WWW_UID:$WWW_GID $DOCUMENT_ROOT
		else
			chown -R www:www $DOCUMENT_ROOT
		fi
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
		
		if [ ! -z $WWW_UID ] && [ ! -z $WWW_GID ]; then
			chown -R $WWW_UID:$WWW_GID /var/www/html
		else
			chown -R www:www /var/www/html
		fi
	fi

	if [ -f /var/www/html/nginx.conf ]; then
		sed -i "s|%WORDPRESS_NGINX_FILE%|include /var/www/html/nginx.conf;|g" /etc/nginx/sites-available/99-app.conf
	else
		sed -i "s|%WORDPRESS_NGINX_FILE%||g" /etc/nginx/sites-available/99-app.conf
	fi
	
fi

if [ ! -z $WWW_UID ] && [ ! -z $WWW_GID ]; then
	USERNAME=`cat /etc/passwd | grep $WWW_UID | awk -F: '{print $1}'`
	if [ -f /etc/crontabs/www ] && [ "$USERNAME" != "" ]; then
		mv /etc/crontabs/www /etc/crontabs/$USERNAME
	fi
fi