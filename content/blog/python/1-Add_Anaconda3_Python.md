---
title: Use Anaconda3 Python In Ubuntue Usage 
date: 2019-04-20 23:58:45
tags: ["python"]
---
# Use Anaconda3 Python In Ubuntu

First of all, where is your annaconda3 installed, and where is the system python path?

```sh
# anaconda3 path
~/anaconda3/bin
```

```sh
echo `whereis python`
```

Then Add you anaconda3 to ~/.zshrc or ~/.bashrc PATH

```sh
export ANACONDA_HOME=~/anaconda3
export PATH=$ANACONDA_HOME/bin:$PATH
```
