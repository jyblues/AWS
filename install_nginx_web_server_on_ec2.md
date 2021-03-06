# EC2 Instance 생성 후 SSH 접속, AmazonLinux 에 nginx + PHP5.6(or PHP7) + PHP-fpm + PHP-redis 환경을 만들기


## EC2 Instance 생성 후 SSH 접속
외부(PuTTYGen)에서 생성한 public, private key 사용으로 접속 가능
참고 : http://pyrasis.com/book/TheArtOfAmazonWebServices/Chapter07/02

## AmazonLinux 에 nginx + PHP5.6(or PHP7) + PHP-fpm + PHP-redis 환경을 만들기

아래 주소 참조합니다.
http://qiita.com/toshihirock/items/77835f83f679423874ea

다른 방법 : https://gist.github.com/dragonjet/270cf0139df45d1b7690

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

좋은 정보 : http://www.solanara.net/solanara/nginx

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


#### PHP 7 (remi repo 이용해서 설치)

```
yum install -y epel-release
rpm -ivh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum --enablerepo=remi update remi-release
yum --enablerepo=remi-php70 install -y php php-fpm php-mysql php-mcrypt php-pdo php-common php-mbstring php-devel
php -v
```

#### PHP 7 (다른 방법)

```
sudo yum install -y php70w php70w-common php70w-pear php70w-mcrypt php70w-cli php70w-xml php70w-pdo php70w-fpm php70w-mbstring php70w-process php70w-pecl-zendopcache php70w-mysqlnd
```

#### PHP 5

```
sudo yum -y install php55 php55-fpm php55-devel php55-common php55-cli php55-pdo php55-mysql php55-xml php55-gd php55-mbstring php-pear php55-mysqlnd php55-mcrypt php55-pecl-zendopcache
sudo yum install php55w-pecl-redis
sudo yum install php55-pecl-igbinary
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
cgi.fix_pathinfo = 0    // aaa.com/bad.hack/bbb.php  이런식으로 비정상적인 접근이 허용된다. 이를 막기 위해 설정을 변경해줘야 한다. 이 명령어는 보안에 매우 취약하기 때문에 0으로 수정한다.
allow_url_fopen = Off   // URL 객체에 파일처럼 접근할 수 있는 URL-판단 fopen 랩퍼를 활성화
expose_php = Off        // HTTP 헤더에 PHP 버전이 노출된다. 노출되지 않게 합니다.
display_errors = Off
```

* PHP timezone 설정

timezone을 설정하지 않으면 PHP 시간 관련 함수에서 예외가 발생하여 작동하지 않습니다.
vi /etc/php.ini에서 date.timezone = Asia/Seoul로 수정

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

### nginx – php 연동 설정
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
        #변경 전
        #fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        # 변경 후(아래처럼 해줘야 php 파일을 읽을수 있습니다.
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
        # 사용 도메인을 설정합니다.
        server_name  my_domain;
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


### MariaDB 설치

```
yum install -y mariadb mariadb-server
systemctl enable mariadb.service
systemctl start mariadb.service
mysql_secure_installation
```

* 외부에서 접속 가능하게 설정

참고 자료 : http://zetawiki.com/wiki/MySQL%EC%97%90_%EC%9B%90%EA%B2%A9_%EC%A0%91%EC%86%8D_%ED%97%88%EC%9A%A9
```
SELECT Host FROM mysql.user WHERE user='root';
```
모든 IP 허용
```
INSERT INTO mysql.user (host,user,password) VALUES ('%','root',password('패스워드'));
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
```
IP 대역 허용
```
INSERT INTO mysql.user (host,user,password) VALUES ('111.222.%','root',password('패스워드'));
GRANT ALL PRIVILEGES ON *.* TO 'root'@'111.222.%';
FLUSH PRIVILEGES;
```


* EC2 instance 에 PHP 내에서 RDS로 연결이 안되는 경우

꼭 PHP 에서만 나타나는 현상은 아닙니다.
EC2 SecurityGroup Inbound 에 RDS(MySQL/Aura) 포트는 열어줘야하고, 반대로 RDS SecurityGroup Inbound 에서도 EC2 포트를 추가해줘야합니다.
쌍방으로 열어줘야 합니다.
