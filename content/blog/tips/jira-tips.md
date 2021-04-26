---
title: JIRA Fields 说明
date: 2020-08-04 09:17:08
tags: ["daily-tips","jira"]
---

JIRA可以导出的字段的说明

<!-- more -->

JIRA可以导出的字段|中文名|字段说明|字段样例
|-------|-------|----|----|
Summary|概要|一句话描述问题|100字符以内的文本
Issue key|问题号|用于识别任务的唯一编号。可通过搜索问题号快速跳转至问题详情页面
Issue id|问题ID|用于系统表结构关联，用户无需关注|43021
Parent id|父问题ID|用于系统表结构关联，用户无需关注|38524
Issue Type|问题类型|标识问题的类型|史诗；任务；子任务等
Status|状态|标识问题的状态。可参考JIRA中的问题状态待办，进行中，开发中，测试，完成等
Project key|项目关键字|项目的唯一识别标识符。项目中的问题号会以累加的数列标识在关键字后面。例如|TS-1，TS-2
Project name|项目名称|项目名称，在创建项目时必填。项目管理员可随时修改项目名称
Project type|项目类型|项目类型分两种，software|或|business。项目在创建之初会通过选择的类型提供不同的创建模板software|或|business
Project lead|项目负责人|项目的负责人。其不一定是项目参与者或管理员人员名称
Project description|项目描述|项目名称，在创建项目时选填。项目管理员可随时修改项目描述可带特殊字符的文本，支持markup
Project url|项目URL链接|在项目链接板块选择添加的网页链接|网页链接
Priority|优先级|P1，P2，P3
Resolution|解决结果|当问题状态流转至最终阶段时系统填写的字段。系统通过此值来判断问题是否完成完成；未解决
Assignee|经办人|当前问题的负责人，由其负责该任务的完成人员名称
Reporter|报告人|当前问题的发起人，该角色关注此问题的进展人员名称
Creator|创建人|当前问题的创建者，操作创建的人，不一定是报告人或经办人人员名称
Created|创建时间|问题被创建时的时间|精确到分钟的时间戳
Updated|更新时间|问题被最近一次更新时的时间|精确到分钟的时间戳
Last Viewed|上次浏览时间|问题被最近一次浏览时的时间|精确到分钟的时间戳
Resolved|解决时间|仅当“解决结果”被赋值时由系统自动更新精确到分钟的时间戳
Fix Version/s|修复的版本|将发布此问题的版本号|文本|例|DalmoreX|v1.2
Affected Version/s|影响的版本|此问题造成影响的版本号，多用于故障类的问题文本|例|x|v1.2
Components|模块|同一条记录可含有多个值|JIRA中的4个字段
Due Date|到期日|当前问题需要完成的截止日期|精确到分钟的时间戳
Log Work|工作日志|同一条记录可含有多个值|精确到分钟的记录时间；记录人；记录时长（秒）
OriginalEstimate|初始预估|记录一个问题的计划工作时长。参考时间记录3600（秒）
RemainingEstimate|剩余估算|记录一个问题的剩余工作时长。参考时间记录1080（秒）
TimeSpent|时间消耗|记录一个问题的耗费工作时长。参考时间记录360（秒）
WorkRatio|未明确|整数百分比例|85%
SecurityLevel|安全等级|未明确
Outwardissue|link|外部连接问题|基于连接类型，同一条记录可含有多个值
Attachment|附件|同一条记录可含有多个值
Custom field|(Baseline|end|date)|自定义字段|记录一个问题的计划结束时间基线。第三方插件SoftwarePlant引入的字段，用于BigPicture,|BigGantt等插件精确到分钟的时间戳
Custom field|(Baseline|start|date)|自定义字段|记录一个问题的计划开始时间基线。第三方插件SoftwarePlant引入的字段，用于BigPicture,|BigGantt等插件精确到分钟的时间戳
Custom field|(End|date)|自定义字段|记录一个问题的计划结束时间。参考时间记录第三方插件SoftwarePlant引入的字段，用于BigPicture,|BigGantt等插件精确到分钟的时间戳
Custom field|(Epic状态)|自定义字段|表示史诗的状态，系统通过此值来判断史诗是否完成待办，进行中，完成
Custom field|(Epic颜色)|自定义字段|记录该史诗在史诗栏位中所使用的颜色
Custom field|(Progress)|自定义字段|第三方插件SoftwarePlant引入的字段，用于BigPicture,|BigGantt等插件
Custom field|(Severity)|严重程度|表示此问题的严重程度。S1为最高|S1，S2，S3
Custom field|(Start|date)|自定义字段|记录一个问题的计划开始时间。参考时间记录第三方插件SoftwarePlant引入的字段，用于BigPicture,|BigGantt等插件精确到分钟的时间戳
Custom field|(Story|Point)|自定义字段|记录一个问题故事点估算值|任意数值，例|1，2，3，5，8，0.5|等
Custom field|(史诗名称)|自定义字段|史诗类型问题专用，一句话描述史诗问题包括项目创建、项目查询、基础信息、资源管理、项目角色及权限配置等
Custom field|(史诗链接)|自定义字段|史诗类型问题专用，概括史诗，用于史诗栏内显示“项目管理”
Custom field|(等级)|自定义字段|未明确|0|i0019d:zkvy0hyw9c
Comment|备注|同一条记录可含有多个值|可带特殊字符的文本，支持markup
