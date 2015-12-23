# Install linux update, followed by GCC and Make
sudo yum -y update
sudo yum install -y gcc make

# CentOS/RHEL 7.x
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# nginx 1.8 install
yum install -y nginx18

# HTTP firewall setting
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload

# PHP
yum install -y php70w php70w-opcache php70w-common php70w-fpm php70w-mysql php70w-mcrypt php70w-mbstring

# PHP-FPM 연동
