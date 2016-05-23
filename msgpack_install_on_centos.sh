$ wget https://github.com/msgpack/msgpack-php/zipball/master -O msgpack-php.zip
$ unzip msgpack-php.zip 
$ cd msgpack-msgpack-php-da24be3/
$ phpize
Configuring for:
PHP Api Version:         20121113
Zend Module Api No:      20121212
Zend Extension Api No:   220121212

$ ./configure
$ make && make install
Installing shared extensions:     /usr/lib64/php/modules/
Installing header files:          /usr/include/php/


$ cd /usr/lib64/php/modules/
$ ll | grep msgpack
-rwxr-xr-x 1 root root  388516 Sep 18 14:27 msgpack.so


##### php.conf 디렉토리에 맞게 ini 에 extension 등록하기! 안되면 php.ini등록해도됨
$ echo extension=msgpack.so > /etc/php.d/msgpack.ini 

##### 웹서버종류에 따라서 Apache Restart 또는 php-fpm restart
$ /etc/init.d/php-fpm restart

##### 최종확인
$ php -i | grep 'MessagePack Support'
MessagePack Support => enabled

<?php phpinfo() ?> 
MessagePack Support enabled
Session Support enabled
extension Version   0.5.6-dev
header Version  0.5.4
Directive   Local Value Master Value
msgpack.error_display   On  On
msgpack.illegal_key_insert  Off Off
msgpack.php_only    On  On
