#### yum 설치
```
yum -y install redis --enablerepo=remi --disableplugin=priorities
```

/etc/redis.conf 에 bind를 127.0.0.1 -> 0.0.0.0 으로 변경

#### password 설정
/etc/redis.conf 파일에 requirepass 에서 설정합니다.
```
vi /etc/redis.conf
```



#### Source 로 설치
링크 : https://medium.com/@andrewcbass/install-redis-v3-2-on-aws-ec2-instance-93259d40a3ce#.nuxrmv1av
