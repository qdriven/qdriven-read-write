## HBASE Installation

- Local Installation
- Pseudo-Distributed Local Install
- Distribution Install

-----

### HBase Installation-Local Installation

- download hbase, and put into server
- without HDFS(ignore HDFS first)
- config hbase-site.xml (/conf)
- run start hbase

```sh
sh bin/start-hbase.sh 
```
- stop hbase

```sh
sh bin/stop-hbase.sh
```
---- 

Local HBase Configuration: 

```xml
<configuration>
<property>
    <name>hbase.rootdir</name>
    <value>file:///www/hbase</value>
</property>
<property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>file:///www/hbase/zookeeper</value>
</property>
</configuration>

```

----

### HBase Basic Commands Journey

- hbase shell

```sh
./bin/hbase shell
```

- Create Table
```sh
create 'test_table','test_cf'
```

- List Table information

```sh
list 'test_table'
```

- Describe Table information

```sh
describe 'test_table'
```

-----

### HBase Basic Data Manipulation

- put data

```sh
put 'test_table','rowkey_1','test_cf:key1','value1'
put 'test_table','rowkey_1','test_cf:key1','value2'

```

- scan data

```sh
scan 'test_table'
```
----
- get data
```sh
get 'test_table','rowkey_1'
```
- disable table
```sh
disable 'test_table'
```
- drop table
```sh
drop 'test_table'
```
-----

## HBase Pseudo-Distributed Local Install

- Pseudo-Distributed Mode
  * HMaster
  * HRegionServer
  * Zookeeper
  running in separate process
- But hadoop and hdfs is needed

-----

### HBase Pseudo-Distibuted Local Install -HADOOP

- hdfs-site.xml (etc/hadoop/)

```xml
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
       <property>
        <name>dfs.namenode.name.dir</name>
        <value>/www/local/hadoop/tmp/dfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/www/local/hadoop/tmp/dfs/data</value>
    </property>
    <property>
        <name>dfs.permissions</name>
        <value>false</value>
    </property>
</configuration>
```
----

- core-site.xml (etc/hadoop)

```xml

<configuration>
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://bigdatafat027117.ppdgdslfat.com:9000</value>
</property>
 <property>
        <name>hadoop.tmp.dir</name>
        <value>/www/local/hadoop/tmp</value>
    </property>
</configuration>
                  
```
- /etc/hosts

```
10.114.27.117 bigdatafat027117.ppdgdslfat.com
```
----

- start HADOOP - set up env

set env in ~/.bashrc or hadoop-env.sh

```sh
export PATH=$PATH:/www/hadoop-2.7.7/bin
export HADOOP_HOME=/www/hadoop-2.7.7
export HBASE_HOME=/www/hbase-2.1.0
export PATH=$PATH:$HBASE_HOME/bin
export JAVA_HOME=/usr/local/jdk1.8.0_74
```

```sh
source `/.bashrc
```

- start HADOOP - Format NameNode

```sh
hdfs namenode -format
```

- start HADOOP- Start 

```sh
# don't start yarn
./sbin/start-dfs.sh # (don't use start-all)
```
----

### Start HBase Pseudo-Distibuted

- hbase-site.xml

```xml

<configuration>
<property>
    <name>hbase.rootdir</name>
    <value>hdfs://bigdatafat027117.ppdgdslfat.com:9000/hbase</value>
</property>
   <property>
        <name>hbase.cluster.distributed</name>
        <value>true</value>
    </property>
</configuration>
```

- make sure JAVA_HOME is set in hbase-config.sh

```sh
export JAVA_HOME='/usr/local/jdk1.8.0_74'
```

---

- run HBase

```sh
./bin/start-hbase.sh
```

- Checkout java process

```sh

[root@bigdatafat027117 hbase-2.1.0] jps
11777 Jps
10387 HRegionServer
903 NameNode
1003 DataNode
10267 HMaster
1213 SecondaryNameNode
20510 Bootstrap
10206 HQuorumPeer
```
- enter hbase shell same as local mode

