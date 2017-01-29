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

##### redis-server install from sources
```
wget https://github.com/antirez/redis/archive/2.8.24.tar.gz
tar xvfz 2.8.24.tar.gz
cd redis-2.8.24/
make
sudo make install
sudo mkdir -p /etc/redis /var/lib/redis /var/log/redis
sudo cp src/redis-server src/redis-cli /usr/local/bin
sudo cp redis.conf /etc/redis/redis.conf
sudo vi /etc/redis/redis.conf
```

##### configure a redis.conf
```
bind 127.0.0.1                                //line 61
daemonize yes                                 //line 127
logfile "/var/log/redis.log"             //line 162
dir /var/log/redis                           //line 246
```
