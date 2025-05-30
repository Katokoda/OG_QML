# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""


import subprocess
import threading

import pickle


from Library import Library
from InstanciatedAct import InstanciatedActData
from ContextActivity import ContextActivity
from Efficience import getEff

import params as p
from params import NUMBER_PRINT

from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant


#For tests
import random as r
from pValues import pVal
from Library import Library

class OrchestrationGraphData:
    def __init__(self, library:Library, timeBudget:int, start, goal):
        self.lib = library
        self.tBudget = timeBudget
        self.start = start
        self.reached = start
        self.goal = goal
        
        self.listOfFixedInstancedAct = []
        self.quantities = [0]*self.lib.getLength()
        self.totTime = 0

        self.remainingGapsCount = 1
        self.remainingGapsDistance = start.distance_onlyForward(goal)

        self.gapFocus = None # Index of the gap currently selected in QML.
        self.currentListForSelectedGap = [] # REQUIRED --> Segmentation Fault
        # otherwise the QML objects references to a temporary variable

    def __repr__(self):
        textList = ""
        for iAct in self.listOfFixedInstancedAct:
            textList += str(iAct) + "\n"
        return "\nThe lesson plan is:\n"\
                + textList\
                + "Time spent " + str(self.totTime) + " min (budget = "\
                + str(self.tBudget) + " min).\n"\
                + "Remains " + str(self.remainingGapsCount) + " gaps to cover, "\
                + "for a \"distance\" of " + str(self.remainingGapsDistance) + ".\n"
    
    def __getstate__(self):
        # https://stackoverflow.com/questions/1939058/simple-example-of-use-of-setstate-and-getstate
        out = self.__dict__.copy()
        del out["currentListForSelectedGap"]
        del out["gapFocus"]
        return out
    
    def __setstate__(self, d):
        self.__dict__ = d
        self.currentListForSelectedGap = []
        self.gapFocus = None


    # ========== ACTIONNABLES ========== #

    def saveAsFile(self, filename:str):
        with open(filename+".pickle", 'wb') as f:
            # Pickle the 'data' dictionary using the highest protocol available.
            pickle.dump(self, f, pickle.HIGHEST_PROTOCOL)


    def reEvaluateData(self):
        if self.gapFocus == None:
            self.currentListForSelectedGap = self.evaluateGlobal()
        else:
            start = self.start if self.gapFocus == 0 else self.listOfFixedInstancedAct[self.gapFocus - 1].end
            end = self.goal if self.gapFocus == len(self.listOfFixedInstancedAct) else self.listOfFixedInstancedAct[self.gapFocus].start
            self.currentListForSelectedGap = self.evaluateFor(start, end)
    
    def evaluateGlobal(self):
        result = []
        for i in range(self.lib.getLength()):
            flags = self.getFlags(i)
            actData = self.lib.getActData(i)
            result.append(ContextActivity(actData, 100, flags, (len(flags) == 0)))
        return result
    
    def evaluateFor(self, start, goal):
        result = []
        d = start.distance_onlyForward(goal)
        
        for i in range(self.lib.getLength()):
            flags = self.getFlags(i)
            actData = self.lib.getActData(i)
            wouldStart, wouldEnd, _ = actData.what_from(start)
            d1 = start.distance_onlyForward(wouldStart)
            d2 = wouldEnd.distance_onlyForward(goal)
            if wouldStart.isPast(goal):
                flags.append("isPast")
            efficiency = getEff(d, d1, d2, actData.defT, self.tBudget - self.totTime)
            result.append(ContextActivity(actData, efficiency, flags, (len(flags) == 0)))
        return result
    

    def reStructurateData(self):
        current = self.start
        self.totTime = 0
        for iAct in self.listOfFixedInstancedAct:
            self.totTime += iAct.time
            iAct.adjust(current, iAct.time)
            current = iAct.end
        self.reached = current
        self.evaluate_gaps()
    

    def insert(self, actIdx:int, idx:int):
        instanceToAdd = InstanciatedActData(self.lib.getActData(actIdx), self.reached)
        if len(self.listOfFixedInstancedAct) < idx:
            print("WARNING: inserted at index", idx)
        self.quantities[actIdx] += 1
        
        temp = self.listOfFixedInstancedAct
        self.listOfFixedInstancedAct = temp[:idx]\
            + [instanceToAdd] + temp[idx:]
        

    def exchange(self, iActIdx:int, spaceIdx:int):
        #    0   1   2   3   4   5   6      # InsActIndices
        #  0   1   2   3   4   5   6   7    # SpacesIndices
        movingInstAct = self.listOfFixedInstancedAct[iActIdx]
        modifiedListe = self.listOfFixedInstancedAct[:iActIdx] + self.listOfFixedInstancedAct[iActIdx+1:]  # Remove the instAct from its current position
        if spaceIdx > iActIdx: #Find the index of the goal-space with the modified list's point of view
            spaceIdx -= 1

        preList = modifiedListe[:spaceIdx]
        postList = modifiedListe[spaceIdx:]
        self.listOfFixedInstancedAct = preList + [movingInstAct] + postList


    def remove(self, iActIdx:int):
        self.quantities[self.listOfFixedInstancedAct[iActIdx].actData.idx] -= 1
        self.listOfFixedInstancedAct = self.listOfFixedInstancedAct[:iActIdx] + self.listOfFixedInstancedAct[iActIdx+1:]  # Remove the instAct from its current position
        

    def reset(self):
        self.quantities = [0]*self.lib.getLength()
        self.listOfFixedInstancedAct = []
        

    # ========== GETTERS ========== #
    
    def getFlags(self, actIdx:int):
        flags = []
        if self.lib.getActData(actIdx).maxRepetition <= self.quantities[actIdx]:
            flags.append("tooM")
        if self.tBudget < self.totTime + self.lib.getActData(actIdx).defT:
            flags.append("long")
        return flags
    
    def evaluate_gaps(self):
        # returns the idx of the all gaps to cover
        self.remainingGapsCount = 0
        self.remainingGapsDistance = 0
        gapsToCover = []
        current = self.start
        
        for gap_idx in range(len(self.listOfFixedInstancedAct)+1):
            if gap_idx < len(self.listOfFixedInstancedAct):
                act = self.listOfFixedInstancedAct[gap_idx]
                curr_gap = current.distance_onlyForward(act.start)
                current = act.end
            else:
                curr_gap = current.distance_onlyForward(self.goal)
                
            if p.TRESHOLD < curr_gap:
                self.remainingGapsCount += 1
                self.remainingGapsDistance += curr_gap
                gapsToCover.append((curr_gap, gap_idx))

        print(gapsToCover)
        return gapsToCover

  

