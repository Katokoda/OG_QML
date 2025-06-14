import QtQuick 2.15
import QtQuick.Shapes 1.9


Rectangle {
    id: og
    anchors.fill: parent
    color: "transparent"


    property int lessonIdealWidth: (og.width-50) * 0.8
    property int lessonTotalTime: context_OGraph.totalTime
    property double pixelPerMinute: lessonIdealWidth / lessonTotalTime

    function isHard(index) {
        // This functions has been written by chatGPT
        // Returns true if the index is in the hardGapList
        return hardGapList.indexOf(index) !== -1;
    }
    property list<int> hardGapList: context_OGraph.hardGapList

        // // DEBUG to make some property visible live
        // Text{
        //     id:debugText
        //     anchors.top: parent.top
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     text: "\"" + hardGapList + "\" DEBUG"
        //     color: "white"
        // }

    property int dragExtendedLength: 0    // the dropzones change this length if they accept a drag
    property int selectExtendedLength: 0    // the dropzones change this length if they get selected or unselected
    property int labelRightMargin: 30
    // KNOWN VISUAL GLITCH: when the selected gap is dragged over, the size is counted in both extended lengths but it should not.
    property int myPixelLength: lessonIdealWidth + dragExtendedLength + selectExtendedLength // This is the pixel-width from the start to the finish of the current lesson
    property int myPixelHeight: 40*context_OGraph.numberPlanes


    // WHEN EMPTY
    Rectangle {
        anchors.centerIn: parent
        visible: context_OGraph.totalTime == 0
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



    // LABELS for each plane + Line for each planes + time
    Item {
        id: labelColumn
        visible: lessonRow.visible
        anchors.right: lessonRow.left
        anchors.top: lessonRow.top
        anchors.rightMargin: labelRightMargin


        Repeater {
            model: context_OGraph.labelPlanes
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
    
    Text{
        visible: lessonRow.visible
        anchors.top: lessonRow.bottom
        anchors.horizontalCenter: lessonRow.left
        text: "Start"
        color: "gray"
    }
    Text{
        id: textTotTime
        visible: lessonRow.visible
        anchors.top: lessonRow.bottom
        anchors.horizontalCenter: lessonRow.right
        text: context_OGraph.totalTime + " min"
        color: (context_OGraph.totalTime > context_OGraph.lessonTime? "#dd0000" : "gray")
    }
    Text{
        visible: lessonRow.visible
        anchors.top: textTotTime.bottom
        anchors.horizontalCenter: textTotTime.horizontalCenter
        text: "(max " + context_OGraph.lessonTime + " min)"
        color: "gray"
    }

    // This holds the lesson itself
    Row {
        id: lessonRow
        visible: context_OGraph.totalTime > 0

        spacing: 0
        anchors.centerIn: parent

        // First item holding only a DropZone for inserting things at the start
        Rectangle {
            z: 1.9
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
                isAHardGap: isHard(0)
            }
        }

        Repeater {
            model: context_OGraph.listeReal

            // Item holding an InstantiatedActivity followed by a DropZone
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
                    z: (thisAct.shouldBeAbove ? 2 : 1)
                }

                DropZoneOG{
                    id: mydropzone
                    myIdx: index + 1
                    z: 1.5
                    localOGreference: og
                    isAHardGap: isHard(index + 1)
                }

                // ONLY in relation to the other items in the same parent
                // This is extremely cursed but ensures that the red indicator of a hard gap is always above the instantiated activity
                z: (thisAct.shouldBeAbove ? 2 : 1.9 - (index+1) * 0.001)
            }
        }
    }
}