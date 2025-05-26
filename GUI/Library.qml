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

    // This is the standard library column. It is shown when no gap is selected.
    Column {
        id: libraryColumn
        spacing: 5
        anchors.centerIn: parent

        Repeater {
            model: context_OGraph.listActivityForGap

            delegate: Item {
                width: contextAct.occuping_width
                height: contextAct.occuping_height

                ContextAct {
                    id: contextAct
                    contextActObject: modelData
                    ctxActIdx: index
                }

                // ONLY in relation to the other items in the same parent
                z: (contextAct.shouldBeAbove ? 2 : 1)
            }
        }
    }


    
    states: [
        State {
            name: "PresentingSelectionGap"
            PropertyChanges {
                target: selectedGapText
                visible: true
            }
        }
    ]

}
 