# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 14:27:39 2025

@author: Samuel
"""

import os
#os.system('color')

PRECISION = 0.01 # to avoid saying "not reached" when 0.00001 from goal.
TRESHOLD = 0.05 # Should depend of the dimensionality.
                # Another way to do is to restrict bigger difference
                
COLORS_DEPTH = ["black", "red", "orange", "yellow", "lime", "green", "blue", "cyan", "purple", "magenta", "pink"]
COLORS_DEPTH.extend(["gray"]*100)

# left-aligning with https://stackoverflow.com/questions/14776788/how-can-i-pad-a-string-with-spaces-from-the-right-and-left
FORMAT_NAME = '{:>15}'
FORMAT_PVAL = '{:^12}'
FORMAT_TIME = '{:>2}'
FORMAT_DIST = '{:<6}'
FORMAT_NUMB = '{:>5}'

NUMBER_PRINT = ["first", "secnd", "third"]
NUMBER_PRINT.extend([FORMAT_NUMB.format(str(x)+"th") for x in range(4, 100)])


SELECT_ACT_VERBOSE = False


C_PURPLE = '\033[95m'
C_BLUE = '\033[94m'
C_CYAN = '\033[96m'
C_GREEN = '\033[92m'
C_WARNING = '\033[93m'
C_FAIL = '\033[91m'
C_ENDC = '\033[0m'
C_UNDERLINE = '\033[4m'


def tests():
    print("testing params")
    print("no test yet implemented")
    
if __name__=="__main__":
    tests()