import sys
import os

from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtQuick import QQuickWindow

from PyQt6.QtCore import QMetaObject

from Library import Library
from OrchestrationGraph import OrchestrationGraph
from TextShortener import TextShortener
from pValues import pVal


# Found from https://stackoverflow.com/questions/44474745/python-matplotlib-plot-inside-qml-layout
# https://github.com/jmitrevs/matplotlib_backend_qtquick/blob/master/examples/main.py
# Can be installed using pip install git+https://github.com/jmitrevs/matplotlib_backend_qtquick
# HOWEVER - this requires PyQt5 and we can't retrograde to it.
#from matplotlib_backend_qtquick.qt_compat import QtGui, QtQml, QtCore


# Should be included in your code as a fallback option for uses with old hardware specs
QQuickWindow.setSceneGraphBackend('software')


app = QGuiApplication(sys.argv)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)

myTextShortener = TextShortener()


# Get the directory where the current file is located #chatGPT helped for that
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, "inputData", "interpolation_2D_library.csv")

# Pass the absolute path to your Library class
myLib = Library(csv_path)
print("Printing my library")
print(myLib)

OG = OrchestrationGraph(myLib, 50, pVal((0.0, 0.0)), pVal((0.9, 0.9)))
engine.rootContext().setContextProperty("context_OGraph", OG)
engine.rootContext().setContextProperty("context_textShortener", myTextShortener)

# for i in range(5):
#    OG.insert(2*i, i)
#OG.autoAdd()
print(OG)


gui_path = os.path.join(script_dir, "GUI", "Main.qml")
engine.load(gui_path)
if not engine.rootObjects():
    print("Failed to load QML file.")
    sys.exit(-1)


root_obj = engine.rootObjects()[0]

def mySignalToQMLofAnOgReset():
    QMetaObject.invokeMethod(root_obj, "myGraphUpdate") # Call QML function

OG.ogChangeSignal.connect(mySignalToQMLofAnOgReset)

sys.exit(app.exec())