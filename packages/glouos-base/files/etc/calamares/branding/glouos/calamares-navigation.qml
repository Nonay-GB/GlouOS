import io.calamares.ui 1.0
import io.calamares.core 1.0

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Rectangle {
    id: navBar
    height: 64
    color: "#ffffff"

    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: "#ececec"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        spacing: 10

        Item { Layout.fillWidth: true }

        Button {
            id: backBtn
            text: ViewManager.backLabel
            enabled: ViewManager.backEnabled
            visible: ViewManager.backAndNextVisible
            onClicked: ViewManager.back()
            contentItem: Text {
                text: backBtn.text.replace("&","")
                color: backBtn.enabled ? "#1a1a1a" : "#b9bcc1"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                implicitWidth: 116; implicitHeight: 38; radius: 4
                color: backBtn.down ? "#e0e0e0" : (backBtn.hovered ? "#eaeaea" : "#f3f3f3")
                border.width: 1; border.color: "#e2e2e2"
            }
        }

        Button {
            id: nextBtn
            text: ViewManager.nextLabel
            enabled: ViewManager.nextEnabled
            visible: ViewManager.backAndNextVisible
            onClicked: ViewManager.next()
            Layout.rightMargin: 6
            contentItem: Text {
                text: nextBtn.text.replace("&","")
                color: nextBtn.enabled ? "#ffffff" : "#eef3f8"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                implicitWidth: 124; implicitHeight: 38; radius: 4
                color: !nextBtn.enabled ? "#9cc3e6"
                     : nextBtn.down ? "#005ba8"
                     : (nextBtn.hovered ? "#1975c5" : "#0067c0")
            }
        }

        Button {
            id: quitBtn
            text: ViewManager.quitLabel
            enabled: ViewManager.quitEnabled
            visible: ViewManager.quitVisible
            onClicked: ViewManager.quit()
            contentItem: Text {
                text: quitBtn.text.replace("&","")
                color: quitBtn.enabled ? "#1a1a1a" : "#b9bcc1"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                implicitWidth: 116; implicitHeight: 38; radius: 4
                color: quitBtn.down ? "#e0e0e0" : (quitBtn.hovered ? "#eaeaea" : "#f3f3f3")
                border.width: 1; border.color: "#e2e2e2"
            }
        }
    }
}
