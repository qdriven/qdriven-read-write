---
title: junit-perf
date: 2018-07-24 22:11:05
tags: ["performance"]
---

# 使用JunitPerf进行性能测试

以下简单介绍一下如何使用JunitPerf进行性能测试，JunitPerf是基于JUnit4的一个单元性能测试插件，对于会远程调用API测试比较合适，如果想要比较nanosecond 延迟的则需要使用[JMH](http://openjdk.java.net/projects/code-tools/jmh/).

## JunitPerf 依赖声明

此例子假设使用MAVEN管理项目，所以在POM文件中添加：

```xml
<dependency>
 <groupId>junit</groupId>
 <artifactId>junit</artifactId>
 <version>4.12</version>
</dependency>
<dependency>
 <groupId>com.github.noconnor</groupId>
 <artifactId>junitperf</artifactId>
 <version>1.9.1</version>
</dependency>
```

## 构建压力测试类

假设你想衡量DemoPerfService 类中的getServiceId方法：

```java
public class DemoPerfService {

    public String getServiceId(String userId){

        return UUID.randomUUID().toString();
    }
}
```

那么你可以构建如下的测试类：

```java
public class DemoServiceTest {
    @Rule
    public JUnitPerfRule perfTestRule = new JUnitPerfRule();
    DemoPerfService demoPerfService;
    @Before
    public void setupService(){
        this.demoPerfService = new DemoPerfService();
    }
    @Test
    @JUnitPerfTest(threads = 50,durationMs = 1200,warmUpMs = 100,maxExecutionsPerSecond = 110)
    public void getServiceId_withoutTestRequirement() {

        String result =demoPerfService.getServiceId("userid");
        System.out.println(result);
        Assert.assertNotNull(result);
    }
```

直接运行就可以进行压力测试,默认的测试报告可以在build/reports 目录下获取：

![img](/images/ut/junitperf_1.jpg)

以下是对于测试类的几点说明：

|Item|定义说明|Default值或说明|
|----|-------|---------|
|@Rule|申明为JUnit 的Rule类||
|JUnitPerfRule|JUnitPerf 测试规则类||
|@JunitPerfTest|声明为性能测试方法||
|threads|测试使用的线程数||
|durationMs|测试持续时间||
|warmUpMs|测试热身时间|热身时间的测试数据不会计算进最后的测试结果|
|maxExecutionsPerSecond|方法执行的上限|RateLimiter，控制TPS上限|

## 对自己的测试设置期望值

使用@JUnitPerfTestRequirement 可以给性能测试设置期望值，这个annotation的属性有:

|属性|定义|
|----|----|
|percentits|设置例如90%/95%/50% 响应时间的期望|
|executionsPerSec|期望每秒执行测试(TPS)|
|allowedErrorPercentage|允许错误比例|
|minLatency|期望最小延时，如果实际最小延时超过这个数，则失败|
|maxLatency|期望最大延时，如果实际最大延时超过这个，则失败|
|meanLatency|期望中位数延时|

下面是使用了JUnitPerfTestRequirement的一个测试方法,需要和@JUnitPerfTest一起使用：
- @JUnitPerfTest 定义了压测的运行参数
- @JUnitPerfTestRequirement定义了压测的期望值

具体代码如下例:

```java
  @Test
    @JUnitPerfTest(threads = 50,durationMs = 1200,warmUpMs = 100,maxExecutionsPerSecond = 110)
    @JUnitPerfTestRequirement(percentiles = "90:7,95:7,98:7,99:8", executionsPerSec = 10_000, allowedErrorPercentage = 0.10f)
    public void getServiceId() {

        String result =demoPerfService.getServiceId("userid");
        System.out.println(result);
        Assert.assertNotNull(result);
    }
```

运行之后，如果发现没有满足JUnitPerfTestRequirement定义，则报错:

```java
java.lang.AssertionError: Test throughput threshold not achieved
Expected: is <true>
     but: was <false>
Expected :is <true>
```

是不是很简单！

## 设置测试报告地址

JUnitPerf 有不同的测试报告，个人觉得HTML的测试报告比较实用，具体只需要:

```java
@Rule
public JUnitPerfRule perfTestRule = new JUnitPerfRule(new HtmlReportGenerator("perf/report.html"));

```

## 完整的例子

```java
public class DemoServiceTest {
    @Rule
//    public JUnitPerfRule perfTestRule = new JUnitPerfRule(new HtmlReportGenerator("perf/report.html"));
    public JUnitPerfRule perfTestRule = new JUnitPerfRule();
    DemoPerfService demoPerfService;
    @Before
    public void setupService(){
        this.demoPerfService = new DemoPerfService();
    }

    @Test
    @JUnitPerfTest(threads = 50,durationMs = 1200,warmUpMs = 100,maxExecutionsPerSecond = 110)
    @JUnitPerfTestRequirement(percentiles = "90:7,95:7,98:7,99:8", executionsPerSec = 10_000, allowedErrorPercentage = 0.10f)
    public void getServiceId() {

        String result =demoPerfService.getServiceId("userid");
        System.out.println(result);
        Assert.assertNotNull(result);
    }

    @Test
    @JUnitPerfTest(threads = 50,durationMs = 1200,warmUpMs = 100,maxExecutionsPerSecond = 110)
    public void getServiceId_withoutTestRequirement() {

        String result =demoPerfService.getServiceId("userid");
        System.out.println(result);
        Assert.assertNotNull(result);
    }
}
```

最后可以再设定的目录中查看测试报告，测试报告和默认的HTML 测试报告是一致的.

## 一点问题

压力测试过程中，有时数据不能复用，举个例子来说，如果想测试完全没有访问redis缓存情况下，通过userid查询的user信息速度，那么压测的时候userid就不能复用，因为一旦访问了就会放入redis缓存而影响结果，这个可以通过使用其他的方法解决，比如曾今使用过BlockingQueue的方法进行过尝试，具体方法如下：
1. 读取所有userid的文件
2. 把userid放到一个BlockingQueue中
3. 压测时获取userid通过BlockingQueue去获取

这样就解决了数据不能重复的方法，具体方法可以参考如下代码:

```java
    static BlockingQueue<String> distinctIdQueue ;
    @Rule
    public JUnitPerfRule perfTestRule =
            new JUnitPerfRule(new HtmlReportGenerator("data/report_test.html"));

    @BeforeClass
    public static void setupQueue() throws IOException {

        distinctIdQueue = new LinkedBlockingQueue<>();
        Files.readAllLines(
                Paths.get("data/userid.txt")
        ).parallelStream().forEach(
                item-> {
                    try {
                        distinctIdQueue.put(item);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
        );

    }

     @Test
    @JUnitPerfTest(threads = 50,durationMs = 1200,warmUpMs = 100,maxExecutionsPerSecond = 110)
    @JUnitPerfTestRequirement(percentiles = "90:7,95:7,98:7,99:8", executionsPerSec = 10_000, allowedErrorPercentage = 0.10f)
    public void getServiceId() {
        String uesrId = distinctIdQueue.take();
        String result =demoPerfService.getServiceId(userId);
        System.out.println(result);
        Assert.assertNotNull(result);
    }

    
}
```
