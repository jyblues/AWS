* EC2 micro instance를 사용하면 아래 메시지가 발생할 수 있습니다.

```
> babel server --out-dir build --presets=es2015 && webpack

.
.
.

sh: line 1:  5276 Killed                  webpack
npm ERR! code ELIFECYCLE
npm ERR! errno 137
npm ERR! delta-service-tool@1.0.0 build: `babel server --ignore 'dbdata/coupon-gen-list',test --out-dir build --presets=es2015 && webpack`
npm ERR! Exit status 137
npm ERR!
npm ERR! Failed at the delta-service-tool@1.0.0 build script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.

npm ERR! A complete log of this run can be found in:
npm ERR!     /root/.npm/_logs/2017-11-24T03_05_29_314Z-debug.log
```

* 해결 방법 - 1(AWS 공식 문서)
http://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/instance-store-swap-volumes.html

* 해결 방법 - 2
swap file을 생성합니다. :)

```
$ sudo dd if=/dev/zero of=/swapfile bs=1M count=512     # 512MB 스왑용 파일 생성
$ sudo chown root:root /swapfile    # root 소유
$ sudo chmod 600 /swapfile          # 권한설정
$ sudo mkswap /swapfile
$ sudo swapon /swapfile
$ sudo swapon -a
 
$ sudo vi /etc/fstab        # 리부팅시 인식할 수 있도록 fstab에 등록 (실수할 경우 부팅이 안될 수 있으니 스냅샷 + 조심!)

가장 아래줄에 내용추가
   
/swapfile   swap   swap   defaults  0  0
   
 
$ sudo swapon -s    # sanity test  Swap 에 설정한 용량이 사용되었는지 확인
$ free -m           # sanity test  Swap 에 설정한 용량이 사용되었는지 확인
```
