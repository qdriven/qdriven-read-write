---
title: 快速生成简单的TPS报告 
date: 2019-12-13 02:19:56
tags: [10Minutes,python,productivity]
---

练手的机会无处不在，不需要太久，也许只要10分钟半个小时就可以. 
测试人员来说每天重复的事情其实不少，比如今天这件，大体时期如下:
- 要做压力测试，需要提供一个TPS时间序列报告
- 压力测试工具是开发自己写的，TPS的数据从日志里面拿
- 不同的并发数下面需要重复好几次整理收集的事情，不同的版本下面又需要做好多次这样的事情

那么先让我们改进一下吧。

## 原材料和最终结果:

原材料TPS的日志大体如下:

```sh
2019/12/11 17:36:15.810881 [0;31m[ERROR][m GID 2324, vbft actor SaveBlockCompleteMsg receives block complete event. block height=2, numtx=236
2019/12/11 17:36:17.027152 [0;31m[ERROR][m GID 16478, vbft actor SaveBlockCompleteMsg receives block complete event. block height=3, numtx=1341
2019/12/11 17:36:18.595527 [0;31m[ERROR][m GID 52389, checkUpdateChainConfig err:not found
2019/12/11 17:36:18.745932 [0;31m[ERROR][m GID 63065, vbft actor SaveBlockCompleteMsg receives block complete event. block height=4, numtx=5495
```

需要从日志中收集的数据是，commit_time(日志中一开始的这个时间,如2019/12/11 17:36:15.810881),block height(块的高度，有点神秘，不用管它就是了Who cares)，numtx(交易比数)数量

最终结果，其实需要绘制如如下图:

![img](/images/chains/TPS.jpg)

## 开始解题

很明显题目可以分解为一下几个步骤:

- 从日志中获取需要的数据(日志不大)
- 将数据加工转化为图表，EXCEl其实就有图标功能，直接用EXCEL就好
  - X轴是时间，X轴起点是0，每一个TPS点就是从0计算的时间偏移量，也就是第二行日志的时间，减去第一行日志的时间
  - Y轴是TPS的数量

问题定义了，动作分解了，那么就动手了.

### 解析日志文件

其实就是获取commit_time, height,num_tx, 解析日志就是
  - 先用空格切割成数组，第一个和第二个合并变成提交时间
  - 倒数第二个用=切成数组，然后获取数组第二个元素就是height值了
  - 倒数第一个用=切成数组，然后获取数组第二个元素就是提交时间是提交的交易总数量了
  - 最后返回一个数组，就是在不同时间点上提交的交易数量
  
```python
MetricSample = namedtuple('MetricsData', 'commit_time height num_tx')

def read_metric_file(path="metrics.log"):
    """
    Read and Parse Metric Log
    """
    with open(path, 'r') as raw_metric:
        lines = raw_metric.readlines()
    metrics_data = []
    for line in lines:
        try:
            parsed_data = line.split(" ")
            start_time = " ".join(parsed_data[0:2])
            height = parsed_data[-2:][0].split("=")[1][0]
            num_tx = parsed_data[-1:][0].split("=")[1]
            metrics_sample = MetricSample(commit_time=start_time,
                                          height=int(height),
                                          num_tx=int(num_tx))
            metrics_data.append(metrics_sample)
        except IndexError as e:
            pass

    return metrics_data
```

