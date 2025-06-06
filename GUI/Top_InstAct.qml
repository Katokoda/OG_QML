import QtQuick 2.15
import QtQuick.Shapes 1.9


Rectangle {
    anchors.fill: parent
    color: "transparent"
    
    // DESCRIPTION OF THE INST_ACT
    Rectangle{
        color: "transparent"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height * 0.75


        property int lineSpacing: 10

        Text {
            id: text_title
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.bold: true
            color: "white"
            text: (app_selectedModel_InstAct != null ? "Specific activity named "+ app_selectedModel_InstAct.label + "." : "null")
            font.pointSize: 16
        }


        Text {
            id: text_position
            anchors.top: text_title.bottom
            anchors.topMargin: parent.lineSpacing
            anchors.left: text_title.left
            
            color: "white"
            text:   (app_selectedAct != null && app_selectedModel_InstAct != null?
                        "Starts after " +
                        app_selectedModel_InstAct.startsAfter +
                        " minutes" + 
                            (app_selectedAct.myIdx > 0 ?
                                ", with " +
                                app_selectedAct.myIdx + 
                                " prior activit" + 
                                (app_selectedAct.myIdx > 1 ? "ies" : "y")
                            : "") +
                        "."
                    : "null" )
            font.pointSize: 12
        }

        Text {
            id: text_time
            anchors.top: text_position.bottom
            anchors.topMargin: parent.lineSpacing
            anchors.left: text_position.left

            color: "white"
            text: (app_selectedModel_InstAct != null ? "Uses "+ app_selectedModel_InstAct.myTime + " minutes." : "null")
            font.pointSize: 12

            Text{
                visible: (app_selectedModel_InstAct != null ? app_selectedModel_InstAct.canChangeTime : false)
                anchors.bottom: text_time.bottom
                anchors.left: text_time.right

                color: "#CCCCCC"
                text:   (app_selectedModel_InstAct != null ?
                            " The engine recommends it to use between " +
                            app_selectedModel_InstAct.minTime +
                            " and " +
                            app_selectedModel_InstAct.maxTime +
                            " minutes."
                        : "null" )
            }
        }

        Text {
            id: text_plane
            anchors.top: text_time.bottom
            anchors.topMargin: parent.lineSpacing
            anchors.left: text_time.left
            
            color: "white"
            text: (app_selectedModel_InstAct != null ? "Is done <b>"+ app_selectedModel_InstAct.planeDescription + "</b>." : "null")
            font.pointSize: 12
        }
    }

    // ACTIONS FOR THE INST_ACT
    Rectangle{
        color: "transparent"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height * 0.25

        Row {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            spacing: 5

            id: buttonRow

            MyButton {
                id: button_reset
                anchors.verticalCenter: parent.verticalCenter
                enabled: (context_OGraph.totalTime > 0) // TODO - enabling condition

                buttonText: "Button" // TODO - name
                onClicked: {
                    console.log("InstAct: Button clicked") // TODO - apply changes
                }
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