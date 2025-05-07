# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""


import matplotlib.pyplot as plt
import matplotlib.patches as patches


from InstanciatedAct import InstanciatedAct
from ScoreMap import ScoreMap


import params as p
from params import NUMBER_PRINT

from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant


#For tests
import random as r
from pValues import pVal
from Library import Library
  

class OrchestrationGraph(QObject):
    ogChangeSignal = pyqtSignal()

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
        
        
    def __repr__(self):
        """ WARNING """
        # The utilisation of matplotlib conflicts with PyQT, see
        # https://stackoverflow.com/questions/36675269/cannot-move-matplotlib-plot-window-and-exit-it-using-red-x-button/36704822#36704822
        # That explains the comments below which are use to print the OG but can't be used with PyQT. They are not maintained anymore


        # fig, ax = plt.subplots(1)
        
        # reached = None
        res = ""
        for iAct in self.listOfFixedInstancedAct:
            res += str(iAct) + "\n"
        #     temp_effect = iAct.end.minus(iAct.start)
        #     ax.add_patch( patches.Rectangle(iAct.start.v,
        #                 temp_effect.v[0], temp_effect.v[1], fc = 'none', #facecolor
        #                 color = p.COLORS_DEPTH[iAct.depth], linewidth = 1, linestyle="-"))
        #     if reached != None:
        #         ax.add_patch( patches.FancyArrowPatch(reached.v, iAct.start.v, arrowstyle='->', mutation_scale=10))
        #         # draw arrow from reached to act.start
        #     reached = iAct.end
        

            
        # ax.scatter(self.start.v[0], self.start.v[1], marker='x')
        # ax.scatter(self.goal.v[0], self.goal.v[1], marker='x')
        # plt.xlabel("fluency")
        # plt.ylabel("depth")
        # plt.title("OG")
        
        # plt.show()

        return "OG printed as plot:\n"\
                + res\
                + str(round(self.evaluate_gaps()[0], 4))\
                + " " + str(self.totTime) + " min (budget = "\
                + str(self.tBudget) + " min)"
    

    @pyqtProperty(QVariant, notify=ogChangeSignal)
    def listeReal(self):
        return self.listOfFixedInstancedAct

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
            
        return remainingGap, ScoreMap(gapsToCover, len(self.listOfFixedInstancedAct)+1)
        
    def reStructurate(self):
        current = self.start
        self.totTime = 0
        for iAct in self.listOfFixedInstancedAct:
            self.totTime += iAct.time
            iAct.adjust(current, iAct.time)
            current = iAct.end
        self.reached = current
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
    
    def insert(self, actIdx, idx):
        instanceToAdd = InstanciatedAct(self.lib.getAct(actIdx), self.reached, len(self.listOfFixedInstancedAct))
        if len(self.listOfFixedInstancedAct) < idx:
            print("WARNING: inserted at index", idx)
        self.quantities[actIdx] += 1
        
        temp = self.listOfFixedInstancedAct
        self.listOfFixedInstancedAct = temp[:idx]\
            + [instanceToAdd] + temp[idx:]
        self.reStructurate()
        # self.reStructurate() takes care of this:
        #self.totTime += instanceToAdd.act.time
        #self.reached = None
        #self.ogChangeSignal.emit()
        


def tests():
    myLib = Library("inputData/interpolation_2D_library.csv")
    
    #"""
    OG = OrchestrationGraph(myLib, 50, pVal((0.0, 0.0)), pVal((0.9, 0.9)))
    for actIdx in range(5):
        OG.insert(actIdx, actIdx)

    print(OG)

if __name__=="__main__":
    tests()