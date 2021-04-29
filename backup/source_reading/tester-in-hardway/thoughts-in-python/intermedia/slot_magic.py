# encoding: utf-8

"""
# Slot Magic

slot just assign static amount of attribute for small class


"""
class MyClass(object):
    __slots__ = ['name', 'identifier'] # save burden on your RAM

    def __init__(self, name, identifier):
        self.name = name
        self.identifier = identifier
        self.set_up()

    def set_up(self):
        print("setup")
