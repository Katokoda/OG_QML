import QtQuick 2.15

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Column {
        spacing: 5
        anchors.centerIn: parent

        Repeater {
            model: ContextLibrary.listeProp

            delegate: Item {
                width: thisAct.width
                height: thisAct.height

                Activity {
                    id: thisAct
                    activity: modelData
                    myIdx: index
                }

                // ONLY in relation to the other items in the same parent
                //z: (thisAct.isCurrentlyDragged ? 2 : 1)
            }
        }
    }

}
 