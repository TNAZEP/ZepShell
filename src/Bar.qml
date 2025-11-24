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

        // CPU
        Text {
            id: cpuText
            text: "cpu: 0%"
            color: Theme.foreground
            font: Theme.mainFont

            property var lastTotal: 0
            property var lastIdle: 0

            Process {
                id: cpuProcess
                command: ["cat", "/proc/stat"]
                stdout: SplitParser {
                    onRead: (data) => {
                        
                        if (data.startsWith("cpu ")) {
                            var parts = data.split(/\s+/)
                            // parts[0] = "cpu"
                            // parts[1] = user
                            // parts[2] = nice
                            // parts[3] = system
                            // parts[4] = idle
                            
                            var user = parseInt(parts[1])
                            var nice = parseInt(parts[2])
                            var system = parseInt(parts[3])
                            var idle = parseInt(parts[4])
                            var iowait = parseInt(parts[5])
                            var irq = parseInt(parts[6])
                            var softirq = parseInt(parts[7])
                            
                            var total = user + nice + system + idle + iowait + irq + softirq
                            
                            var totalDelta = total - cpuText.lastTotal
                            var idleDelta = idle - cpuText.lastIdle
                            
                            if (cpuText.lastTotal !== 0) {
                                var usage = 1.0 - (idleDelta / totalDelta)
                                cpuText.text = "cpu: " + Math.round(usage * 100) + "%"
                            }
                            
                            cpuText.lastTotal = total
                            cpuText.lastIdle = idle
                        }
                    }
                }
            }
            
            Timer {
                interval: 500
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: cpuProcess.running = true
            }
        }

        // Volume
        Text {
            id: volText
            text: "vol: --%"
            color: Theme.foreground
            font: Theme.mainFont
            
            Process {
                id: volProcess
                command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
                stdout: SplitParser {
                    onRead: (data) => {
                        // Output: "Volume: 0.40" or "Volume: 0.40 [MUTED]"
                        var parts = data.split(" ")
                        if (parts.length >= 2 && parts[0] === "Volume:") {
                            var vol = parseFloat(parts[1])
                            var percent = Math.round(vol * 100)
                            var muted = data.includes("[MUTED]")
                            volText.text = "vol: " + percent + "%" + (muted ? " (M)" : "")
                        }
                    }
                }
            }
            
            Timer {
                interval: 500
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: volProcess.running = true
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
