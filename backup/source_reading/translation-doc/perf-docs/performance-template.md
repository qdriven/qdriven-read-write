# Performance Template

## What to Test: 测试对象和测试环境
- Target API
- Environment

## How to Test: 如何测试，测试场景
- API, ratio
- Threads: 多少个线程
- Time Period： 持续时间

## 数据收集

- 90s
- 95s
- Average RT
- Median RT
- TPS

|Threads Num|TPS|Average RT|Median RT|90 RT|95 RT|error rate(%)|
|---|----|----|----|-----|-----|----|
|1|12|241|250|708|860|5%|

线程数目：
1，5，24，48,72
TCP copy-> replay traffic

- CPU MEM graphic
- CPU Load/Utilization
- Java Memory Usage

## JAVA Memory

- Heap + Non-Heap
- Heap = Eden + S0 + S1 + Old Generation
  * -Xms 1/64 of physics memory, -Xmx 1/4 physics memory
  * -Xms = -Xmx
- Heap Memory
  |Young Generation|Eden|Survivor Space|Old Generation|
  |----------------|----|-------------|--------------|
  |Eden+S0+S1|new objects|S0 and S1, 回收后存活的对象|长生命周期的对象|
- Non-Heap Memory
  |Permanent Generation|Code Cache|
  |--------------------|----------|
  |虚拟机自己的静态数据(reflective),class 级别的静态对象，permanent generation 不足会full GC|编译和保存本地代码(native code),JVM 内部优化处理|

## JAVA 对象内存申请
- JVM 在eden中申请初始化一块内存区域
- eden 可以分配，如果不能分配，则进行下一步
- JVM 释放Eden 所有的不活跃对象(Minor GC),如果Eden空间还是不足，就将Eden活跃对象放倒Survivor 区
- Survivor区用来进行eden和old的交换区域，对象在S0和S1中来回拷贝，对于1.7版本，拷贝16次后，OLD区空间足够，Survivor区对象就会
  进入old区
- 当old 区空间不够时，就进行major collection
- 如果Eden复制过来的部分对象然后无法存放，那就会OOM错误

## JVM GC

- CMS 收集器:
  * Concurrent Mark Sweep, 初始标记、并发标记、重新标记、并发清除和并发重置
  * 并发标记、并发清除和并发重置是可以和用户线程一起执行的,初始标记、并发标记和重新标记都是为了标记出需要回收的对象
  * CMS在Init-mark和Remark时，会stop the world来进行CMS GC

  触发JVM进行Full GC的情况
  从年轻代空间（包括 Eden 和 Survivor 区域）回收内存被称为 Minor GC，对年老代GC称为Major GC,而Full GC是对整个堆来说的，在最近几个版本的JDK里默认包括了对永生带即方法区的回收（JDK8中无永生带了），出现Full GC的时候经常伴随至少一次的Minor GC,但非绝对的。
  引起Full GC的场景
  1、当新生代对象转入老生代时，老生代出现空间不足的情况，会引起Full GC
  2、当新生代创建大对象、大数组时，新生代放不下，老生代也放不下，会引起Full GC
  3、Permanet Generation中存放一些class的信息、常量、静态变量等数据，当系统中要加载的类、反射的类和调用的方法较多时，Permanet Generation可能会被占满，在未配置为采用CMS GC的情况下也会执行Full GC
  4、当创建需要大量连续内存空间的java对象，例如很长的数组，此种对象会直接进入年老代，而年老代虽然有很大的剩余空间，但是无法找到足够大的连续空间来分配给当前对象，此种情况就会触发JVM进行Full GC。

## JVM toolkit

