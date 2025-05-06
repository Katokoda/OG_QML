import QtQuick
import QtQuick.Controls.Basic

ApplicationWindow {
    visible: true
    width: 1080
    height: 1080
    title: "Engine"

    property var app_selectedAct_Real: null
    property var app_selectedAct_Prop: null
    property var app_selectedGap: null

    property bool isTopPanelVisible: true
    property bool isBotPanelVisible: true

    // Background
    Rectangle {
        anchors.fill: parent
        color: "pink"
    }



    // TOP PANEL
    Rectangle {
        id: topPanel
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: (isTopPanelVisible ? parent.height * 0.25 : 0)

        color: "#2b2b2b"
        border.width: 1
        border.color: "#444444"
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


    // BOTTOM PANEL
    Rectangle {
        id: bottomPanel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: (isBotPanelVisible ? parent.height * 0.25 : 0)
        
        color: "#2b2b2b"
        border.width: 1
        border.color: "#444444"

        LLM {
            id: llm
        }

    }
}