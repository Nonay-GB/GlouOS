import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1280
    height: 800
    color: "#0d2947"

    Image {
        anchors.fill: parent
        source: config.background ? config.background : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    property var users: []
    property int idx: 0
    function cur() {
        if (users.length === 0) return ({ name: "", real: "", needsPw: true })
        return users[Math.max(0, Math.min(idx, users.length - 1))]
    }
    function displayName() {
        var u = cur()
        return (u.real && u.real.length) ? u.real : u.name
    }
    function refresh() {
        nameText.text = displayName()
        var d = displayName()
        initial.text = d.length ? d.charAt(0).toUpperCase() : "?"
        errText.text = ""
        pw.text = ""
        pw.forceActiveFocus()
    }
    function doLogin() {
        errText.text = ""
        sddm.login(cur().name, pw.text, sessionModel.lastIndex)
    }

    Repeater {
        model: userModel
        Item {
            Component.onCompleted: {
                root.users.push({ name: model.name, real: model.realName, needsPw: model.needsPassword })
                if (model.name === userModel.lastUser) root.idx = root.users.length - 1
                root.refresh()
            }
        }
    }
    Component.onCompleted: refresh()

    Text {
        id: clock
        anchors { left: parent.left; top: parent.top; margins: 28 }
        color: "#f2ffffff"
        font.pixelSize: 18
        text: Qt.formatDateTime(new Date(), "dddd, d MMMM   h:mm AP")
        Timer { interval: 15000; running: true; repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "dddd, d MMMM   h:mm AP") }
    }

    Column {
        anchors.centerIn: parent
        spacing: 18

        Rectangle {
            width: 128; height: 128; radius: 64
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#33ffffff"
            border.color: "#55ffffff"; border.width: 2
            Text {
                id: initial
                anchors.centerIn: parent
                color: "white"; font.pixelSize: 60; font.bold: true
                text: "?"
            }
        }

        Text {
            id: nameText
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"; font.pixelSize: 30; font.bold: false
            text: ""
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 320; height: 40; radius: 6
            color: "#ffffff"
            TextField {
                id: pw
                anchors.fill: parent
                leftPadding: 14; rightPadding: 46
                echoMode: TextInput.Password
                placeholderText: "Password"
                color: "#111"; font.pixelSize: 16
                verticalAlignment: TextInput.AlignVCenter
                background: Rectangle { color: "transparent" }
                onAccepted: root.doLogin()
                focus: true
            }
            Rectangle {
                width: 30; height: 30; radius: 15
                anchors { right: parent.right; rightMargin: 5; verticalCenter: parent.verticalCenter }
                color: pw.text.length ? "#2b6cb0" : "#d3dbe4"
                Text { anchors.centerIn: parent; text: "→"; color: "white"; font.pixelSize: 18 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.doLogin() }
            }
        }

        Text {
            id: errText
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#ffc0c0"; font.pixelSize: 15; text: ""
        }
    }

    Row {
        anchors { right: parent.right; bottom: parent.bottom; margins: 28 }
        spacing: 26

        Row {
            spacing: 8
            visible: root.users.length > 1
            Text { text: "↻"; color: "white"; font.pixelSize: 20; anchors.verticalCenter: parent.verticalCenter }
            Text { text: "Switch user"; color: "white"; font.pixelSize: 15; anchors.verticalCenter: parent.verticalCenter }
            MouseArea {
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: { root.idx = (root.idx + 1) % root.users.length; root.refresh() }
            }
        }

        Text {
            text: "⏻"; color: "white"; font.pixelSize: 22
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() { errText.text = "Incorrect password. Try again."; pw.text = ""; pw.forceActiveFocus() }
    }
}
