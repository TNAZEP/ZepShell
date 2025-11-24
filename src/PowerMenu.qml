import QtQuick
import Quickshell
import Quickshell.Io
import "."
import "./theme"

PanelWindow {
    id: powerMenu
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    visible: Global.powerMenuVisible
    
    // Background dim / click to close
    Rectangle {
        anchors.fill: parent
        color: "#80000000" // Semi-transparent black
        MouseArea {
            anchors.fill: parent
            onClicked: Global.togglePowerMenu()
        }
    }
    
    Rectangle {
        anchors.centerIn: parent
        width: 600
        height: 200
        color: Theme.background
        border.color: Theme.selection
        border.width: 2
        
        Row {
            anchors.centerIn: parent
            spacing: 20
            
            Repeater {
                model: [
                    { label: "Lock", color: Theme.blue, cmd: ["loginctl", "lock-session"] },
                    { label: "Suspend", color: Theme.yellow, cmd: ["systemctl", "suspend"] },
                    { label: "Logout", color: Theme.purple, cmd: ["hyprctl", "dispatch", "exit"] },
                    { label: "Reboot", color: Theme.orange, cmd: ["systemctl", "reboot"] },
                    { label: "Off", color: Theme.red, cmd: ["systemctl", "poweroff"] }
                ]
                
                Rectangle {
                    width: 80
                    height: 80
                    color: modelData.color
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: Theme.background
                        font: Theme.boldFont
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var proc = Qt.createQmlObject(`
                                import Quickshell.Io
                                Process {
                                    command: ${JSON.stringify(modelData.cmd)}
                                    running: true
                                }
                            `, parent);
                            Global.togglePowerMenu();
                        }
                    }
                }
            }
        }
    }
}
