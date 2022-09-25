import pytest
# 登录参数
data = [('anjing', 'anjing_pwd'), ('test', 'test_pwd'), ('admin', 'admin_pwd')]

class Test_01:
    # 通过parametrize进行参数化
    @pytest.mark.parametrize('user,pwd', data, ids=['user name is anjing','user name is test','user name is admin'])
    def test_01(self, user,pwd):
        print('---用例01---')
        print('登录的用户名：%s' % user)
        print('登录的密码：%s' % pwd)
        
    def test_02(self):
        print('---用例02---')
        
if __name__ == '__main__':
    pytest.main(['-vs', './test.py'])