import QtQuick 2.15

Rectangle {
    id: actId
    width: 80
    height: 40
    radius: 8

    // lime = "#00FF00" hence the un-selected color will be de-saturated, "#00CC00"
    color: ((willBeAdded)? "cyan" : (isCurrentlySelected ? "lime" : "#00CC00")) 
    border.color : (isCurrentlySelected ? "white" : "black")
    border.width: 2

    scale: ((isCurrentlyDragged)? 1.2 : 1.0)
    property bool isCurrentlyDragged: false
    property bool isCurrentlySelected: false
    property bool acceptedDrag: false
    property bool willBeAdded: false
    property point beginDrag

    property string myType: "activity"
    required property int myIdx
    required property var activity


    MyText {
        id: labelText
        myText: activity.label
        myColor: "#222222"
        mySize: 10
    }


    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: dragArea.mouseX
    Drag.hotSpot.y: dragArea.mouseY

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: parent

        onPressed: {
            parent.beginDrag = Qt.point(parent.x, parent.y);
            parent.Drag.start()
            parent.isCurrentlyDragged = true
            rightPanel.state = 'hasDraggedElement'
        }

        onReleased: {
            parent.isCurrentlyDragged = false
            rightPanel.state = ""
            if (parent.acceptedDrag){
                parent.acceptedDrag = false
                parent.Drag.drop()
                tpBackAnimX.from = actId.x;
                tpBackAnimX.to = beginDrag.x;
                tpBackAnimY.from = actId.y;
                tpBackAnimY.to = beginDrag.y;
                tpBackAnim.start()
            } else {
                backAnimX.from = actId.x;
                backAnimX.to = beginDrag.x;
                backAnimY.from = actId.y;
                backAnimY.to = beginDrag.y;
                backAnim.start()
            }
        }

        onClicked: (mouse) => {
            setActSelection(actId, false)
            parent.acceptedDrag = false
            parent.Drag.drop()
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation { id: backAnimX; target: actId; property: "x"; duration: 500; spring: 10; damping: 0.45 }
        SpringAnimation { id: backAnimY; target: actId; property: "y"; duration: 500; spring: 10; damping: 0.45 }
    }
    ParallelAnimation {
        id: tpBackAnim
        NumberAnimation { id: tpBackAnimX; target: actId; property: "x"; duration: 1}
        NumberAnimation { id: tpBackAnimY; target: actId; property: "y"; duration: 1}
        NumberAnimation { id: tpBackAnimScale; target: actId; from: 0.0; to: 1.0; property: "scale"; duration: 50}
    }
}
 