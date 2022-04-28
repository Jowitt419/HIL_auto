class Gentor(object):
    
    def __init__(self):
        self.out_fp = r'C:/Users/jiahui/Desktop/HIL NI/HIL_auto/TestStand_log/ts_log.tdms'
        self.out_png = r'C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL试验结果示例.png'
        self.docx_fp = r'C:/Users/jiahui/Desktop/HIL NI/HIL_auto/HIL试验报告示例.docx'
        self.df = pd.DataFrame()
    def plt_HIL(self):
        df_raw = pd.DataFrame()
        with td.open(self.out_fp) as tdms_file:
            print(tdms_file)
            metadata = td.read_metadata(self.out_fp)
            df_pro = pd.DataFrame([metadata.properties.values()], columns=metadata.properties.keys())
            df_raw = td(self.out_fp).as_dataframe()
            def postprocessing(df_raw, rate):
                col1 = df_raw.columns.to_list()
                # col2 = [n.replace('/\'VeriStand Channels\'/\'Aliases/', '').replace('\'', '') for n in col1]
                col2 = [re.sub(r'^.*Aliases/', '', n).replace('\'', '') for n in col1]#

                df_out = df_raw.rename(columns = dict(zip(col1, col2)))
                df_out['time'] = df_out.index*1/rate
                return df_out
            df = postprocessing(df_raw, rate = df_pro['Specified Rate [Hz]'][0])
            
        fig = plt.figure(figsize = (6, 5), dpi = 200)
        gs = fig.add_gridspec(2,1, height_ratios=(2,1), hspace=0)
        ax1 = fig.add_subplot(gs[0])
        ax1.plot(df['time'], df['DesiredRPM'], color = 'green', label = 'DesiredRPM')
        ax1.plot(df['time'], df['ActualRPM'], color = 'blue', label = 'ActualRPM')
        ax1.set_ylabel('Engine RPM', fontsize = 12)
        plt.xticks(fontsize = 12)
        plt.yticks(fontsize = 12)
        plt.legend(loc = 'best', fontsize = 12)
        plt.grid()
        
        ax2 = fig.add_subplot(gs[1])
        ax2.plot(df['time'], df['EngineTemp'], color = 'orange', label = 'EngineTemp')
        ax2.set_ylabel('EngineTemp °C', fontsize = 12)
        ax2.set_xlabel('time (s)', fontsize = 12)
        plt.xticks(fontsize = 12)
        plt.yticks(fontsize = 12)
        plt.legend(loc = 'best', fontsize = 12)
        plt.grid()
        plt.suptitle('HIL试验结果示例', fontsize = 14)
        plt.savefig(fname = self.out_png)
        self.df = df
        return True