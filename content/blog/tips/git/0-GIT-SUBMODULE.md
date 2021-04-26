---
title: Git Sub Module Usage 
date: 2019-04-20 23:58:45
tags: ["GIT"]
---
# Git Sub Module Usage

A Git Repo sometimes has several sub projects which are also a git repo. Let's walk through following scenarios to became a super
git sub module user. The Scenario are:

- Add Git Sub odule into a existing Git Repo
- Git Clone With Sub Modules
- Push To Sub Module's remote repo

##  Add Git Sub Module into a existing Git Repo

It is a quit straight forward. You have already clone one git repo to local, then you want to add a sub module to this repo.
So just using:

```sh
git submodule add https://github.com/allroundtesters/Shell-Steps.git
```
 
```git submodule add <git repo url> <local dir>``` is the command 
to use. Just checkout the folder, everything is there. So easy, no magic. But what is different with ```git clone ```, The different is that ```.gitmodules``` file is added to the existing repo, and there sub module info is in it:

```sh
[submodule "Shell-Steps"]
	path = Shell-Steps
	url = https://github.com/allroundtesters/Shell-Steps.git

```

Obviously, if you add more than one sub module, the sub module info will be appened into the ```.gitmodules``` file to make the parent repo know where the sub modules are.
That's it.

## Git Clone With Sub Modules

Normally you git clone one project, then find out several folders is empty, then you are confused what happened.  Don't worry, use the following command to have a try:

```sh
git pull  --recurse-submodules
# or for git 1.8.2
git submodule update --recursive --remote

```

Then everything is ready. Go to work right now.

## Push To Sub Module's remote repo

There is no difference. Go to the Sub Module Folder. Then use git push or change the working branch. Everything is same as the single git repo. T here are several advaned command for sub modules, your can read [gitbook-submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for more details.




