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
        width: row.implicitWidth + 60
        height: 100
        color: Theme.background
        border.color: Theme.foreground
        border.width: Theme.borderWidth
        radius: Theme.cornerRadius
        
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 30
            
            Repeater {
                model: [
                    { label: "Lock", color: Theme.blue, cmd: ["loginctl", "lock-session"] },
                    { label: "Suspend", color: Theme.yellow, cmd: ["systemctl", "suspend"] },
                    { label: "Logout", color: Theme.purple, cmd: ["hyprctl", "dispatch", "exit"] },
                    { label: "Reboot", color: Theme.orange, cmd: ["systemctl", "reboot"] },
                    { label: "Off", color: Theme.red, cmd: ["systemctl", "poweroff"] }
                ]
                
                Rectangle {
                    width: btnText.width + 20
                    height: 40
                    color: "transparent"
                    
                    Text {
                        id: btnText
                        anchors.centerIn: parent
                        text: "[ " + modelData.label + " ]"
                        color: parent.activeFocus || area.containsMouse ? modelData.color : Theme.foreground
                        font: Theme.boldFont
                    }
                    
                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
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
