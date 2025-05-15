import QtQuick 2.15

Rectangle {
    id: invisibleAct
    property string myType: "instAct"

    property bool isCurrentlyDragged: false
    property bool acceptedDrag: false
    property bool willBeDeleted: false
    property point beginDrag

    required property int myIdx
    required property var instAct

    property int verticalOffset: 40 * instAct.plane


    width: pixelPerMinute * instAct.myTime
    height: 120
    color: "transparent"

        // //DEBUG
        // border.width: 1
        // border.color: "orange"
        // //DEBUG

    Rectangle{
        id: visibleAct
        width: invisibleAct.width
        height: 40
        radius: 8
        color: ((parent.willBeDeleted)? "lime" : "cyan")

        anchors.top: parent.top
        anchors.topMargin: verticalOffset

        border.color : "black"
        border.width: 2

        scale: ((parent.isCurrentlyDragged)? ((parent.willBeDeleted)? 1.0 : 1.2) : 1.0)


        Text {
            id: labelText
            anchors.centerIn: parent
            font.bold: true
            color: "#222222"
            text: invisibleAct.instAct.label
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
            resetSelection()
            app_selectedAct = instAct
            app_selectedActIsInstanciated = true
            // The point (0, 0 + verticalOffset) is, in the local coordinate system, the "top-left-corner" of the activity.
            // However, as the rectangle are rounded, this point is visibly outside of the rectangle.
            // The precise coordinates of the goal point is (1 - sin(45°)) * radius) for each coordinate.
            // However, this is still visibly outside of the rectangle, hence I rounded this 0.29289 to 0.5 (weird, I might have not understood the radius property)
            app_selectionActAngle = invisibleAct.mapToGlobal(Qt.point(visibleAct.radius * 0.5, visibleAct.radius * 0.5 + verticalOffset))
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation { id: backAnimX; target: invisibleAct; property: "x"; duration: 500; spring: 10; damping: 0.45 }
        SpringAnimation { id: backAnimY; target: invisibleAct; property: "y"; duration: 500; spring: 10; damping: 0.45 }
    }
}
 