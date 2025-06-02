import QtQuick 2.15

Rectangle {
    id: invisibleAct
    property string myType: "instAct"

    property bool isCurrentlyDragged: false
    property bool shouldBeAbove: (isCurrentlyDragged || labelText.isCurrentlyHovered)
    property bool acceptedDrag: false
    property bool willBeDeleted: false
    property point beginDrag

    required property int myIdx
    required property var instAct

    property int verticalOffset: (instAct != null ? (40 * instAct.plane) : 0)


    width: (instAct != null ? pixelPerMinute * instAct.myTime : 0)
    height: parent.height
    color: "transparent"

        // //DEBUG
        // border.width: 1
        // border.color: "orange"
        // //DEBUG

    Rectangle{
        id: visibleAct

        property bool isCurrentlySelected: false
        width: invisibleAct.width - 1
        height: 40
        radius: 8

        // cyan = "#00FFFF" hence the un-selected color will be de-saturated, "#00CCCC"
        color: ((parent.willBeDeleted)? "lime" : (isCurrentlySelected ? "cyan" : "#00CCCC"))
        border.color : (isCurrentlySelected ? "white" : "black")
        border.width: 2

        anchors.top: parent.top
        anchors.topMargin: verticalOffset


        scale: ((parent.isCurrentlyDragged)? ((parent.willBeDeleted)? 1.0 : 1.2) : 1.0)

        
        MyText {
            id: labelText
            myText: (instAct != null ? invisibleAct.instAct.label : "null")
            myColor: "#222222"
            mySize: 10
        }

        // Small text displaying the time taken by that instantiated activity
        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 4
            text: (invisibleAct.instAct != null ? invisibleAct.instAct.myTime + "'" : "null")
            color: "black"
            font.pixelSize: 10
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
            setActSelection(visibleAct, true)
        }
    }
    ParallelAnimation {
        id: backAnim
        SpringAnimation { id: backAnimX; target: invisibleAct; property: "x"; duration: 500; spring: 10; damping: 0.45 }
        SpringAnimation { id: backAnimY; target: invisibleAct; property: "y"; duration: 500; spring: 10; damping: 0.45 }
    }
}
 