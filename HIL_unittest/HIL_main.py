import unittest
from HIL_process import HILTestFunc
#from HTMLTestRunner import HTMLTestRunner
import pandas as pd
from nptdms import TdmsFile as td
# import os
import glob
#%%
from Data_Analy import Data_2_Report
#%%
if __name__ == '__main__':
    suite = unittest.TestSuite()
    tests = [HILTestFunc("test_vib")]   
    suite.addTests(tests)   
    # suite.addTest(TestMathFunc("test_multi"))  # 直接用addTest方法添加单个TestCase
    
    # test report to txt
    with open('UnittestTextReport.txt', 'a') as f:
        runner = unittest.TextTestRunner(stream=f, verbosity=2)
        runner.run(suite)
    
    
    out_fp = glob.glob('*.tdms')[0]
    time_now = out_fp[5:16]
    df_raw = pd.DataFrame()
    with td.open(out_fp) as tdms_file:
        print('Reading ' + out_fp)
        metadata = td.read_metadata(out_fp)
        df_pro = pd.DataFrame([metadata.properties.values()], 
                              columns=metadata.properties.keys())
        df_raw = td(out_fp).as_dataframe()
        
    if len(df_raw):
        dr = Data_2_Report(df_raw = df_raw, rate = df_pro['Specified Rate [Hz]'][0], 
                       out_png = './HIL试验结果示例' + time_now + '.png', #C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_unittest
                       docx_fp = './' + time_now + 'HIL试验报告示例.docx')
        dr.postprocessing()
        dr.plot_HIL()
        dr.create_docx()
    else:
        print('No data in tmds file!')
        