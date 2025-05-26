import QtQuick 2.15

Rectangle {
    id: contextAct

    //required property var contextActObject
    //required property int myIdx


    width: 20
    height: 20
    color: "white"

    property int occuping_width: 20
    property int occuping_height: 20
    property bool shouldBeAbove: false



    // width: thisAct.width
    // height: thisAct.height

    // property int occuping_width: thisAct.width
    // property int occuping_height: thisAct.height
    // property bool shouldBeAbove: thisAct.isCurrentlyDragged || thisAct.isCurrentlySelected

    // Activity {
    //     id: thisAct
    //     activity: contextActObject.activity
    //     myIdx: myIdx
    // }
}
 