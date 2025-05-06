import QtQuick
import QtQuick.Controls.Basic

import QtQuick.Shapes 1.9

ApplicationWindow {
    id: main
    enum BottomPanelMode {
        Hidden,
        Visible,
        Big
    }

    visible: true
    width: 1080
    height: 1080
    title: "Engine"

    property var app_selectedAct_Real: null
    property var app_selectedAct_Prop: null
    property var app_selectedGap: null
    property bool app_hasSelection: (app_selectedAct_Real != null ||
                                    app_selectedAct_Prop != null ||
                                    app_selectedGap != null)
    property point app_selectionPoint

    property bool isTopPanelVisible: true
    property int botPanelMode: Main.BottomPanelMode.Visible

    // Background
    Rectangle {
        anchors.fill: parent
        color: "pink"
    }

    MouseArea {
        anchors.fill: parent

        onClicked: (mouse) => {
            console.log("The main window has been clicked - reseting selections")
            app_selectedAct_Real = true
            app_selectedAct_Prop = null
            app_selectedGap = null
            console.log("TODO: reset the selectionPoint")
            app_selectionPoint = Qt.point(mouse.x, mouse.y)
        }
        
    }



    // TOP PANEL
    Rectangle {
        id: topPanel
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: (isTopPanelVisible && botPanelMode != Main.BottomPanelMode.Big ? parent.height * 0.25 : 0)

        color: "#2b2b2b"
        border.width: 1
        border.color: "#444444"

        Item {
            id: topPanelBalise
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // SELECTION INDICATOR
    Shape {
        z : 1000
        visible: app_hasSelection

        ShapePath {
            strokeWidth: 2
            strokeColor: "red"
            capStyle: ShapePath.RoundCap

            startX: topPanelBalise.x; startY: topPanelBalise.y
            PathLine { x: app_selectionPoint.x; y: app_selectionPoint.y }
        }
    }


    // MIDDLE SECTION
    Rectangle {
        id: middleSection
        anchors.bottom: bottomPanel.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: parent.height - topPanel.height - bottomPanel.height
        color: "purple"

        // MAIN SECTION
        Rectangle {
            id: mainSection
            anchors.left: middleSection.left
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width - rightPanel.width
            height: parent.height
            color: "#000000"
            border.width: 1
            border.color: "#444444"

            OrchestrationGraph {
                id: og
            }
        }

        // RIGHT PANEL
        Rectangle {
            id: rightPanel
            anchors.right: middleSection.right
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width * 0.33
            height: parent.height

            color: "#222222"
            border.width: 1
            border.color: "#444444"
        }
    }


    // Small button to pup up the Bottom Panel
    Rectangle {
        anchors.bottom: bottomPanel.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: llmText.contentWidth
        height: llmText.contentHeight

        color: "#2b2b2b"
        border.width: 1
        border.color: "#444444"

        Text {
            id: llmText
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold:      (botPanelMode == Main.BottomPanelMode.Hidden ? "true"   : "false"   )
            font.pointSize: (botPanelMode == Main.BottomPanelMode.Hidden ? 15       : 15        )
            text:           (botPanelMode == Main.BottomPanelMode.Hidden ? "LLM"    : "close"   )
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent

            onClicked: botPanelMode = (botPanelMode == Main.BottomPanelMode.Hidden ?
                                        Main.BottomPanelMode.Visible
                                        :  Main.BottomPanelMode.Hidden)
            
        }
    }

    // BOTTOM PANEL
    Rectangle {
        id: bottomPanel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter


        width: parent.width
        height: (botPanelMode == Main.BottomPanelMode.Visible ?
                parent.height * 0.25
                :   (botPanelMode == Main.BottomPanelMode.Big ?
                        parent.height * 0.5
                        : 0
                    )
                )
        
        color: "#2b2b2b"
        border.width: 1
        border.color: "#444444"

        LLM {
            id: llm
        }

    }
}