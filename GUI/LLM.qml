import QtQuick 2.15

Rectangle {
    anchors.fill: parent
    color: "transparent"
    visible: botPanelMode != Main.BottomPanelMode.Hidden

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            font.pointSize: 20
            color: "white"
            text: "LLM"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            text: "(not yet implemented)"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#AAAAAA"
            text: "Click for details... "
            visible: botPanelMode !== Main.BottomPanelMode.Big
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: parent

        onClicked: botPanelMode = Main.BottomPanelMode.Big
    }
}
