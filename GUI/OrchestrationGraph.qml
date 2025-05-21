import QtQuick 2.15
import QtQuick.Shapes 1.9


Rectangle {
    id: og
    anchors.fill: parent
    color: "transparent"


    property int lessonIdealWidth: (og.width-50) * 0.8
    property int lessonTotalTime: OGraph.totalTime
    property double pixelPerMinute: lessonIdealWidth / lessonTotalTime

        // // DEBUG to make some property visible live
        // Text{
        //     anchors.top: parent.top
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     text: pixelPerMinute
        //     color: "white"
        // }

    property int dragExtendedLength: 0    // the dropzones change this length if they accept a drag
    property int selectExtendedLength: 0    // the dropzones change this length if they get selected or unselected
    property int labelRightMargin: 30
    // KNOWN BUG: when the selected gap is dragged over, the size is counted in both extended lengths but it should not.
    property int myPixelLength: lessonIdealWidth + dragExtendedLength + selectExtendedLength // This is the pixel-width from the start to the finish of the current lesson
    property int myPixelHeight: 40*OGraph.numberPlanes


    // LABELS for each plane + Line for each planes
    Item {
        id: labelColumn
        visible: lessonRow.visible
        anchors.right: lessonRow.left
        anchors.top: lessonRow.top
        anchors.rightMargin: labelRightMargin


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

                        startX: labelRightMargin; startY: 0
                        PathLine { x: labelRightMargin + og.myPixelLength; y: 0}
                    }
                }
            }

        }
    }


    Rectangle {
        anchors.centerIn: parent
        visible: OGraph.totalTime == 0
        width: 200
        height: 200
        color: "transparent"

        border.width: 1
        border.color: "lightgray"

        DropZoneWhenEmpty{
            id: startDropZone
            myIdx: 0
            localOGreference: og
    }
}


    // This holds the lesson itself
    Row {
        id: lessonRow
        visible: OGraph.totalTime > 0

        spacing: 0
        anchors.centerIn: parent

        // First item holding only a DropZone for inserting things at the start
        Rectangle {
            width: mydropzone.occuping_width
            height: myPixelHeight
            color: "transparent"

                // //DEBUG to make the item visible
                // border.width: 1
                // border.color: "red"
                // //DEBUG

            DropZoneOG{
                id: mydropzone
                myIdx: 0
                localOGreference: og
            }
        }

        Repeater {
            model: OGraph.listeReal

            // Item holding an InstanciatedActivity followed by a DropZone
            delegate: Rectangle {
                width: thisAct.width + mydropzone.occuping_width
                height: myPixelHeight
                color: "transparent"

                    // //DEBUG to make the item visible
                    // border.width: 1
                    // border.color: "red"
                    // //DEBUG

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
                    localOGreference: og
                }

                // ONLY in relation to the other items in the same parent
                z: (thisAct.isCurrentlyDragged ? 2 : 1)
            }
        }
    }
}