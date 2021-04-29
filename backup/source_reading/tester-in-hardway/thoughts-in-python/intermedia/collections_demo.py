# encoding: utf-8


"""
# Collections

- defaultdict
- OrderedDict
- Counter
- deque
- namedtuple
- enum.Enum


"""
from collections import defaultdict, deque, namedtuple

colours = (
    ('Yasoob', 'Yellow'),
    ('Ali', 'Blue'),
    ('Arham', 'Green'),
    ('Ali', 'Black'),
    ('Yasoob', 'Red'),
    ('Ahmed', 'Silver'),
)

favourite_colours = defaultdict(list)
for name, colour in colours:
    favourite_colours[name].append(colour)

print(favourite_colours)

tree = lambda: defaultdict(tree)
some_dict = tree()
some_dict['colours']['favourite'] = "yellow"

# Counter
# deque
d = deque()
d.append('1')
d.append('2')
d.append('3')
#namedtuple
man = ('Ali', 30)
print(man[0])

Animal = namedtuple('Animal', 'name age type')
perry = Animal(name="perry", age=31, type="cat")

print(perry)

from enum import Enum

class Species(Enum):
    cat = 1
    dog = 2
    horse = 3
    aardvark = 4
    butterfly = 5
    owl = 6
    platypus = 7
    dragon = 8
    unicorn = 9
    # The list goes on and on...

    # But we don't really care about age, so we can use an alias.
    kitten = 1
    puppy = 2

Animal = namedtuple('Animal', 'name age type')
perry = Animal(name="Perry", age=31, type=Species.cat)
drogon = Animal(name="Drogon", age=4, type=Species.dragon)
tom = Animal(name="Tom", age=75, type=Species.cat)
charlie = Animal(name="Charlie", age=2, type=Species.kitten)