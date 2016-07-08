### installation

```
yum update -y
yum install -y nginx
sudo yum -y install php55 php55-fpm php55-devel php55-common php55-cli php55-pdo php55-mysql php55-xml php55-gd php55-mbstring php-pear php55-mysqlnd php55-mcrypt php55-pecl-zendopcache
```

### Configuration

* Nginx Configuration ```vi /etc/nginx/nginx.conf```

```
root /usr/share/nginx/html;

location / {
    index  index.php index.html index.htm;
}

location ~ \.php$ {
    fastcgi_pass    unix:/var/run/php-fpm/php-fpm.sock;
    fastcgi_index   index.php;
    fastcgi_param   SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    #fastcgi_param   SCRIPT_FILENAME  /scripts$fastcgi_script_name;
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


### 파일 권한 설정

AWS 자습서 참조 : http://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/install-LAMP.html

* www 그룹을 인스턴스에 추가합니다.

```
[ec2-user ~]$ sudo groupadd www
```

* 사용자(이 경우는 ec2-user)를 www 그룹에 추가합니다.

```
[ec2-user ~]$ sudo usermod -a -G www ec2-user
```

#### Important
  로그아웃을 하고 다시 로그인해서 새 그룹을 선택해야 합니다. [exit] 명령을 사용하거나 터미널 창을 닫을 수 있습니다.
  
* 로그아웃을 하고 다시 로그인한 다음, www 그룹에 대한 멤버십을 확인하십시오.

  a. 로그아웃을 합니다.
  ```[ec2-user ~]$ exit```
  
  b.인스턴스에 다시 연결한 다음, 다음 명령을 실행해서 www 그룹에 대한 멤버십을 확인하십시오.
    ```
    [ec2-user ~]$ groups
    ec2-user wheel www
    ```
    
* /var/www 및 그 콘텐츠의 그룹 소유권을 www 그룹으로 변경합니다.

```
[ec2-user ~]$ sudo chown -R root:www /var/www
```

* /var/www 및 그 하위 디렉터리의 디렉터리 권한을 변경해서 그룹 쓰기 권한을 추가하고 미래 하위 디렉터리에서 그룹 ID를 설정합니다.
```
[ec2-user ~]$ sudo chmod 2775 /var/www
[ec2-user ~]$ find /var/www -type d -exec sudo chmod 2775 {} \;
```

* write 권한이 필요하면 아래와 같이 설정합니다.
```
[ec2-user ~]$ sudo chmod 2770 /var/www
```

* /var/www 및 그 하위 디렉터리의 파일 권한을 계속 변경해서 그룹 쓰기 권한을 추가합니다.

```
[ec2-user ~]$ find /var/www -type f -exec sudo chmod 0664 {} \;
```

이제 ec2-user 및 www 그룹의 향후 멤버는 Apache document root에서 파일의 추가, 삭제, 수정을 할 수 있습니다. 이제, 정적 웹사이트 또는 PHP 애플리케이션 등 콘텐츠를 추가할 수 있습니다.


#### 다른 방식
```
usermod -a -G devgroup nginx
chown -R root:devgroup /var/www/html
chmod -R 775 /var/www/html
```

### nginx 실행

```
chkconfig nginx on
service nginx start

chkconfig php-fpm on
service php-fpm start
```
