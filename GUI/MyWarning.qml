import QtQuick 2.15
import QtQuick.Shapes 1.9

Rectangle {
    id: myWarning
    width: 20
    height: 30
    color: "transparent"

    //required property string myType // Could be used to differentiate between different warnings (flags of ContextActs) but we have not time for that right now.

    property bool isCurrentlyHovered: false
    property int myArrowLenght: 8
    property int myMargin: 6

    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: "!"
        color: "#FF0000"
        font.pixelSize: 30
    }

    // When the item is hovered, we add this bubble.
    Item {
        id: whenHovered
        visible: parent.isCurrentlyHovered
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: myArrowLenght
            anchors.horizontalCenter: parent.horizontalCenter
            width: labelText.contentWidth + myMargin + border.width
            height: labelText.contentHeight + myMargin + border.width
            radius: 8
            color: "black"

            border.color : "grey"
            border.width: 3
            Text {
                id: labelText
                width: 160
                wrapMode: Text.WordWrap

                anchors.centerIn: parent
                text: "This symbol indicates that the transition is considered too hard by the engine. Consider inserting an activity here."
                color: "white"
            }
        }

        // Little arrow that connects with the original text
        Shape {
            width: myArrowLenght*2
            height: myArrowLenght
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            ShapePath {
                strokeWidth: 1
                strokeColor: "grey"
                fillColor: "grey"
                startX: myArrowLenght; startY: myArrowLenght
                PathLine { x: 0; y: 0 }
                PathLine { x: 2*myArrowLenght; y: 0 }
                PathLine { x: myArrowLenght; y: myArrowLenght }
            }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.isCurrentlyHovered = true
        onExited: parent.isCurrentlyHovered = false 
    }
}
 