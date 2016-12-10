* 현재 tcp 상황 확인

```
  cat /proc/net/sockstat
```

* file open 개수 늘리기


```
# vi /etc/security/limits.conf  

* soft nofile 65535
* hard nofile 65535

```


* 사용자 별 max process 늘리기


```
# vi /etc/security/limits.conf  

* hard nproc 65535
* soft nproc 65535

```

* 연결 backlog 늘리기


```
# vi /etc/sysctl.conf  

net.core.netdev_max_backlog=30000
```

* socket 최대 connection 수 늘리기


```
# vi /etc/sysctl.conf  

net.core.somaxconn=1024

```

* tcp_fin_timeout 변경


```
# vi /etc/sysctl.conf  

net.ipv4.tcp_fin_timeout=10

```



* 웹서버와 같은 유형의 서버에서 high load에서는 사용자 소켓의 종료 진행에서 
  TIME_WAIT 상태가 되는데 이 것의 양이 60초간 지속 된다는 것을 가정하고 이 값을 충분히 높여 주는 것이 좋음.  


```
# vi /etc/sysctl.conf  

net.ipv4.tcp_max_tw_buckets=1800000

```


* 기존 TIME_WAIT 상태로 남아 있던 소켓을 재사용


```
# vi /etc/sysctl.conf  

net.ipv4.tcp_timestamps=1
net.ipv4.tcp_tw_reuse=1

```


* 브로드케스트에 응답하지 않게 한다.
  Smurf 공격을 예방할 수 있다.
```
net.ipv4.icmp_echo_ignore_broadcasts = 1
```

* 자동 조율 TCP 제한을 늘린다.  최소, 기본, 최대
```
net.ipv4.tcp_rmem = 4096 10000000 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
```

* 같은 시간에 많은 접속을 받았을때 TIME-WAIT 소켓을 재사용하게 한다.
 이것은 웹서버에서 유용하다. 
````
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=30
```

* TCP/IP가 대기 연결이 계속 원래 상태를 유지하는지 확인을 시도하는 빈도를 2시간에서 30분으로 한다.
```
net.ipv4.tcp_keepalive_time=1800
```

* dos(syn-flood) 공격을 방어하는데 도움이 된다.
```
net.ipv4.tcp_max_syn_backlog=4096
```

* 필요할 때 TCP syncookies를 사용한다
```
net.ipv4.tcp_syncookies = 1
```

* TCP 윈도우 스케일링을 활성화한다
```
net.ipv4.tcp_window_scaling = 1
```

* TCP 최대 버퍼 크기를 늘인다
```
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
```


* 커널 소프트 레벨 튜닝

```
  ulimit -n 32768
  /proc/sys/fs/file-max: 4096 -> 32768
  /proc/sys/fs/inode-max: 16384 -> 65536
  /proc/sys/net/ipv4/tcp_keepalive_time: 7200 -> 1200
  /proc/sys/net/ipv4/tcp_fin_timeout: 180 -> 30
  /proc/sys/net/ipv4/tcp_sack: 1 -> 0
  /proc/sys/net/ipv4/tcp_timestamps: 1 -> 0
  /proc/sys/net/ipv4/tcp_syncookies: 0 -> 1
  /proc/sys/net/ipv4/tcp_retries1: 7 -> 2
  /proc/sys/net/ipv4/tcp_max_syn_backlog: 128 -> 8192
  /proc/sys/net/ipv4/tcp_window_scaling: 1-> 0
```

* time_wait 
  * http://tagnee.tistory.com/22 - TCP TIME-WAIT State 재사용(reuse), 재활용(recycle)의 차이점
  * http://kikiho.tistory.com/entry/Linux-TIMEWAIT-State-%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC - TIME_WAIT  (tcp_tw_reuse 
  * http://sunyzero.tistory.com/198 - TCP의 TIME_WAIT를 없애는 법
  * http://tech.kakao.com/2016/04/21/closewait-timewait/ - CLOSE_WAIT & TIME_WAIT 최종 분석
  
  
* other reference
  * http://bonegineer.blogspot.kr/2014/01/blog-post.html - 리눅스 시스템 커널 파라메터 튜닝 값
  * http://hotpotato.tistory.com/93
  * http://www.brendangregg.com/blog/2015-03-03/performance-tuning-linux-instances-on-ec2.html - Performance Tuning Linux Instances on EC2


  * http://meetup.toast.com/posts/53 리눅스 서버의 TCP 네트워크 성능을 결정짓는 커널 파라미터 이야기 - 1편
  * http://meetup.toast.com/posts/54 리눅스 서버의 TCP 네트워크 성능을 결정짓는 커널 파라미터 이야기 - 2편
  * http://meetup.toast.com/posts/55 리눅스 서버의 TCP 네트워크 성능을 결정짓는 커널 파라미터 이야기 - 3편

* service problem
  * http://simp1e.tistory.com/39 nginx 서비스 도중 생긴일 (리눅스 시스템 자원 제한 변경)
