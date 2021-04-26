---
title: Linux Learning - linux 用户管理
tags: ["shell"]
date: 2014-08-24T10:31:11+08:00
---

linux 用户管理
-------------
基本上所有linux命令，都可以先用`cmd --help`后用`man cmd`查看特殊的选项
## 用户
这里列几个样例
### 添加
	useradd -p passwd -g group –G adm,root user_name
### 删除
	userdel -r user_name		#加-r选项会删除主目录
### 修改
	usermod
### 用户密码
	passwd

## 小组
也有类似命令

	groupadd
	groupdel
	groupmod
	gpasswd
	
	newgrp					#切换组

## sudo
可以会执行不了这个命令，说用户不是sudoers，网上说法是修改/etc/sudoers。
在Ubuntu上将用户加入组sudo中

## 账户相关文件
	/etc/passwd
	/etc/shadow
	/etc/group

## 批量创建
	newusers
	chpasswd
	pwconv

## 查询命令
	users
	groups
	finger
	id
## 切换用户
	su - new_user   

## [MAC] Mac Port Listener

```sh
lsof -Pni4 | grep LISTEN
```	