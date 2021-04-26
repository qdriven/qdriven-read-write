---
title: 命令行艺术-测试人员版本
date: 2020-05-12 08:29:57
tags: [qa-daily, shell]
---

```
QA-Daily将每日不定期推送一些测试相关的github仓库,翻译/英文原文文章,好用的教程给测试/开发人员发现有用的测试工具,了解测试最新动态,扩大自己的技术视野,从开源项目中获取知识,提高自身能力,提高自己的Coding技能,提高自己的工资,也能让测试人员职业上又了解更多的选择!信息不是太少,是太多了,希望QA-Daily能在筛选信息方面帮到想要了解测试/质量相关的工程师.
```

GITHUB 上面又一个很好的仓库**命令行的艺术**,一页纸的篇幅介绍了常用的 shell 命令, 这个项目有 82.5K star，相当火爆的一个项目. QA-DAILY 再给你做一些精简方便测试人员快速了解 shell 以及测试中常用的命令行.

命令行的艺术原始出处:

- https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md

这遍文章包含不少有用的信息,同时也提供给很多工具,我先把一些工具列出来:

- [Explainshell](http://explainshell.com/) 去获取相关命令、参数、管道等内容的解释
- [awesome-shell](https://github.com/alebcay/awesome-shell)：一份精心组织的命令行工具及资源的列表。
- [awesome-osx-command-line](https://github.com/herrbischoff/awesome-osx-command-line)：一份针对 OS X 命令行的更深入的指南。
- [Strict mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)：为了编写更好的脚本文件。
- [shellcheck](https://github.com/koalaman/shellcheck)：一个静态 shell 脚本分析工具，本质上是 bash／sh／zsh 的 lint。
- [Filenames and Pathnames in Shell](http://www.dwheeler.com/essays/filenames-in-shell.html)：有关如何在 shell 脚本里正确处理文件名的细枝末节。
- [Data Science at the Command Line](http://datascienceatthecommandline.com/#tools)：用于数据科学的一些命令和工具，摘自同名书籍。

## 命令行基础

- 学习 Bash 的基础知识。具体地，在命令行中输入 `man bash` 并至少全文浏览一遍; 它理解起来很简单并且不冗长。其他的 shell 可能很好用，但 Bash 的功能已经足够强大并且到几乎总是可用的（ 如果你*只*学习 zsh，fish 或其他的 shell 的话，在你自己的设备上会显得很方便，但过度依赖这些功能会给您带来不便，例如当你需要在服务器上工作时）。

- 熟悉至少一个基于文本的编辑器。通常而言 Vim （`vi`） 会是你最好的选择，毕竟在终端中编辑文本时 Vim 是最好用的工具（甚至大部分情况下 Vim 要比 Emacs、大型 IDE 或是炫酷的编辑器更好用）。

- 学会如何使用 `man` 命令去阅读文档。学会使用 `apropos` 去查找文档。知道有些命令并不对应可执行文件，而是在 Bash 内置好的，此时可以使用 `help` 和 `help -d` 命令获取帮助信息。你可以用 `type 命令` 来判断这个命令到底是可执行文件、shell 内置命令还是别名。

- 学会使用 `>` 和 `<` 来重定向输出和输入，学会使用 `|` 来重定向管道。明白 `>` 会覆盖了输出文件而 `>>` 是在文件末添加。了解标准输出 stdout 和标准错误 stderr。

- 学会使用通配符 `*` （或许再算上 `?` 和 `[`...`]`） 和引用以及引用中 `'` 和 `"` 的区别（后文中有一些具体的例子）。

- 熟悉 Bash 中的任务管理工具：`&`，**ctrl-z**，**ctrl-c**，`jobs`，`fg`，`bg`，`kill` 等。

- 学会使用 `ssh` 进行远程命令行登录，最好知道如何使用 `ssh-agent`，`ssh-add` 等命令来实现基础的无密码认证登录。

- 学会基本的文件管理工具：`ls` 和 `ls -l` （了解 `ls -l` 中每一列代表的意义），`less`，`head`，`tail` 和 `tail -f` （甚至 `less +F`），`ln` 和 `ln -s` （了解硬链接与软链接的区别），`chown`，`chmod`，`du` （硬盘使用情况概述：`du -hs *`）。 关于文件系统的管理，学习 `df`，`mount`，`fdisk`，`mkfs`，`lsblk`。知道 inode 是什么（与 `ls -i` 和 `df -i` 等命令相关）。

- 学习基本的网络管理工具：`ip` 或 `ifconfig`，`dig`。

- 学习并使用一种版本控制管理系统，例如 `git`。

- 熟悉正则表达式，学会使用 `grep`／`egrep`，它们的参数中 `-i`，`-o`，`-v`，`-A`，`-B` 和 `-C` 这些是很常用并值得认真学习的。

- 学会使用 `apt-get`，`yum`，`dnf` 或 `pacman` （具体使用哪个取决于你使用的 Linux 发行版）来查找和安装软件包。并确保你的环境中有 `pip` 来安装基于 Python 的命令行工具 （接下来提到的部分程序使用 `pip` 来安装会很方便）。

相关的内容还有很多,访问这个仓库能够帮助你了解更多.
最后附上该项目地址: https://github.com/jlevy/the-art-of-command-line
