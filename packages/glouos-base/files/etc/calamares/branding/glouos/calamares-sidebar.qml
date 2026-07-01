import io.calamares.ui 1.0
import io.calamares.core 1.0

import QtQuick 2.15
import QtQuick.Layouts 1.3

Rectangle {
    id: stepBar
    height: 64
    color: "#ffffff"

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: "#ececec"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        spacing: 0

        Repeater {
            id: steps
            model: ViewManager

            delegate: Item {
                id: cell
                Layout.fillWidth: true
                Layout.fillHeight: true

                property bool done:    index < ViewManager.currentStepIndex
                property bool current: index === ViewManager.currentStepIndex

                Rectangle {
                    visible: index > 0
                    height: 2
                    color: (cell.done || cell.current) ? "#0067c0" : "#e3e6ea"
                    anchors.left: parent.left
                    anchors.right: node.horizontalCenter
                    anchors.verticalCenter: node.verticalCenter
                }
                Rectangle {
                    visible: index < steps.count - 1
                    height: 2
                    color: cell.done ? "#0067c0" : "#e3e6ea"
                    anchors.left: node.horizontalCenter
                    anchors.right: parent.right
                    anchors.verticalCenter: node.verticalCenter
                }

                Rectangle {
                    id: node
                    width: 24; height: 24; radius: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -9
                    color: (cell.done || cell.current) ? "#0067c0" : "#ffffff"
                    border.width: (cell.done || cell.current) ? 0 : 2
                    border.color: "#cdd2d8"

                    Text {
                        anchors.centerIn: parent
                        text: cell.done ? "✓" : (index + 1)
                        color: (cell.done || cell.current) ? "#ffffff" : "#9097a1"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                Text {
                    anchors.top: node.bottom
                    anchors.topMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: cell.width - 6
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    text: display
                    color: cell.current ? "#0067c0" : "#9097a1"
                    font.pixelSize: 10
                    font.bold: cell.current
                }
            }
        }
    }
}
