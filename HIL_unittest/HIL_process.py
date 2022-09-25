import unittest
import sys
from niveristand.legacy import NIVeriStand
from niveristand.errors import RunError
from niveristand.library import wait
import time
import pandas as pd
import os

#%%
class HILTestFunc(unittest.TestCase):
    # TestCase基类方法,所有case执行之前自动执行
    @classmethod
    def setUpClass(cls):#, in_fp
        # cls.in_fp = './HIL_in.csv'#in_fp#
        # time_now = time.strftime("%m%d_%H%M%S", time.localtime())
        # cls.log_fp = 'C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_unittest/' + time_now + '.tdms'
        # df = pd.read_csv(cls.in_fp, encoding = 'utf-8', header = [0], skiprows = [1, 2])
        # df['period'] = df['timestamp'].diff().shift(periods = -1).fillna(4)
        # cls.df = df
        df_config = pd.read_csv('./config.csv')
        print(df_config)
        cls.df_config = df_config
        
        
        
        print("Start HIL test preparation~")
        GATEWAY = "localhost"
        TARGET = "Controller" 
        workspace = NIVeriStand.Workspace2(GATEWAY)
        cls.workspace = workspace
        print("Connecting to HIL Target")
        try:
            workspace.ReconnectToSystem(TARGET, True, None, 60000)
            print("Successfully connected to HIL Target")
        except RunError as e:
            print('Fail to connect to HIL Target' + e)
            # sys.exit(0)
        Alias_dict = workspace.GetAliasList()
        cls.Alias_dict = Alias_dict
        print("Getting AliasList")
        
    # TestCase基类方法,所有case执行之后自动执行
    @classmethod
    def tearDownClass(cls):
        workspace = cls.workspace
        # workspace.DisconnectFromSystem('', True)
        print('Disconnect from target~')
        print("Clean up completed")
        
    # TestCase基类方法,每次执行case前自动执行
    def setUp(cls):  
        print("Unit test setup")
        print("Engine power up")
        workspace = cls.workspace
        # workspace.SetSingleChannelValue('Aliases/EnginePower', False)
        workspace.SetSingleChannelValue('Aliases/DesiredRPM',0)
        workspace.SetSingleChannelValue('Aliases/EnginePower', True)
    
    
    # TestCase基类方法,每次执行case后自动执行
    def tearDown(cls):
        workspace = cls.workspace
        print('Wait for 5 sec then shut down')
        workspace.SetSingleChannelValue('Aliases/EnginePower', False)
        workspace.SetSingleChannelValue('Aliases/DesiredRPM', 0)
        wait(5)
        print("Unit test completed")
        
        
    def test_vib(cls):
        print("==============")
        print("VIB TEST START")
        print("==============")
        time_now = time.strftime("%m%d_%H%M%S", time.localtime())
        df_tmp = cls.df_config
        cls.log_fp = os.getcwd() + '\\' + df_tmp.loc[df_tmp['test_name'] == 'vib', 'log_fp'].values[0]
        cls.log_fp = cls.log_fp.replace('.tdms', '-'+time_now+'.tdms')
        print(cls.log_fp)
        cls.in_fp = df_tmp.loc[df_tmp['test_name'] == 'vib', 'in_fp'].values[0]
        print(cls.in_fp)
        
        # cls.in_fp = './HIL_in.csv'#in_fp#
        # cls.log_fp = 'C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_unittest/' + time_now + '.tdms'
        df = pd.read_csv(cls.in_fp, encoding = 'utf-8', header = [0], skiprows = [1, 2])
        df['period'] = df['timestamp'].diff().shift(periods = -1).fillna(4)
        cls.df = df
        
        
        print("start to create log")
        log_info = NIVeriStand.CreateLogInfo()
        log_info.file_path = cls.log_fp#'VeriStand.tdms'#
        log_info.description = "Engine demo logging"
        log_info.rate = 1000/5
        channels_paths_to_log = [
            "Aliases/EnginePower",
            "Aliases/DesiredRPM",
            "Aliases/ActualRPM",
            "Aliases/EngineTemp"]
        channels_to_log = [NIVeriStand.CreateLogChannel(path) for path in channels_paths_to_log]
        NIVeriStand.SetLogInfoChannels(log_info, channels_to_log)
        cls.log_info = log_info
        
        workspace = cls.workspace
        log_info = cls.log_info
        df = cls.df
        workspace.StartDataLogging(configuration_name = 'Logging', logInfo = log_info)
        for i in range(len(df)):
            workspace.SetMultipleChannelValues(['Aliases/DesiredRPM', 'Aliases/EnginePower'],
                                               [df['N1(rpm)'][i], True])
            wait(df['period'][i])
        workspace.StopDataLogging(configuration_name = 'Logging')
        print("stop log")
        
        # pt_ActualRPM = workspace.GetSingleChannelValue('Aliases/ActualRPM')
        # pt_array = workspace.GetMultipleChannelValues(['Aliases/ActualRPM', 'Aliases/EngineTemp'])
        # pt_what = workspace.GetChannelVectorValues('Aliases/ActualRPM')
        # Alias_dict = cls.Alias_dict
        # out_list = [Alias_dict, pt_ActualRPM, pt_array, pt_what]
        print("==============")
        print("VIB TEST SUCCESS")
        print("==============")
    def test_start(cls):
        print("==============")
        print("START TEST START")
        print("==============")
        time_now = time.strftime("%m%d_%H%M%S", time.localtime())
        df_tmp = cls.df_config
        cls.log_fp = os.getcwd() + '\\' + df_tmp.loc[df_tmp['test_name'] == 'start', 'log_fp'].values[0]
        cls.log_fp = cls.log_fp.replace('.tdms', '-'+time_now+'.tdms')
        print(cls.log_fp)
        cls.in_fp = df_tmp.loc[df_tmp['test_name'] == 'start', 'in_fp'].values[0]
        print(cls.in_fp)
        
        df = pd.read_csv(cls.in_fp, encoding = 'utf-8', header = [0], skiprows = [1, 2])
        df['period'] = df['timestamp'].diff().shift(periods = -1).fillna(4)
        cls.df = df
        
        
        print("start to create log")
        log_info = NIVeriStand.CreateLogInfo()
        log_info.file_path = cls.log_fp#'VeriStand.tdms'#
        log_info.description = "Engine demo logging"
        log_info.rate = 1000/5
        channels_paths_to_log = [
            "Aliases/EnginePower",
            "Aliases/DesiredRPM",
            "Aliases/ActualRPM",
            "Aliases/EngineTemp"]
        channels_to_log = [NIVeriStand.CreateLogChannel(path) for path in channels_paths_to_log]
        NIVeriStand.SetLogInfoChannels(log_info, channels_to_log)
        cls.log_info = log_info
        
        workspace = cls.workspace
        log_info = cls.log_info
        df = cls.df
        workspace.StartDataLogging(configuration_name = 'Logging', logInfo = log_info)
        for i in range(len(df)):
            # workspace.SetSingleChannelValue('Aliases/DesiredRPM', df['N1(rpm)'][i])
            workspace.SetMultipleChannelValues(['Aliases/DesiredRPM', 'Aliases/EnginePower'],
                                               [df['N1(rpm)'][i], True])
            wait(df['period'][i])
        workspace.StopDataLogging(configuration_name = 'Logging')
        print("stop log")
        print("==============")
        print("START TEST SUCCESS")
        print("==============")
#%%
if __name__ == '__main__':
    unittest.main(verbosity=2)
    
    
    