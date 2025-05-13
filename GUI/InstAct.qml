import QtQuick 2.15

Rectangle {
    id: invisibleAct
    width: 80
    height: 120

        //DEBUG
        border.width: 1
        border.color: "orange"
        color: "transparent"
        //DEBUG

    property bool isCurrentlyDragged: false
    property bool acceptedDrag: false
    property bool willBeDeleted: false
    property point beginDrag

    property string myType: "instAct"
    required property int myIdx
    required property var instAct

    property int verticalOffset: 40 * instAct?.plane

    Rectangle{
        id: visibleAct
        width: 80
        height: 40
        radius: 8
        color: ((parent.willBeDeleted)? "lime" : "cyan")

        anchors.top: parent.top
        anchors.topMargin: verticalOffset

        border.color : "black"
        border.width: 2

        scale: ((parent.isCurrentlyDragged)? ((parent.willBeDeleted)? 1.0 : 1.1) : 1.0)


        Text {
            id: labelText
            anchors.centerIn: parent
            font.bold: true
            color: "#222222"
            text: invisibleAct.instAct?.label
            font.pointSize: 8
        }
    }


    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: dragArea.mouseX
    Drag.hotSpot.y: dragArea.mouseY + verticalOffset

    MouseArea {
        id: dragArea
        anchors.fill: visibleAct
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
                backAnimX.from = invisibleAct.x;
                backAnimX.to = beginDrag.x;
                backAnimY.from = invisibleAct.y;
                backAnimY.to = beginDrag.y;
                backAnim.start()
            }
        }

        onClicked: (mouse) => {
            app_selectedAct_Real = instAct
            app_selectionPoint = invisibleAct.mapToGlobal(Qt.point(mouse.x, mouse.y))
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation { id: backAnimX; target: invisibleAct; property: "x"; duration: 500; spring: 10; damping: 0.45 }
        SpringAnimation { id: backAnimY; target: invisibleAct; property: "y"; duration: 500; spring: 10; damping: 0.45 }
    }
}
 