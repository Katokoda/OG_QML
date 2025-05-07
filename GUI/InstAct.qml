import QtQuick 2.15

Rectangle {
    id: actId
    width: 80
    height: 40
    radius: 8
    color: "cyan"

    border.color : "black"
    border.width: 2

    scale: ((isCurrentlyDragged)? 1.1 : 1.0)
    property bool isCurrentlyDragged: false
    property bool acceptedDrag: false
    property point beginDrag

    property string myType: "instAct"
    required property int myIdx
    required property var instAct


    Text {
        id: labelText
        anchors.centerIn: parent
        font.bold: true
        color: "#222222"
        text: instAct?.label
        font.pointSize: 8
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
            mainSection.state = 'hasDraggedElement'
        }

        onReleased: {
            parent.isCurrentlyDragged = false
            mainSection.state = ""
            if (parent.acceptedDrag){
                parent.acceptedDrag = false
                parent.Drag.drop()
            } else {
                backAnimX.from = actId.x;
                backAnimX.to = beginDrag.x;
                backAnimY.from = actId.y;
                backAnimY.to = beginDrag.y;
                backAnim.start()
            }
        }

        onClicked: (mouse) => {
            app_selectedAct_Real = instAct
            app_selectionPoint = actId.mapToGlobal(Qt.point(mouse.x, mouse.y))
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation { id: backAnimX; target: actId; property: "x"; duration: 500; spring: 10; damping: 0.45 }
        SpringAnimation { id: backAnimY; target: actId; property: "y"; duration: 500; spring: 10; damping: 0.45 }
    }
}
 