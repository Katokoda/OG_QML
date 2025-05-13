import QtQuick 2.15

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Row {
        spacing: 0
        anchors.centerIn: parent

        Rectangle {
            width: mydropzone.occuping_width
            height: 100

                //DEBUG
                border.width: 1
                border.color: "red"
                color: "transparent"
                //DEBUG

            DropZoneOG{
                id: mydropzone
                myIdx: 0
            }
        }

        Repeater {
            model: OGraph.listeReal

            delegate: Rectangle {
                //width: thisAct.width + mydropzone.width
                width: thisAct.width + mydropzone.occuping_width
                height: 100

                    //DEBUG
                    border.width: 1
                    border.color: "red"
                    color: "transparent"
                    //DEBUG

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