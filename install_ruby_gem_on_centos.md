# CentOS 7

참고 : https://www.vultr.com/docs/install-ruby-on-rails-with-rbenv-on-centos-7

먼저 필요한 패키지를 설치합니다.

```
sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel
```

## RVM 으로 설치 

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

아래 명령을 실행해야 사용 가능합니다.

```
source /usr/local/rvm/scripts/rvm
```


## rbenv 로 설치

다음 명령을 실행하여 rbenv를 설치합니다.

```
cd ~
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

rbenv install -l
rbenv install -v 2.2.3
rbenv rehash

```

사용 버전을 설정합니다.
```
rbenv global 2.2.3
```

설치된 버전을 확인합니다.

```
rbenv versions
```


## Source 받아서 컴파일해서 설치

### 설치

소스에서 빌드하기
물론, 소스로부터 루비를 설치할 수도 있습니다. tarball을 다운로드, 압축을 풀고 이 명령어를 입력하세요.

```
./configure
make
sudo make install
```
기본적으로, 이 명령어는 루비를 /usr/local에 설치합니다. 변경하시려면 ./configure 스크립트에 --prefix=DIR 옵션을 넘기세요.

서드파티 도구나 패키지 관리자를 사용하시는 것이 더 좋습니다. 왜냐하면, 이렇게 설치된 루비는 어떤 도구로도 관리되지 않기 때문이죠.


### 삭제

빌드한 디렉토리에서 아래 명령 실행

```
sudo make uninstall
```
