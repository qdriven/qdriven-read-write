# Top Tomcat Performance Problem

[source](http://apmblog.dynatrace.com/2016/02/23/top-tomcat-performance-problems-database-micro-services-and-frameworks/)

- slow/excessive sql queries
- wrong configured connection pools
- excessive service
- REST and remoting calls
- overhead through excessive logging or inefficient exception handling
- bad coding leading to CPU hotspots,memory leaks,impact GC or stuck threads through synchronization issues

## Top Tomcat Performance issues list

- Database Access: load too much data inefficiently
- Micro-Service Access: inefficient access and badly designed service apis
- Bad Frameworks: Bottlenecks under load or misconfiguration
- Bad Coding:CPU,Sync and Wait hotspots
- inefficient Logging: Even too much for splunk &ELK
- Invisible exceptions
- Pools && Queues: Bottlenecks through wrong size
- Exception: overhead through stack trace generation
- Multiple-Threading: Locks,Syncs && Wait issues
- Memory: Leaks,and GC impact
