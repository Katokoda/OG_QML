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


    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.left
        text: (contextActObject != null ?
            (contextActObject.isRecommended ? "RECOMMENDED" : "")
            : "null")
        color: "white"
        font.pixelSize: 12
    }


    Activity {
        id: thisAct
        visible: contextActObject != null
        activity: (contextActObject != null ? contextActObject.activity : null)
        myIdx: ctxActIdx
    }

    Row {
        anchors.left: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: (contextActObject != null ?
                (contextActObject.flags.isExhausted ? "tooMuch" : "")
                : "null")
            color: "white"
            font.pixelSize: 12
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: (contextActObject != null ?
                (contextActObject.flags.isTooLong ? "time" : "")
                : "null")
            color: "white"
            font.pixelSize: 12
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: (contextActObject != null ?
                (contextActObject.flags.isWorse ? "NO" : "")
                : "null")
            color: "white"
            font.pixelSize: 12
        }
    }

    // DEBUG TEXT
    Text {
        anchors.bottom: parent.bottom
        anchors.left: parent.right
        text: (contextActObject != null ? contextActObject.efficiencyDEBUG : "null")
        color: "gray"
        font.pixelSize: 10
    }
}
 