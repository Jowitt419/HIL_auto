import unittest
from HIL_Process import HILTestFunc
import pandas as pd
from nptdms import TdmsFile as td
import glob
import os
#%%
from Data_Analy import Data_2_Report
#%%
if __name__ == '__main__':
    suite = unittest.TestSuite()
    df_config = pd.read_csv('./config.csv')
    # ======================================================
    for i in range(len(df_config)):
        test_name = df_config['test_name'][i]
        suite.addTests([HILTestFunc("test_"+test_name)])

    
    # ================== test report to txt
    with open('TextReport.txt', 'a') as f:
        runner = unittest.TextTestRunner(stream=f, verbosity=2)
        runner.run(suite)
    
    
    # ======================================================
    path=os.getcwd()
    listDir=os.listdir(path)
    out_fp_tdms = [item for item in listDir if item.endswith('.tdms')]
    out_fp = [item for item in out_fp_tdms if 'vib' in item][0]
    # ======================================================
    # ===========          post processing      ============
    # ======================================================
    
    df_raw = pd.DataFrame()
    with td.open(out_fp) as tdms_file:
        print('Reading ' + out_fp)
        metadata = td.read_metadata(out_fp)
        df_pro = pd.DataFrame([metadata.properties.values()], 
                              columns=metadata.properties.keys())
        df_raw = td(out_fp).as_dataframe()
        
    if len(df_raw):
        out_png = './HIL试验结果vib' + '.png'
        dr = Data_2_Report(df_raw = df_raw)#, rate = df_pro['Specified Rate [Hz]'][0], 
                       # , #C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_unittest
                       # )
        dr.postprocessing(rate = df_pro['Specified Rate [Hz]'][0])
        dr.plot_HIL(out_png = out_png)
        dr.create_docx(out_png = out_png, docx_fp = './' + 'HIL试验报告vib.docx')# + time_now
    else:
        print('No data in tmds file!')
