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
        activity: contextActObject.activity
        myIdx: ctxActIdx
    }

    Text {
        id: labelText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.right
        text: contextActObject.efficiencyDEBUG
        color: "white"
        font.pixelSize: 12
    }
}
 