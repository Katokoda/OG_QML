
from Library import Library
from OrchestrationGraph import OrchestrationGraph
from pValues import pVal

myLib = Library("inputData/interpolation_2D_library.csv")
OG = OrchestrationGraph(myLib, 50, pVal((0.0, 0.0)), pVal((0.9, 0.9)))
for i in range(5):
    OG.insert(2*i, i)

print(OG)
OG.saveAsFile("temp/OGSaveForPrinting")


