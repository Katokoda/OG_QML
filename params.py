# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 14:27:39 2025

@author: Samuel
"""

PRECISION = 0.01 # to avoid saying "not reached" when 0.00001 from goal.
TRESHOLD = 0.05 # Should depend of the dimensionality.
                # Another way to do is to restrict bigger difference
   
# left-aligning with https://stackoverflow.com/questions/14776788/how-can-i-pad-a-string-with-spaces-from-the-right-and-left
FORMAT_NAME = '{:>15}'
FORMAT_PVAL = '{:^12}'
FORMAT_TIME = '{:>2}'
FORMAT_DIST = '{:<6}'
FORMAT_NUMB = '{:>5}'

NUMBER_PRINT = ["first", "secnd", "third"]
NUMBER_PRINT.extend([FORMAT_NUMB.format(str(x)+"th") for x in range(4, 100)])


SELECT_ACT_VERBOSE = False


def tests():
    print("testing params")
    print("no test yet implemented")
    
if __name__=="__main__":
    tests()