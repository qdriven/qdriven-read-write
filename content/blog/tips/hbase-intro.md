---
title: HBase 介绍
date: 2018-11-21 23:11:47
tags: [bigdata,hbase]
---

## What is HBASE

- NoSQL: Not Only SQL
- Column-Oriented Database
- Based on Google BigTable
- HDFS as Storage
- TB/PB data and Random Access
- 解决10条记录和1000千万记录同样的读写性能问题



## RDBMS 问题

![img](/images/db-e.jpg)

## HBASE VS MYSQL

![img](/images/habseVSmysql.jpg)

## Google Big Table
```
A Bigtable is a sparse, distributed, persistent multidimensional sorted map.
The map is indexed by a row key, column key, and a timestamp; each value in the map is an uninterpreted array of bytes.
```

- map: bigtable 的核心就是一个Map，key-value
- persistent： 持久化和其他没有任何区别
- distributed： 分布式文件系统(HDFS/S3/GFS)/多副本(replication)
- sorted: key是排序的
- multidimensional： 和columns有对应关系, 第一层key-value,可以认为是个row, A,B 可以认为是Column Families
```json
{
  "1" : {
    "A" : "x",
    "B" : "z"
  },
  "aaaaa" : {
    "A" : "y",
    "B" : "w"
  }
  }
```
- sparse: 稀疏，字段不固定,null值不占空间

## Tables,Rows,Columns and Cells

![img](/images/table_row_col.jpg)

## Region

map: key-value, 根据key可以直接找到对应值,o(1),但是内存不可能无限大,怎么办?
![img](/images/regions.jpg)

## Region Server

![img](/images/regserver.jpg)

## Region,Region Server

- Region 根据不同表来切分
- Region 放到不同的Region Server

## HBASE Column Family
![img](/images/Hbase_CF.jpg)

## HBASE column family 
- 每个column family 存成不同的文件
- 缓存/压缩/version
  ![img](/images/reg_hfile.jpg)

## HBASE架构-1

存储基于Haddop/HDFS:
![img](/images/hbase-1.jpg)

## HBASE架构-2
Region Server/Region：
![img](/images/hbase-2.jpg)

## HBASE架构-3
![img](/images/hbase-3.jpg)

## HBASE架构-4
- zookeeper: 管理节点信息,hbase:meta信息
![img](/images/HBASE-4.jpg)

## HBASE架构-5
- HMASTER： 管理RegionServer节点，所有metadata变化的接口
![img](/images/HBASE-5.jpg)

## HBASE架构-6
客户端访问：
![img](/images/hbase-7.jpg)

## HBASE架构-7

Region Sever 内部结构：
![img](/images/hbase-10.jpg)

Regions:
```
Table                    (HBase table)
    Region               (Regions for the table)
        Store            (Store per ColumnFamily for each Region for the table)
            MemStore     (MemStore for each Store for each Region for the table)
            StoreFile/HFILE    (StoreFiles for each Store for each Region for the table)
                Block    (Blocks within a StoreFile within a Store for each Region for the table)
```

## HBASE架构-8

HBASE是CP系统，WAL(Write Ahead Log)
![img](/images/hbase-11.jpg)
![img](/images/hbase_wp.jpg)


## HBASE

- table,rowkey,column family
- Region/Region Server
- Store/MemStore/StoreFile/HFILE/WAL
- Zookeeper/HMaster

![img](https://mapr.com/blog/in-depth-look-hbase-architecture/assets/blogimages/HBaseArchitecture-Blog-Fig3.png)

## HBase CLI

Use Hbase in CLI and JAVA to learning the basic usage of hbase:

- Use Hbase in a Local Mode
- Use Hbase in JAVA 

## HBase Local Mode

使用Hbase的本地模式相当简单，启动hbase就可以,不需要太多额外配置。

- 启动hbase
```sh
cd ${HBASE_HOME}/bin
sh start-hbase.sh
```
- 使用hbase shell 访问
  
```sh
./hbase shell
HBase Shell
Use "help" to get list of supported commands.
Use "exit" to quit this interactive shell.
For Reference, please visit: http://hbase.apache.org/2.0/book.html#shell
Version 2.1.1, rb60a92d6864ef27295027f5961cb46f9162d7637, Fri Oct 26 19:27:03 PDT 2018
Took 0.0336 seconds
Ignoring executable-hooks-1.3.2 because its extensions are not built. Try: gem pristine executable-hooks --version 1.3.2
Ignoring gem-wrappers-1.3.2 because its extensions are not built. Try: gem pristine gem-wrappers --version 1.3.2
2.4.1 :001 >
```

## HBase Basic Commands

- create table with column family
  
```sh
  create 'test_table','cf1'
```

- put data: 插入数据： put <table>,<row_key>,<cf:property>,<value>
```sh
put 'test_table','row_key_1','cf1:k1','k1:v1'
```
同一个column family,不同数据，然后scan结果, scan的结果是cell-oriented

```sh
 => ["test_table"]
2.4.1 :004 > put 'test_table','row_key_1','cf1:k1','k1:v1'
Took 0.2186 seconds
2.4.1 :005 > put 'test_table','row_key_1','cf1:k2','k2:v2'
Took 0.0094 seconds
2.4.1 :006 > put 'test_table','row_key_1','cf1:k3','k3:v3'
Took 0.0032 seconds
2.4.1 :007 > scan 'test_table'
ROW                        COLUMN+CELL
 row_key_1                 column=cf1:k1, timestamp=1545926595556, value=k1:v1
 row_key_1                 column=cf1:k2, timestamp=1545926683964, value=k2:v2
 row_key_1                 column=cf1:k3, timestamp=1545926692956, value=k3:v3
```

- get data

```sh
2.4.1 :008 > get 'test_table','row_key_1'
COLUMN                     CELL
 cf1:k1                    timestamp=1545926595556, value=k1:v1
 cf1:k2                    timestamp=1545926683964, value=k2:v2
 cf1:k3                    timestamp=1545926692956, value=k3:v3
```

以上实际上就是HBASE的最常用的使用方法: put/get(write/read)









