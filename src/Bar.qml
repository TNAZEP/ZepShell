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
        spacing: 10

        Repeater {
            model: Hyprland.workspaces
            
            Text {
                text: modelData.id
                color: modelData.active ? Theme.red : Theme.comment
                font: Theme.boldFont
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.focus()
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(new Date(), "ddd, MMM dd  HH:mm")
        color: Theme.foreground
        font: Theme.mainFont
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.text = Qt.formatDateTime(new Date(), "ddd, MMM dd  HH:mm")
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 15

        // CPU (Placeholder)
        Text {
            text: "cpu: 2%"
            color: Theme.foreground
            font: Theme.mainFont
        }

        // Volume (Placeholder)
        Text {
            text: "vol: 40%"
            color: Theme.foreground
            font: Theme.mainFont
        }

        // Battery
        Text {
            id: batteryText
            text: "bat: N/A%"
            color: Theme.foreground
            font: Theme.mainFont
            
            Process {
                id: batteryProcess
                command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
                stdout: SplitParser {
                    onRead: (data) => batteryText.text = "bat: " + data + "%"
                }
            }
            Timer {
                interval: 60000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: batteryProcess.running = true
            }
        }

        // System Tray
        Row {
            spacing: 5
            Repeater {
                model: SystemTray.items
                
                Image {
                    width: 16
                    height: 16
                    source: modelData.icon
                    fillMode: Image.PreserveAspectFit
                    
                    TrayMenu {
                        id: trayMenu
                        menuHandle: modelData.menu
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.LeftButton) {
                                modelData.activate()
                            } else if (mouse.button === Qt.RightButton) {
                                var pos = parent.mapToGlobal(0, 0)
                                trayMenu.x = pos.x
                                trayMenu.y = pos.y + parent.height
                                trayMenu.visible = true
                            }
                        }
                    }
                }
            }
        }

        // Toggles (Text based)
        Text {
            text: "[side]"
            color: Theme.blue
            font: Theme.mainFont
            MouseArea {
                anchors.fill: parent
                onClicked: Global.toggleSidePanel()
            }
        }

        Text {
            text: "[pwr]"
            color: Theme.red
            font: Theme.mainFont
            MouseArea {
                anchors.fill: parent
                onClicked: Global.togglePowerMenu()
            }
        }
    }
}
