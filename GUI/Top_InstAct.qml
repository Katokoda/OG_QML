import QtQuick 2.15
import QtQuick.Shapes 1.9
import QtQuick.Controls 2.5


Rectangle {
    anchors.fill: parent
    color: "transparent"

    function forceResetSelection() {
        timeInput.clear();
    }
    
    // DESCRIPTION OF THE INST_ACT
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
                font.pointSize: 16
                font.bold: true

                color: "white"
                text: (app_selectedModel_InstAct != null ? "Specific activity named "+ app_selectedModel_InstAct.label + "." : "null")
            }


            Text {
                font.pointSize: 12

                color: "white"
                // "Starts after XX minutes[, with YY prior activit[y/ies]]."
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
            }

            Text {
                font.pointSize: 12

                color: "white"
                text: (app_selectedModel_InstAct != null ? "Uses "+ app_selectedModel_InstAct.myTime + " minutes." : "null")

                Text{
                    visible: (app_selectedModel_InstAct != null ? app_selectedModel_InstAct.canChangeTime : false)
                    anchors.bottom: parent.bottom
                    anchors.left: parent.right

                    color: "#CCCCCC"
                    // " The engine recommends it to use between XX and YY minutes. Change to"
                    text:   (app_selectedModel_InstAct != null ?
                                " The engine recommends it to use between " +
                                app_selectedModel_InstAct.minTime +
                                " and " +
                                app_selectedModel_InstAct.maxTime +
                                " minutes. Change to "
                            : "null" )

                    TextField {
                        id: timeInput
                        anchors.left: parent.right
                        anchors.bottom: parent.bottom

                        placeholderText: (app_selectedModel_InstAct != null ? app_selectedModel_InstAct.myTime : "0")
                        validator: IntValidator{bottom:
                                                    (app_selectedModel_InstAct != null ? app_selectedModel_InstAct.minTime : 0);
                                                top:
                                                    (app_selectedModel_InstAct != null ? app_selectedModel_InstAct.maxTime : 0)}
                        onAccepted : {
                            app_selectedModel_InstAct.setTime(timeInput.text);
                            console.log("InstAct: Time changed to " + app_selectedModel_InstAct.myTime);
                            timeInput.clear()
                            context_OGraph.forceRestructuration();
                        }
                    }
                }
            }

            Text {
                id: text_plane
                
                color: "white"
                text: (app_selectedModel_InstAct != null ? "Is done <b>"+ app_selectedModel_InstAct.planeDescription + "</b>." : "null")
                font.pointSize: 12
            }
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