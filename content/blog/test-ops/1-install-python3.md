---
title: Install Python3.7 in Centos
date: 2019-10-1 00:58:45
tags: ["test-ops"]
---

Centos安装Python3.7需要通过自己编译安装进行，中间是不是会遇到一些问题，以下是一些安装步骤和一些问题：

- 下载Python3.7文件
- 解压Pyton3.7文件
- 设置config
- make install 

## 下载Python3.7文件并解压

```sh
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
tar -zxvf Python-3.7.0.tgz
```

## 安装依赖并且设置config

```sh
sudo yum install gcc
sudo yum install zlib*
sudo yum install libffi-devel -y
./configure prefix=/usr/local/python3 --with-ssl
```

## make install

```sh
sudo make && sudo make install
```

## setup bashrc path

修改.bashrc文件将python3导入到PATH中:

```sh
export PATH="/usr/local/python3/bin:$PATH"
```