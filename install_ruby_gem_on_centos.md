#CentOS 7

참고 : https://www.vultr.com/docs/install-ruby-on-rails-with-rbenv-on-centos-7

먼저 필요한 패키지를 설치합니다.

```
sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel
```

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

설치된 버전을 확인합니다.

```
rbenv versions
```
