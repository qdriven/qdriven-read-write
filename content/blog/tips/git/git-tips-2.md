---
title: 修改Git提交人 
date: 2020-08-04 09:17:08
tags: ["daily-tips","git"]
---

## 修改Github仓库的提交人

有时突然发现自己的github仓库使用的名称不对，那么如何把已经提交变更人修改呢？

```sh
git filter-branch -f --env-filter '
OLD_EMAIL="<old@emai.com>"
CORRECT_NAME="<new_user_name>"
CORRECT_EMAIL="<更正的邮箱@qq.com>"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
```

## 查看GITHUB一段时间前的变更

查看10周以前的变更:

```sh
git whatchanged --since='10 weeks ago'
```


## 使用Github Cli 直接创建issue

如果安装好了github cli之后，可以直接在自己的仓库目录下面使用命令行创建issue.

```sh
gh issue create
```

如果没有安装可以使用如下命令安装:

```sh
# For Mac
brew install github/gh/gh
# For Windows
scoop bucket add github-gh https://github.com/cli/scoop-gh.git
scoop install gh
# or
choco install gh
## 
```