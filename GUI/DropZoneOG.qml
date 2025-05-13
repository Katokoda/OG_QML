import QtQuick 2.15

Rectangle {
    id: mydropzone
    height: parent.height + 20
    anchors.verticalCenter: parent.verticalCenter

    width: 20 + occuping_width
    property int occuping_width: acceptsDrag ? 60 : 0
    //anchors.right: acceptsDrag ? parent.right : parent.right - 10
    anchors.right: parent.right
    anchors.rightMargin: -10

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
                og.myExtendedLength = occuping_width
            } else {
                if (!((drag.source.myIdx == myIdx) || (drag.source.myIdx == myIdx - 1)))
                {
                    drag.source.acceptedDrag = true
                    acceptsDrag = true
                    og.myExtendedLength = occuping_width
                } else {
                    drag.source.acceptedDrag = false
                    acceptsDrag = false
                    og.myExtendedLength = 0
                }
            }
        }

        onExited:{
            if (drag.source.myType == "activity"){
                drag.source.willBeAdded = false
            }
            drag.source.acceptedDrag = false
            acceptsDrag = false
            og.myExtendedLength = 0
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
                console.log("")
                console.log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                console.log(og)
                og.myExtendedLength = 0
            }
        }
    }
}