---
layout: post
title: "JMETER NON GUI模式的结果"
tags: [performance,jmeter]
date: 2016-04-05T18:31:42
---

# JMETER NON GUI模式的结果

[reference source](https://www.blazemeter.com/blog/how-to-use-grafana-to-monitor-jmeter-non-gui-results?utm_source=blog&utm_medium=BM_blog&utm_campaign=how-to-use-grafana-to-monitor-jmeter-non-gui-results2)

使用Jmeter的命令行模式运行压力测试，可以减少客户端机器的资源使用从而更轻便的模拟压力。凡事都有好坏，没有了JMETER的GUI，监控压力测试的指标就会显得有些困难。下面介绍几个方法来更好的使用JMETER NON GUI模式进行压力测试。

## 1. 使用```-o```参数输出JMETER测试结果

最简单的办法查看NON GUI的结果就是使用jmeter命令行的```-o```参数，可以输出一份比较漂亮的结果报告，具体使用方法如下：

- 使用如下命令：

```sh
sh bin/jmeter.sh -n -t <jmeter jmx file> -l log.jtl -e -o result
```

使用以下命令，jmeter 运行时的log.jtl文件会被解析输出到result文件夹中，同时生成一份测试的报告，dashboard如下图：

![img](../ref/jmeter_dashboard.jpg)

## 2. 使用grafana和influxdb进行实时监控测试结果

使用grafana和influxdb最为后端的监控，可以实时的掌握测试的过程和结果，下面是关于influxdb和grafana的一个简介:

- [influxdb](https://www.influxdata.com/)是一个时序数据库用来存储测试的时序数据，这里是作为grafana的数据源
- [grafana](http://docs.grafana.org/guides/getting_started/)是一个开源的监控dashboard工具，可以接入不同种类的数据源来实时监控应用的各种不同指标

* 安装grafana和influxdb，可以参考官方文档，如果是MAC的话，直接使用：

```sh
brew update
brew install grafana
brew install influxdb
```

* 启动influxdb和grafana

```sh
influxd # 默认influx db,启动端口为8086，存储位置为：～／.influxdb/data
influx # 启动influx客户端

```            


