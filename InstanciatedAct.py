# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from Activity import ActivityData
from pValues import pVal
from Library import Library
from Plane import planeFromInt

import params as p
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal

class InstanciatedActData:
    def __init__(self, activityData:ActivityData, pstate):
        self.actData = activityData
        self.start, self.end, self.time = self.actData.what_from(pstate)
        self.plane_ = self.actData.defPlane
    
    def __repr__(self):
        string = "InstAct of " + p.FORMAT_NAME.format(self.actData.name) + " from "
        string += str(self.start) + " to " + str(self.end)
        string += "(" + str(self.time) + "')"
        string += " on " + planeFromInt(self.plane_)
        return string
    
    def __getstate__(self):
        # https://stackoverflow.com/questions/1939058/simple-example-of-use-of-setstate-and-getstate
        out = self.__dict__.copy()
        del out["QTObjectNotVisibleFromPickle"]
        return out
    
    def adjust(self, pNew, notDefTime = None):
        # Modify the start and end pValues given a new starting-position
        self.start, self.end, self.time = self.actData.what_from(pNew, notDefTime)
        #self.instActChangeSignal.emit() # This will bug but it is trouble for later

    def getQtObject(self):
        # Returns a PyQt6 object to be used in the GUI
        self.QTObjectNotVisibleFromPickle = InstanciatedAct(self)
        return self.QTObjectNotVisibleFromPickle

class InstanciatedAct(QObject):
    instActChangeSignal = pyqtSignal()

    def __init__(self, data:InstanciatedActData):
        super().__init__()
        self.data = data
    
    def __repr__(self):
        return str(self.data)
    
    @pyqtProperty(int, notify=instActChangeSignal)
    def myTime(self):
        return self.data.time
    
    @pyqtProperty(int, notify=instActChangeSignal)
    def plane(self):
        return self.data.plane_
    
    @pyqtProperty(str, notify=instActChangeSignal)
    def label(self):
        return self.data.actData.name
    
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