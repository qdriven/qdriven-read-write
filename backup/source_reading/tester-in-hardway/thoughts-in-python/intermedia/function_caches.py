# encoding: utf-8


from functools import lru_cache

@lru_cache(maxsize=320)
def fib(n):
    if n < 2:
        return n
    return fib(n-1) + fib(n-2)

print([fib(n) for n in range(100)])

print(fib(100))
fib.cache_clear()