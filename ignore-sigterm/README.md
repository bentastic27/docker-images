Just a container that ignores sigterms or waits based on the first arg.

Example with arg:

```
[root@archvm ignore-sigterm]# docker run -d bentastic27/ignore-sigterm:latest 3
41d64094bbe39d9636237f05787e7ec9d66293226cfc1bb750fb3ec8a82b1168

[root@archvm ignore-sigterm]# docker stop 41d
41d

[root@archvm ignore-sigterm]# docker logs 41d
Hello, waiting for the signal
Add an arg to wait X number of seconds after sigterm to exit
ex: script.py 3

2021-10-05 20:23:58.019790
started
will wait 3 seconds after sigterm

2021-10-05 20:24:09.946642
SIGTERM'd
waiting 3 seconds

2021-10-05 20:24:12.951489
Goodbye
```
