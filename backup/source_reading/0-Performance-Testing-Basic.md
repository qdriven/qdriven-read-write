# Performance Testing

- 性能测试目的
- 性能测试原理
- 性能测试方法
- 性能测试Metrics
- Tunning

## 性能测试目的
## 性能测试原理
## 性能测试方法
## 性能测试Metrics
    * Disk IO
    * Memeory Usage
    * CPU
    * Database
    * Network
    * Racing condition/Lock
    * TPS/Latency
    并发度 = 吞吐量 * 延迟
![img](../assets/performance-testing/performance_metrics.png)


## Tunning
* 80/20 原则，找出瓶颈位置
* Amdahl

## Performance Tuning Pattern

* Design Pattern
* Buffer
* Cache
* Pooling
* Parell
* protocol adapter

## Singleton in Performance

- Reduce Objects

## Proxy/FlyIn in Performance

- ASM Proxy/JDK Proxy/CGLib/JAVA Assist
- InvocationHandler

## 并行化：多进程/多线程

线程池最佳线程数目 =（线程等待时间与线程CPU时间之比 + 1）* CPU数目

## Tunning Code

- String handler: charAt && indexOf
- For example: ArrayList/LinkedList,add/remove
- HashMap/HashSet
- NIO
- Pub/Sub
- Future
- Master-Worker
- Immutable
- CopyOnWriteArryList/CopyOnWriteSet/ConcurrentHashMap/ConcurrentLinkedQueue/BlockingQueue

- Lock

```
读写锁分离，ReadWriteLock
无锁化，ThreadLocal、CopyOnWriteArrayList（读）、ConcurrentLinkedQueue
减少锁粒度，ConcurrentHashMap分离锁
减少锁持有时间，最小化同步代码块
乐观CAS锁，AtomicInteger、AtomicLong、AtomicReference
自旋锁，JVM层面锁优化，-XX:+UseSpinning开启自旋锁
自旋锁使得在线程没有获得锁情况下不被挂起而是转去执行空循环 
线程挂起、恢复开销很大
适用于访问共享资源时间较短情况
锁消除，JVM层面锁优化，-server –XX:+DoEscapeAnalysis –XX:+EliminateLocks开启
偏向锁，JVM层面锁优化，-XX:+UseBiasedLocking
```

## JVM Tuning
![img](../assets/performance-testing/jvm_mem.png)

options for JVM:

```
堆内存：-Xmx、-Xms
新生代：-Xmn，一般设置为整个堆空间的1/4到1/3
Hot   Spot虚拟机中-XX:NewSize、-XX:MaxNewSize
持久代：-XX:PermSize、-XX:MaxPermSize
线程栈：-Xss
堆比例参数
-XX:SurvivorRatio = eden / s0 = eden / s1
-XX:NewRatio = 老年代 / 新生代
```

## GC algorithm

- Mark-Sweep: 内存不连续
- Copy
- Mark-Compact

options:

```
堆Dump：-XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/heapdump
获取GC信息：-verbose:gc或-XX:+PrintGC或-XX:+PrintGCDetails，-XX:PrintHeapAtGC、-XX:PrintGCApplicationStoppedTime
类和对象跟踪：-XX:+TraceClassLoading、-XX:+TraceClassUnloading
尽量避免短命大对象，使用-XX:PretenureSizeThreshold设置大对象直接进入老年代的阈值
Young GC速度远高于Full GC，尽量避免对象提升到老年代，Young GC应该占绝大部分，Full GC应该很少
不可变对象对GC友好：减少卡表扫描

```

Reference:

```
http://www.cs.cornell.edu/projects/ladis2009/talks/dean-keynote-ladis2009.pdf
http://blog.hesey.net/2014/05/gc-oriented-java-programming.html
http://www.javaworld.com/article/2078623/core-java/jvm-performance-optimization--part-1--a-jvm-technology-primer.html
http://www.javaworld.com/article/2076539/build-ci-sdlc/java-performance-programming--part-1--smart-object-management-saves-the-day.html
http://www.javaworld.com/article/2074893/build-ci-sdlc/design-for-performance--part-1--interfaces-matter.html
http://www.ibm.com/developerworks/cn/java/l-javaio/
```