
먼저 필요한 패키지를 설치합니다.

```
sudo yum install gcc openssl-devel libyaml-devel readline-devel zlib-devel git
```

다음 명령을 실행하여 rbenv를 설치합니다.

```
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
```

/home/<사용자 계정>/.rbenv 디렉터리에 rbenv가 설치됩니다. rbenv 명령을 사용할 수 있도록 다음 명령을 실행합니다.

```
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source .bashrc
```

rbenv install 명령을 사용할 수 있도록 ruby-build를 설치합니다. 
그리고 gem을 설치했을 때 매번 rbenv rehash 명령을 입력하지 않도록 rbenv-gem-rehash를 설치합니다.
```
mkdir ~/.rbenv/plugins
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/ruby-build.git
git clone https://github.com/sstephenson/rbenv-gem-rehash.git
```

이제 사용자 계정 디렉터리로 이동한 뒤 rbenv install 명령으로 Ruby 2.1.3 버전을 설치합니다. 
그리고 rbenv local 명령으로 Ruby를 현재 사용자 계정에서만 사용할 수 있도록 설정합니다.
```
rbenv install 2.1.3
rbenv local 2.1.3
```
