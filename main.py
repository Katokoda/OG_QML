import sys
import os

import threading

from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtQuick import QQuickWindow
from Library import Library
from OrchestrationGraph import OrchestrationGraph
from pValues import pVal

# Should be included in your code as a fallback option for uses with old hardware specs
QQuickWindow.setSceneGraphBackend('software')


app = QGuiApplication(sys.argv)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)


myLib = Library("inputData/interpolation_2D_library.csv")
print("Printing my library")
print(myLib)
engine.rootContext().setContextProperty("ContextLibrary", myLib)

OG = OrchestrationGraph(myLib, 50, pVal((0.0, 0.0)), pVal((0.9, 0.9)))
engine.rootContext().setContextProperty("OGraph", OG)

for i in range(5):
    OG.insert(2*i, i)
print(OG)


engine.load('./GUI/Main.qml')

sys.exit(app.exec())