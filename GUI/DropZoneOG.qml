import QtQuick 2.15
import QtQuick.Shapes 1.9

Rectangle {
    id: mydropzone
    color: "transparent"

        // // DEBUG to make the dropZone visible
        // border.width: 1
        // border.color: (acceptsDrag ? "lightgreen" : "lightgray")
        // // DEBUG

    required property QtObject localOGreference
    required property int myIdx
    required property bool isAHardGap


    property bool acceptsDrag: false
    property bool isCurrentlySelected: false
    property int myHeightMargin: 35


    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    anchors.rightMargin: (isCurrentlySelected ? 0 : -10)

    height: parent.height + 2 * myHeightMargin
    width:  (acceptsDrag ? 60 : 20)
    property int occuping_width: width + 2*anchors.rightMargin
    





        
    // Indicator that the gap is considered HARD
    Rectangle {
        id: hardIndicator
        visible: isAHardGap
        anchors.fill: parent
        color: "transparent"

        Text {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: "!"
            color: "#FF0000"
            font.pixelSize: 30
        }

        Shape {
            ShapePath {
                strokeWidth: 1
                strokeColor: "#FF0000"

                startX:       mydropzone.width/2; startY: myHeightMargin
                PathLine { x: mydropzone.width/2; y: mydropzone.height - myHeightMargin}
            }
        }
    }

    // Indicator of selection
    Rectangle{
        visible: isCurrentlySelected
        anchors.fill: parent


        color: "transparent"

        Shape {
            ShapePath {
                strokeWidth: 2
                strokeColor: "white"

                startX:       mydropzone.width/2; startY: myHeightMargin
                PathLine { x: mydropzone.width/2; y: mydropzone.height - myHeightMargin}
            }
        }

        Rectangle{
            color: "black"
            anchors.centerIn: parent
            height: 25
            width: height
            radius: height/2

            MyPlus {
                height: 14
                anchors.centerIn: parent
            }
        }

    }

    DropArea {
        id: dropArea
        anchors.fill: parent


        onEntered: (drag) => {
            if (drag.source.myType == "activity")
            {
                drag.source.willBeAdded = true

                drag.source.acceptedDrag = true
                acceptsDrag = true
                localOGreference.dragExtendedLength = occuping_width
            } else {
                if (!((drag.source.myIdx == myIdx) || (drag.source.myIdx == myIdx - 1)))
                {
                    drag.source.acceptedDrag = true
                    acceptsDrag = true
                    localOGreference.dragExtendedLength = occuping_width
                } else {
                    drag.source.acceptedDrag = false
                    acceptsDrag = false
                    localOGreference.dragExtendedLength = 0
                }
            }
        }

        onExited: {
            if (drag.source.myType == "activity"){
                drag.source.willBeAdded = false
            }
            drag.source.acceptedDrag = false
            acceptsDrag = false
            localOGreference.dragExtendedLength = 0
        }

        onDropped: (drop) => {
            if (acceptsDrag){
                if (drag.source.myType == "instAct"){
                    context_OGraph.exchange(drag.source.myIdx, myIdx)
                } else {
                    context_OGraph.insert(drag.source.myIdx, myIdx)
                }
                if (drag.source.myType == "activity"){
                    drag.source.willBeAdded = false
                }
                drag.source.acceptedDrag = false
                acceptsDrag = false
                localOGreference.dragExtendedLength = 0
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: (mouse) => {
            setGapSelection(mydropzone)
        }
    }
}