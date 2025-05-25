# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from Activity import Activity
from Efficience import getEff
from ContextActivity import ContextActivity
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant


class Library(QObject):
    libraryChangedSignal = pyqtSignal()


    def __init__(self, nameOfFile):
        super().__init__()
        with open(nameOfFile) as inputFile:
            data = inputFile.readlines()
            data = data[1:] #removing the headline
            self.liste = [Activity(line.strip()) for line in data]
            
    def __str__(self):
        res = ""
        for val in self.liste:
            res += str(val) + "\n"
        return res

    
    @pyqtProperty(QVariant, notify=libraryChangedSignal)
    def listeProp(self):
        return self.liste
    
    def getAct(self, number):
        if len(self.liste) < number:
            print("Error in getAct,", number, "out of range")
        return self.liste[number]
    
    def evaluateFor(self, start, goal, OG, remTime):
        result = []
        d = start.distance_onlyForward(goal)
        
        for i in range(len(self.liste)):
            flags = OG.getStatus(i)
            act = self.getAct(i)
            wouldStart, wouldEnd, _ = act.what_from(start)
            d1 = start.distance_onlyForward(wouldStart)
            d2 = wouldEnd.distance_onlyForward(goal)
            if wouldStart.isPast(goal):
                flags.append("isPast")
            efficiency = getEff(d, d1, d2, act.defT, remTime)
            result.append(ContextActivity(act, efficiency, flags, (len(flags) == 0)))
        return result

    
def tests():
    print("testing Activities")
    print("See file InstanciatedAct.py instead")
if __name__=="__main__":
    tests()