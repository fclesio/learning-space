import unittest

from my_sum import say_hello
from my_sum import sum_int


class Test(unittest.TestCase):
    def test_should_say_hello(self):
        """
        Test that it can present data in the correct format
        """
        self.assertEqual(say_hello("Test"), "Hello, Test!")


class TestSum(unittest.TestCase):
    def test_list_int(self):
        """
        Test that it can sum a list of integers
        """
        data = [1, 2, 3]
        result = sum_int(data)
        self.assertEqual(result, 6)


if __name__ == '__main__':
    unittest.main()