- jstat -gc PID
  S0C: Current survivor space 0 capacity (kB)./新生代中Survivor space中S0当前容量的大小（KB）
  S1C: Current survivor space 1 capacity (kB)./新生代中Survivor space中S1当前容量的大小（KB）
  S0U: Survivor space 0 utilization (kB)./新生代中Survivor space中S0容量使用的大小（KB）
  S1U: Survivor space 1 utilization (kB)./新生代中Survivor space中S1容量使用的大小（KB）
  EC: Current eden space capacity (kB)./Eden space当前容量的大小（KB）
  EU: Eden space utilization (kB)./Eden space容量使用的大小（KB）
  OC: Current old space capacity (kB)./Old space当前容量的大小（KB）
  OU: Old space utilization (kB)./Old space使用容量的大小（KB)
  MC: Metaspace capacity (kB)./Metaspace当前容量的大小（KB）（JVM1.8版本中用Metaspace替换了JVM1.7中的Perm区 )
  MU: Metacspace utilization (kB)./Metaspace容量使用的大小（KB）
  CCSC: Compressed class space capacity (kB)./压缩类容量大小
  CCSU: Compressed class space used (kB)./压缩类使用的大小
  YGC: Number of young generation garbage collection events./从应用程序启动到采样时发生 Young GC 的次数
  YGCT: Young generation garbage collection time./从应用程序启动到采样时 Young GC 所用的时间(秒)
  FGC: Number of full GC events./从应用程序启动到采样时发生 Full GC 的次数（CMS的stop the world次数也会计入，所以该字段的值并非准确的FGC次数）
  FGCT: Full garbage collection time./从应用程序启动到采样时 Full GC 所用的时间(秒)
  GCT: Total garbage collection time./从应用程序启动到采样时用于垃圾回收的总时间(单位秒)，它的值等于YGC+FGC

## TCP/IP

- build connection
（1）第一次握手：建立连接时，客户端A发送SYN包（SYN=j）到服务器B，并进入SYN_SEND状态，等待服务器B确认。
（2）第二次握手：服务器B收到SYN包，必须确认客户A的SYN（ACK=j+1），同时自己也发送一个SYN包（SYN=k），即SYN+ACK包，此时服务器B进入SYN_RECV状态。
（3）第三次握手：客户端A收到服务器B的SYN＋ACK包，向服务器B发送确认包ACK（ACK=k+1），此包发送完毕，客户端A和服务器B进入ESTABLISHED状态，完成三次握手。
完成三次握手，客户端与服务器开始传送数据。
确认号：其数值等于发送方的发送序号 +1(即接收方期望接收的下一个序列号)。

- close connection
由于TCP连接是全双工的，因此每个方向都必须单独进行关闭。TCP连接的拆除需要发送四个包，因此称为四次挥手(four-way handshake)。客户端或服务器均可主动发起挥手动作，在socket编程中，任何一方执行close()操作即可产生挥手操作。 TCP采用四次挥手关闭连接如下图所示：

（1）客户端A发送一个FIN，用来关闭客户A到服务器B的数据传送。
（2）服务器B收到这个FIN，它发回一个ACK，确认序号为收到的序号加1。和SYN一样，一个FIN将占用一个序号。
（3）服务器B关闭与客户端A的连接，发送一个FIN给客户端A。
（4）客户端A发回ACK报文确认，并将确认序号设置为收到序号加1。
完成四次挥手，客户端与服务器断开连接，停止传送数据。

## Performance Testing

测试执行监控阶段:

```
  1、选择合适的Client(Jmeter),client与Server是否在同一个网段内，考虑网络开销                                                               2、Jmeter本身就是Java程序，考虑GC，尽量不开启查看结果树;                                                                                                3、线程组的迭代是根据测试情况确定的，不是随意写的；             
  4、不同的服务，关注的指标不一样，比如支付服务，可能要求考虑95%的用户体验，别的服务可能只要求考虑90%的用户体验。         
  5、不同的测试对象监控的关注点不同，具体情况具体对待（内存、CPU、磁盘IO、网络）
  6、命令行执行脚本，节省资源，实现监控，收集数据
```

```
设计用例始终保持一个宗旨：最大限度的模拟用户行为，模拟真实场景，设计出有效全面的用例；
我们一般回放线上log,加工处理，得到需要的数据源，然后设计用例
```
