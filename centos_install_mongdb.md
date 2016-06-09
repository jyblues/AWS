저장소 추가

```
vi /etc/yum.repos.d/mongodb.repo

// 추가
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
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
$ mongo
MongoDB shell version: 2.6.2
connecting to: test
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
```

접속 방법
```
mongo --port <포트> -u "<사용자 계정>" -p "<비밀번호>" --authenticationDatabase "<databse>"
 
ex)
mongo --port 25321 -u "test_user" -p "tutori2341" --authenticationDatabase "test_db"
</databse>
```

PHP용 MongoDB library

https://github.com/mongodb/mongo-php-library

