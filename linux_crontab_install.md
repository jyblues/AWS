참고 http://hosting.websearch.kr/entry/php-%EC%9E%90%EB%8F%99%EC%8B%A4%ED%96%89-%EB%AA%85%EB%A0%B9-crontab-%EC%84%A4%EC%A0%95-%EB%B0%8F-%EB%B0%A9%EB%B2%95-%ED%81%AC%EB%A1%A0%ED%83%AD-%EC%86%8D%EC%84%B1%EC%8B%9C%EA%B0%84-%EB%B0%98%EB%B3%B5-%EC%A3%BC%EA%B8%B0

### CentOS 7 기준

* 예약 추가
```
crontab -e
```

위에 명령 후 editor 창이 열리면 아래 부분 추가
5분마다 특정 script(sh) 파일 실행(root 사용자로 실행)
```
*/5 * * * * [실행할 경로의 script]
```

실행할 script 파일 생성
```
vi cron_test.sh
```


방식 1(php 실행 파일로 실행)
단점 : 여러 모듈 및 확장, 각종 캐시 및 전역 정보들이 없는 경우가 발생합니다.
```
! /usr/bin/sh
/usr/bin/php [실행할 php 경로 및 파일명]
```

방식 2(curl 사용)
장점 : 각종 캐시 및 전역 정보들이 정상적으로 작동합니다.
단점 : ..
```
curl http://localhost/[실행할 php 파일명]
```

script 실행 권한 추가
```
chmod +x [실행할 script 파일명]
```

crond 재실행(이때는 crond 가 맞음)
```
systemctl restart crond
```

실행 확인
```
vi /etc/log/cron
```

부팅 후 script 실행
```
crontab -e
@reboot /root/test_boot_start.sh
```
