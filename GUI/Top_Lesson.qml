import QtQuick 2.15
import QtQuick.Dialogs


Rectangle {
    anchors.fill: parent
    color: "transparent"

    // DESCRIPTION OF THE LESSON
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
            text: "Lesson teaching <description of the lesson>."
            font.pointSize: 16

        }

        Text {
            id: text_time
            anchors.top: text_title.bottom
            anchors.topMargin: parent.lineSpacing
            anchors.left: text_title.left

            color: "white"
            text: "Using "+ context_OGraph.totalTime + " out of allowed "+ context_OGraph.lessonTime + " minutes."
            font.pointSize: 12
        }

        Text {
            id: text_gaps
            anchors.top: text_time.bottom
            anchors.topMargin: parent.lineSpacing
            anchors.left: text_time.left
            
            color: "white"
            text: "Has "+ context_OGraph.remainingGapsCount + " transitions considerered too hard by the engine (NOT marked <!>)."
            font.pointSize: 12
        }
    }


    // ACTIONS ON THE LESSON
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

            // This is the row of buttons for the lesson
            id: buttonRow

            MyButton {
                id: button_reset
                anchors.verticalCenter: parent.verticalCenter
                enabled: (context_OGraph.totalTime > 0)

                buttonText: "Reset"
                onClicked: {
                    context_OGraph.reset()
                }
            }
            
            MyButton {
                id: button_load
                anchors.verticalCenter: parent.verticalCenter
                
                buttonText: "Load"
                onClicked: {
                    loadFileDialog.open()
                }


                FileDialog {
                    id: loadFileDialog
                    defaultSuffix: "pickle"
                    acceptLabel: "Save"

                    nameFilters: ["Pickle Files (*.pickle)", "All Files (*)"]

                    onAccepted: {
                        context_OGraph.loadFromFile(selectedFile)
                    }
                    onRejected: {
                        console.log("Rejected File")
                    }
                }
            }

            MyButton {
                id: button_save
                anchors.verticalCenter: parent.verticalCenter
                
                buttonText: "Save"
                onClicked: {
                    saveFileDialog.open()
                }

                FileDialog {
                    id: saveFileDialog
                    defaultSuffix: "pickle"
                    acceptLabel: "Save"
                    fileMode: FileDialog.SaveFile

                    nameFilters: ["Pickle Files (*.pickle)", "All Files (*)"]

                    onAccepted: {
                        loadFileDialog.currentFolder = currentFolder
                        context_OGraph.saveAsFile(selectedFile)
                    }
                    onRejected: {
                        console.log("Rejected File")
                    }
                }
            }

            MyButton {
                id: button_textprint
                anchors.verticalCenter: parent.verticalCenter
                
                buttonText: "Print"
                onClicked: {
                    context_OGraph.print()
                }
            }

            MyButton {
                id: button_techprint
                anchors.verticalCenter: parent.verticalCenter
                
                buttonText: "Print (technical)"
                onClicked: {
                    context_OGraph.myCustomPrintFunction()
                }
            }

            MyButton {
                id: button_addRecoGeneral
                visible: (app_selectedGap == null)
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                
                buttonText: "Add Recommended"
                onClicked: {
                    console.log("Clicked Add Recommended GENERAL button - not yet implemented")
                }
            }

            MyButton {
                id: button_addRecoGap
                visible: (app_selectedGap != null)
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                
                buttonText: "Add Recommended here"
                onClicked: {
                    console.log("Clicked Add Recommended HERE button - not yet implemented")
                }
            }
        }
    }
}