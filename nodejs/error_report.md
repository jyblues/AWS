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
