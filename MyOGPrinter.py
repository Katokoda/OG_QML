"""
This file is an external process called by an external script (in file callMyPythonPrinter.sh).
It loads an OrchestrationGraphData object from a pickle file and prints it using matplotlib.

This is necessary because the matplotlib package conflicts heavily with PyQt
and because both librairies need to be called from the main thread.
"""


import pickle

from OrchestrationGraph import OrchestrationGraphData
import params as p

import matplotlib.pyplot as plt
import matplotlib.patches as patches

def myExternalPrint(OG:OrchestrationGraphData):
    # WARNING: this should not be called from a file or process including a PyQt component
    # The utilisation of matplotlib conflicts with PyQT, see
    # https://stackoverflow.com/questions/36675269/cannot-move-matplotlib-plot-window-and-exit-it-using-red-x-button/36704822#36704822

    fig, ax = plt.subplots(1)
    
    reached = OG.start
    res = ""
    for iAct in OG.listOfFixedInstancedAct:
        res += str(iAct) + "\n"
        temp_effect = iAct.end.minus(iAct.start)

        # draw arrow from reached to act.start
        ax.add_patch( patches.FancyArrowPatch(reached.v, iAct.start.v, arrowstyle='->', mutation_scale=10, color='red'))

        ax.add_patch( patches.Rectangle(iAct.start.v,
                    temp_effect.v[0], temp_effect.v[1], fc = 'none', #facecolor
                    color = "black",
                    linewidth = 1, linestyle="-"))
        
        ax.text(iAct.start.v[0] + 0.5*temp_effect.v[0],
                iAct.start.v[1] + 0.5*temp_effect.v[1],
                iAct.actData.name,
            horizontalalignment='center',
            verticalalignment='center',
            fontsize=10, color='gray')

        reached = iAct.end
    

    # draw arrow from reached to the goal (if progression still needed)
    ax.add_patch( patches.FancyArrowPatch(reached.v, reached.needToReach(OG.goal).v, arrowstyle='->', mutation_scale=10, color='red'))
    
    ax.scatter(OG.goal.v[0], OG.goal.v[1], marker='x', label="goal")
    ax.scatter(OG.start.v[0], OG.start.v[1], marker='x', label="start")
    plt.xlabel("fluency")
    plt.ylabel("depth")
    plt.title("OG")
    plt.legend()
    plt.show()


with open("temp/OGSaveForPrinting.pickle", 'rb') as f:
    OG = pickle.load(f)
    myExternalPrint(OG)

