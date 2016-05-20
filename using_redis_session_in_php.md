아래 코드를 session_start() 전에 호출합니다.

```
ini_set('session.save_handler', 'redis');
ini_set('session.save_path', 'tcp://HOST:PORT?auth=PASSWORD&timeout=1800'; // timeout(초)

```
