# -*- coding: utf-8 -*-
"""
Created on Tue Feb 25 09:43:43 2025

@author: Samuel
"""

from PyQt6.QtCore import QObject, pyqtSignal, pyqtSlot
# This module is used to shorten text (Activities names). It reduced the text with a reduction ratio computed dynamically based on the display area.


def extractCapitals(s: str):
    # extractCapitals was coded entirely by ChatGPT
    
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
        # (mySize / txtSize) is the reduction ratio. However, as the letters have different widths, we add 0.9 to increase margins.
        len_shorten = round(len_text * 0.9 * (mySize / txtSize))

        myCapitals = extractCapitals(text)

        return myCapitals[:len_shorten]
    
    
def tests():
    print("testing TextShortener")
    myTS = TextShortener()

    # Test cases for the ExtractCapitals function, written by chatGPT
    print(extractCapitals("AbcdeFghiJklmn"))  # Output: "AFJklmn"
    print(extractCapitals("hello"))           # Output: "hello"
    print(extractCapitals("HELLO"))           # Output: "HELLO"
    print(extractCapitals("HeLloWorLD"))      # Output: "HLWLD"

    
if __name__=="__main__":
    tests()