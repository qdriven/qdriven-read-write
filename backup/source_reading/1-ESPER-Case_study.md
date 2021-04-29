# ESPER CASE STUDY

[source](http://www.espertech.com/esper/feedmonitor_casestudy.php)

- Monitor Raw Feed Rate

## 监控Raw Market Data Feed

- event: create schema

```java
String symbol;
FeedEnum feed;
double bidPrice;
double askPrice;
```

- define rule: create rule

We can use an aggregation function by name "rate" that outputs an average rate given a number of seconds of events 

```sql
insert into TicksPerSecond
select feed, rate(10) as cnt
  from MarketDataEvent
 group by feed
```

- Detecting a Fall-off

We define a rapid fall-off by alerting when the number of ticks per second for any second falls below 75% of the average number of ticks per second over the last 10 seconds.

```sql
select feed, avg(cnt) as avgCnt, cnt as feedCnt
  from TicksPerSecond.win:time(10 seconds)
 group by feed
having cnt < avg(cnt) * 0.75
```

不同的Feed数据流量进入，10秒内小于平均值75%的Feed报警

## Transaction Case Study

- Events

EventA
```
transactionId
timestamp
customerId
```

EventB

```
transactionId
timestamp
```

EventC

```
transactionId
timestamp
supplierId
```

- Real time summary data
- Find Missing Events

```sql
nsert into CombinedEvent(transactionId, customerId, supplierId, latencyAC, latencyBC, latencyAB)
select C.transactionId, customerId, supplierId,
       C.timestamp - A.timestamp, C.timestamp - B.timestamp, B.timestamp - A.timestamp
  from TxnEventA.win:time(30 minutes) A,
       TxnEventB.win:time(30 minutes) B,
       TxnEventC.win:time(30 minutes) C
 where A.transactionId = B.transactionId and B.transactionId = C.transactionId;
 select min(latencyAC) as minLatencyAC, max(latencyAC) as maxLatencyAC, avg(latencyAC) as avgLatencyAC from CombinedEvent.win:time(30 minute);
```

```sql
select customerId, min(latencyAC) as minLatencyAC, max(latencyAC) as maxLatencyAC, avg(latencyAC) as avgLatencyAC
  from CombinedEvent.win:time(30 minutes)
 group by customerId

```

find missing transaction id

```sql
select rstream *
  from TxnEventA.win:time(30 minutes) A
       full outer join TxnEventC.win:time(60 minutes) C on A.transactionId = C.transactionId
       full outer join TxnEventB.win:time(30 minutes) B on B.transactionId = C.transactionId
 where C.transactionId is null
```

