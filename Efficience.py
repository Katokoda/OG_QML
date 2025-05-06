# -*- coding: utf-8 -*-
"""
Created on Tue Mar 11 13:39:49 2025

@author: Samuel
"""


import params as p

def leftTime_over_leftDistance(d, d1, d2, actTime, remTime):
    #print("details", (remTime - actTime), (d1 + d2))
    leftDistance = (d1 + d2)
    if leftDistance < p.TRESHOLD:
        leftDistance = p.TRESHOLD/100
        #print("new leftDistance = ", leftDistance)
    return (remTime - actTime)/leftDistance

def distanceDone_over_usedTime(d, d1, d2, actTime, remTime):
    return (d - d1 - d2)/actTime

def random(d, d1, d2, actTime, remTime):
    if (d1 + d2 < d):
        return 1
    else:
        return 0
    
def distanceDone(d, d1, d2, actTime, remTime):
    return (d - d1 - d2)

def getEff(d, d1, d2, actTime, remTime):
    return distanceDone(d, d1, d2, actTime, remTime) 