# APP testing 22 principles

## 设备和平台

- hardware

|操作系统|设备硬件|屏幕尺寸|分辨率|像素密度|
|----|-------|-----|------|----------|
||||||

选择这些资料的来源：
- Google Analytics
- Adobe Omniture
- iOS version distribution
- Android version distribution


## 移动网络切换

- 网络切换
  * GSM
  * LTE
  * UMTS
  * EDGE
  * GPRS/2.5G
  * Wi-Fi
- Exception handler

## 多任务处理

- App 切换处理
- 恢复

## 手势操作

- 应用手势
- 操作系统手势

## 用户体验

- 横竖屏
- 辅助功能Accessibility
- 一致性
- WebView

## 通知和消息

- 权限
- 传感器
- 通知栏
- 消息推送

## 操作系统特性

- Android: Wdget/Dalvik/ART
- iOS: Widget/App setting

## 不同设备信息同步

- 一处改变
- 多处同步

## 特定设备

- 三星的TouchWiz
- HTC的Sense
- 魅族的FlyMe
- LG的UX

## 多文件格式支持

- PDF
- Office: word,excel,powerpoint
- 图片
- 视频

## 国家和地区支持

- 文字显示
- 时间和日期格式
- 输入法

## 高内存占用

- 操作系统本身对于app内存的限制
- 大量图片
- 长时间语音
- 大容量视频


## 非标准控件

- 操作系统本身提供的控件
- 第三方类库的控件
- App中独立实现的控件

## APP升级管理

- 覆盖/增量安装
- 用户信息
- 数据库变化
- delete APP

## APP缓存机制

- 更新频率
- 更新显示

## 第三方APP集成和调用

- app集成
- app调用

## APP依赖

- 第三方系统/app
- WebService
- API和集成测试

## 自动化测试和探索式测试

自动化测试:
- 单元测试
- WebService的自动化测试
- 模拟器
- 用户旅程的自动化测试

探索式测试:

- 实际设备
- 页面跳转
- 数据流动
- 涉及多页面的流程操作

## 安全测试

- WebService
- iPhone Configuration Utility
- Android Developer Tools: DDMS
- SQLite数据库
- App请求中用户信息

## 性能测试

- 网络连接速度
- 操作流畅度
- WebService性能

## 操作系统升级

- 新的操作系统的特性和规范
- 当前系统的回归测试
- 新系统的适应性测试

## 持续集成和持续部署
- 稳定性问题
- iOS: TestFlight
- Android: Dropbox
