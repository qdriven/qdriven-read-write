---
layout: posts
title: 测试日志2020-4 Dive Into Markov(阿里妈妈功能测试平台) 
date: 2020-07-30 12:12:00
categories: [java,testing-platform]
tags: [java,testing-platform,worthless]
---

## Dive Into Markov(阿里妈妈功能测试平台) 架构分析

<img src="https://mmbiz.qpic.cn/mmbiz_png/DWQ5ap0dyHMvWOVCYt8M5463BURIjtVD4x8ibtJxYRa0euRLC3ic47oHkRXltOg4SbEtECFwQVoOjlLqIWicpsPwg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1" width="70%" height="70%"></img>

根据Markov本身提供的功能图，以及代码，大致总结Markov如下图:
![img](img/alimama/overview.jpg)
<!-- more -->

从技术角度看了一下这个代码仓库的pom文件,有几个问题可以改善

1. mysql的依赖使用了两个可以去除一个
2. 使用了至少三个以上的json包，不确定是什么原因
3. 使用了.gitignore，为什么还有*.iml和.idea/目录存在
4. 然后pom文件里面为什么有这样的

```xml

	<groupId>com.alibaba</groupId>
	<artifactId>markov-demo</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>markov-demo</name>
	<description>Demo project for Spring Boot</description>
```

artifactId是markov-demo? 认真的？

不过这些都是第一眼的小问题，具体做的东西让老鸟在慢慢看看，具体做的内容才是吸引人的东西.

## 如何使用-搭建环境

在进入代码分析之前，先把环境构建起来，然后跑跑试试看看哪些功能.因为没有具体的使用手册，老鸟就按照经验自己一步一步玩耍.

### 如何使用-搭建环境 - build jar包

```sh
mvn clean package
```
这个时候会出现一下错误：

```sh
Could not find artifact net.sf.json-lib:json-lib:jar:2.4 in central (https://repo.maven.apache.org/maven2) 
```

最后的解决办法是: json-lib依赖添加classifier是jdk15

```xml
		<dependency>
			<groupId>net.sf.json-lib</groupId>
			<artifactId>json-lib</artifactId>
			<version>2.4</version>
			<classifier>jdk15</classifier>
		</dependency>
```

运行*** mvn clean compile *** 通过，然后重新build打出jar包
不过使用maven打包的时候，会出现测试不通过情况：

```sh 
2020-05-15 13:50:04.461  INFO 39887 --- [extShutdownHook] o.s.s.concurrent.ThreadPoolTaskExecutor  : Shutting down ExecutorService 'applicationTaskExecutor'
[INFO] 
[INFO] Results:
[INFO] 
[ERROR] Errors: 
[ERROR]   MarkovDemoApplicationTests.wordTest:51 » FileNotFound dic.txt (No such file or...
[INFO] 
[ERROR] Tests run: 1, Failures: 0, Errors: 1, Skipped: 0

```

测试代码:

由于这个dict.txt没有在classpath下面，所以就找不到了. 所以build的时候ignore tests就可以了

```sh
@Test
	void wordTest () throws IOException {

		// FileInputStream fis = new FileInputStream("199801.txt");
		// FileOutputStream fos = new FileOutputStream("dic.txt");
		// ImportCorpus readF = new ImportCorpus(fis, fos);
		// readF.readDic();
		// System.out.println("µ¼Èë½áÊø");

		String filename = "dic.txt";
		HashMap hm = new HashMap();
		HashMap len = new HashMap();
		GenerateDictionary genDic = new GenerateDictionary();
		Segmentation seg;
    .....
    }
```

```sh
mvn clean package -Dmaven.test.skip=true

```

第一片吐槽先到这里.