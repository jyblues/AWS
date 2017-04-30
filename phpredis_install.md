
### phpredis 설치

```
$ wget https://github.com/phpredis/phpredis/archive/2.2.4.tar.gz
$ cd phpredis-2.2.7                      # 进入 phpredis 目录
$ /usr/local/php/bin/phpize              # php安装后的路径
$ ./configure --with-php-config=/usr/local/php/bin/php-config
$ make && make install
```

### PHP7에서는 아래에서 다운로드해야 합니다.
```
git clone -b php7 https://github.com/phpredis/phpredis.git
```
