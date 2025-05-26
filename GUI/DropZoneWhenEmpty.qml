import QtQuick 2.15
import QtQuick.Shapes 1.9

Rectangle {
    id: mydropzone
    height: parent.height
    width:  parent.width

    anchors.verticalCenter: parent.verticalCenter

    property bool isCurrentlySelected: false

    property int occuping_width: width

    color: "transparent"

    required property QtObject localOGreference
    required property int myIdx
    property bool acceptsDrag: false


    Text {
        visible: !isCurrentlySelected
        id: firstTextHere
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        color: "white"
        text: "Click to see details"
        font.pointSize: 12
    }
    Text {
        visible: !isCurrentlySelected
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: firstTextHere.bottom
        color: "white"
        text: "or drop in your favorite activity"
        font.pointSize: 10
    }

    Rectangle{
        visible: isCurrentlySelected
        anchors.fill: parent


        color: "transparent"

        Shape {
            ShapePath {
                strokeWidth: 2
                strokeColor: "white"

                startX:       mydropzone.width/2; startY: 0
                PathLine { x: mydropzone.width/2; y: mydropzone.height}
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