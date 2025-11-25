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
    margins {
        top: 8
        left: 8
        right: 8
    }
    height: 34 // Increased to account for borders and match visual height
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.width: Theme.borderWidth
        border.color: Theme.borderColor
        radius: Theme.cornerRadius

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            Repeater {
                model: 5
                
                Rectangle {
                    property int wsId: index + 1
                    property bool isActive: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === wsId
                    property bool exists: {
                        var list = Hyprland.workspaces
                        var len = list.length !== undefined ? list.length : list.count
                        if (len === undefined) return false
                        for (var i = 0; i < len; i++) {
                            // Handle both array access and get() method if it's a ListModel
                            var item = list[i] !== undefined ? list[i] : (list.get ? list.get(i) : null)
                            if (item && item.id === wsId) return true
                        }
                        return false
                    }

                    width: wsText.width + 12
                    height: 30
                    color: "transparent"
                    
                    Text {
                        id: wsText
                        anchors.centerIn: parent
                        text: (isActive ? "*" : " ") + wsId
                        color: isActive ? Theme.accentColor : (exists ? Theme.foreground : Theme.comment)
                        font: isActive ? Theme.boldFont : Theme.mainFont
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Hyprland.dispatch("workspace", parent.wsId)
                        }
                    }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            textFormat: Text.RichText
            text: "<span style='color:" + Theme.bgAlt + "'>[ </span>" + 
                  Qt.formatDateTime(new Date(), "HH:mm ddd, MMM dd").toLowerCase() + 
                  "<span style='color:" + Theme.bgAlt + "'> ]</span>"
            color: Theme.foreground
            font: Theme.mainFont
            
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: parent.text = "<span style='color:" + Theme.bgAlt + "'>[ </span>" + 
                                         Qt.formatDateTime(new Date(), "HH:mm ddd, MMM dd").toLowerCase() + 
                                         "<span style='color:" + Theme.bgAlt + "'> ]</span>"
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            // CPU
            Text {
                id: cpuText
                textFormat: Text.RichText
                text: ""
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
                                    var percent = Math.round(usage * 100)
                                    // Bar characters:  ▂ ▃ ▄ ▅ ▆ ▇ █
                                    var bars = [" ", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
                                    var barIndex = Math.floor(percent / 12.5)
                                    if (barIndex > 7) barIndex = 7
                                    var barChar = bars[barIndex]
                                    
                                    cpuText.text = "<span style='color:" + Theme.bgAlt + "'>[ </span>" +
                                                 "<span style='color:" + Theme.accentColor + "'>cpu: </span>" +
                                                 barChar + barChar + barChar + barChar + " " +
                                                 percent + "%" +
                                                 "<span style='color:" + Theme.bgAlt + "'> / </span>"
                                }
                                
                                cpuText.lastTotal = total
                                cpuText.lastIdle = idle
                            }
                        }
                    }
                }
                
                Timer {
                    interval: 2000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: cpuProcess.running = true
                }
            }

            // Volume
            Text {
                id: volText
                textFormat: Text.RichText
                text: ""
                color: Theme.foreground
                font: Theme.mainFont
                
                Process {
                    id: volProcess
                    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
                    stdout: SplitParser {
                        onRead: (data) => {
                            var parts = data.split(" ")
                            if (parts.length >= 2 && parts[0] === "Volume:") {
                                var vol = parseFloat(parts[1])
                                var percent = Math.round(vol * 100)
                                var muted = data.includes("[MUTED]")
                                volText.text = "<span style='color:" + Theme.accentColor + "'>vol: </span>" + 
                                             percent + "%" + (muted ? " (M)" : "") +
                                             "<span style='color:" + Theme.bgAlt + "'> ]</span>"
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

            // Spacer
            Item { width: 10; height: 1 }

            // Toggles (Restored)
            Text {
                text: "[side]"
                color: Theme.blue
                font: Theme.mainFont
                MouseArea {
                    anchors.fill: parent
                    onClicked: Global.toggleSidePanel()
                }
            }

            Item { width: 10; height: 1 }

            Text {
                text: "[run]"
                color: Theme.red
                font: Theme.mainFont
                MouseArea {
                    anchors.fill: parent
                    onClicked: Global.toggleLauncher()
                }
            }

            Item { width: 10; height: 1 }

            Text {
                text: "[pwr]"
                color: Theme.red
                font: Theme.mainFont
                MouseArea {
                    anchors.fill: parent
                    onClicked: Global.togglePowerMenu()
                }
            }

            // System Tray
            Row {
                spacing: 5
                leftPadding: 10
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
        }
    }
}
