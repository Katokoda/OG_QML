# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from Activity import Activity
from ContextActivity import ContextActivity
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant


class Library(QObject):
    libraryChangedSignal = pyqtSignal()


    def __init__(self, nameOfFile):
        super().__init__()
        with open(nameOfFile) as inputFile:
            data = inputFile.readlines()
            data = data[1:] #removing the headline

            self.liste = []
            idx = 0
            for line in data:
                self.liste.append(Activity(line.strip(), idx))
                idx += 1
            
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
    
def tests():
    print("testing Activities")
    print("See file InstanciatedAct.py instead")
if __name__=="__main__":
    tests()