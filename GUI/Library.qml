import QtQuick 2.15

Rectangle {
    id: library
    anchors.fill: parent
    color: "transparent"

    // Drop zone filling the entire Library which accepts to "delete" the dragged instanciated activity
    DropZoneLibrary{}

    Text {
        id: selectedGapText
        visible: false

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: libraryColumn.top
            rightMargin: 5
            leftMargin: 5
        }
        wrapMode: Text.Wrap
        horizontalAlignment:Text.AlignHCenter
        verticalAlignment:Text.AlignVCenter

        text: "The color indicates which activity fits in the selected gap"
        //font.pointSize: 8
        color: "white"
    }

    Column {
        id: libraryColumn
        spacing: 5
        anchors.centerIn: parent

        Repeater {
            model: ContextLibrary.listeProp

            delegate: Item {
                width: thisAct.width
                height: thisAct.height

                Activity {
                    id: thisAct
                    activity: modelData
                    myIdx: index
                }

                // ONLY in relation to the other items in the same parent
                z: (thisAct.isCurrentlyDragged ? 2 : 1)
            }
        }
    }
    
    states: [
        State {
            name: "PresentingSelectionGap"
            PropertyChanges {
                target: library
                color: "purple"
            }
            PropertyChanges {
                target: selectedGapText
                visible: true
            }
        }
    ]

}
 