import QtQuick 2.15
import QtQuick.Shapes 1.9


Rectangle {
    anchors.fill: parent
    color: "transparent"

    // DESCRIPTION OF THE ACT
    Rectangle{
        color: "transparent"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height * 0.75


        Column{
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20

            spacing: 10


            Text {
                font.bold: true
                font.pointSize: 16

                color: "white"
                text: (app_selectedModel_Act != null ? "General activity named "+ app_selectedModel_Act.label + "." : "null")

            }

            Text {
                font.pointSize: 12

                color: "white"
                text: (app_selectedModel_Act != null ? "Would use "+ app_selectedModel_Act.defTime + " minutes by default." : "null")
            }

            Text {
                font.pointSize: 12

                color: "white"
                text: (app_selectedModel_Act != null ? "Would be done <b>"+ app_selectedModel_Act.planeDescription + "</b> by default." : "null")
            }
        }
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
                fillColor: (app_selectedAct!=null ? app_selectedAct.shownColor : "pink")
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