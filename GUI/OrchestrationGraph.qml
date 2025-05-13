import QtQuick 2.15

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Row {
        spacing: 0
        anchors.centerIn: parent

        Item {
            width: mydropzone.width
            height: 40
            DropZoneOG{
                id: mydropzone
                myIdx: 0
            }
        }

        Repeater {
            model: OGraph.listeReal

            delegate: Item {
                width: thisAct.width + mydropzone.width //thisAct.occuping_width + mydropzone.width
                height: thisAct.height

                InstAct {
                    id: thisAct
                    instAct: modelData
                    myIdx: index
                    z: 2
                }

                DropZoneOG{
                    id: mydropzone
                    myIdx: index + 1
                    z: 1
                }

                // ONLY in relation to the other items in the same parent
                z: (thisAct.isCurrentlyDragged ? 2 : 1)
            }
        }
    }

}