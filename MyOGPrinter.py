
import pickle

from OrchestrationGraph import OrchestrationGraphData
from pValues import pVal
import params as p

import matplotlib.pyplot as plt
import matplotlib.patches as patches

def myExternalPrint(OG:OrchestrationGraphData):
    # WARNING: this should not be called from a file or process including a PyQt component
    # The utilisation of matplotlib conflicts with PyQT, see
    # https://stackoverflow.com/questions/36675269/cannot-move-matplotlib-plot-window-and-exit-it-using-red-x-button/36704822#36704822

    fig, ax = plt.subplots(1)
    
    reached = None
    res = ""
    for iAct in OG.listOfFixedInstancedAct:
        res += str(iAct) + "\n"
        temp_effect = iAct.end.minus(iAct.start)
        ax.add_patch( patches.Rectangle(iAct.start.v,
                    temp_effect.v[0], temp_effect.v[1], fc = 'none', #facecolor
                    color = p.COLORS_DEPTH[iAct.depth], linewidth = 1, linestyle="-"))
        if reached != None:
            ax.add_patch( patches.FancyArrowPatch(reached.v, iAct.start.v, arrowstyle='->', mutation_scale=10))
            # draw arrow from reached to act.start
        reached = iAct.end
    
    ax.scatter(OG.start.v[0], OG.start.v[1], marker='x')
    ax.scatter(OG.goal.v[0], OG.goal.v[1], marker='x')
    plt.xlabel("fluency")
    plt.ylabel("depth")
    plt.title("OG")
    
    plt.show()



print("    SUB - This is another python process speaking")

with open("temp/OGSaveForPrinting.pickle", 'rb') as f:
    OG = pickle.load(f)
    print(OG)
    myExternalPrint(OG)

print("    SUB - Done")

