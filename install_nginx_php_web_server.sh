# Install linux update, followed by GCC and Make
sudo yum -y update
sudo yum install -y gcc make

# CentOS/RHEL 7.x
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# nginx 1.8 install
sudo yum install -y nginx18

# HTTP firewall setting
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload

# PHP
sudo yum install -y php70w php70w-opcache php70w-common php70w-fpm php70w-mysql php70w-mcrypt php70w-mbstring

# PHP-FPM 연동
