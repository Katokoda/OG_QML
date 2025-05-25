# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from pValues import pVal
from pValues import InterPVal
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant
from Plane import intFromPlane
from Plane import planeFromInt

import params as p

class ContextActivity(QObject):
    contextActivityChangeSignal = pyqtSignal()

    def __init__(self, activity, score, flags, isRecommended):
        super().__init__()
        self.myAct = activity
        self.score = score
        self.flags = flags
        self.isRecommended = isRecommended

    def __repr__(self):
        return f"ContextActivity({self.myAct.name}, {self.score}, {self.flags}, {self.isRecommended})"
    
    


    
def tests():
    print("No tests for ContextActivity")
    
if __name__=="__main__":
    tests()