import unittest
from mathfunc import *
#%%
class TestMathFunc(unittest.TestCase):

    # TestCase基类方法,所有case执行之前自动执行
    @classmethod
    def setUpClass(cls):
        print("所有测试准备")

    # TestCase基类方法,所有case执行之后自动执行
    @classmethod
    def tearDownClass(cls):
        print("所有测试清理")

    # TestCase基类方法,每次执行case前自动执行
    def setUp(self):
        print("单元准备")

    # TestCase基类方法,每次执行case后自动执行
    def tearDown(self):
        print("单元清理")

    @unittest.skip("我想临时跳过这个测试用例.")
    def test_add(self):
        self.assertEqual(3, add(1, 2))
        print("看到这里，说明test_add没有跳过！")
        self.assertNotEqual(3, add(2, 2))  # 测试业务方法add

    def test_minus(self):
        print("看到这里，说明test_minus进来了一下")
        self.skipTest('跳过这个测试用例')
        print("看到这里，说明test_minus没有跳过！")
        self.assertEqual(1, minus(3, 2))  # 测试业务方法minus

    def test_multi(self):
        print("看到这里，说明test_multi没有跳过！")
        self.assertEqual(6, multi(2, 3))  # 测试业务方法multi

    def test_divide(self):
        print("看到这里，说明test_divide没有跳过！")
        self.assertEqual(2, divide(6, 3))  # 测试业务方法divide
        self.assertEqual(2.5, divide(5, 2))
#%%
if __name__ == '__main__':
    unittest.main(verbosity=2)
    
    
    