不过namedtuple用的有点好玩，其实是一个不错的学习点，可以让代码看的更好懂点，所以又练了一次手，熟悉了一个新的库用法.
怎么用，其实查文档看看就好，或者查查[python module of week](https://pymotw.com/3/).
为什么代码更好懂呢？至少每个变量名代表的含义看的很清楚了，自然就好懂了。


### 保存到EXCEL并且生成图表

保存到EXCEl需要加工一下数据，计算一下TPS(Transaction Per Senconds).

公式其实就是：

```
TPS = num_tx/(这次提交时间-上一次提交时间) 
```

以下就是实现代码，当然如何操作excel，其实[openpyxl](https://openpyxl.readthedocs.io/en/stable/)还是很方便的,
怎么用？RTFM，其实还是很好理解的，chart这块稍微麻烦点，不过一样，文档里面也有示例代码，抄抄，然后自己打开一个EXCEL自己添加一个line chart
看看，总体意思其实是:
- chart要用的数据通过什么方式在程序里面给

```python
 data = Reference(ws, min_col=3, min_row=1,
                     max_col=3, max_row=max_row)
    lc.add_data(data, titles_from_data=True)
```
- X轴的数据怎么设定

```python
 x_timeoffset = Reference(ws,min_col=2,
                                max_col =2,
                                min_row=2,
                                max_row=max_row)
    lc.set_categories(x_timeoffset)
```

关于操作EXCEL里面的内容:

- cell是什么鬼,excel的cell就是一个表格，怎么定位要设定值的表格呢，
  其实就是几行几列，所以就是col=1,row=1就是第一行第一列的那个表格
- Reference里面的min_col,min_row,max_col,max_row是什么鬼？
  给图表用的数据，需要设定从那行开始到那行结束，如果是多列的话，还要说明从那列开始到那列结束.所以这个是取那些数据，excel里面俗称拉一下

下面是完整的代码实现:

```python
def metrics_to_excel(metrics, excel_path="metrics.xlsx"):
    wb = Workbook()
    ws = wb.create_sheet("metric", 0)
    ws.cell(1, 1, "duration")
    ws.cell(1, 2, "time_offset")
    ws.cell(1, 3, "tps")
    ws.cell(1, 4, "height")
    ws.cell(1, 5, "num_tx")
    row_num = len(metrics)
    time_offset = 0
    for index in range(row_num):
        ws.cell(index + 2, 4, metrics[index].height)
        ws.cell(index + 2, 5, metrics[index].num_tx)
        if index == 0:
            ws.cell(index + 2, 1, 0)
            ws.cell(index + 2, 2, 0)
            ws.cell(index + 2, 3, 0)
        else:
            start_time = datetime.datetime.strptime(metrics_data[index - 1].start_time,
                                                    "%Y/%m/%d %H:%M:%S.%f")

            end_time = datetime.datetime.strptime(metrics_data[index].start_time,
                                                  "%Y/%m/%d %H:%M:%S.%f")
            duration = (end_time - start_time).seconds
            time_offset = time_offset + duration
            ws.cell(index + 2, 1, duration)
            ws.cell(index + 2, 2, time_offset)
            ws.cell(index + 2, 3, metrics[index].num_tx / duration)
    add_chart(ws, row_num)
    wb.save(excel_path)


def add_chart(ws, max_row):
    lc = LineChart()
    lc.title = "Chain TPS"
    lc.style = 15
    lc.y_axis.title = "TPS"
    lc.x_axis.title = "Time"
    data = Reference(ws, min_col=3, min_row=1,
                     max_col=3, max_row=max_row)
    lc.add_data(data, titles_from_data=True)
    x_timeoffset = Reference(ws,min_col=2,
                                max_col =2,
                                min_row=2,
                                max_row=max_row)
    lc.set_categories(x_timeoffset)
    ws.add_chart(lc,"G13")

if __name__ == '__main__':
    metrics_data = read_metric_file()
    metrics_to_excel(metrics_data)
```

然后运行这段程序，上面的那个TPS图表就生成好了，同时简历里面可以写上:

- 构建自动生成性能测试报告的工具平台
- 熟练使用Python 标准库中的namedtuple和EXCEL openpyxl库操作EXCEl，自动生成漂亮的报告

当然重点不是简历上写什么，重点是有时间可以看看这两个库的用法，说不定哪天又用到了。
时间节约了，事情完成了，东西学到了. It's a perfect day! 大概合计用了1个小时完成，但是学到东西也不少哇！
原来这个报告整理一下，1次需要个2个小时，现在花了一个小时写代码，其他就没有额外时间了。这也算不上什么自动化测试，但是投入产出比不是很高吗？