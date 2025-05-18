import QtQuick 2.15

Rectangle{
    color: "transparent"
    width: height
    radius: height/2

    border.width: 1
    border.color: "white"

    Text{
        anchors.centerIn: parent
        text: "+"
        color: "white"
    }
}