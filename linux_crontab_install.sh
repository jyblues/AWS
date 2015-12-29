# 참고
# http://hosting.websearch.kr/entry/php-%EC%9E%90%EB%8F%99%EC%8B%A4%ED%96%89-%EB%AA%85%EB%A0%B9-crontab-%EC%84%A4%EC%A0%95-%EB%B0%8F-%EB%B0%A9%EB%B2%95-%ED%81%AC%EB%A1%A0%ED%83%AD-%EC%86%8D%EC%84%B1%EC%8B%9C%EA%B0%84-%EB%B0%98%EB%B3%B5-%EC%A3%BC%EA%B8%B0

# CentOS 7 기준

# 예약 추가
crontab -e

# 위에 명령 후 editor 창이 열리면 아래 부분 추가
#
# 5분마다 특정 script(sh) 파일 실행(root 사용자로 실행)
# */5 * * * * root [실행할 script]

# 실행할 script 파일 생성
vi cron_test.sh
#! /usr/bin/sh
/usr/bin/php [실행할 php 경로 및 파일명]

# script 실행 권한 추가
chmod +x [실행할 script 파일명]

# crond 재실행(이때는 crond 가 맞음)
systemctl restart crond

# 실행 확인
vi /etc/log/cron
