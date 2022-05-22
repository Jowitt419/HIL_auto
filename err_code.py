# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
#%%
def convert_hex_2_dec(string):
    a = int(string, 16) - 16 ** 8
    print(a)
    return a
a = convert_hex_2_dec(string = '0x6')
#%%

