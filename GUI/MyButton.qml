import QtQuick 2.15
import QtQuick.Controls 2.15

Button{
    // https://doc.qt.io/archives/qt-5.15/qtquickcontrols2-customize.html#customizing-button
    id: control

    required property string buttonText

    contentItem: Text {
        text: control.buttonText
        opacity: enabled ? 1 : 0.3

        color: control.down ? "white" : "#dddddd"

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: control.parent.height - 10
        opacity: enabled ? 1 : 0.3

        color: control.down ? "#333333" : "#222222"

        border.color : "black"
        border.width: 2
        radius: 8
    }
}