shell语法精简，只用这些
---------------------
只求熟练使用shell的一个子集
## 文件开头

	#! /bin/sh

## 特殊变量值
	$* $@ $# $[0-9] $? $$ $!

	$@ $* 只在被双引号包起来的时候才会有差异,$*当成一个字段，$@当成多个字段。
	$?    表示上一个命令退出的状态
	$$    表示当前进程编号
	$!    表示最近一个后台命令的进程编号
	
## 命令
shell的使用，侧重在命令的调用、组合，其中最好不要有处理逻辑，有了估计也不会或不熟。

命令都有退出码，就是c main 最后的`return 0;`了，用$?取上一个，可以调用`exit n`指定退出码，如果不指定n，或者没有调用exit，就以退出前的最后一个命令的退出码作为总的退出码。

一般命令：`cmd [options] objects	`,用回车或“;”分隔

有复合命令：if,case,for in,while,until

	if 条件测试语句
	then
		action
	[elif 条件
		action
	else
		action
	]
	fi

	for 变量 in seq字符串
	do
		action
	done

	while 条件语句
	do
		action
	done

	case $arg in  
	    pattern | sample) # arg in pattern or sample  
	    ;;  
	    pattern1) # arg in pattern1  
	    ;;  
	    *) #default  
	    ;;  
	esac 

## 基本语法
	
	#注释
	'$ 是个普通字符串'
	"$var 取出var变量中的数据"
	var='赋值'
	echo $var					#一般取值
	echo $((...))				#执行算数命令
	$(cmd)和`cmd`				#捕捉cmd的stdout
	{ cmd;cmd;}和(cmd;cmd)		#命令组，后一个会新开shell的
### 命令别名
	alias ll='ls -alF'
### 字符取值的特别用法
	${var}
	${var:="变量var不存在时赋值并提示"}
	${var:+"变量var存在时提示"}
	${var:-"变量var不存在提示"}
	${var:?"变量var不存在提示，输出到stderr中"}
	${这个的用法很多呀}

## shell 条件判断 
判断命令 test 和 [  ]。另外还有[[  ]]
### 1、字符串判断
	str1 = str2　　　　　　当两个串有相同内容、长度时为真
	str1 != str2　　　　　 当串str1和str2不等时为真
	-n str1　　　　　　　 当串的长度大于0时为真(串非空)
	-z str1　　　　　　　 当串的长度为0时为真(空串)
	str1　　　　　　　　   当串str1为非空时为真
### 2、数字的判断
	int1 -eq int2　　　　两数相等为真
	int1 -ne int2　　　　两数不等为真
	int1 -gt int2　　　　int1大于int2为真
	int1 -ge int2　　　　int1大于等于int2为真
	int1 -lt int2　　　　int1小于int2为真
	int1 -le int2　　　　int1小于等于int2为真
### 3、文件的判断
	-r file　　　　　用户可读为真
	-w file　　　　　用户可写为真
	-x file　　　　　用户可执行为真
	-f file　　　　　文件为正规文件为真
	-d file　　　　　文件为目录为真
	-c file　　　　　文件为字符特殊文件为真
	-b file　　　　　文件为块特殊文件为真
	-s file　　　　　文件大小非0时为真
	-t file　　　　　当文件描述符(默认为1)指定的设备为终端时为真
	-e file			如果文件存在为真
### 4、与或非
bash环境中，在[[]]中会出错，在[]中就对的。

	-a 　 　　　　　 与
	-o　　　　　　　 或
	!　　　　　　　　非


## 关于字符串

要写个几行的字符串，其中还有转义元素
<<END
steing '${val}'
safdas
END

要是在END前后加上'，就不转义了。奇技淫巧。


尴尬的是这种字符串，他妈的echo之类的函数用不了。

### shell里也不都是简单的字符串替换

```
a="te st"
b='"te st"'
c=$b
echo $c
```
这里的c的值是"test"，不是test。

shell 的一些用法
---------------
下面的说明没考虑不同bash的差异，主要适用于bash，
脚本开头`#! /bin/bash`。

### shell参数约定
shell命令的参数分选项options和命令操作对象objects。
个人约定选项的格式：

	短选项（单字母选项）。
	"-"开头，可以多个连写在一起，如：-a -ab
	选项如果是有值的话，值紧跟在其后面，用空格分开，如-v value -abv value

	长选项（单词选项）
	格式“--key”或者“--key=value”

	key中不含“=”，不一“-”开头

### shell输入输出
一般就是标准输出，标准输入。可以使用重定向“<>”和管道“|”。
常见用法 `> /dev/null 2>&1`,`cat words|wc -lwmc`

### shell中的括号用法
以$开头的都有字符串替换的作用

- ${var} 一般取变量值是$var，但当变量值加载字符中是需要设定边界，例如：echo ${var}xxx
- $(cmd) 和`cmd`有相同之处，shell执行cmd，用标准输出代替$(cmd)
- ()和{} ()和{}都是对一串的命令进行执行，但有所区别：
	1. ()只是对一串命令重新开一个子shell进行执行
	2. {}对一串命令在当前shell执行
	3. ()和{}都是把一串的命令放在括号里面，并且命令之间用;号隔开
	4. ()最后一个命令可以不用分号
	5. {}最后一个命令要用分号
	6. {}的第一个命令和左括号之间必须要有一个空白
	7. ()里的各命令不必和括号有空格
	8. ()和{}中括号里面的某个命令的重定向只影响该命令，但括号外的重定向则影响到括号里的所有命令
