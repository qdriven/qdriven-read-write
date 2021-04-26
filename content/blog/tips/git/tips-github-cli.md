---
layout: posts
title: 测试日志2020-2 Github Cli使用
date: 2020-07-30 12:12:00
categories: [backend,tips]
tags: [java,tips]
---

[Github Cli](https://github.com/cli/cli),是一个命令行工具，可以让你在命令行中直接操作github的仓库.
那么命令行工具可以提高平常的效率吗? 我的答案是可以,原因如下:

1. 使用习惯: Dev/Test 工作中基本上和Code打交道，现代的IDE都可以terminal(命令行工具),不需要额外的切换浏览器操作github仓库
2. 一个命令实现一个目的: 浏览器操作需要点击几个页面，输入不同的数据进行创建，但是命令行中使用了默认参数，可以一个命令就完成你想要的操作

<!-- more -->

## 0. Github Cli 安装 

安装Github Cli非常方便:

- Mac: 
```sh 
```sh 
# Install: 
brew install github/gh/gh
# Upgrade: 
brew upgrade gh
```
```
- Windows
```sh
scoop bucket add github-gh https://github.com/cli/scoop-gh.git
scoop install gh
```

## 1. Github Cli 功能一览

使用Github Cli之前，先大致了解一下GitHub Cli的功能集合:

```sh 
2020-qa-advance (master●●)$ gh -h                                                               [ruby-2.4.1]
Work seamlessly with GitHub from the command line.

GitHub CLI is in early stages of development, and we'd love to hear your
feedback at <https://forms.gle/umxd3h31c7aMQFKG7>

Usage:
  gh [command]

Available Commands:
  completion  Generate shell completion scripts
  help        Help about any command
  issue       Create and view issues
  pr          Create, view, and checkout pull requests
  repo        Create, clone, fork, and view repositories

Flags:
      --help              Show help for command
  -R, --repo OWNER/REPO   Select another repository using the OWNER/REPO format
      --version           Show gh version

Use "gh [command] --help" for more information about a command.
```
通过帮助可以看到Github Cli功能主要包括:

1. issue: issue相关
2. pr: pull request相关
3. repo: repo相关

## 2. Github Cli Repo相关

使用repo之前先了解一下github cli repo的功能:

```sh
gh repo -h                                                          [ruby-2.4.1]
Work with GitHub repositories.

A repository can be supplied as an argument in any of the following formats:
- "OWNER/REPO"
- by URL, e.g. "https://github.com/OWNER/REPO"

Usage:
  gh repo [command]

Available Commands:
  clone       Clone a repository locally
  create      Create a new repository
  fork        Create a fork of a repository
  view        View a repository in the browser

Global Flags:
      --help              Show help for command
  -R, --repo OWNER/REPO   Select another repository using the OWNER/REPO format

Use "gh repo [command] --help" for more information about a command.
```

### 1.1 Github Cli创建Repo

安装好了Github Cli创建Repo非常方便, 下面是一个例子:

1. 创建目录

```sh
mkdir 2020-qa-adventure
cd 2020-qa-adventure
```

2. 创建Repo

使用以下命令，直接创建一个github仓库
```sh
gh repo create --public
```

这样仓库就创建好了.

### 1.2 Github Cli 创建Issue

1. 创建Github Issue 
```sh
gh issue create 
```
2. 获取Github Issue列表
```sh
gh issue list
```
3. 查看Github Issue 内容
```sh
gh issue view 2
```
4. Open issue in Web

```sh
gh issue view 2 --w 
```
打开issue之后，然后就可以进行处理issue.


## 2. Github Commit Tips：

在commit中输入一些关键字，就可以直对github的issue进行处理，下面结合github cli和github自带的功能快速处理和更新issue状态.

1. 创建Issue
```sh
gh issue create
```
2. 修改代码处理好issue
3. 准备提交代码，但是在代码的Commit中如果加入

```sh
close #3 fix Isseu #3
```

push之后 Issue #3会直接关闭.

## 3. 参考使用

[github-enterprise](https://help.github.com/en/enterprise/2.16/user/github/managing-your-work-on-github/closing-issues-using-keywords)

## 4. 自己学习一个新工具思路

- 了解解决什么问题
- 新工具的功能的大体结构和索引情况
- 动手试试，确定是不是真的实用
- 好的工具大体是思路和结构清楚的，只有思路和结构清楚才能清晰的解决问题；如果解决什么问题都不清楚
  工具也就是玩具
