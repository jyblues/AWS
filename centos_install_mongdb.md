## 저장소 추가

```
vi /etc/yum.repos.d/mongodb.repo
```

// 추가
```
[MongoDB]
name=MongoDB Repository
baseurl=http://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
```

## yum 으로 설치

```
yum -y install mongodb-org
```

yum -update로 mongdb가 업데이트되는 것을 방지

```
vi /etc/yum.conf

exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools
```

## 실행, 재시작, 중지

```
systemctrl start mongod
```

부팅시 자동으로 실행하려면

```
systemctl enable mongod
```

## 테스트

```
$ mongod --version

db version v3.2.0
git version: 45d947729a0315accb6d4f15a6b06be6d9c19fe7
OpenSSL version: OpenSSL 1.0.1e-fips 11 Feb 2013
allocator: tcmalloc
modules: none
build environment:
    distmod: rhel70
    distarch: x86_64
    target_arch: x86_64
```

## 관리자 계정 추가

```
$ mongo    
> use admin
> db.createUser( { user: "<username>",
          pwd: "<password>",
          roles: [ "userAdminAnyDatabase",
                   "dbAdminAnyDatabase",
                   "readWriteAnyDatabase"
] } )
```

## 사용자 DB에 계정 추가

```
use myDB
db.createUser({ user: "<username>",
          pwd: "<password>",
          roles: ["dbAdmin", "readWrite"]
})
```


## 외부에서 인증하고 접속하기

참고 : http://www.tutorialbook.co.kr/entry/MongoDB-%EC%97%90%EC%84%9C-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%9D%B8%EC%A6%9D-authorization-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0

```
vi /etc/mongodb.conf

# 모든 IP 접속 가능하게 설정 comment
#bindIp: 127.0.0.1

# 인증으로 접속 가능하게 설정
security:
   authorization: enabled
```

## 접속 방법

```
mongo --port <포트> -u "<사용자 계정>" -p "<비밀번호>" --authenticationDatabase "<databse>"
 
ex)
mongo --port 25321 -u "test_user" -p "tutori2341" --authenticationDatabase "test_db"
```

# PHP MongoDB library(new)

https://github.com/mongodb/mongo-php-library

```
wget "https://github.com/mongodb/mongo-php-driver/archive/master.zip"
unzip master.zip
cd mongo-php-driver-master
phpize
./configure
make
make install
echo 'extension=mongodb.so' > /etc/php.d/mongodb.ini
systemctl restart httpd
```

# PHP Mongo library(regacy)
```
pecl install mongo
echo 'extension=mongo.so' > /etc/php.d/mongo.ini
systemctl restart httpd
```

## error & solution
Q: phpize Cannot find PHP headers in /usr/include/php
A: yum install php-devel

Q: mongodb configure: error: Cannot find OpenSSL's <evp.h>
A: yum install openssl openssl-devel

# PHP Session Handler
https://gist.github.com/dimzon/62eeb9b8561bcb9f0c6d

