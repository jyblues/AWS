### 1. Convert a putty private key to pem
https://stackoverflow.com/questions/33273180/create-a-pem-from-a-ppk-file

### 2. Security Group 설정합니다.

### 3. Bastion 서버를 통해서 연결할 177.xx.xx.xx로 연결합니다.
```
ssh -i ~/private_key.pem ec2-user@177.xx.xx.xx
```
