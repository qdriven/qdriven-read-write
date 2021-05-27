---
title: 数据中台研究-1
date: 2021-05-27 21:34:04
tags: [DataPlatform]
---

关于所以中台的研究，我的第一个问题总是为什么有中台这个东西？所以对应到数据中台就是为什么有数据中台这个概念？
他解决什么问题？和原来的不是中台的情况下有什么优势？有什么不同点？

## 为什么有数据中台

我自己的理解是从三方面看:
1. 数据量和多样性的指数式增长，必然造成数据相关技术的快速迭代，以及沿用旧技术越来越难以跟上新的发展，技术能力直接会影响到企业的业务和产品能力
2. 单独业务团队负责自身数据的技术在原有的基础上变得越来越困难，面临的选择是：
   1. 扩张自身团队，跟上技术发展
   2. 把这部分数据业务交给专门人来做，自己专注使用和自身业务而不是基础技术
3. 公司层面，自然看到了数据能力的重要性，但是在业务团队有两种不同的选择时，个人认为为倾向选择业务团队2的选项，为什么？因为1选项自然会出现重复建设，
   大数据成本还是相当高的，公司从自身出发自然会选择看起来成本有优势的选择；同时数据的关联性变得越来越重要也支持公司建立数据中台的决策

以上是我认为公司会选择数据中台的原因。 同样我相信公司也了解数据中台之后，面临的问题是沟通成本上升，但是公司一定认为自己的组织能力是有办法解决这个问题的.

## 数据中台做什么事情和需要的能力

![img](https://pic4.zhimg.com/80/v2-62e4ca86b5cc1ca51e99bd115d460e6f_720w.jpg)
![img](https://pic3.zhimg.com/80/v2-8ad4211766ba27220a14212a11186a42_720w.jpg)


## 数据中台分层

- ODS： Operation Data Store： 数据仓库源头系统的数据表通常会原封不动的存储一份，这称为ODS层，是后续数据仓库加工数据的来源
- 数据仓库：
  - DWD: Datawarehouse Detail
  - DWB: Datawarehouse Base
  - DWS: Data warehouse service
  - ADS: Application Data Service
  - DWM: Data warehouse Detail
  - DIM: dimension
- ETL: Extract-Transform-Load
- 范式： 
  - 第一范式：字段值不可分理
  - 第二范式：确保表的每列都和主键相关
  - 第三范式：确保每列都和主键列直接相关，而不是间接相关

![img](https://i2.wp.com/img-blog.csdnimg.cn/20200629174843500.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hlbGxvX2phdmFfbGNs,size_16,color_FFFFFF,t_70)

![img](https://i2.wp.com/img-blog.csdnimg.cn/20200630104907949.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hlbGxvX2phdmFfbGNs,size_16,color_FFFFFF,t_70)
![img](https://i2.wp.com/img-blog.csdnimg.cn/20200630152135408.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hlbGxvX2phdmFfbGNs,size_16,color_FFFFFF,t_70)


## Hadoop/Spark/Flink

![img](https://pic4.zhimg.com/80/v2-852cb3069eb5f88cf68a7386f7d86fbf_720w.jpg)
![img](https://pic2.zhimg.com/80/v2-2093e7b71deb4f2c6de82cf1095c3bed_720w.jpg)
![img](https://pic1.zhimg.com/80/v2-004fbf11fabf89d097cbdd5c42f0c3ec_720w.jpg)
![img](https://pic4.zhimg.com/80/v2-0bc9afeb560dc9f5cd6ca36bdb4f6a6b_720w.jpg)

![img](https://pic4.zhimg.com/80/v2-4c5e9fc9bb344a707e2f8bd4aa463b47_720w.jpg)

![img](https://pic1.zhimg.com/80/v2-113f19ec5452ef2b85ce548027c5a9b0_720w.jpg)

![img](https://pic2.zhimg.com/80/v2-3d24fd1b242e0ef68efe431eed47d031_720w.jpg)