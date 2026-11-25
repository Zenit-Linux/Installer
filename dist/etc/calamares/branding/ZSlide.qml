/* Wspólny szablon slajdu Zenit Linux */
import QtQuick 2.0
import calamares.slideshow 1.0

Slide {
    property string title: ""
    property string body: ""
    Rectangle {
        anchors.fill: parent
        color: "#0F0D08"
        Image {
            id: logo
            source: "zenit-logo.png"
            width: 200; height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 30
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: t
            anchors.top: logo.bottom; anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter
            text: title; color: "#F2D675"; font.pixelSize: 28; font.bold: true
        }
        Text {
            anchors.top: t.bottom; anchors.topMargin: 14
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.7
            horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
            text: body; color: "#E8D9A8"; font.pixelSize: 17
        }
    }
}
