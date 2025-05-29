import QtQuick 2.15


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

        MyButton {
            id: button_reset
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20

            buttonText: "Reset"
            onClicked: {
                context_OGraph.reset()
            }
        }
        
        MyButton {
            id: button_load
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: button_reset.right
            anchors.leftMargin: 5
            
            buttonText: "Load"
            onClicked: {
                console.log("Clicked load button - not yet implemented")
            }
        }

        MyButton {
            id: button_save
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: button_load.right
            anchors.leftMargin: 5
            
            buttonText: "Save"
            onClicked: {
                console.log("Clicked save button - not yet implemented")
            }
        }

        MyButton {
            id: button_textprint
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: button_save.right
            anchors.leftMargin: 5
            
            buttonText: "Print"
            onClicked: {
                context_OGraph.print()
            }
        }

        MyButton {
            id: button_techprint
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: button_textprint.right
            anchors.leftMargin: 5
            
            buttonText: "Print (technical)"
            onClicked: {
                context_OGraph.myCustomPrintFunction()
            }
        }
    }
}