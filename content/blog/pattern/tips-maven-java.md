---
layout: posts
title: 测试日志2020-1 MAVEN 创建项目JAVA项目 
date: 2020-07-30 12:12:00
categories: [backend,tips]
tags: [java,tips]
---

## MAVEN 创建项目JAVA项目

MAVEN是开发过程中常用的一个管理软件项目代码的工具，这里开始一个简单系列的介绍，给测试同学介绍MAVEN的使用，
以便更好的了解开发过程，以及版本，文档管理的方式.
<!-- more -->
## 1.1. 什么是MAVEN

在理解MAVEN之前首先先要了解一个JAVA项目有哪些内容组成.
通常我们看到的一个JAVA的后台服务从代码层面上简单理解主要有两类：

1. 自己写的代码
2. 第三方写的代码，在自己项目里面做引用

由于Java历史悠久，因此沉淀和很多第三方的代码，而现实的项目不可能每个项目从头开始
写代码，必然站在巨人的肩膀上来实现自己的项目，那么就一定会去使用第三方的代码.
使用第三方代码越多，管理起来就越麻烦，这种麻烦直接会造成自己项目的编译，打包的麻烦.
这样MAVEN就出现了.

MAVEN就是为了解决项目中出现的这些问题，[MAVEN](https://maven.apache.org/)官方对自己的定位:
```
Apache Maven is a software project management and comprehension tool. Based on the concept of a project object model (POM), Maven can manage a project's build, reporting and documentation 
from a central piece of information.
```

MAVEN的功能：

```
Feature Summary
The following are the key features of Maven in a nutshell:

1. Simple project setup that follows best practices - get a new project or module started in seconds
2. Consistent usage across all projects - means no ramp up time for new developers coming onto a project
3. Superior dependency management including automatic updating, dependency closures (also known as transitive dependencies)
4. Able to easily work with multiple projects at the same time
5. A large and growing repository of libraries and metadata to use out of the box, and arrangements in place with the largest Open Source projects for real-time availability of their latest releases
6. Extensible, with the ability to easily write plugins in Java or scripting languages
7. Instant access to new features with little or no extra configuration
8. Ant tasks for dependency management and deployment outside of Maven
9. Model based builds: Maven is able to build any number of projects into predefined output types such as a JAR, WAR, or distribution based on metadata about the project, without the need to do any scripting in most cases.
10. Coherent site of project information: Using the same metadata as for the build process, Maven is able to generate a web site or PDF including any documentation you care to add, and adds to that standard reports about the state of development of the project. Examples of this information can be seen at the bottom of the left-hand navigation of this site under the "Project Information" and "Project Reports" submenus.
11. Release management and distribution publication: Without much additional configuration, Maven will integrate with your source control system (such as Subversion or Git) and manage the release of a project based on a certain tag. It can also publish this to a distribution location for use by other projects. Maven is able to publish individual outputs such as a JAR, an archive including other dependencies and documentation, or as a source distribution.
12. Dependency management: Maven encourages the use of a central repository of JARs and other dependencies. Maven comes with a mechanism that your project's clients can use to download any JARs required for building your project from a central JAR repository much like Perl's CPAN. This allows users of Maven to reuse JARs across projects and encourages communication between projects to ensure that backward compatibility issues are dealt with.
```

## 1.2. MAVEN的常用方法

1. 创建多个模块的MAVEN项目
2. 如果给JAVA项目打包

## 1.3. 创建多个模块的MAVEN项目

如何创建MAVEN多个模块的项目,大概分成如下几个步骤:
1. 创建MAVEN 父项目
2. 创建MAVEN 子项目(module)

### 1.3.1. 创建MAVEN 父项目

1. 使用IntelliJ IDEA创建MAVEN项目,这个时候能看到项目自动生成了如下的文件:
```
├── README.md
├── multiple-modules.iml
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   └── resources
    └── test
        └── java

```

检查MAVEN的```pom.xml```文件:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>io.qmeta.dirthyhands</groupId>
    <artifactId>multiple-modules</artifactId>
    <version>1.0-SNAPSHOT</version>

</project>
```

可以清楚的看到这个项目的定义(关于POM的定义后续会再做介绍).
项目建立成功了，那么我们先试试打包可不可以.MAVEN如何打包，使用如下命令就可以:

```sh 
mvn clean package
```
命令执行完成后，可以看到一个有趣的内容，就是项目中新生成了一个目录target：

```sh 
└── target
    ├── classes
    ├── maven-archiver
    │   └── pom.properties
    ├── maven-status
    │   └── maven-compiler-plugin
    │       ├── compile
    │       │   └── default-compile
    │       │       └── inputFiles.lst
    │       └── testCompile
    │           └── default-testCompile
    │               └── inputFiles.lst
    └── multiple-modules-1.0-SNAPSHOT.jar

```
那么target目录是用来做什么的呢？这个目录实际上是JAVA编译完成后的文件，同时由于我们做了打包(package),
我们可以看到这个里面有个文件**multiple-modules-1.0-SNAPSHOT.jar**, 这个就是项目打包出来的文件了.

到这里一个最简单的MAVEN项目建立好了.

## 1.4. 创建多个模块的MAVEN项目

现实中一个项目有很多的模块组成，代码也一般按照模块来分开管理，因此我们试试创建多个模块的项目.
1. 在刚才创建的项目中，选中项目，创建模块java11-module
2. 我们通过查看文件来说明项目情况,新增的module和新建项目几乎一样的结构，但是检查POM文件，
文件结构:
```
├── java11-module
│   ├── pom.xml
│   └── src
│       ├── main
│       │   ├── java
│       │   └── resources
│       └── test
│           └── java
├── multiple-modules.iml
├── pom.xml

```
java11-module pom.xml,可以看到这个里面有个parent,这个parent项目就是刚才建立的父项目
```xml 
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>multiple-modules</artifactId>
        <groupId>io.qmeta.dirthyhands</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>java11-module</artifactId>

</project>
```
检查父项目POM文件: 新加了一个module的项，看到这里是不是大家都理解了？
```xml 
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>io.qmeta.dirthyhands</groupId>
    <artifactId>multiple-modules</artifactId>
    <packaging>pom</packaging>
    <version>1.0-SNAPSHOT</version>
    <modules>
        <module>java11-module</module>
    </modules>


</project>
```

那么如何给这个项目打包呢，其实一样:

```
mvn clean package
```

## 1.5. MAVEN 小结

这里简单介绍了MAVEN项目创建的方式,和如何打包使用. 这是最简单的MAVEN的使用，
后续会慢慢加入新的MAVEN使用的高级一点的方法. Stay tuned!

简单的代码后台留言，我会根据留言发送给需要.