class OrchestrationGraph(QObject):
    ogChangeSignal = pyqtSignal()
    gapSelectionChangeSignal = pyqtSignal()

    def __init__(self, library:Library, timeBudget:int, start, goal):
        super().__init__()
        self.data = OrchestrationGraphData(library, timeBudget, start, goal)
        self.setGapFocus(-1)

    def __repr__(self):
        return self.data.__repr__()
    
    def reEvaluate(self):
        self.data.reEvaluateData()
        self.gapSelectionChangeSignal.emit()

    def reStructurate(self):
        self.data.reStructurateData()
        self.reEvaluate()        
        self.ogChangeSignal.emit()


    def myCallerForPrintingSubprocess(self):
        self.saveAsFile("temp/OGSaveForPrinting")
        subprocess.call(['sh', './callMyPythonPrinter.sh'])


    # ============== SLOTS ============== #

    @pyqtSlot()
    def print(self):
        print(self)
    
    @pyqtSlot()
    def myCustomPrintFunction(self):
        t_thread = threading.Thread(target=self.myCallerForPrintingSubprocess)
        t_thread.start()

    @pyqtSlot(str)
    def saveAsFile(self, filename):
        self.data.saveAsFile(filename)

    @pyqtSlot(int)
    # Should always be called before listActivityForGap is required.
    def setGapFocus(self, gapIdx:int):
        if gapIdx < 0:
            self.data.gapFocus = None
            self.reEvaluate()
        else:
            self.data.gapFocus = gapIdx
            self.reEvaluate()
        self.gapSelectionChangeSignal.emit()

    @pyqtSlot(int, int)
    def insert(self, actIdx:int, idx:int):
        self.data.insert(actIdx, idx)
        self.reStructurate()

    @pyqtSlot(int, int)
    def exchange(self, iActIdx:int, spaceIdx:int):
        self.data.exchange(iActIdx, spaceIdx)
        self.reStructurate()

    @pyqtSlot(int)
    def remove(self, iActIdx:int):
        self.data.remove(iActIdx)
        self.reStructurate()


    @pyqtSlot()
    def reset(self):
        self.data.reset()
        self.reStructurate()

    
    # ============== PROPERTIES ============== #

    @pyqtProperty(QVariant, notify=ogChangeSignal)
    def listeReal(self):
        return [iActData.getQtObject() for iActData in self.data.listOfFixedInstancedAct]


    @pyqtProperty(QVariant, notify=gapSelectionChangeSignal)
    def listActivityForGap(self):
        return self.data.currentListForSelectedGap
    
    @pyqtProperty(QVariant, notify=gapSelectionChangeSignal)
    def sortedListActivityForGap(self):
        print("WARNING - sortedListActivityForGap - not sorted")
        return self.data.currentListForSelectedGap[0:-1:-1]
    

    @pyqtProperty(int, notify=ogChangeSignal)
    def totalTime(self):
        return self.data.totTime
    
    @pyqtProperty(int, notify=ogChangeSignal)
    def lessonTime(self):
        return self.data.tBudget
    
    @pyqtProperty(int, notify=ogChangeSignal)
    def remainingGapsCount(self):
        return self.data.remainingGapsCount

    @pyqtProperty(int, notify=ogChangeSignal)
    def numberPlanes(self):
        print("Python has been asked the number of planes and answered three") #TODO
        return 3
    
    @pyqtProperty(QVariant, notify=ogChangeSignal)
    def labelPlanes(self):
        print("Python has been asked the labels of planes and answered hard-written list") #TODO
        return ["Indiv.", "Team", "Class"]
    


def tests():
    myLib = Library("inputData/interpolation_2D_library.csv")
    
    #"""
    OG = OrchestrationGraph(myLib, 50, pVal((0.0, 0.0)), pVal((0.9, 0.9)))
    for actIdx in range(5):
        OG.insert(actIdx, actIdx)

    print(OG)
    OG.saveAsFile("test/OG_file_test")

    OG2 = pickle.load(open("test/OG_file_test.pickle", 'rb'))
    print("")
    print("PICKLED OG:")
    print(OG2)

if __name__=="__main__":
    tests()