# yesterday=`date -d last-day +%Y-%m-%d`
# echo $yesterday
 
# curday=`date +%Y-%m-%d`
# echo $curday
 
# echo "现在时间：`date '+%Y%m%d %T'`"
# echo "现在时间：`date '+%Y%m%d %H%M%S'`"
 
# echo `date '+%Y%m%d-%H%M%S'`
 
# t3=`date '+%Y-%m-%d %H:%M:%S'`
# echo $t3
 
# send=`date '+%Y-%m-%d %H:%M:%S'`
# echo $send
 
# t4=`date '+%Y-%m-%d %H:%M:%S'`
# echo $t4

mkdir -p tip-per-day/$2
curday=`date +%Y-%m-%d`

echo "---
layout: post
title: "$2 $1 使用tips"
categories: [automation，$2,daily-automation-tip]
tags: [$2,daily-automation-tip]
image: 6.jpg
date: `date '+%Y-%m-%d %H:%M:%S'` 
---
## 为什么使用$1

## 如何使用$1

## $1示例
"  > tip-per-day/$2/$curday-$1.md