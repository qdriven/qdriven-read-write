---
title: Linux Learning - linux的文件系统
tags: ["shell"]
date: 2014-08-24T10:31:11+08:00
---

linux的文件系统
--------------
## 概述（个人描述）
linux有个说法，一切皆文件，算是对IO的简化。
通常我们操作的目录+文件名是个逻辑上的概念，用以定位，目录也是文件。
物理上的概念是分区，分区需要挂载`mount`到特定目录上使用，挂载后就屏蔽了物理细节了。

## 文件
这个用`ls -l`可以看到详细信息
### 权限
	-rwxrwsrwT，三个类别读写执行权限。第一个字符表明文件类型。
### 所有者和所属组
	权限是分所有者、所属组和其他人的。
### 特殊位
	SUID	u+s,文件执行时以文件所有者的身份执行
	SGID	g+s,文件执行时以文件所属组的身份执行
	SBIT	o+t,针对目录，删除目录中文件的只能是root和所有者

### 修改命令
	chown user file
	chgrp group file
	chmod a+x file
### umask
	权限掩码，创建文件是默认权限由他的值控制，回取消其设置的相应权限
	

## 单个文件系统的结构
linux大致把外部存储空间分为**数据区**和**索引区**，文件系统间独立。这个索引区就是inode了，存文件的大小、权限、拥有者、引用数、block块位置等信息。inode与block的对应是个多级列表的结构，有十几个block指针。

inode的概念，在使用ln时有用，这个默认创建硬连接（只能是文件），这个时候两个文件指向同一个inode。

## 分区挂载
分区需要挂载才能使用，根`/`也是如此（这个不明白具体怎么做的）。
内核加载时，会根据`/etc/fstab`的内容加载分区。

## NFS
	Ubuntu下面Ubuntu下的例子
	服务端:
	$apt-get install nfs-kernel-server
	vi /etc/exports 添加nfs目录: /personal/nfs_share 10.1.60.34(rw,sync,no_root_squash)
	$sudo exportfs -r
	$sudo /etc/init.d/portmap start
	$sudo /etc/init.d/nfs-kernel-server start
	客户端:
	$sudo apt-get install nfs-common
	$sudo mount 10.19.34.76:/personal/nfs_share ~/nfsshare

## 特定目录含义
markdown表格支持挫呀，左右都可编辑估计就解决问题了