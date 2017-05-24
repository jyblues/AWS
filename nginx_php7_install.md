
# nginx, php7, php-redis, php-msgpack 설치 방법

## OS update
```
yum update
yum upgrade
```

## remi repository 설정
```
yum install -y wget
yum -y install epel-release
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -ivh remi-release-7.rpm
```

## 방화벽 시작 및 daemon 등록
```
systemctl start firewalld
systemctl enable firewalld
```

## 기본 필요한 package 설치
```
yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel tcl vim unzip 
```

## nginx 설치

### /etc/nginx/conf.d/default.conf

```
server {
    listen       80;
    server_name  example.com;

    access_log  /var/log/nginx/laos.access.log;
    error_log  /var/log/nginx/laos.error.log warn;

    root   /usr/share/nginx/html;
    index  index.html index.php;

    location / {
        try_files $uri $uri?$args $uri/ /index.php?$uri&$args /index.php?$args;
    }

    location ~ \.php$ {
        try_files      $uri =404;
        fastcgi_pass   unix:/var/run/php-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```

### /etc/nginx/nginx.conf

```
user  nginx;
worker_processes  auto;
worker_rlimit_nofile 100000;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  2048;
    multi_accept on;
    use epoll;
}


http {
    server_tokens off;
    include       /etc/nginx/mime.types;
    default_type  text/html;
    charset UTF-8;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile       off;
    tcp_nopush     on;
    tcp_nodelay    on;


    keepalive_timeout 10;
    client_header_timeout 10;
    client_body_timeout 10;
    reset_timedout_connection on;
    send_timeout 10;

    limit_conn_zone $binary_remote_addr zone=addr:5m;
    limit_conn addr 100;

    gzip on;
    gzip_http_version 1.0;
    gzip_disable "msie6";
    gzip_proxied any;
    gzip_min_length 1024;
    gzip_comp_level 6;
    gzip_types text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript application/json;
    open_file_cache off;

    client_max_body_size 20m;
    server_names_hash_bucket_size 64;
    include /etc/nginx/conf.d/*.conf;
}
```

### nginx 시작 및 daemon 등록
```
sudo systemctl start nginx
sudo systemctl enable nginx
```


## PHP7 설치

```
yum --enablerepo=epel,remi,remi-php70 install php70 php70-php-mcrypt php70-php-mbstring php70-php-fpm php70-php-pecl-xdebug php70-php-pecl-redis php70-php-mysqlnd php70-php-bcmath php70-php-pecl-zip php70-php-xmlrpc php70-php-xml php70-php-pecl-http php70-php-pecl-http-devel php70-php-opcache php70-php-pear php70-php-pdo
```



### PHP 경로 설정

```
cat /opt/remi/php70/enable
export PATH=/opt/remi/php70/root/usr/bin:/opt/remi/php70/root/usr/sbin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/opt/remi/php70/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export MANPATH=/opt/remi/php70/root/usr/share/man:${MANPATH}
```

### ~/.bashrc

```
export PATH=/opt/remi/php70/root/usr/bin:/opt/remi/php70/root/usr/sbin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/opt/remi/php70/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export MANPATH=/opt/remi/php70/root/usr/share/man:${MANPATH}
```

### PHP 버전 확인
```
php -v
```



### /etc/opt/remi/php70/php-fpm.d/www.conf
```
user = nginx
group = nginx
listen = /var/run/php-fpm.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0666
```


### /etc/systemd/system/php-fpm.service
```
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/var/run/php-fpm.pid
ExecStart=/opt/remi/php70/root/usr/sbin/php-fpm --nodaemonize --fpm-config /etc/opt/remi/php70/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID


[Install]
WantedBy=multi-user.target
```

### /usr/share/nginx/html 폴더 권한 설정
```
chown -R nginx:nginx /usr/share/nginx/html/
```

### PHP-FPM 시작 및 daemon 등록
```
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
```


## php-redis 설치
```
git clone -b php7 https://github.com/phpredis/phpredis.git
cd phpredis/
/opt/remi/php70/root/usr/bin/phpize
./configure --with-php-config=/opt/remi/php70/root/usr/bin/php-config
make && make install
make test
echo "extension=redis.so" > /etc/opt/remi/php70/php.d/redis.ini
```

## php-msgpack 설치
```
wget https://github.com/msgpack/msgpack-php/zipball/master -O msgpack-php.zip
unzip msgpack-php.zip
cd msgpack-msgpack-php-e616221/
/opt/remi/php70/root/usr/bin/phpize
./configure
make && make install
make test
echo extension=msgpack.so > /etc/opt/remi/php70/php.d/msgpack.ini 
```

## PHP-FPM 재시작
```
sudo systemctl start php-fpm
```

## local cache용 redis server 설치
```
cd ~
wget http://download.redis.io/releases/redis-2.8.24.tar.gz
tar xzvf redis-2.8.24.tar.gz
cd redis-2.8.24
make
make install
# update-rc.d redis-server defaults
# /etc/init.d/redis-server start
```

## python pip 설치

링크 - http://zetawiki.com/wiki/CentOS_python-pip_%EC%84%A4%EC%B9%98

## redis-py 설치

링크 - https://redislabs.com/python-redis


## 외부 MySQL 사용 설정
참고 : http://www.systemhook.net/?tag=mysql
```
setsebool -P httpd_can_network_connect 1
```


