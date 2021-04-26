---
title: Git Upstream/Patch Tips
date: 2020-08-04 09:17:08
tags: ["daily-tips","git"]
---

## Fork的Github仓库如何同步更新

1. 添加原始的GITHUB仓库到upstream
```sh
# 查看所有的远程项目
git remote -v
# 添加原始仓库成为upstream
git remote add upstream https://github.com/otheruser/repo.git
# 获取最新远程仓库的更新
git fetch upstream
git checkout master
git merge upstream
```

运行以上的命令就可以把fork的github仓库更新到最新的代码了

## git如何将修改的path文件提交到本地仓库

如果开发给你一个代码的diff文件，只需要运行：
```sh
git apply **.diff
```
就可以将修改的文件提交到git仓库了
