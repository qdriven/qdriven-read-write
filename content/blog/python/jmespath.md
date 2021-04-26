---
title: jmespath 使用，jsonpath外的另外一种选择
date: 2018-08-13 22:35:32
tags:
    - tips
    - python
---

在测试过程中，经常会去JSON中的某个值，[jmespath](http://jmespath.org/tutorial.html)可以是除了jsonpath的另外一种选择.
下面通过几个例子来说明jmespath在python的使用

## jmespath python安装

非常简单直接pip,
```sh
pip install jmespth
```

## 查询一个key值

```python
source={"a": "foo", "b": "bar", "c": "baz"}
result = jmespath.search("a",source)
print(result)
```

## subexpression

类似于jsonpath，通过***.***来表示路径的层级

```python
source_1={"a": {"b": {"c": {"d": "value"}}}}
sub_result = jmespath.search("a.b.c",source_1)
print(sub_result)

```
这个例子的结果为：{'d': 'value'}

## index expressions

index expression主要使用在数组上

```python
source_2 = ["a", "b", "c", "d", "e", "f"]
index_result = jmespath.search("[1]",source_2)
print(index_result)
```

这个例子的结果为:b

## 多个表达式综合使用

以上几种表达式可以合起来一期使用：

```python
composite_exp = "a.b.c[0].d[1][0]"
source_3= {"a": {
  "b": {
    "c": [
      {"d": [0, [1, 2]]},
      {"d": [3, 4]}
    ]
  }
}}

composite_result = jmespath.search(composite_exp,source_3)
print(composite_result)
```

这个例子的结果为1

## Slicing 切片

slicing 和python本身的slicing比较像，

```python
source_4=[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
slicing_exp = "[0:5]"
slicing_result = jmespath.search(slicing_exp,source_4)
print(slicing_result)
```

这个例子的结果为： [0, 1, 2, 3, 4]

slicing实际上和python自己的机制基本一样，同样这个也是主要给数组使用.
有一点需要记住，基本的slicing的格式其实是： [start:stop:step]

## Projections

projection不知道怎么翻译，就先叫做投影吧，具体通过例子来说比较好理解.
projections主要包含一下几种情况:

- List Projections
- Slice Projections
- Object Projections
- Flatten Projections
- Filter Projections

### Projections- 例子

```python
list_exp="people[*].first"
source_5 = {
  "people": [
    {"first": "James", "last": "d"},
    {"first": "Jacob", "last": "e"},
    {"first": "Jayden", "last": "f"},
    {"missing": "different"}
  ],
  "foo": {"bar": "baz"}
}

proj_result1= jmespath.search(list_exp,source_5)
print(proj_result1) # ['James', 'Jacob', 'Jayden']


obj_exp ="reservations[*].instances[*].state"
source_6= {
  "reservations": [
    {
      "instances": [
        {"state": "running"},
        {"state": "stopped"}
      ]
    },
    {
      "instances": [
        {"state": "terminated"},
        {"state": "runnning"}
      ]
    }
  ]
}

proj_result2=jmespath.search(obj_exp,source_6)
print(proj_result2) #[['running', 'stopped'], ['terminated', 'runnning']]

# Flatten projections

source_7=[
  [0, 1],
  2,
  [3],
  4,
  [5, [6, 7]]
]
flat_exp ="[]"
flat_result = jmespath.search(flat_exp,source_7)
print(flat_result) # [0, 1, 2, 3, 4, 5, [6, 7]]

# filter

filter_exp="machines[?state=='running'].name"
filter_source ={
  "machines": [
    {"name": "a", "state": "running"},
    {"name": "b", "state": "stopped"},
    {"name": "b", "state": "running"}
  ]
}
filter_result = jmespath.search(filter_exp,filter_source)
print(filter_result)

# pipe expression

pipe_exp= "people[*].first | [0]"
pipe_source= {
  "people": [
    {"first": "James", "last": "d"},
    {"first": "Jacob", "last": "e"},
    {"first": "Jayden", "last": "f"},
    {"missing": "different"}
  ],
  "foo": {"bar": "baz"}
}

pipe_result = jmespath.search(pipe_exp,pipe_source)
print(pipe_result)  # James

# multiselect
multi_exp="people[].[first,last]"
multiselect_result = jmespath.search(multi_exp,pipe_source)
print(multiselect_result) # [['James', 'd'], ['Jacob', 'e'], ['Jayden', 'f'], [None, None]]
```

基本上把网站上例子试了一下，总体感觉功能是相当强大(怀疑比jsonpath还要厉害一点).
从简单到复杂，都还是比较好用.

