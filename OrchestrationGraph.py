# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

# See WARNING in OrchestrationGraph.__repr__.
#import matplotlib.pyplot as plt
#import matplotlib.patches as patches

import subprocess
import threading


from InstanciatedAct import InstanciatedAct
from ContextActivity import ContextActivity
from Efficience import getEff


import params as p
from params import NUMBER_PRINT

from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant


#For tests
import random as r
from pValues import pVal
from Library import Library
  

class OrchestrationGraph(QObject):
    ogChangeSignal = pyqtSignal()
    gapSelectionChangeSignal = pyqtSignal()

    def __init__(self, library, timeBudget, start, goal):
        super().__init__()
        self.lib = library
        self.tBudget = timeBudget
        self.start = start
        self.reached = start
        self.goal = goal
        
        self.listOfFixedInstancedAct = []
        self.quantities = [0]*len(self.lib.liste)
        self.totTime = 0

        self.gapFocus = None # Index of the gap currently selected in QML.
        self.currentListForSelectedGap = [] # REQUIRED --> Segmentation Fault
        # otherwise the QML objects references to a temporary variable

        self.setGapFocus(-1)

    def myCallerForPrintingSubprocess(self):
        print("Caller - myCallerForPrintingSubprocess - start")
        subprocess.call(['sh', './callMyPythonPrinter.sh'])
        print("Caller - myCallerForPrintingSubprocess - done")
    
    @pyqtSlot()
    def myCustomPrintFunction(self):
        t_thread = threading.Thread(target=self.myCallerForPrintingSubprocess)
        t_thread.start()
        print("MAIN - after threading continues")

        
    def __repr__(self):
        res = ""
        for iAct in self.listOfFixedInstancedAct:
            res += str(iAct) + "\n"
        return "OG printed (but not as plot):\n"\
                + res\
                + str(round(self.evaluate_gaps()[0], 4))\
                + " " + str(self.totTime) + " min (budget = "\
                + str(self.tBudget) + " min)"
    

    @pyqtProperty(QVariant, notify=ogChangeSignal)
    def listeReal(self):
        return self.listOfFixedInstancedAct
    
    def reEvaluate(self):
        if self.gapFocus == None:
            self.currentListForSelectedGap = self.evaluateGlobal()
        else:
            start = self.start if self.gapFocus == 0 else self.listOfFixedInstancedAct[self.gapFocus - 1].end
            end = self.goal if self.gapFocus == len(self.listOfFixedInstancedAct) else self.listOfFixedInstancedAct[self.gapFocus].start
            self.currentListForSelectedGap = self.evaluateFor(start, end)
        self.gapSelectionChangeSignal.emit()
    
    def evaluateGlobal(self):
        result = []
        for i in range(len(self.lib.liste)):
            flags = self.getStatus(i)
            act = self.lib.getAct(i)
            result.append(ContextActivity(act, 100, flags, (len(flags) == 0)))
        return result
    
    def evaluateFor(self, start, goal):
        result = []
        d = start.distance_onlyForward(goal)
        
        for i in range(len(self.lib.liste)):
            flags = self.getStatus(i)
            act = self.lib.getAct(i)
            wouldStart, wouldEnd, _ = act.what_from(start)
            d1 = start.distance_onlyForward(wouldStart)
            d2 = wouldEnd.distance_onlyForward(goal)
            if wouldStart.isPast(goal):
                flags.append("isPast")
            efficiency = getEff(d, d1, d2, act.defT, self.tBudget - self.totTime)
            result.append(ContextActivity(act, efficiency, flags, (len(flags) == 0)))
        return result

    @pyqtSlot(int)
    # Should always be called before listActivityForGap is required.
    def setGapFocus(self, gapIdx : int):
        if gapIdx < 0:
            self.gapFocus = None
            self.reEvaluate()
        else:
            self.gapFocus = gapIdx
            self.reEvaluate()
        self.gapSelectionChangeSignal.emit()


    @pyqtProperty(QVariant, notify=gapSelectionChangeSignal)
    def listActivityForGap(self):
        return self.currentListForSelectedGap
    
    @pyqtProperty(QVariant, notify=gapSelectionChangeSignal)
    def sortedListActivityForGap(self):
        print("WARNING - sortedListActivityForGap - not sorted")
        return self.currentListForSelectedGap[0:-1:-1]
    

    @pyqtProperty(int, notify=ogChangeSignal)
    def totalTime(self):
        return self.totTime

    @pyqtProperty(int, notify=ogChangeSignal)
    def numberPlanes(self):
        print("Python has been asked the number of planes and answered three") #TODO
        return 3
    
    @pyqtProperty(QVariant, notify=ogChangeSignal)
    def labelPlanes(self):
        print("Python has been asked the labels of planes and answered hard-written list") #TODO
        return ["Indiv.", "Team", "Class"]

    def create(self, verbose = False):
        self.reached, self.listOfFixedInstancedAct = self.AddActivity_rec(self.start, self.goal, verbose = verbose)
        self.quantities = None
        
    
    def selectActivity(self, start, goal):
        
        print("DBG - selectActivity(", start, ", ", goal, ")", sep = '')
        #print("d =", round(d, 3))
        
        mapping = self.lib.evaluateFor(start, goal, self.tBudget - self.totTime)
        
        mapping.sort(reverse=True)
        """
        print("sorted mapping")
        [print(el) for el in mapping]
        """
        idx = mapping[0][1]
        return idx
        
    
    def evaluate_gaps(self):
        # returns the total remaining gap and the idx of the all gaps to cover
        remainingGap = 0
        gapsToCover = []
        current = self.start
        
        for gap_idx in range(len(self.listOfFixedInstancedAct)+1):
            if gap_idx < len(self.listOfFixedInstancedAct):
                act = self.listOfFixedInstancedAct[gap_idx]
                curr_gap = current.distance_onlyForward(act.start)
                current = act.end
            else:
                curr_gap = current.distance_onlyForward(self.goal)
                
            remainingGap += curr_gap
            if p.TRESHOLD < curr_gap:
                gapsToCover.append((curr_gap, gap_idx))
            
        return remainingGap, gapsToCover
        
    def reStructurate(self):
        current = self.start
        self.totTime = 0
        for iAct in self.listOfFixedInstancedAct:
            self.totTime += iAct.time
            iAct.adjust(current, iAct.time)
            current = iAct.end
        self.reached = current
        self.reEvaluate()
        
        self.ogChangeSignal.emit()
        
    def getStatus(self, actIdx):
        flags = []
        if self.lib.getAct(actIdx).maxRepetition <= self.quantities[actIdx]:
            flags.append("tooM")
        if self.tBudget < self.totTime + self.lib.getAct(actIdx).defT:
            flags.append("long")
        return flags
        
    def copy(self):
        other = OrchestrationGraph(self.lib, self.tBudget, self.start, self.goal)
        other.listOfFixedInstancedAct = self.listOfFixedInstancedAct.copy()
        other.totTime = self.totTime
        other.quantities = self.quantities.copy()
        return other
    
    @pyqtSlot(int, int)
    def insert(self, actIdx, idx):
        instanceToAdd = InstanciatedAct(self.lib.getAct(actIdx), self.reached, len(self.listOfFixedInstancedAct))
        if len(self.listOfFixedInstancedAct) < idx:
            print("WARNING: inserted at index", idx)
        self.quantities[actIdx] += 1
        
        temp = self.listOfFixedInstancedAct
        self.listOfFixedInstancedAct = temp[:idx]\
            + [instanceToAdd] + temp[idx:]
        self.reStructurate()
        # this last call "self.reStructurate()" takes care of this:
        #self.totTime += instanceToAdd.act.time
        #self.reached = None
        #self.ogChangeSignal.emit()

    @pyqtSlot(int, int)
    def exchange(self, iActIdx : int, spaceIdx : int):
        #    0   1   2   3   4   5   6      # InsActIndices
        #  0   1   2   3   4   5   6   7    # SpacesIndices
        movingInstAct = self.listOfFixedInstancedAct[iActIdx]
        modifiedListe = self.listOfFixedInstancedAct[:iActIdx] + self.listOfFixedInstancedAct[iActIdx+1:]  # Remove the instAct from its current position
        if spaceIdx > iActIdx: #Find the index of the goal-space with the modified list's point of view
            spaceIdx -= 1

        preList = modifiedListe[:spaceIdx]
        postList = modifiedListe[spaceIdx:]
        self.listOfFixedInstancedAct = preList + [movingInstAct] + postList
        self.reStructurate()

    @pyqtSlot(int)
    def remove(self, iActIdx : int):
        self.quantities[self.listOfFixedInstancedAct[iActIdx].act.idx] -= 1
        self.listOfFixedInstancedAct = self.listOfFixedInstancedAct[:iActIdx] + self.listOfFixedInstancedAct[iActIdx+1:]  # Remove the instAct from its current position
        self.reStructurate()

    @pyqtSlot()
    def print(self):
        print(self)
        


def tests():
    myLib = Library("inputData/interpolation_2D_library.csv")
    
    #"""
    OG = OrchestrationGraph(myLib, 50, pVal((0.0, 0.0)), pVal((0.9, 0.9)))
    for actIdx in range(5):
        OG.insert(actIdx, actIdx)

    print(OG)

if __name__=="__main__":
    tests()