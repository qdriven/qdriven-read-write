# encoding: utf-8


"""
# *args and **kwargs

- *args: 按照参数顺序传递参数，是一个tuple类型
- **kwargs: 按照参数名字传递参数，是一个dict类型
"""

"""
## *args 使用

- 是个tuple类型
- 根据位置传递参数
```python
def test_var_args(arg1, *args):
    print("first arg:", arg1)
    print(type(args))
    print(args[0]) # 根据位置获取参数
    for arg in args: # args类型是tuple，所以可以遍历
        print("following args:", arg)
    for index in range(len(args)):
        print("arg index ",index, "value is ",args[index])


test_var_args("arg1", 2, 3, 4, 5, 6)
``` 

结果可以非常清楚的这显示这个结论:

```python
first arg: arg1
<class 'tuple'>
2
following args: 2
following args: 3
following args: 4
following args: 5
following args: 6
arg index  0 value is  2
arg index  1 value is  3
arg index  2 value is  4
arg index  3 value is  5
arg index  4 value is  6
```

## **kwargs 使用

- **kwargs可以用来处理有名字的参数
- kwargs是一个dict类型

"""


def test_var_args(arg1, *args):
    print("first arg:", arg1)
    print(type(args))
    print(args[0])  # 根据位置获取参数
    for arg in args:  # args类型是tuple，所以可以遍历
        print("following args:", arg)
    for index in range(len(args)):
        print("arg index ", index, "value is ", args[index])


test_var_args("arg1", 2, 3, 4, 5, 6)


def test_var_kwargs(args1, **kwargs):
    print("arg 1 is ", args1)
    print(type(kwargs))
    print(kwargs['name'])
    for key, value in kwargs.items():
        print("{0}={1}".format(key, value))


test_var_kwargs("args1", name="hello", world="world", dict_args={"k":"v"})
# test_var_kwargs("args1", {"name":"hello","world":"world"}) # this is error

if __name__ == '__main__':
    print(__doc__)
