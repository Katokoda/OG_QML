import sys
import os

import threading

from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtQuick import QQuickWindow
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot, QVariant
from Library import Library

# Should be included in your code as a fallback option for uses with old hardware specs
QQuickWindow.setSceneGraphBackend('software')


app = QGuiApplication(sys.argv)




engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)


myLib = Library("inputData/interpolation_2D_library.csv")
print("Printing my library")
print(myLib)
engine.rootContext().setContextProperty("ContextLibrary", myLib)


engine.load('./GUI/Main.qml')

sys.exit(app.exec())