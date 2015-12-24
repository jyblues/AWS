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

# PHP
sudo yum install -y php70w php70w-opcache php70w-common php70w-fpm php70w-mysql php70w-mcrypt php70w-mbstring


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
#        include         fastcgi_params;
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

