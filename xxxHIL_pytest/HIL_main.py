import pytest
import pandas as pd
from nptdms import TdmsFile as td
import glob
import time
from Data_Analy import Data_2_Report
#%%
if __name__ == '__main__':
    df_config = pd.read_csv('./config.csv')
    
    
    # time_now = time.strftime("%m%d_%H%M%S", time.localtime())
    test_name = 'vib'
    pytest.main(["-s", "./test_HIL.py"])
    out_fp = df_config.loc[df_config['test_name'] == test_name, 'log_fp'].values[0]
    
    
    
    df_raw = pd.DataFrame()
    with td.open(out_fp) as tdms_file:
        print('Reading ' + out_fp)
        metadata = td.read_metadata(out_fp)
        df_pro = pd.DataFrame([metadata.properties.values()], 
                              columns=metadata.properties.keys())
        df_raw = td(out_fp).as_dataframe()
        
    if len(df_raw):
        out_png = './HIL试验结果示例' + test_name + '.png'
        dr = Data_2_Report(df_raw = df_raw)#, rate = df_pro['Specified Rate [Hz]'][0], 
                       # , #C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL_unittest
                       # )
        dr.postprocessing(rate = df_pro['Specified Rate [Hz]'][0])
        dr.plot_HIL(out_png = out_png)
        dr.create_docx(out_png = out_png, docx_fp = './' + test_name + 'HIL试验报告示例.docx')
    else:
        print('No data in tmds file!')
        