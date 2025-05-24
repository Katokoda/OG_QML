# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant


def extractCapitals(s: str):
    # Coded entirely with ChatGPT
    
    # Extract all uppercase letters
    capitals = ''.join([char for char in s if char.isupper()])
    
    # Find the trailing lowercase-only segment (after last uppercase)
    last_upper_index = -1
    for i in range(len(s) - 1, -1, -1):
        if s[i].isupper():
            last_upper_index = i
            break
    
    # If no uppercase found, return empty capitals + full string
    tail = s[last_upper_index + 1:]
    
    return capitals + tail


class TextShortener(QObject):
    instActChangeSignal = pyqtSignal()

    def __init__(self):
        super().__init__()

    @pyqtSlot(str, float, float, result = str)
    def shorten(self, text: str, txtSize: float, mySize: float):
        if txtSize <= 0:
            return ""
        len_text = len(text)
        len_shorten = round(len_text * (mySize / txtSize))

        myCapitals = extractCapitals(text)

        return myCapitals[:len_shorten]
    
    
def tests():
    print("testing TextShortener")
    myTS = TextShortener()

    print(extractCapitals("AbcdeFghiJklmn"))  # Output: "AFJklmn"
    print(extractCapitals("hello"))           # Output: "hello"
    print(extractCapitals("HELLO"))           # Output: "HELLO"
    print(extractCapitals("HeLloWorLD"))      # Output: "HLWLD"

    
if __name__=="__main__":
    tests()