FROM        ubuntu:18.10
LABEL		maintainer="pig492@gmail.com"
RUN         apt-get -y update; \
			apt-get -y upgrade; \
			apt-get -y install software-properties-common; \
			add-apt-repository ppa:ondrej/php; \
			apt-get -y install apt-transport-https lsb-release ca-certificates; \
			apt-get -y update; \
			apt-get -y upgrade; \
			apt-get -y install vim; \
			apt-get -y install apache2; \
			apt-get -y install ssh

RUN 		ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN 		apt-get -y install git wget curl openssh-server tzdata \
			mysql-server mysql-client locales net-tools iputils-ping telnet

RUN			apt-get -y install php7.3 php7.3-cli php7.3-curl \
			php7.3-gd php7.3-json php7.3-mysql php7.3-opcache \
			php7.3-xml php7.3-xml php7.3-xmlrpc php7.3-intl \
			php7.3-mbstring php7.3-zip php7.3-xdebug php7.3-bcmath \
			php7.3-oauth php7.3-memcached php7.3-readline

RUN			apt-get -y install php5.6 php5.6-pdo php5.6-gd \
			php5.6-mbstring php5.6-cli php5.6-mysql php5.6-dba \
			php5.6-pdo php5.6-intl php5.6-curl php5.6-simplexml \
			php5.6-xmlrpc php5.6-zip php5.6-xdebug php5.6-bcmath \
			php5.6-oauth php5.6-memcached php5.6-json php5.6-readline

RUN 		echo "[xdebug]" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.max_nesting_level=256" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_connect_back=0" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_enable=1" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_log=/var/log/apache2/xdebug.log" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_port=9000" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_cookie_expire_time=86400" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_handler=dbgp" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_host=10.0.75.0" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.remote_mode=req" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.collect_vars=on" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.collect_params=4" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.dump_globals=on" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.profiler_enable=0" >> /etc/php/5.6/mods-available/xdebug.ini; \
			echo "xdebug.profiler_enable_trigger=1" >> /etc/php/5.6/mods-available/xdebug.ini

RUN 		echo "[xdebug]" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.max_nesting_level=256" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_connect_back=0" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_enable=1" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_log=/var/log/apache2/xdebug.log" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_port=9000" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_cookie_expire_time=86400" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_handler=dbgp" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_host=10.0.75.0" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.remote_mode=req" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.collect_vars=on" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.collect_params=4" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.dump_globals=on" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.profiler_enable=0" >> /etc/php/7.3/mods-available/xdebug.ini; \
			echo "xdebug.profiler_enable_trigger=1" >> /etc/php/7.3/mods-available/xdebug.ini

RUN 		a2enmod vhost_alias; \
			a2dissite 000-default.conf

RUN			apt-get -y install composer; \
			composer global require laravel/installer
COPY		./environment /etc

RUN 		apt-get clean; \
			apt-get autoclean; \
  			apt-get -y autoremove; \
  			rm -rf /var/lib/apt/lists/*

RUN 		sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
  			echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config; \
  			locale-gen ko_KR.UTF-8; \
  			mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd

RUN 		rm -rf /var/lib/mysql/*; /usr/sbin/mysqld --initialize-insecure; \
  			sed -i 's/^bind-address/#bind-address/g' /etc/mysql/mysql.conf.d/mysqld.cnf; \
  			sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf

RUN 		mkdir -p /var/run/mysqld; \
    		chown mysql:mysql /var/run/mysqld; \
			touch /var/log/apache2/xdebug.log; chmod a+rw /var/log/apache2/xdebug.log

COPY		./sites.conf /etc/apache2/sites-available
COPY		./site.conf /etc/apache2/sites-available
RUN 		a2ensite sites
RUN			mkdir -p /home/sites; \
			mkdir -p /home/site

COPY 		./index.php /var/www/html
COPY  		./myadmin /var/www/html/myadmin

COPY		./entrypoint /sbin
COPY		./svhost /sbin
COPY		./sphp /sbin
COPY		./phpversion /sbin
COPY		./detect_site /sbin
COPY 		./menu /sbin
COPY		./drush.phar /sbin/drush
RUN			chmod a+x /sbin/entrypoint /sbin/svhost /sbin/sphp \
			/sbin/phpversion /sbin/detect_site /sbin/menu /sbin/drush

RUN			echo "root:rootpass" | chpasswd

EXPOSE		80 22 3306 9000

VOLUME		["/home/sites", "/home/site", "/var/lib/mysql"]

ENTRYPOINT	"/sbin/entrypoint" "menu"