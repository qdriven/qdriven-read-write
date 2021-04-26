---
layout: post
title: "数据驱动测试- 测试用例加载"
categories: [automation，python,daily-automation-tip]
tags: [automation,daily-automation-tip]
image: 6.jpg
date: 2019-11-22T10:31:11+08:00
---

使用pytest作为测试工具，有一个pytest.parameterized 的装饰器可以用来进行数据驱动测试，以下是一个最简单的例子：

```python
@pytest.mark.parametrize("id_num", (1, 2, 3, 4, 5))
def test_issue_plain(id_num):
    print(id_num)
```

test_issue方法有一个参数名称是 id_num, 这个值可以在测试过程中不断的被改变，但是实际中接口自动化中，有时我们会使用一些excel，yml作为外部测试用例来传入参数进行测试，那怎么样才能实现这个功能呢？

## case loader 例子说明

简单来说，一般我们测试用例传入的数据包括：

- test_desc: 测试用例描述
- inputs: 输入参数，可以作为json格式
- expected: 期望结果，可以是json格式

```python
@pytest.mark.parametrize("test_desc,input,expected", load_case_by_yml("testcases.yml"))
def test_issue_plain(test_desc, input, expected):
    print(test_desc, input, expected)
```

所以我们通过程序加载后的内容也就是load_case_by_yml返回的应该是这样的一个list：

```
[(test_desc,inputs,expected),......]
```

## case loader 实现

有了目标，我们就动手，使用yml包非常容易的下面的功能:

```python

def load_case_by_yml(path):
    with open(path, 'r') as stream:
        raw_yaml_result = yaml.safe_load(stream)
    cases = raw_yaml_result["tests"]
    parameterized_case = []
    for case in cases:
        parameterized_case.append(tuple(case.values()))
    return parameterized_case

```

对应测试用例的yaml如下:

```yaml
tests:
  - test_desc: test1
    input: {"k1":"v1"}
    expected: {"k1":"v1"}
  - test_desc: test2
    input: {"k1":"v2"}
    expected: {"k1":"v2"}

```

通过这个方式，就非常容易的实现了数据驱动，同时也可以让自己的测试数据更好的被阅读和管理.


每天1小时，可以让你的效率更好. 明天可以自己试试如何从excel加载实现类似功能.
