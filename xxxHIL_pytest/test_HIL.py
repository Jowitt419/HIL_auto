import pytest
from niveristand.legacy import NIVeriStand
from niveristand.errors import RunError
from niveristand.library import wait
import pandas as pd    
# import time
# time_now = time.strftime("%m%d_%H%M%S", time.localtime())
# config_data = [('./HIL_in.csv', #C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_pytest
#                     './vib_' + time_now + '.tdms')]#C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_pytest/
#%%
class Test_HIL():
    '''Based on Pytest Framework to build Class Test_HIL'''
    # HIL setup preparation
    # @pytest.mark.parametrize('in_fp, log_fp', config_data)
    def setup_class(self):#, in_fp, log_fp):
        df_config = pd.read_csv('./config.csv')
        self.df_config = df_config
        print(df_config)
        
        print("Start HIL test preparation~")
        GATEWAY = "localhost"
        TARGET = "Controller" 
        workspace = NIVeriStand.Workspace2(GATEWAY)
        self.workspace = workspace
        print("Connecting to HIL Target")
        try:
            workspace.ReconnectToSystem(TARGET, True, None, 60000)
            print("Successfully connected to HIL Target")
        except RunError as e:
            print('Fail to connect to HIL Target' + e)
            # sys.exit(0)
        Alias_dict = workspace.GetAliasList()
        self.Alias_dict = Alias_dict
        print("Getting AliasList")
        
    # HIL Clean-up after test execution
    def teardown_class(self):
        # self.workspace.DisconnectFromSystem('', True)
        print('Disconnect from target~')
        print("Clean up completed")
        
    # TestCase基类方法,每次执行case前自动执行
    def setup(self):   
        print("Unit test setup")
        print("Engine power up")
        workspace = self.workspace
        # workspace.SetSingleChannelValue('Aliases/EnginePower', False)
        workspace.SetSingleChannelValue('Aliases/DesiredRPM',0)
        workspace.SetSingleChannelValue('Aliases/EnginePower', True)
    
    
    # TestCase基类方法,每次执行case后自动执行
    def teardown(self):
        print('Wait for 5 sec then shut down')
        self.workspace.SetSingleChannelValue('Aliases/EnginePower', False)
        self.workspace.SetSingleChannelValue('Aliases/DesiredRPM', 0)
        wait(5)
        print("Unit test completed")
        
    # @pytest.mark.parametrize('in_fp, log_fp', config_data)
    def test_vib(self):#, in_fp, log_fp
        # time_now = time.strftime("%m%d_%H%M%S", time.localtime())
        # self.log_fp = log_fp#'C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_pytest/' + time_now + '.tdms'
        # self.in_fp = in_fp#in_fp#
        df_tmp = self.df_config
        self.log_fp = df_tmp.loc[df_tmp['test_name'] == 'vib', 'log_fp'].values[0]
        print(self.log_fp)
        self.in_fp = df_tmp.loc[df_tmp['test_name'] == 'vib', 'in_fp'].values[0]
        print(self.in_fp)
        
        
        df = pd.read_csv(self.in_fp, encoding = 'utf-8', header = [0], skiprows = [1, 2])
        df['period'] = df['timestamp'].diff().shift(periods = -1).fillna(4)
        self.df = df
        
        
        
        print("Start to create log")
        log_info = NIVeriStand.CreateLogInfo()
        log_info.file_path = self.log_fp#'VeriStand.tdms'#
        log_info.description = "Engine demo logging"
        log_info.rate = 10
        channels_paths_to_log = [
            "Aliases/EnginePower",
            "Aliases/DesiredRPM",
            "Aliases/ActualRPM",
            "Aliases/EngineTemp"]
        channels_to_log = [NIVeriStand.CreateLogChannel(path) for path in channels_paths_to_log]
        NIVeriStand.SetLogInfoChannels(log_info, channels_to_log)
        self.log_info = log_info

        
        # print("Unit test start: "+str(self.in_fp))
        # df = self.df
        # self.workspace.StartDataLogging(configuration_name = 'Logging', logInfo = log_info)
        # for i in range(len(df)):
        #     # workspace.SetSingleChannelValue('Aliases/DesiredRPM', df['N1(rpm)'][i])
        #     self.workspace.SetMultipleChannelValues(['Aliases/DesiredRPM', 'Aliases/EnginePower'], # Aliases/EnvTemp
        #                                        [df['N1(rpm)'][i], True])
        #                                        # [df['N1(rpm)'][i], df['EnvTemp'][i]])
        #     wait(df['period'][i])
        # self.workspace.StopDataLogging(configuration_name = 'Logging')
        
        
        
        
        
        workspace = self.workspace
        log_info = self.log_info
        df = self.df
        workspace.StartDataLogging(configuration_name = 'Logging', logInfo = log_info)
        print('start_logging')
        for i in range(len(df)):
            # workspace.SetSingleChannelValue('Aliases/DesiredRPM', df['N1(rpm)'][i])
            workspace.SetMultipleChannelValues(['Aliases/DesiredRPM', 'Aliases/EnginePower'],
                                               [df['N1(rpm)'][i], True])
            wait(df['period'][i])
        workspace.StopDataLogging(configuration_name = 'Logging')
        print('stop_logging')
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        pt_ActualRPM = self.workspace.GetSingleChannelValue('Aliases/ActualRPM')
        pt_array = self.workspace.GetMultipleChannelValues(['Aliases/ActualRPM', 'Aliases/EngineTemp'])
        pt_what = self.workspace.GetChannelVectorValues('Aliases/ActualRPM')
        Alias_dict = self.Alias_dict
        out_list = [Alias_dict, pt_ActualRPM, pt_array, pt_what]
        print("Unit test success")
        
    # @unittest.skip("skip for now")
    # def test_add(self):
    #     self.assertEqual(3, add(1, 2))
    #     print("看到这里，说明test_add没有跳过！")
    #     self.assertNotEqual(3, add(2, 2))  # 测试业务方法add

    # def test_minus(self):
    #     print("看到这里，说明test_minus进来了一下")
    #     self.skipTest('跳过这个测试用例')
    #     print("看到这里，说明test_minus没有跳过！")
    #     self.assertEqual(1, minus(3, 2))  # 测试业务方法minus

    # def test_multi(self):
    #     print("看到这里，说明test_multi没有跳过！")
    #     self.assertEqual(6, multi(2, 3))  # 测试业务方法multi

    # def test_divide(self):
    #     print("看到这里，说明test_divide没有跳过！")
    #     self.assertEqual(2, divide(6, 3))  # 测试业务方法divide
    #     self.assertEqual(2.5, divide(5, 2))
#%%
if __name__ == '__main__':
    
    pytest.main(["-s", "test_HIL.py"])
    
    
    