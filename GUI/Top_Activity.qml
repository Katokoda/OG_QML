import QtQuick 2.15
import QtQuick.Shapes 1.9


Rectangle {
    anchors.fill: parent
    color: "transparent"


    // Proposed activity info
    Text {
        visible: (app_selectedActIsInstantiated == false)
        anchors.top: parent.top
        anchors.left: parent.left
        font.bold: true
        color: "white"
        text: "Info about the proposed activity"
        font.pointSize: 12
    }


    // Instantiated activity info
    Text {
        visible: (app_selectedActIsInstantiated == true)
        anchors.top: parent.top
        anchors.left: parent.left
        font.bold: true
        color: "white"
        text: "Info about the activity in the lesson"
        font.pointSize: 12
    }


    // ACTIVITY SELECTION INDICATOR
    Rectangle {
        id: topPanelBalise
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40
        width: height*2
        z : 2
        color : "transparent"
        border.color : "transparent"
        border.width: 1

        Shape {
            anchors.centerIn: parent

            ShapePath {
                fillColor: (app_selectedAct!=null ? app_selectedAct.color : "pink")
                strokeColor: "white"
                strokeWidth: 2

                capStyle: ShapePath.FlatCap

                PathAngleArc {
                    centerX: topPanelBalise.height; centerY: topPanelBalise.height
                    radiusX: topPanelBalise.height; radiusY: topPanelBalise.height
                    startAngle: -180
                    sweepAngle: 180
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "black"
            text: "close"
        }
    }
}