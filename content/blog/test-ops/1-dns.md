---
title: "DNS Tips"
tags: [test-ops]
date: 2014-08-24T10:31:11+08:00
---

## DNS 使用Tips

- dig 工具使用

```
dig  www.baidu.com
```

result:

```sh
; <<>> DiG 9.9.7-P3 <<>> www.baidu.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16168
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;www.baidu.com.                 IN      A

;; ANSWER SECTION:
www.baidu.com.          907     IN      CNAME   www.a.shifen.com.
www.a.shifen.com.       154     IN      A       61.135.169.121
www.a.shifen.com.       154     IN      A       61.135.169.125

;; Query time: 32 msec
;; SERVER: 10.0.5.55#53(10.0.5.55)
;; WHEN: Tue Nov 28 15:28:20 CST 2017
;; MSG SIZE  rcvd: 101
```

CNAME: 事实服务器

- DNS Trace:

```sh
dns www.baidu.com +trace
```

- dns cache

nscd in linux

```sh
nscd
/etc/nscd.conf
enable-cache hosts yes
/etc/init.d/nscd restart
nscd -g
nscd -i hosts # clean cache
```

- BIND9

```sh
/etc/bind
/etc/bind/named
/etc/named.conf
named-checkzone
```

- nslookup

```sh
nslookup <server to look for> <dns server to use>
```

