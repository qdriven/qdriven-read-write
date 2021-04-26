---
title: ansible In 30 Minutes
date: 2018-07-01 21:34:04
tags: [ansible,ci-cd]
---
# Ansible Basic Concept

ansible 是一个操作机器的工具,可以通过编排不同的inventory,组合不同的命令来将日常运维的操作
变成可运行的脚本资产,同时也可以积累常用的脚本以便复用.

下面是关于ansible的一些基础概念的脑图,总体而言ansible包括了以下几个概念：

- inventory: 定义主机,定义操作对象
  * Host:主机
  * Group：不同的主机组合成一个组，一个组下面可以有子组，于是就构成了一个树形结构
- variable： 变量，主要用来定义对于操作机器时使用的可变参数


# Ansible Installation

- install in MAC

```sh
brew unisntall ansible
brew install ansible
```

- install in centos

```sh
sudo yum install epel-release
sudo yum install ansible -y
```

# Configure hosts for ansible ssh connector

- copy ssh key to different hosts

```sh

ssh-keygen
ssh-copy-id remoteuser@remote.server
ssh-keyscan remote.server >> ~/.ssh/known_hosts

```

- check ssh connection

```sh
ssh remoteuser@remote.server

```

it is done.

# Ansible Ad-hoc Commands

ansible 命令的pattern 如下：

```sh
ansible <host-pattern> [options]
```

具体查看ansible 的使用帮助是：

```sh
ansible --help
```

## ansible ad-hoc command - 检查安装环境


```sh
ansible all -m ping -u root
```

## ansible ad-hoc command - 执行命令

```sh
ansible all -a "/bin/sh echo hello world"
```

## ansible ad-hoc command - copy files

```sh
ansible web -m copy -a "src=/etc/hosts dest=/tmp/hosts"
```

## ansible ad-hoc command - yum install 

```sh
ansible web -m yum -a "name=acme state=present"
```

## ansible ad-hoc command - add user

```sh
ansible all -m user -a "name=foo passsword=<crypted password here>"
```

## ansible ad-hoc command - download git 包

```sh
ansible web -m git -a "repo=git://foo.example.io/repo.git dest=/src/myapp"
```

## ansible ad-hoc command - start service 

```sh
ansible web -m service -a "name=httpd state=started"
```

## ansible ad-hoc command - 并行运行

```sh
ansible web -a "/sbin/reboot" -f 10
```

## ansible ad-hoc command - 查看全部系统信息

```sh
ansible all -m setup
```

## ansible ad-hoc command 小结

从以上的例子中我们可以看到ansible的命令一般都会使用如下几点：

- module: -m 
- module_args: -a 
- hosts: all/web/......

以上三个组合成为了下面的一个命令：

```sh
ansible all -m service -a "name=httpd state=started"
```

从python的角度看,可以用伪代码的方式:

```sh

def copy(args={}):
    for kwarg, v in args.items():
        print("{key}={value}".format(key=kwarg, value=v))


def test(args={}):
    for kwarg, v in args.items():
        print("{key}={value}".format(key=kwarg, value=v))


module_mapping = {
    "copy": copy,
    "test": test
}


def ansible(module, module_args):
    func = module_mapping.get(module)
    parsed = module_args.split(" ")
    args = {}
    for module_arg in parsed:
        kv = module_arg.split("=")
        args[kv[0]] = kv[1]
    func(args)


if __name__ == '__main__':
    ansible(module='copy', module_args="name=name test=test")

```
