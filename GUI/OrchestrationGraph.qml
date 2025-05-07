import QtQuick 2.15

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Row {
        spacing: 5
        anchors.centerIn: parent

        Repeater {
            model: OGraph.listeReal

            delegate: Item {
                width: thisAct.width
                height: thisAct.height

                InstAct {
                    id: thisAct
                    instAct: modelData
                    myIdx: index
                }

                // ONLY in relation to the other items in the same parent
                //z: (thisAct.isCurrentlyDragged ? 2 : 1)
            }
        }
    }

}