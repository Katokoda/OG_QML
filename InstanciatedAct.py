# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from pValues import pVal
from Library import Library

import params as p
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant

class InstanciatedAct(QObject):
    instActChangeSignal = pyqtSignal()

    def __init__(self, activity, pstate, notDefTime = None, rec_depth = 0):
        super().__init__()
        self.act = activity
        self.start, self.end, self.time = self.act.what_from(pstate)
        self.depth = rec_depth
    
    def __repr__(self):
        string = "InstAct of " + p.FORMAT_NAME.format(self.act.name) + " from "
        string += str(self.start) + " to " + str(self.end) + " (" + str(self.depth) + ")"
        string += "(" + str(self.time) + "')"
        return string
    
    def adjust(self, pNew, notDefTime = None):
        # Modify the start and end pValues given a new starting-position
        self.start, self.end, self.time = self.act.what_from(pNew, notDefTime)
        self.instActChangeSignal.emit()
    
    @pyqtProperty(QVariant, notify=instActChangeSignal)
    def activity(self):
        return self.act
    
    @pyqtProperty(str, notify=instActChangeSignal)
    def label(self):
        return self.act.name
    
def tests():
    print("testing Activities and Librairies")
    myLib = Library("inputData/basic_2D_library.txt")
    print(myLib)
        
        
    print("The library if all were instanciated for a class at", end = '')
    startingPValue = pVal((0.0, 0.0))
    print(startingPValue)
    liste_one = [InstanciatedAct(myLib.getAct(i), startingPValue) for i in range(len(myLib.liste))]
    [print(liste_one[i]) for i in range(len(liste_one))]
    
    print()
    print("Updated to", end = ' ')
    adjustPValue = pVal((0.15, 0.4))
    print(adjustPValue)
    for act in liste_one:
        act.adjust(adjustPValue)
        print(act)
            
    
    print()
    print("The library if all were instanciated for a class at", end = '')
    startingPValue = pVal((0.3, 0.3))
    print(startingPValue)
    liste_two = [InstanciatedAct(myLib.getAct(i), startingPValue) for i in range(len(myLib.liste))]
    [print(liste_two[i]) for i in range(len(liste_two))]
    
if __name__=="__main__":
    tests()