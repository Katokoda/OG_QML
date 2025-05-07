import QtQuick 2.15

Rectangle {
    id: mydropzone
    width: acceptsDrag ? 80 : 20
    height: parent.height
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    color: "transparent"
    border.width: 1 // TO DEBUG, put to 1
    border.color: (acceptsDrag ? "lightgreen" : "lightgray")

    required property int myIdx
    property bool acceptsDrag: false

    DropArea {
        id: dropArea
        anchors.fill: parent


        onEntered: (drag) => {
            if ((drag.source.myIdx == myIdx) || (drag.source.myIdx == myIdx - 1)) {
                drag.source.acceptedDrag = false
                acceptsDrag = false
            } else {
                drag.source.acceptedDrag = true
                acceptsDrag = true
            }
        }

        onExited:{
            drag.source.acceptedDrag = false
            acceptsDrag = false
        }

        onDropped: (drop) => {
            console.log("DROPPED")
            //trainModelContext.moveWagon(drag.source.myIdx, myIdx)
            drag.source.acceptedDrag = false
            acceptsDrag = false
        }
    }
}