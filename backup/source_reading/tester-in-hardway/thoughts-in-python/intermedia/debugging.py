# encoding: utf-8
import pdb


def learn_debug_pdb(arg):
    pdb.set_trace()
    print(arg)
    return  "pdb debugging"

print(learn_debug_pdb("this is arg"))