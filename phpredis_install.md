
### phpredis 다운로드

#### PHP 5.x

```
$ wget https://github.com/phpredis/phpredis/archive/2.2.4.tar.gz
tar -xvzf 2.2.4.tar.gz
```

#### PHP 7
```
git clone -b php7 https://github.com/phpredis/phpredis.git
```


### 설치합니다.
```
$ cd phpredis-2.2.7                      # 进入 phpredis 目录
$ /usr/local/php/bin/phpize              # php安装后的路径
$ ./configure --with-php-config=/usr/local/php/bin/php-config
$ make && make install
```

### phpredis.so을 등록합니다.
```
echo "extension=redis.so" > /etc/php.d/redis.ini
```
