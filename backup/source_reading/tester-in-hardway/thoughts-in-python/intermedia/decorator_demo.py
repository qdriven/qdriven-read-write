# encoding: utf-8

"""
# Decorators

decorator在python使用非常广泛，他是用来改变函数的一种函数


## 传递函数，函数中定义函数

```python
def hi(name="world"):
    def name_it(prefix):
        return prefix+name

    return name_it("prefix")

print(hi("world"))


func=hi
print(func("use func"))

```

## Decorator

使用python函数可以传递，函数可以定义函数的特性，实现一个decorator的原理：
使用demo_decorator来装饰add函数

```python
def demo_decorator(a_func):
    def wrapper_func():
        print("before func invoked....")
        a_func()
        print("after func invoked.....")
    return wrapper_func

def add():
    print("add it")

decorated_func = demo_decorator(add)
decorated_func()

```
使用python decorator来进行更方便的编写,使用***@***可以起到和上例一样的效果

```python

@demo_decorator
def add_2():
    print("for decorator")

add_2()

```

这个例子有一个问题就是如果使用:

```python
print(add_2.__name__)
```
你会发现这个函数的名字变了，但是这个是我们不是期望的，所以需要想办法解决这个问题：

```python
def wrapper_func(a_func):

    @wraps(a_func)
    def wrapper():
        print("before")
        a_func()
        print("after")

    return wrapper

@wrapper_func
def add_3():
    print("add 3")

print(add_3.__name__)
add_3()
```

使用了```@wraps```这个方法你就发现可以完成不改变函数名称这个任务.
但是还有一个问题就是如果有函数有参数要怎么办呢？

```python
def decorator_name(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        print("for parameters ....")
        return f(*args, **kwargs)

    return decorated

@decorator_name
def add_4(a,b):
    print(a+b)

add_4(12,34)
```



"""
from functools import wraps


def hi(name="world"):
    def name_it(prefix):
        return prefix + name

    return name_it("prefix")


print(hi("world"))

func = hi
print(func("use func"))


def demo_decorator(a_func):
    def wrapper_func():
        print("befor func invoked....")
        a_func()
        print("after func invoked.....")

    return wrapper_func


def add():
    print("add it")


decorated_func = demo_decorator(add)
decorated_func()


@demo_decorator
def add_2():
    print("for decorator")


add_2()
print(add_2.__name__)  # overrider the function name but we don't want


def wrapper_func(a_func):
    @wraps(a_func)
    def wrapper():
        print("before")
        a_func()
        print("after")

    return wrapper


@wrapper_func
def add_3():
    print("add 3")


print(add_3.__name__)
add_3()


def decorator_name(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        print("for parameters ....")
        print(f.__name__)
        return f(*args, **kwargs)

    return decorated


@decorator_name
def add_4(a, b):
    print(a + b)


add_4(12, 34)

## decorate class