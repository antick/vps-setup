# PHP Dev Env Setup for Laravel

Setup a dev environment on Ubuntu for PHP and node.

## Setup Dev Environment

Run the updates-

```bash
sudo apt update

sudo apt upgrade
```

### Apache2

Install and start apache2-

```bash
sudo apt install apache2

sudo systemctl enable apache2

sudo systemctl start apache2
```

Check if the apache2 is running now or not-

```bash
sudo systemctl status apache2
```

If it's not running then figure out the cause by checking its config-

```bash
apache2ctl configtest
```

If you have upgraded your system and your PHP version was upgraded then this might cause the issue. You can fix that by disabling the old PHP and enable the new PHP in configuration. Do this only if this is the case otherwise skip this-

```bash
sudo a2dismod php7.3
sudo a2enmod php7.4
```

Enable rewrite module in apache2-

```bash
sudo a2enmod rewrite

sudo systemctl restart apache2
```

### MySQL

Install and setup database-

```bash
sudo apt install mysql-server

sudo mysql_secure_installation

sudo systemctl status mysql
```

Login into mysql-

```bash
mysql -u root -p
```

If the above does not work then try logging in with sudo-

```bash
sudo mysql -u root
```

Now set a password for root here in mysql terminal-

```bash
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
```

In case it still does not work then switch to mysql db in mysql terminal and check the user table. Make sure it uses the native password plugin.

```bash
mysql -uroot -p
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_mysql_pass';
FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;
```

Once this is enabled, you would be able to access PHPmyadmin. If you want to access database remotely then you will have to create a new user from phpmyadmin.

Make sure to comment bind address in this file so it can connect remotely-

`nano /etc/mysql/mysql.conf.d/mysqld.cnf`

### PHP

In case you have two PHP versions installed then you can remove the extra one by this command-

```bash
sudo apt purge php7.3*
```

Install PHP 7.4-

```bash
sudo apt install php7.4 \
  php7.4-bcmath \
  php7.4-cli \
  php7.4-common \
  php7.4-curl \
  php7.4-gd \
  php7.4-intl \
  php7.4-json \
  php7.4-mbstring \
  php7.4-mysql \
  php7.4-opcache \
  php7.4-soap \
  php7.4-xml \
  php7.4-zip
```

Test the PHP-

```bash
cd /var/www/html

sudo nano info.php 
```

Write this in info.php and run it to check if everything is working fine-

```php
<?php

phpinfo();

```

### Phpmyadmin

Install phpmyadmin to access database-

```bash
sudo apt install phpmyadmin
```

Increase `max_execution_time`, `max_input_time`, `memory_limit`, `post_max_size` in php.ini-

```bash
sudo nano /etc/php/7.4/apache2/php.ini
```

Update default configuration for apache-

```bash
sudo nano /etc/apache2/sites-available/000-default.conf
```

### GIT 

```bash
sudo apt install git
```

Install Node through nvm-
Follow this to intall node version manager-
https://github.com/nvm-sh/nvm

### Composer

```bash
curl -s https://getcomposer.org/installer | php

sudo mv composer.phar /usr/local/bin/composer

composer
```

### Setup multiple virtual host on same IP

Change in your /etc/apache2/sites-available/000-default.conf

```
<VirtualHost *:80>
  #ServerName www.example.com
	ServerAdmin webmaster@localhost
        
	DocumentRoot /var/www

	<Directory /var/www/>
	    Options Indexes FollowSymLinks Includes
	    AllowOverride All
	    Order allow,deny
      Allow from all
	</Directory>

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:80>
  ServerName 123.123.123.123

  Alias /project-one /var/www/project-one/public
  Alias /project-two /var/www/project-two/public

  DocumentRoot /var/www/project-one/public
  <Directory "/var/www/project-one/public">
    AllowOverride all
    Order allow,deny
    Allow from all
  </Directory>

  DocumentRoot /var/www/project-two/public
  <Directory "/var/www/project-two/public">
    AllowOverride all
    Order allow,deny
    Allow from all
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Change in your /var/www/project-one/public/.htaccess

```
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /project-one/
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php/$1 [L]
</IfModule>
```

### Virtual Host Setup in Local

```
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName localhost
    DocumentRoot /var/www
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName my-project.local
    DocumentRoot /var/www/my-project/public

    <Directory /var/www/my-project/public/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

### Virutal Host Setup in Nginx

```
server {
  listen 80;
  server_name www.my-domain.com;
  rewrite ^(.*) http://my-domain.com$1 permanent;
}

server {
  listen 80 default_server;
  server_name my-domain.com;
  root /var/www/my-project/public;
  index index.php index.html index.htm;
  location / {
     try_files $uri $uri/ /index.php?$query_string;
  }

  location ~ \.php$ {
     include snippets/fastcgi-php.conf;
     fastcgi_pass unix:/run/php/php7.3-fpm.sock;
  }

  location ~ /\.ht {
     deny all;
  }
}
```
