import QtQuick 2.15
import QtQuick.Shapes 1.9

Rectangle {
    id: myTextElement
    anchors.fill: parent
    color: "transparent"

    required property string myText
    required property color myColor
    required property int mySize

    property bool isCurrentlyHovered: false
    property bool isTooBig: (labelText.contentWidth + myMargin > parent.width)
    property int myArrowLenght: 8
    property int myMargin: 6


    // The text that should be displayed if there is enough space.
    Text {
        id: labelText
        anchors.centerIn: parent
        text: myTextElement.myText

        visible: !isTooBig

        font.pointSize: mySize
        font.bold: true
        color: myColor
    }

    // The alternative text that we display when there is not enough space.
    Text {
        id: miniText
        anchors.centerIn: parent

        visible: isTooBig

        font.pointSize: mySize
        font.bold: true
        color: myColor
        text: (isTooBig? context_textShortener.shorten(myText, labelText.contentWidth, myTextElement.parent.width - myMargin) : "nothing - ERROR")
    }

    // When there is no space AND the item is hovered, we add this bubble.
    Item {
        id: whenHovered
        visible: (parent.isCurrentlyHovered && parent.isTooBig)
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: myArrowLenght
            anchors.horizontalCenter: parent.horizontalCenter
            width: labelText.contentWidth + myMargin + border.width
            height: 40
            radius: 8
            color: "black"

            border.color : "grey"
            border.width: 3
                Text {
                anchors.centerIn: parent
                text: myTextElement.myText

                font.pointSize: labelText.font.pointSize
                font.bold: true
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
 