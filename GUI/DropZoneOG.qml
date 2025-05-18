import QtQuick 2.15

Rectangle {
    id: mydropzone
    height: parent.height + 20
    anchors.verticalCenter: parent.verticalCenter

    property bool isCurrentlySelected: false

    width:  (acceptsDrag ? 60 : 20)
    property int occuping_width: width + 2*anchors.rightMargin
    anchors.right: parent.right
    anchors.rightMargin: (isCurrentlySelected ? 0 : -10)

    color: "transparent"

        // // DEBUG to make the dropZone visible
        // border.width: 1
        // border.color: (acceptsDrag ? "lightgreen" : "lightgray")
        // // DEBUG

    required property QtObject localOGreference
    required property int myIdx
    property bool acceptsDrag: false

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
                    OGraph.exchange(drag.source.myIdx, myIdx)
                } else {
                    OGraph.insert(drag.source.myIdx, myIdx)
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