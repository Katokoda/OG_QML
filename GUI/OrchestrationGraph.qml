import QtQuick 2.15

Rectangle {
    anchors.fill: parent
    color: "transparent"



    Column {
        anchors.centerIn: parent
        spacing: 10
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            font.pointSize: 20
            color: "white"
            text: "Orchestration Graph"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            text: "(not yet implemented)"
        }
    }

}