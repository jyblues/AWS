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

* other reference

** http://bonegineer.blogspot.kr/2014/01/blog-post.html
** http://hotpotato.tistory.com/93