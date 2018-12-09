# Complete this function to return either
# "Hello, [name]!" or "Hello there!"
# based on the input

def say_hello(name):
    if name != '':
        print('Hello, ' + name + '!')
    else:
        print('Hello there!')

    result = ('Hello, ' + name + '!')

    return result

# In other script
import unittest


class Test(unittest.TestCase):
    def test_should_say_hello(self):
        self.assertEqual(say_hello("Qualified"), "Hello, Qualified!")
