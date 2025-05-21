import QtQuick 2.15

Rectangle {
    id: myTextElement
    anchors.fill: parent
    color: "transparent"

    required property string myText
    required property color myColor
    required property int mySize

    property bool isCurrentlyHovered: false


    Text {
        id: labelText
        anchors.centerIn: parent
        text: myTextElement.myText

        // font.pointSize: mySize
        // font.bold: true
        // color: myColor

        font.pointSize: mySize + 5
        font.bold: true
        color: (parent.isCurrentlyHovered ? "purple" : "#222222") 
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.isCurrentlyHovered = true
        onExited: parent.isCurrentlyHovered = false 
    }
}
 