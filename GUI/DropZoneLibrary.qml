import QtQuick 2.15

Rectangle {
    id: mydropzone

    anchors.fill: parent

    color: "transparent"
    border.width: 0 // TO DEBUG, put to 1
    border.color: (acceptsDrag ? "lightgreen" : "lightgray")

    property bool acceptsDrag: false

    DropArea {
        id: dropArea
        anchors.fill: parent


        onEntered: (drag) => {
            if (drag.source.myType == "instAct") {
                drag.source.willBeDeleted = true

                drag.source.acceptedDrag = true
                acceptsDrag = true
            } else {
                drag.source.acceptedDrag = false
                acceptsDrag = false
            }
        }

        onExited:{
            if (drag.source.myType == "instAct") {
                drag.source.willBeDeleted = false
            }
            drag.source.acceptedDrag = false
            acceptsDrag = false
        }

        onDropped: (drop) => {
            if (acceptsDrag){
                if (drag.source.myType == "instAct") {
                    drag.source.willBeDeleted = false
                }
                drag.source.acceptedDrag = false
                acceptsDrag = false
                OGraph.remove(drag.source.myIdx)
            }
        }
    }
}