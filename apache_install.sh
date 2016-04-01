# web server 구축
http://www.spidersoft.com.au/2013/apache-php-config-boilerplate/

# phpize 설치
sudo yum install -y php-devel  # php
sudo yum install -y php56-devel  # php 5.6

#------------------
# phpredis 설치

# github 에서 소스 복제
sudo git clone https://github.com/phpredis/phpredis
cd phpredis

# autoconf 및 Makefile 생성.  --enable-redis-igbinary 는 igbinary 패키지를 설치했을 경우에만 사용
sudo phpize
sudo ./configure --enable-redis-igbinary

# 컴파일과 설치
sudo make && make install

# redis.so 파일 필요한 곳에 복사
sudo cp /home/ec2-user/phpredis/modules/redis.so /usr/lib64/php/5.6/modules/redis.so
sudo cp /home/ec2-user/phpredis/modules/redis.so /usr/lib64/php-zts/5.6/modules/redis.so

# apache에 추가
sudo echo "extension=redis.so" > /etc/php.d/redis.ini # redis.ini로
sudo echo "extension=redis.so" > /etc/php.d/php.ini # 
