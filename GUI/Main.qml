import QtQuick
import QtQuick.Controls.Basic

import QtQuick.Shapes 1.9

ApplicationWindow {
    id: main

        // // DEBUG to make some property visible live
        // Text{
        //     z:1000
        //     anchors.top: parent.top
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     text: (app_selectedGap != null ? app_selectedGap.myIdx : "no gap selected")
        //     color: "white"
        // }

    visible: true
    width: 1080
    height: 1080
    title: "Orchestration Graph - interactive Engine"

    color: "#000000"
    property bool isTopPanelVisible: true


    property var app_selectedAct: null
    property bool app_selectedActIsInstanciated: false

    property var app_selectedGap: null

    function myGraphUpdate() {
        resetActSelection()
        resetGapSelection()
    }

    function resetActSelection() {
        if (app_selectedAct != null){
            app_selectedAct.isCurrentlySelected = false
        }
        app_selectedAct = null
        app_selectedActIsInstanciated = false
    }
    
    function setActSelection(selAct: var, isInstanciated: bool){
        resetActSelection()
        selAct.isCurrentlySelected = true
        app_selectedAct = selAct
        app_selectedActIsInstanciated = isInstanciated
    }

    function resetGapSelection() {
        og.selectExtendedLength = 0
        library.state = ""
        if (app_selectedGap != null){
            context_OGraph.setGapFocus(-1)
            app_selectedGap.isCurrentlySelected = false
        }
        app_selectedGap = null
    }
    
    function setGapSelection(selGap: var){
        if (app_selectedGap != selGap){
            resetGapSelection()
            selGap.isCurrentlySelected = true
            og.selectExtendedLength = selGap.occuping_width
            app_selectedGap = selGap
            context_OGraph.setGapFocus(selGap.myIdx)
            library.state = "PresentingSelectionGap"
        }
    }

    // This mouseArea covers the whole window and catchs clicks to "un-select" anything.
    MouseArea {
        anchors.fill: parent
        onClicked: (mouse) => {
            resetActSelection()
            resetGapSelection()
        }
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

        Top_Lesson {
            anchors.fill: parent
            visible: (app_selectedAct == null)
        }

        Top_Activity {
            anchors.fill: parent
            visible: (app_selectedAct != null)
        }

    }




    // MIDDLE SECTION
    Rectangle {
        id: middleSection
        z: 3
        anchors.bottom: bottomPanel.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: parent.height - topPanel.height - bottomPanel.height
        color: "transparent"

        // MAIN SECTION
        Rectangle {
            id: mainSection
            anchors.left: middleSection.left
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width - rightPanel.width
            height: parent.height
            color: "transparent"
            border.width: 1
            border.color: "#444444"

            OrchestrationGraph {
                id: og
            }


            states: [
                State {
                    name: "hasDraggedElement"
                    PropertyChanges {
                        target: mainSection
                        z: 2
                    }
                }
            ]
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

            Library {
                id: library
                visible: true
            }

            states: [
                State {
                    name: "hasDraggedElement"
                    PropertyChanges {
                        target: rightPanel
                        z: 2
                    }
                }
            ]
            
        }
    }


    // Small button to pup up the Bottom Panel
    Rectangle {
        id: smallButtonBotPanel
        z: 2 // To get over the Bottom Panel as well as the other sections
        anchors.bottom: undefined
        anchors.top: bottomPanel.top
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
            font.pointSize: 15
            color: "white"

            // default state of bottomPanel:
            font.bold:      false
            text:           "close"
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent

            onClicked: {
                if (bottomPanel.state == 'closed'){
                    bottomPanel.state = ""
                } else {
                    bottomPanel.state = 'closed'
                }
            }
        }
    }

    // BOTTOM PANEL
    Rectangle {
        id: bottomPanel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter


        width: parent.width
        height: main.height * 0.25
        
        color: "#2b2b2b"
        border.width: 1
        border.color: "#444444"

        Rectangle {
            id: llm
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
                    text: "LLM"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    text: "(not yet implemented)"
                }

                Text {
                    id: clickForDetailsText
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#AAAAAA"
                    text: "Click for details... "
                }
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                drag.target: parent

                onClicked: bottomPanel.state = "big"
            }
        }

        states: [
            State {
                name: "closed"
                PropertyChanges {
                    target: llmText
                    font.bold:      true
                    text:           "LLM"
                }
                PropertyChanges {
                    target: bottomPanel
                    height: 0
                }
                PropertyChanges {
                    target: llm
                    visible: false
                }
                AnchorChanges {
                    target: smallButtonBotPanel
                    anchors.top: undefined
                    anchors.bottom : parent.bottom
                }
            },
            State {
                name: "big"
                PropertyChanges {
                    target: topPanel
                    height: 0
                }
                PropertyChanges {
                    target: bottomPanel
                    height: main.height * 0.5
                }
                PropertyChanges {
                    target: clickForDetailsText
                    visible: false
                }
            }
        ]

        Component.onCompleted: {
            bottomPanel.state = "closed"
        }
    }
}