# encoding: utf-8

"""
# Generators

- iterator: enable to traverse a container
  * iterable
  * iterator
  * iteration
- generator

## Iterable/Iterator/Iteration

***Iterable***:
- __iter__ and __getitem__
- return iterator
- any object provide an iterator

***Iterator***
- __next__

***Iteration***
A process of taking an item from something.

## Generator
Generators are iterators. 但是你只能iterate 一次，generator不会存储所有值到内存
- 大部分情况generator像函数一样使用
- yield it

下面例子表示了Generator的使用, generator yield出来一次，外面的print就执行一次,next函数可以对iterator使用，
因为iterator都有一个__next__()方法

```python
def simple_generator_func():
    for index in range(10):
        yield index

g = simple_generator_func()
print(next(g))
print(next(g))
for item in simple_generator_func():
    print(item)
```

next for a iterator:

```python
print(next(iter("thisis"))
```

"""



def simple_generator_func():
    for index in range(10):
        yield index


g = simple_generator_func()
print(next(g))
print(next(g))
for item in simple_generator_func():
    print(item)


def fibon(n):
    a = b = 1
    for i in range(n):
        yield a
        a, b = b, b + a


for x in fibon(10000):
    print(x)


print(next(iter("thisis")))