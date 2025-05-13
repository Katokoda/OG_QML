import QtQuick 2.15
import QtQuick.Shapes 1.9


Rectangle {
    anchors.fill: parent
    color: "transparent"

    property int myExtendedLength: 0
    property int myRightMargin: 30
    property int myPixelLength: 500 + myExtendedLength
    property int myPixelHeight: 40*OGraph.numberPlanes

    Text {
        id:dbgText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        color: "white"
        text: myExtendedLength
        font.pointSize: 8
    }
    Text {
        anchors.top: dbgText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        color: "white"
        text: myPixelLength
        font.pointSize: 8
    }


    Item {
        id: labelColumn
        anchors.right: myRow.left
        anchors.top: myRow.top
        anchors.rightMargin: myRightMargin

        Repeater {
            model: OGraph.labelPlanes
            delegate: Item {
                anchors.top: labelColumn.top
                anchors.topMargin: (index * 40) + 20
                anchors.right: labelColumn.right
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    id: myPlaneLabels
                    font.bold: true
                    color: "white"
                    text: modelData
                    font.pointSize: 8
                }

                Shape {
                    ShapePath {
                        strokeWidth: 2
                        strokeColor: "gray"

                        startX: myRightMargin; startY: 0
                        PathLine { x: og.myPixelLength; y: 0}
                    }
                }
            }

        }
    }

    Row {
        id: myRow
        spacing: 0
        anchors.centerIn: parent

        Rectangle {
            width: mydropzone.occuping_width
            height: myPixelHeight

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
                height: myPixelHeight

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