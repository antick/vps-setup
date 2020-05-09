# Development Setup
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

### MySQL

Install and setup database-

```bash
sudo apt install mysql-server

mysql_secure_installation
```

### PHP

Install PHP 7.3-

```bash
sudo apt install php7.3 \
  php7.3-bcmath \
  php7.3-cli \
  php7.3-common \
  php7.3-curl \
  php7.3-gd \
  php7.3-intl \
  php7.3-json \
  php7.3-mbstring \
  php7.3-mysql \
  php7.3-opcache \
  php7.3-xml \
  php7.3-soap \
  php7.3-zip
```

Test the PHP-
```
cd /var/www/html

sudo nano info.php 
```

Write this in info.php and run it to check if everything is working fine-
```php
<?php

phpinfo();

?>
```

Install phpmyadmin to access database-
```
sudo apt install phpmyadmin
```

Increase max_execution_time, max_input_time, memory_limit, post_max_size in php.ini-
```
sudo nano /etc/php/7.3/apache2/php.ini
```

Update default configuration for apache-
```
sudo nano /etc/apache2/sites-available/000-default.conf
```

Enable rewrite module in apache-
```
sudo a2enmod rewrite

sudo systemctl restart apache2
```

#### Note:
In case you have two php versions installed you can remove one by this command-

```
sudo apt purge php7.2*
```

Install Git- 

```
sudo apt install git
```

Install Node through nvm-
Follow this to intall node version manager-
https://github.com/nvm-sh/nvm

Install Composer-
```
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
