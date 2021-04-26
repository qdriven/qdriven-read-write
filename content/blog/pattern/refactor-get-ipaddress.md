---
title:  一次获取IP地址的小重构 
date: 2020-1-13 02:19:56
tags: [10Minutes,refactor]
---

原始代码不好的地方：

- 有很多if/else
- 扩展需要增加内部的if/else判断

```java
 public static String getIpAddr(HttpServletRequest request)
    {
        if (request == null)
        {
            return "unknown";
        }
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("X-Forwarded-For");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getHeader("X-Real-IP");
        }

        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
        {
            ip = request.getRemoteAddr();
        }

        return "0:0:0:0:0:0:0:1".equals(ip) ? "127.0.0.1" : ip;
    }

```

重构后代码:
1. 代码精简
2. 取header部分只要传入参数就可以

```java
  private final static String UNKNOWN = "UNKNOWN";

  public static String getIpAddressFromReq(HttpServletRequest request,String... headerNames) {
    if (ObjectUtil.isNotNull(request)) {
      String ip = request.getHeader("x-forwarded-for");
      List<String> headers = Arrays.asList("Proxy-Client-IP",
                                           "X-Forwarded-For",
                                           "WL-Proxy-Client-IP","X-Real-IP");
      headers.addAll(Arrays.asList(headerNames));
      for (String header : headers) {
        if (ip == null || ip.length() == 0 || UNKNOWN.equalsIgnoreCase(ip)) {
          ip = request.getHeader(header);
        } else {
          break;
        }
      }
      if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getRemoteAddr();
      }
      return "0:0:0:0:0:0:0:1".equals(ip) ? "127.0.0.1" : ip;
    } else {
      return UNKNOWN;
    }
  }
```