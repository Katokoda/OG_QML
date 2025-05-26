import QtQuick 2.15

Rectangle {
    required property var contextActObject
    required property int ctxActIdx

    width: thisAct.width
    height: thisAct.height

    color: "transparent"

    property int occuping_width: thisAct.width
    property int occuping_height: thisAct.height
    property bool shouldBeAbove: thisAct.isCurrentlyDragged || thisAct.isCurrentlySelected

    Activity {
        id: thisAct
        visible: contextActObject != null
        activity: (contextActObject != null ? contextActObject.activity : null)
        myIdx: ctxActIdx
    }

    Text {
        id: exhaustionWarning
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.right
        text: (contextActObject != null ?
            (contextActObject.flags.isExhausted ? " tooMuch " : "")
            : "null")
        color: "white"
        font.pixelSize: 12
        Text {
            id: timeWarning
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            text: (contextActObject != null ?
                (contextActObject.flags.isTooLong ? " time " : "")
                : "null")
            color: "white"
            font.pixelSize: 12
            Text {
                id: worseWarning
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.right
                text: (contextActObject != null ?
                    (contextActObject.flags.isWorse ? " NO " : "")
                    : "null")
                color: "white"
                font.pixelSize: 12
            }
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.left: parent.right
        text: (contextActObject != null ? contextActObject.efficiencyDEBUG : "null")
        color: "gray"
        font.pixelSize: 10
    }
}
 