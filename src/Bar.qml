import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Io
import "."
import "./theme"

PanelWindow {
    id: bar
    anchors {
        top: true
        left: true
        right: true
    }
    height: 30
    color: Theme.background

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Repeater {
            model: Hyprland.workspaces
            
            Rectangle {
                width: 20
                height: 20
                color: modelData.active ? Theme.selection : Theme.comment
                radius: 4
                
                Text {
                    anchors.centerIn: parent
                    text: modelData.id
                    color: Theme.foreground
                    font: Theme.mainFont
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.focus()
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(new Date(), "yyyy-MM-dd HH:mm:ss")
        color: Theme.foreground
        font: Theme.mainFont
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.text = Qt.formatDateTime(new Date(), "yyyy-MM-dd HH:mm:ss")
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        // Battery
        Text {
            text: "BAT: " + (batteryFile.data ? batteryFile.data.trim() : "N/A") + "%"
            color: Theme.foreground
            font: Theme.mainFont
            
            File {
                id: batteryFile
                path: "/sys/class/power_supply/BAT0/capacity"
                // interval: 60000 // Default is usually fine or needs a timer
            }
            Timer {
                interval: 60000
                running: true
                repeat: true
                onTriggered: batteryFile.read()
            }
        }

        // System Tray
        Row {
            spacing: 5
            Repeater {
                model: SystemTray.items
                
                Image {
                    width: 20
                    height: 20
                    source: modelData.icon
                    fillMode: Image.PreserveAspectFit
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.activate()
                        onSecondaryClicked: modelData.menu.open()
                    }
                }
            }
        }

        
        // Side Panel Toggle
        Rectangle {
            width: 20
            height: 20
            color: Theme.blue
            radius: 4
            MouseArea {
                anchors.fill: parent
                onClicked: Global.toggleSidePanel()
            }
        }

        // Power Menu Toggle
        Rectangle {
            width: 20
            height: 20
            color: Theme.red
            radius: 4
            MouseArea {
                anchors.fill: parent
                onClicked: Global.togglePowerMenu()
            }
        }
    }
}
