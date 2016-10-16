저장소 추가

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

yum 으로 설치

```
yum -y install mongodb-org
```

yum -update로 mongdb가 업데이트되는 것을 방지

```
vi /etc/yum.conf

exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools
```

실행, 재시작, 중지

```
systemctrl mongod start
```

부팅시 자동으로 실행하려면

```
chkconfig mongod on
```

테스트

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

$ mongo    
> db.users.insert({name:'hello'})
WriteResult({ "nInserted" : 1 })
> db.users.find({})
{ "_id" : ObjectId("53a3fa85a3484631e5c4cfdd"), "name" : "hello" }
```

외부에서 인증하고 접속하기

참고 : http://www.tutorialbook.co.kr/entry/MongoDB-%EC%97%90%EC%84%9C-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%9D%B8%EC%A6%9D-authorization-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0

```
vi /etc/mongodb.conf

# 모든 IP 접속 가능하게 설정
bind_ip=0.0.0.0

# 인증으로 접속 가능하게 설정
auth=true
# 인증이 없어도 접속 가능하게 설정
#noauth=true
```

admin 계정 생성
참고 : http://jmkjb.blogspot.kr/2015/06/mongo-db.html

```
mongo

use admin
db.createUser({ user: "<사용자 계정>",
          pwd: "<비밀번호>",
          roles: ["dbAdmin", "readWrite"]
})
 
ex)
use test_db
db.createUser({ user: "test_user",
          pwd: "tutori2341",
          roles: ["dbAdmin", "readWrite"]
})

생성된 전체 DB들에 대한 액세스 권한이 있는 계정 생성
db.createUser({user: "dba",pwd: "dba",roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]  })

해당 DB(chatlog)에 대해 readWrite 권한을 가진 일반 사용자 계정 생성
db.createUser( { user:"user", pwd: "password", roles: [{role:"readWrite", db: "chatlog"}] } )

해당 DB(chatlog)에 대해 관리자 권한을 가진 사용자 계정 생성
db.createUser( { user:"user", pwd: "password", roles: [{role:"userAdmin", db: "chatlog"}] } )

일반 계정 삭제
db.dropUser("user")

```

접속 방법
```
mongo --port <포트> -u "<사용자 계정>" -p "<비밀번호>" --authenticationDatabase "<databse>"
 
ex)
mongo --port 25321 -u "test_user" -p "tutori2341" --authenticationDatabase "test_db"
```

PHP용 MongoDB library

https://github.com/mongodb/mongo-php-library

