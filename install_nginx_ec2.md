### installation

```
yum update -y
yum install -y nginx
sudo yum -y install php55 php55-fpm php55-devel php55-common php55-cli php55-pdo php55-mysql php55-xml php55-gd php55-mbstring php-pear php55-mysqlnd php55-mcrypt php55-pecl-zendopcache
```

### Configuration

* Nginx Configuration ```vi /etc/nginx/nginx.conf```

```
root /var/www/html;

location / {
    root   /var/www/html;
    index  index.php index.html index.htm;
}

location ~ \.php$ {
    fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
    fastcgi_index   index.php;
    fastcgi_param   SCRIPT_FILENAME  /var/www/html$fastcgi_script_name;
    include         fastcgi_params;
}
```

* PHP-FPM Configuration ```vi /etc/php-fpm.d/www.conf```

```
listen = /var/run/php-fpm/php-fpm.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0664
user = nginx
group = nginx
```

* PHP Configuration ``` vi /etc/php.ini ```

```
error_log = /var/log/php-error.log
date.timezone = "UTC"
```


## Finalization

```
usermod -a -G devgroup nginx
chown -R root:devgroup /var/www/html
chmod -R 775 /var/www/html

chkconfig nginx on
service nginx start

chkconfig php-fpm on
service php-fpm start
```
