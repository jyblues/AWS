# ntp 사용(CentOS 7)

# ntp 설치
yum install ntp

# 동기화 서버 주소 설정
vi /etc/ntp.conf

#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst
server 0.kr.pool.ntp.org
server 1.asia.pool.ntp.org
server 3.asia.pool.ntp.org

# 방화벽 설정
firewall-cmd --add-service=ntp --permanent

# 방화벽 다시 로드
firewall-cmd --reload

# ntp 서비스 시작
systemctl start ntpd

# 시스템 재부팅 후 자동으로 ntp 서비스 시작
systemctl enable ntpd.service

# 작동 확인
ntpq -p
