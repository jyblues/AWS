# Install linux update, followed by GCC and Make
sudo yum -y update
sudo yum install -y gcc make

# CentOS/RHEL 7.x
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# nginx 1.8 install
sudo yum install -y nginx18

# HTTP firewall setting
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload

# PHP 7
#sudo yum install -y php70w php70w-opcache php70w-common php70w-fpm php70w-mysql php70w-mcrypt php70w-mbstring
# PHP 5
sudo yum install -y php php-opcache php-common php-fpm php-mysql php-mcrypt php-mbstring php-cli

# PHP timezone 설정
# vi /etc/php.ini에서 date.timezone = Asia/Seoul로 수정


# Nginx Configuration
sudo vi /etc/nginx/conf.d/default.conf

#server{
#    
#    location / {
#        root   /var/www/html;
#        index  index.php index.html index.htm;
#    }
#    
#    location ~ \.php$ {
#        fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
#        fastcgi_index   index.php;
#        fastcgi_param   SCRIPT_FILENAME  $document_root$fastcgi_script_name;
#        변경
#        include         fastcgi_params; // --> include fastcgi.conf;
#    }
#}


# php-FPM Configuration
sudo vi /etc/php-fpm.d/www.conf

# user = nginx
# group = nginx
#
#   ;listen = 127.0.0.1:9000
# listen = /var/run/php-fpm/php-fpm.sock
#   ;listen.owner = nobody
# listen.owner = nginx
#   ;listen.group = nobody
# listen.group = nginx
#   ;listen.mode = 0666
# listen.mode = 0664

# SSL 설정
# /etc/nginx/nginx.conf
# http {
#   server {
#       listen 80;
#       ...
#
#    여기부터
#    server {
#        listen       443;
#        server_name  blackcoffee-studio.iptime.org;
#        root         /usr/share/nginx/html;
#
#        index index.php index.html index.htm;
#
#        #charset koi8-r;
#
#        #access_log  /var/log/nginx/host.access.log  main;
#
#        location / {
#        }
#
#        # redirect server error pages to the static page /40x.html
#        #
#        error_page  404              /404.html;
#        location = /40x.html {
#        }
#
#        # redirect server error pages to the static page /50x.html
#        #
#        error_page   500 502 503 504  /50x.html;
#        location = /50x.html {
#        }
#
#        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
#        #
#        #location ~ \.php$ {
#        #    proxy_pass   http://127.0.0.1;
#        #}
#
#        location ~ \.php$ {
#                fastcgi_pass 127.0.0.1:9000;
#                fastcgi_index index.php;
#                fastcgi_param SCRIPT_NAME $document_root$fastcgi_script_name;
#               변경
#               include fastcgi_params; // --> include fastcgi.conf;
#        }
#
#        ssl                  on;
#        ssl_certificate      /etc/nginx/conf.d/delta-server.crt;
#        ssl_certificate_key  /etc/nginx/conf.d/delta-privatekey.pem;
#
#        ssl_session_timeout  5m;
#
#        ssl_protocols  SSLv2 SSLv3 TLSv1;
#        ssl_ciphers  HIGH:!aNULL:!MD5;
#        ssl_prefer_server_ciphers   on;
#
#    }
