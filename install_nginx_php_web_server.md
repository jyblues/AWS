# AmazonLinux에 nginx + PHP5.6(or PHP7) + PHP-fpm + PHP-redis 환경을 만들기

아래 주소 참조합니다.
http://qiita.com/toshihirock/items/77835f83f679423874ea

```
Install linux update, followed by GCC and Make
sudo yum -y update
sudo yum install -y gcc make
```

#### CentOS/RHEL 7.x

```
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
```

#### nginx 1.8 install

```
sudo yum install -y nginx18
```

#### 최신 stable 버전 설치 방법

nginx의 docs를 보면 최근 stable 버젼으로 설치하는 방법이 있습니다. 
http://nginx.org/en/linux_packages.html 

/etc/yum.repos.d에 nginx.repo 파일을 만들어서 아래 내용을 넣습니다. 
```
[nginx] 
name=nginx repo 
baseurl=http://nginx.org/packages/centos/7/$basearch/ 
gpgcheck=0 
enabled=1 
```

#### HTTP firewall setting
```
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
```


#### PHH 7 (remi repo 이용해서 설치)

```
yum install -y epel-release
rpm -ivh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum --enablerepo=remi update remi-release
yum --enablerepo=remi-php70 install -y php php-fpm php-mysql php-mcrypt php-pdo php-common php-mbstring php-devel
php -v
```

* php-fpm (시작/부팅시 자동 실행/상태 확인/정지)
```
systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm
systemctl stop php-fpm
```

* php.ini 설정
nginx 보안 정보 http://blog.1day1.org/460
```
vi /etc/php.ini
```
```
cgi.fix_pathinfo = 0
allow_url_fopen = Off
expose_php = Off
display_errors = Off
```

* www.conf 설정
```
vi /etc/php-fpm.d/www.conf
```

```
user = nginx
group = nginx
 
listen.owner = nobody //
listen.group = nobody // 앞에 주석 ; 을 지움
```

* nginx – php 연동 설정
```
vi /etc/nginx/conf.d/default.conf
```

nginx 1.8.0 default.conf 기본 설정
```
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/log/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```
nginx-php default.conf 설정 수정
```
 server {
 server_name  localhost mydomain.com sub.domain.com;
root        /usr/share/nginx/html;
index       index.php index.html index.htm;

location / {
        try_files $uri $uri/ =404;
    }

# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
#
    location ~ \.php$ {
        try_files      $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```
위 부분들을 찾아서 수정합니다. 저장하고 (server_name 에 자기 도메인 or IP) nginx 를 시작해준다.
nginx 가 이미 실행중이라면 재시작해야 설정이 적용된다.

```
systemctl reload nginx
```

* nginx – php 가 제대로 연동됐는지 확인
```sh
vi /usr/share/nginx/html/phpinfo.php
```
/usr/share/nginx/html/phpinfo.php
```php
<?php
phpinfo();
?>
```
#### PHP 7

```
sudo yum install -y php70w php70w-common php70w-pear php70w-mcrypt php70w-cli php70w-xml php70w-pdo php70w-fpm php70w-mbstring php70w-process php70w-pecl-zendopcache php70w-mysqlnd
```

#### PHP 5

```
sudo yum install -y php php-common php-pear php-mcrypt php-cli php-xml php-pdo php-fpm php-mbstring php-process php-pecl-zendopcache php-mysqlnd
```

#### PHP timezone 설정

timezone을 설정하지 않으면 PHP 시간 관련 함수에서 예외가 발생하여 작동하지 않습니다.
vi /etc/php.ini에서 date.timezone = Asia/Seoul로 수정

아래 명령어는 PHP 파일이 정확히 일치하지 않는 경우, 비슷한 파일을 찾아주는 명령어인데, 기본적으로 “1”로 설정되어 있다. 
하지만, 이 명령어는 보안에 매우 취약하기 때문에 0으로 수정한다.
cgi.fix_pathinfo=0


#### Nginx Configuration

```
/etc/nginx/conf.d/default.conf or /etc/nginx/nginx.conf
sudo vi /etc/nginx/conf.d/default.conf

server{
    
    location / {
        root   /var/www/html;
        index  index.php index.html index.htm;
    }
    
    location ~ \.php$ {
        fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_index   index.php;
        fastcgi_param   SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        변경
        include         fastcgi_params; // --> include fastcgi.conf;
    }
}
```

#### php-FPM Configuration

```config_file
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
```

#### SSL 설정
```
 /etc/nginx/nginx.conf
 http {
   server {
       listen 80;
       ...

    여기부터
    server {
        listen       443;
        server_name  blackcoffee-studio.iptime.org;
        root         /usr/share/nginx/html;

        index index.php index.html index.htm;

        #charset koi8-r;

        #access_log  /var/log/nginx/host.access.log  main;

        location / {
        }

        # redirect server error pages to the static page /40x.html
        #
        error_page  404              /404.html;
        location = /40x.html {
        }

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        location ~ \.php$ {
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_NAME $document_root$fastcgi_script_name;
               변경
               include fastcgi_params; // --> include fastcgi.conf;
        }

        ssl                  on;
        ssl_certificate      /etc/nginx/conf.d/delta-server.crt;
        ssl_certificate_key  /etc/nginx/conf.d/delta-privatekey.pem;

        ssl_session_timeout  5m;

        ssl_protocols  SSLv2 SSLv3 TLSv1;
        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers   on;

    }
```

#### HTTP firewall setting

```
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
```

#### php-fpm 실행(서비스)

```
systemctl start php-fpm
systemctl enable php-fpm.service
```

#### nginx 실행(서비스)

```
systemctl start nginx
systemctl enable nginx
```

#### index.php 생성

```
vi /usr/share/nginx/html/index.php
<?php phpinfo(); ?>
```

#### 외부 MySQL 사용 설정
참고 : http://www.systemhook.net/?tag=mysql
```
setsebool -P httpd_can_network_connect 1
```

#### 로그 디렉토리 쓰기 가능한 권한 변경
/var/www/html에 log 디렉토리에 파일로그를 기록한다면 소유권 변경 필요합니다.
```
sudo chown -R apache:apache log
```

#### 시간대를 대한민국 서울로 변경
```
sudo cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
```

#### python pip 설치
링크 - http://zetawiki.com/wiki/CentOS_python-pip_%EC%84%A4%EC%B9%98

#### redis-py 설치
링크 - https://redislabs.com/python-redis
