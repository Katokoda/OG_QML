# -*- coding: utf-8 -*-
"""
Created on Wed Mar 12 15:39:36 2025

@author: Samuel
"""

class ScoreMap:
    def __init__(self, scoreList, n):
        bests = [el for el in scoreList if (len(el) < 3 or el[2] == True)]
        bests.sort(reverse = True)
        
        others = [el for el in scoreList if (len(el) == 3 and el[2] == False)]
        others.sort(reverse = True)
        bests.extend(others)
        
        self.scoreList = bests
        
        self.nSpaces = n
        self.nScores = len(scoreList)
        
        self.posList = [None]*n
        for bestIdx in range(len(scoreList)):
            self.posList[scoreList[bestIdx][1]] = scoreList[bestIdx][0]
    
    def has(self, spaceIdx):
        return self.posList[spaceIdx] != None
    
    def score(self, spaceIdx):
        return self.posList[spaceIdx]
    
    def bestIdx(self):
        return self.scoreList[0][1]

    def bestScore(self):
        return self.scoreList[0][0]