# Wordpress setup on VPS

## Installation

```sh
sudo apt update

sudo apt upgrade

sudo apt install php8.1 php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-fpm php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath php8.1-imagick php8.1-http php8.1-raphf

sudo apt install nginx mariadb-server

sudo ufw app list

ufw allow "Nginx Full"

sudo ufw status

systemctl stop apache2

systemctl disable apache2

apt remove apache2*

apt autoremove

apt purge apache2

systemctl restart nginx

systemctl status nginx
```

Change following lines in nano `/etc/php/8.1/fpm/php.ini`

```
cgi.fix_pathinfo=0
upload_max_filesize = 128M
post_max_size = 128M
memory_limit = 512M
max_execution_time = 120
```

```
sudo mysql_secure_installation
mysql

CREATE DATABASE your_db_name;
CREATE USER 'your_db_user_name'@'localhost' IDENTIFIED BY 'somerandompasswordhere';
GRANT ALL ON your_db_name.* TO 'your_db_user_name'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz

chown -R www-data:www-data /var/www/your_project_folder
chmod -R 755 /var/www/your_project_folder

nano /etc/nginx/conf.d/your_configuration.conf
```

```
server {
    listen 80;
    root /var/www/your_project_folder;
    index index.php index.html index.htm;
    server_name  your-domain.com;

    client_max_body_size 500M;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }
	
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }	

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }	

    location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
         include fastcgi_params;
    }
}
```

```
nginx -t

sudo nano /etc/hosts
```

```
127.0.0.1 your_domain_name.com
```

```
systemctl restart nginx
systemctl restart php8.1-fpm

apt install postfix
```
