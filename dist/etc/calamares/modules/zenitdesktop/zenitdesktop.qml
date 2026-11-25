import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import io.calamares.core 1.0
import "desktops.js" as Data

Rectangle {
    id: root
    color: "#0F0D08"

    readonly property color gold:      "#D4A93A"
    readonly property color goldLight: "#F2D675"
    readonly property color panel:     "#1A160D"
    readonly property color textMain:  "#F2E8C8"
    readonly property color textDim:   "#A99C74"

    property var selected: ["plasma"]
    property var current: Data.desktops[0]

    function isSelected(id) { return selected.indexOf(id) >= 0 }
    function indexOfId(id) { return selected.indexOf(id) }
    function publish() { Global.insert("zenit_desktops", selected.join(",")) }
    function toggle(d) {
        if (d.placeholder || d.unavailable) return
        var s = selected.slice()
        var i = s.indexOf(d.id)
        if (i >= 0) { if (s.length === 1) return; s.splice(i, 1) } else s.push(d.id)
        selected = s
        publish()
    }
    Component.onCompleted: publish()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 18

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            Text {
                text: "Wybierz środowiska graficzne"
                color: root.goldLight; font.pixelSize: 24; font.bold: true
            }
            Text {
                Layout.fillWidth: true; wrapMode: Text.WordWrap
                text: "Kliknij, aby zaznaczyć (można kilka). Pierwsze zaznaczone będzie domyślne – "
                    + "pozostałe pojawią się jako sesje na ekranie logowania. Pakiety zostaną pobrane z internetu."
                color: root.textDim; font.pixelSize: 13
            }

            GridView {
                id: grid
                Layout.fillWidth: true; Layout.fillHeight: true
                clip: true
                cellWidth: 184; cellHeight: 150
                model: Data.desktops
                ScrollBar.vertical: ScrollBar { }

                delegate: Item {
                    width: grid.cellWidth; height: grid.cellHeight
                    property bool sel: root.isSelected(modelData.id)
                    property bool off: modelData.placeholder || modelData.unavailable

                    Rectangle {
                        id: card
                        anchors.fill: parent; anchors.margins: 5
                        radius: 10
                        color: root.panel
                        opacity: off ? 0.5 : 1.0
                        border.width: sel ? 2 : 1
                        border.color: sel ? root.gold : "#3A3220"

                        Image {
                            x: 6; y: 6; width: parent.width - 12; height: 86
                            source: modelData.preview
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                        }
                        Text {
                            x: 8; y: 96; width: parent.width - 16
                            text: modelData.name; elide: Text.ElideRight
                            color: root.textMain; font.pixelSize: 14; font.bold: true
                        }
                        Text {
                            x: 8; y: 116; width: parent.width - 16
                            text: modelData.unavailable ? "niedostępne w tej bazie" : modelData.type
                            color: root.textDim; font.pixelSize: 11; elide: Text.ElideRight
                        }
                        Rectangle {          // znacznik wyboru / gwiazdka domyślnego
                            visible: sel
                            anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 8
                            width: 24; height: 24; radius: 12; color: root.gold
                            Text {
                                anchors.centerIn: parent
                                text: root.indexOfId(modelData.id) === 0 ? "★" : "✓"
                                color: "#1A1405"; font.pixelSize: 14; font.bold: true
                            }
                        }
                        MouseArea {
                            anchors.fill: parent; hoverEnabled: true
                            onEntered: root.current = modelData
                            onClicked: { root.current = modelData; root.toggle(modelData) }
                        }
                    }
                }
            }
        }

        // ---- Panel podglądu -------------------------------------------------
        Rectangle {
            Layout.preferredWidth: 340; Layout.fillHeight: true
            radius: 12; color: root.panel
            border.width: 1; border.color: "#3A3220"

            ColumnLayout {
                anchors.fill: parent; anchors.margins: 14; spacing: 10
                Image {
                    Layout.fillWidth: true; Layout.preferredHeight: width * 0.625
                    source: root.current.preview; fillMode: Image.PreserveAspectFit
                    asynchronous: true
                }
                Text { text: root.current.name; color: root.goldLight; font.pixelSize: 22; font.bold: true }
                Text {
                    text: root.current.unavailable ? root.current.reason : "Sesja: " + root.current.type
                    color: root.gold; font.pixelSize: 12
                }
                Text {
                    Layout.fillWidth: true; wrapMode: Text.WordWrap
                    text: root.current.desc; color: root.textMain; font.pixelSize: 14
                }
                Item { Layout.fillHeight: true }
                Text {
                    Layout.fillWidth: true; wrapMode: Text.WordWrap
                    text: "Wybrane: " + root.selected.join(", ")
                    color: root.textDim; font.pixelSize: 12
                }
            }
        }
    }
}
