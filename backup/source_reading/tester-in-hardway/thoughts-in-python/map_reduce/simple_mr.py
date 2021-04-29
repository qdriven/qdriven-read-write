# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     simple_mr
   Description :
   Author :        patrick
   date：          2019/6/2
-------------------------------------------------
   Change Activity:
                   2019/6/2:
-------------------------------------------------
"""
import time
from collections import Counter
from functools import reduce
from multiprocessing.pool import Pool

__author__ = 'patrick'

"""
MR stands for Map-Reduce
"""


def read_inputs(file_path):
    with open(file_path, 'r') as source:
        for line in source:
            line = line.strip()
            yield line.split()


def count_word_job(file_path):
    lines = read_inputs(file_path)
    c = Counter()
    for words in lines:
        for word in words:
            c[word] += 1
    return c


def count_reducer(job_list=None):
    if job_list is None:
        return dict()

    pool = Pool(20)
    return reduce(lambda x, y: x + y, pool.map(count_word_job, job_list))


if __name__ == '__main__':
    job_list=['log.txt','log2.txt']*5000
    print(time.time())
    result = count_reducer(job_list=job_list)
    print(result)
    print(time.time())
