---
title: git stash 使用
date: 2020-01-20 09:52:58
tags: [10minutes,git,qa-daily]
---

git-stash 文档的说明有点抽象，下面用一些例子来解释如何使用git-stash。

```sh
git-stash - Stash the changes in a dirty working directory away
```

git-stash 主要使用的场景如下：
1. 本地的工作区已经有了一些提交
2. 你想恢复本地工作区到本地修改前的状态，pull最新的代码到本地
   
这个时候你可以使用git stash来出来，如何处理？
1. 暂存本地修改：
```sh
git stash
```
2. 更新最新代码

```sh
git pull
```
3. 恢复本地修改

```sh
git stash list
git stash apply stash@{0}
# or
git stash pop 
git status
```

4. 如果不在需要本地的修改

```sh
git stash drop
```

总结git stash的常见用法：
1. git stash： 暂存
2. git stash list: 获取所有的暂存
3. git stash pop： 恢复最新的一个暂存
4. git stash apply stash@{index}: 恢复指定的暂存
5. git stash drop： 清除最新的stash
6. git stash clear：清除所有的stash 


