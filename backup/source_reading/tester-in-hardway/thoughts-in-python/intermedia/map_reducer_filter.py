"""
# Map,filter and Reduce
三个函数是编程的函数：
- map
- filter
- reduce

## Map

如果我们想给一个列表中所有的值加倍，python常用实现：

```python
items=[1,2,3,4,5]
squard=[]
for i in items:
    squard.append(i*2)
```

如果使用map的话：

```python
squared_map = list(map(lambda x:x*2,items))
```

## filter

filter通过函数过滤满足条件的值,下例子就是过掉所有大于0的值，filter是通过传递函数过滤值

```python
print(list(filter(lambda x:x<0,range(-1,9)))
```

上例子使用了lambda 来表示匿名函数，也可以通过自定义函数过滤,只需要将x<0定义为一个函数就可以


## reduce

Reduce用来计算连续的两个值，如下例子：

***不实用Reducer***

```python
product = 1
list = [1, 2, 3, 4]

for num in list:
    product = product * num
```

使用Reducer:

```python
def multipy_two(x,y):
    print("start multipy {0} and {1}".format(x,y))
    return x*y

result = reduce(multipy_two,list)
print(result)

```
如果只使用一句：

```python
print(reduce((lambda x, y: x * y), list))
```

"""
from functools import reduce

items = [1, 2, 3, 4, 5]
squared = []
for i in items:
    squared.append(i * 2)

print(squared)
squared_map = list(map(lambda x: x * 2, items))
print(squared_map)


def multiply(x):
    return x * x


def add(x):
    return x + x


funcs = [multiply, add]
for index in range(6):
    value = list(map(lambda x: x(index), funcs))
    print(value)

print(list(filter(lambda x: x < 0, range(-1, 9))))

product = 1
list = [1, 2, 3, 4]

for num in list:
    product = product * num


def multipy_two(x, y):
    print("start multipy {0} and {1}".format(x, y))
    return x * y


result = reduce(multipy_two, list)
print(result)

print(reduce((lambda x, y: x * y), list))
