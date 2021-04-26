---
title: SONAR环境建立
date: 2019-10-1 00:58:45
tags: ["test-ops"]
---

## postgresql 初始化

```sh
sudo rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
sudo yum -y install postgresql96-server postgresql96-contrib
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl start postgresql-9.6
sudo systemctl enable postgresql-9.6
```

## 切换用户

```sh
sudo su postgres
psql
createuser sonar
ALTER USER sonar WITH ENCRYPTED password 'sonar';
CREATE DATABASE sonar WITH ENCODING 'UTF8' OWNER sonar TEMPLATE=template0;
CREATE DATABASE sonar OWNER sonar;

```
## 设置postgresql密码验证

/var/lib/pgsql/9.6/data/pg_hba.conf 文件中修改 peer to trust and idnet to md5.


```sh
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
```

## postgresql 登陆

```sh
psql -h localhost -d sonar -U sonar -W
```

## sonar config 文件配置

```sh
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:postgresql://localhost/sonar
```

## 启动sonar

```sh
./bin/sonar.sh start
```

去logs目录先观察 web.log,如果启动有报错，那么需要再修改报错的问题，一般按照以上步骤就可以启动SONAR.
