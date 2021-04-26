---
title: Linux 命令基础
date: 2019-10-1 00:58:45
tags: ["test-ops"]
---

## 查询用户和密码

```sh
less /etc/passwd
```

```sh
awk -F: '{ print $1}' /etc/passwd
cut -d: -f1 /etc/passwd
getent passwd | awk -F: '{ print $1}'
getent passwd
getent passwd | grep sonar
grep -E '^UID_MIN|^UID_MAX' /etc/login.defs

```

## hostname

```sh
hostname
hostname -f
```
## install mysql in centos

- update mysql dependencies

```sh
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
```

- install mysql-server and start mysql

```sh
sudo yum install mysql-server
sudo systemctl start mysqld
```

- setup mysql password

```sh
use mysql;
update user SET PASSWORD=PASSWORD("password") WHERE USER='root';
flush privileges;
exit
sudo systemctl start mysqld
```



