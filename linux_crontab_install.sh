# CentOS 7 기준

# 예약 추가
crontab -e

# 위에 명령 후 editor 창이 열리면 아래 부분 추가
#
# 5분마다 php 파일 실행(root 사용자로 실행)
# */5 * * * * root /usr/bin/php [원하는 php 파일 경로 및 파일명]

# php 실행 권한 추가
chmod +x [원하는 php 파일 경로 및 파일명]

# crond 재실행(이때는 crond 가 맞음)
systemctl restart crond

# 실행 확인
vi /etc/log/cron
