# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant

class FlagContainer(QObject):
    def __init__(self, list):
        super().__init__()
        self.exhausted = "tooM" in list
        self.tooLong = "long" in list
        self.worse = "isPast" in list

    flagChangeSignal = pyqtSignal()
    
    @pyqtProperty(bool, notify=flagChangeSignal)
    def isExhausted(self):
        return self.exhausted
    
    @pyqtProperty(bool, notify=flagChangeSignal)
    def isTooLong(self):
        return self.tooLong
    
    @pyqtProperty(bool, notify=flagChangeSignal)
    def isWorse(self):
        return self.worse
    
    def __repr__(self):
        return f"FlagContainer(exhausted={self.exhausted}, tooLong={self.tooLong}, worse={self.worse})"



class ContextActivity(QObject):
    contextActivityChangeSignal = pyqtSignal()

    def __init__(self, activity, score, flags, isRecommended):
        super().__init__()
        self.myAct = activity
        self.myScore = score
        self.myFlags = FlagContainer(flags)
        self.isRecommended = isRecommended

    def __repr__(self):
        return f"ContextActivity({self.myAct.name}, {self.myScore}, {self.myFlags}, {self.isRecommended})"
    
    @pyqtProperty(QObject, notify=contextActivityChangeSignal)
    def activity(self):
        return self.myAct
    
    @pyqtProperty(QObject, notify=contextActivityChangeSignal)
    def flags(self):
        return self.myFlags
    
    @pyqtProperty(float, notify=contextActivityChangeSignal)
    def efficiencyDEBUG(self):
        return self.myScore


    
def tests():
    print("No tests for ContextActivity")
    
if __name__=="__main__":
    tests()