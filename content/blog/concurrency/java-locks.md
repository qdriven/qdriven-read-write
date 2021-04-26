---
title: JAVA Lock
date: 2020-08-04 09:17:08
tags: ["daily-tips","performance","concurrency"]
---

## 0. JAVA Locks

锁在JAVA 并发编程中是一个重要的概念，而且是一些比较难懂的概念，一下是学习Lock概念的时候的一些记录。

- ReadWriteLock，ReentrantReadWriteLock


## 1. ReadWriteLock: ReentrantReadWriteLock

- ReadWriteLock 基本概念
  读写锁，分读锁和写锁，多个读锁不互斥，读锁和写锁互斥；上了读锁，不能写；修改数据，只能一个人写，但是不能读，就上写锁；
  所以就是读的时候上读锁，写的时候上写锁；ReentrantReadWriteLock使用两把锁：
  * 读锁： 进入读锁的条件
    1. 没有其他线程写
    2. 没有写请求，调用线程和持有锁的线程是同一个
  * 写锁： 进入写锁条件
    1. 没有其他线程的读锁
    2. 没有其他线程的写锁

## 2. ReentrantReadWriteLock: 实例说明

- 读锁条件1: 没有其他线程写，进入读锁
- 读锁条件2: 没有写请求，调用线程和持有锁的线程是同一个
- 写锁条件1； 没有其他线程的读锁
- 写锁条件2； 没有其他线程的写锁
- 读写锁混用案例
