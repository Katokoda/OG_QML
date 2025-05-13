import QtQuick 2.15

Rectangle {
    id: mydropzone
    height: 50 // DEBUG
    anchors.verticalCenter: parent.verticalCenter

    width: acceptsDrag ? 80 : 20
    property int occuping_width: acceptsDrag ? 60 : 0
    //anchors.right: acceptsDrag ? parent.right : parent.right - 10
    anchors.right: parent.right

    color: "transparent"
    border.width: 1 // TO DEBUG, put to 1
    border.color: (acceptsDrag ? "lightgreen" : "lightgray")

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
            } else {
                if (!((drag.source.myIdx == myIdx) || (drag.source.myIdx == myIdx - 1)))
                {
                    drag.source.acceptedDrag = true
                    acceptsDrag = true
                } else {
                    drag.source.acceptedDrag = false
                    acceptsDrag = false
                }
            }
        }

        onExited:{
            if (drag.source.myType == "activity"){
                drag.source.willBeAdded = false
            }
            drag.source.acceptedDrag = false
            acceptsDrag = false
        }

        onDropped: (drop) => {
            if (acceptsDrag){
                console.log("DROPPED")
                if (drag.source.myType == "instAct"){
                    console.log("Permuting instAct ", drag.source.myIdx, "with ", myIdx)
                    OGraph.exchange(drag.source.myIdx, myIdx)
                } else {
                    console.log("Inserting new activity with LOCAL index ", drag.source.myIdx)
                    // LOCAL = index in the shown Library
                    OGraph.insert(drag.source.myIdx, myIdx)
                }
                if (drag.source.myType == "activity"){
                    drag.source.willBeAdded = false
                }
                drag.source.acceptedDrag = false
                acceptsDrag = false
            }
        }
    }
}