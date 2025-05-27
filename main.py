import sys

import threading

from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtQuick import QQuickWindow

from PyQt6.QtCore import QMetaObject

from Library import Library
from OrchestrationGraph import OrchestrationGraph
from TextShortener import TextShortener
from pValues import pVal

# Should be included in your code as a fallback option for uses with old hardware specs
QQuickWindow.setSceneGraphBackend('software')


app = QGuiApplication(sys.argv)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)

myTextShortener = TextShortener()


myLib = Library("inputData/interpolation_2D_library.csv")
print("Printing my library")
print(myLib)

OG = OrchestrationGraph(myLib, 50, pVal((0.0, 0.0)), pVal((0.9, 0.9)))
engine.rootContext().setContextProperty("context_OGraph", OG)
engine.rootContext().setContextProperty("context_textShortener", myTextShortener)

#for i in range(5):
#    OG.insert(2*i, i)
print(OG)

engine.load('./GUI/Main.qml')
if not engine.rootObjects():
    print("Failed to load QML file.")
    sys.exit(-1)


root_obj = engine.rootObjects()[0]

def mySignalToQMLofAnOgReset():
    QMetaObject.invokeMethod(root_obj, "myGraphUpdate") # Call QML function

OG.ogChangeSignal.connect(mySignalToQMLofAnOgReset)

sys.exit(app.exec())