- ${var:-string},${var:+string},${var:=string},${var:?string}
	1. ${var:-string}和${var:=string}。若变量var为空，则用在命令行中用string来替换${var:-string}，否则变量var不为空时，则用变量var的值来替换${var:-string}；对于${var:=string}的替换规则和${var:-string}是一样的，所不同之处是${var:=string}若var为空时，用string替换${var:=string}的同时，把string赋给变量var
	2. ${var:+string}的替换规则和上面的相反，即只有当var不是空的时候才替换成string，若var为空时则不替换或者说是替换成变量 var的值，即空值。(因为变量var此时为空，所以这两种说法是等价的)。
	3. ${var:?string}替换规则为：若变量var不为空，则用变量var的值来替换${var:?string}；若变量var为空，则把string输出到标准错误中，并从脚本中退出。我们可利用此特性来检查是否设置了变量的值。
- $((exp)) POSIX标准的扩展计算:$((exp))  

	这种计算是符合C语言的运算符，也就是说只要符合C的运算符都可用在$((exp))，甚至是三目运算符。  
	注意：这种扩展计算是整数型的计算，不支持浮点型.若是逻辑判断，表达式exp为真则为1,假则为0。  
	`echo $((var++))`
- $(var%pattern),$(var%%pattern),$(var#pattern),$(var##pattern)

	这四种结构的意义是：${var%pattern}和${var%%pattern}表示从最右边(即结尾)匹配的，${var#pattern}和${var##pattern}从最左边(即开头)匹配的。其中${var%pattern}和${var#pattern}是最短匹配，${var%%pattern}和${var##pattern}是最长匹配。只有在pattern中使用了通配符才能有最长最短的匹配，否则没有最长最短匹配之分。   
	结构中的pattern支持通配符，*表示零个或多个任意字符，?表示零个或一个任意字符，[...]表示匹配中括号里面的字符，[!...]表示不匹配中括号里面的字符。
- {start..end..step},和seq有些像

		for i in a{1..5..2}; do echo $i; done
		>>> a1 a3 a5
- ${!var}

		var=xxxx
		a=var
		echo ${!a}
		>>>xxxx
- [ condition ] 和[[ condition ]],前一个等同test condition,后一个是真正的条件判断，两种有所不同，字符串当成数字使用是，要是不是合法格式，前一个报错，后一个转成0。

### shell 条件判断
#### 1、字符串判断
	str1 = str2　　　　　　当两个串有相同内容、长度时为真
	str1 != str2　　　　　 当串str1和str2不等时为真
	-n str1　　　　　　　 当串的长度大于0时为真(串非空)
	-z str1　　　　　　　 当串的长度为0时为真(空串)
	str1　　　　　　　　   当串str1为非空时为真
#### 2、数字的判断
	int1 -eq int2　　　　两数相等为真
	int1 -ne int2　　　　两数不等为真
	int1 -gt int2　　　　int1大于int2为真
	int1 -ge int2　　　　int1大于等于int2为真
	int1 -lt int2　　　　int1小于int2为真
	int1 -le int2　　　　int1小于等于int2为真
#### 3、文件的判断
	-r file　　　　　用户可读为真
	-w file　　　　　用户可写为真
	-x file　　　　　用户可执行为真
	-f file　　　　　文件为正规文件为真
	-d file　　　　　文件为目录为真
	-c file　　　　　文件为字符特殊文件为真
	-b file　　　　　文件为块特殊文件为真
	-s file　　　　　文件大小非0时为真
	-t file　　　　　当文件描述符(默认为1)指定的设备为终端时为真
#### 4、与或非
	-a 　 　　　　　 与
	-o　　　　　　　 或
	!　　　　　　　　非


VPS centos 128M 单核
--------------------
买了个小vps，用来学习使用，ip[192.157.212.242]，美国的，延时极为严重

### 查看cpu
	cat /proc/cpuinfo  
	grep "CPU" /proc/cpuinfo | cut -d: -f2
### 查看内存
	grep MemTotal /proc/meminfo | cut -f2 -d:
### 查看cpu是32位还是64位
	getconf LONG_BIT
### 查看当前linux的版本
	cat /etc/redhat-release
### 查看内核版本
	uname -r
	uname -a
### 查看当前时间
	date
### 查看硬盘和分区
	df -h
	du -sh
### 查看安装的软件包
	rpm -qa
### 查看网关  
	cat /etc/sysconfig/network 
### 查看dns  
	cat /etc/resolv.conf 
### 查看默认语言
	echo $LANG
	cat /etc/sysconfig/i18n
### 查看所属时区和是否使用UTC时间
	date -R
### 查看ip、主机名
	hostname
	hostname -i
### 查看开机运行时间
	uptime