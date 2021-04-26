---
layout: posts
title: 测试日志2020-3 Github 访问速度缓慢解决 
date: 2020-07-30 12:12:00
categories: [git,tips]
tags: [git,tips]
---

## 1. Github 访问速度缓慢解决

不知道什么原因，老鸟家里访问Github仓库速度缓慢，下载GITHUB仓库速度也是缓慢。
这种缓慢慢慢已经给老鸟造成了一些困扰. 但是问题是实际存在的，老鸟心里想一定需要解决.
好在有了gitee，通过gitee fork github的项目，然后再通过gitee访问fork过来的github的项目快如闪电。

同时通过下面的介绍，也希望测试同学们能够看到，其实自动化练手的机会很多，一点点小地方都可以提高一点效率.
<!-- more -->
## 1.1. 使用Gitee解决Github下载缓慢的方法

1. 注册Gitee账户，可以直接使用Github账户授权登录，或者直接使用微信登录就可以
2. 通过GITHUB/GITLAB导入仓库创建新的项目
![img](/img/gitee/gitee-import.jpg)
![img](/img/gitee/gitee_import.jpg)
1. 创建仓库完成之后就可以通过git clone 文件

仓库下载好了，速度也快了很多，但是又遇到新的问题了，
就是测试老鸟又遇到新的问题了，问题是，我现在clone的仓库是gitee的仓库，我如何将我的提交同步到两个不同的仓库呢？

## 1.2. GIT 仓库添加多个远程仓库

上面的问题用文绉绉的话描述就是，如果给一个本地仓库添加多个remote(远程)仓库，这样一次提交就可以同时更新两个仓库. 

具体时候方法如下:

1. 查看目前仓库remote有几个

```sh
git remote -v
```

![img](/img/gitee/git-remote-v.jpg)

可以看到目前的远程仓库是gitee

2. 添加github的远程仓库到本地仓库

使用以下命令添加一个名字叫github的远程仓库，这样就把两个远程仓库同时添加到本地仓库了:

```sh
# git remote add <name> <github_url>
git remote add github git@github.com:qdriven/intelligent-test-platform.git
```

再次查看remote 仓库:
```sh
git remote -v
```

![img](img/gitee/two-remote.jpg)

可以看到目前的remote已经有两个了.

3. 同时更新两个远程仓库

目前已经有两个remote，两个分别是:

- origin
- github

因此在Commit之后使用如下两个命令就可以同时更新所有的仓库了

```sh
git push origin master
git push github master
```

4. 更新多个远程仓库脚本化

每次输入两个push，很明显也是比较麻烦的，因此老鸟觉得使用shell来自动化这些事情:

```sh

#! /bin/sh
echo "current path: "`pwd`
git add .
git commit -m "$1"
remotes=`git remote`
for repo in ${remotes}
do
    git push ${repo} master
    # echo ${repo}
done

```

将以上的命令放到commit.sh文件中.然后使用:

```sh
sh commit.sh "<comments>"
```

就可以同时push 两个仓库了. 

## 1.3. 小结

- 通过gitee和github的同步，可以快速解决github访问速度慢的问题
- 使用git命令和shell命令可以自动化提交流程: 自动化的事情到处都有不缺练手机会
- 又多学了几个关于git命令，尤其是git remote的使用


## 1.4 优化

其实老鸟觉得还有优化的空间，老鸟先卖个关子，后面再说这个话题.