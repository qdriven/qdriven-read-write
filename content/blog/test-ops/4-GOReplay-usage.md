---
title: goreplay 流量回放小尝试
date: 2019-10-09 10:06:26
tags: ["test-ops","流量回放"]
---

## Gorelapy简介

goreplay是一款从生产环境copy流量到测试环境的工具，且不会影响生产环境的业务响应，又能很简单的达到复用http请求来做稳定性测试的目的。

GoReplay 工作方式：listener server 捕获流量，并将其发送至 replay server 或者保存至文件。replay server 会将流量转移至配置的地址
![img](https://camo.githubusercontent.com/1c65a684aeb1d16343d59c3ab6d3f9d41c77c36f/68747470733a2f2f692e696d6775722e636f6d2f494e327866446d2e706e67)


最简单的使用模式是：listener server捕获流量，并将其发送至kafka，然后解析kafka的消息并存入mysql,处理起来还是比较方便的.


## 环境准备

- 1、安装kafka
启动zookeeper 和kafka server，并创建一个topic
温馨提示：server.properties中的PLAINTEX后面需要把ip加上，否则其他服务器上的消息接收不到

- 2、安装mysql
创建db和表,用来保存请求数据

## 监听消息发送到kafaka
- 1、在目标服务器上安装gorepay
    * a、源码：https://github.com/buger/goreplay
    * b、二进制包：百度或者找我要吧。如果你的服务器是centos7以上，可以直接解压使用。建议使用这种方式
- 2、监听并往kafka发消息

* 使用HTTP 请求输出到kafka - HTTP原始信息
```sh
sudo ./goreplay --input-raw :8179--output-kafka-host '10.8.1.43:9092' --output-kafka-topic 'test'
```

* 使用HTTP 请求输出到kafka - JSON格式

```sh
sudo ./goreplay --input-raw :8080 --input-raw-track-response --output-kafka-host '10.8.1.43:9092' --output-kafka-topic 'test' --output-kafka-json-format
```

* 查看监听消息
在kafka所在的服务器上启一个consumer，查看这个topic中的消息，可以看到监听端口的流量了
bin/kafka-console-consumer.sh --bootstrap-server 10.8.1.43:9092 --topic test

## 解析kafka的消息并保存到mysql

- 安装依赖库：confluent-kafka、records、PyMySQL
```sh
pip install confluent-kafka
pip install records
pip install PyMySQL
```
- Confluent-kafka是一款高效、稳定的kafka的python客户端
https://github.com/confluentinc/confluent-kafka-python
- records一个非常简单但功能强大的库，用于对大多数关系数据库进行原始SQL查询
- PyMySQL是从Python连接到MySQL数据库服务器的接口
- 编写解析kafka消息的python代码，进行解析并且保存落库

## 常用命令

基本命令：

- 1、获取经过本地8080端口的请求流量，然后打印出来

```sh
sudo ./goreplay --input-raw :8080 --output-stdout
```

- 2、获取经过本地8080端口的请求流量，然后保存在.gor文件中
```sh
sudo ./goreplay --input-raw :8080 --output-file=request.gor
```

- 3、从保存下来的流量文件中提取流量并向某的地址的某个端口输出

```sh
sudo ./goreplay --input-file=request.gor --output-http="http://localhost:8000"
```
- 4、转发
```sh
sudo ./goreplay --input-raw :8080 --output-http="http://localhost:8000"
```

- 5.请求过滤

例如只收集 /api 下的请求
```sh
./gor --input-raw :8080 --output-http staging.com --http-allow-url /api
```
例如只收集请求头中符合 api-version 为 1.0x 的请求

```sh
./gor --input-raw :8080 --output-http staging.com --http-allow-header api-version:^1\.0\d
```
