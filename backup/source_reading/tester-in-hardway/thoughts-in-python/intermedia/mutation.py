# encoding: utf-8

def add_to_mutable(num, target=[]):
    target.append(num)
    return target

def add_to(element, target=None):
    if target is None:
        target = []
    target.append(element)
    return target