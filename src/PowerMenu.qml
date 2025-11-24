import QtQuick
import Quickshell
import Quickshell.Io
import "."
import "./theme"

PopupWindow {
    id: powerMenu
    anchors.centerIn: parent
    width: 600
    height: 200
    color: Theme.background
    visible: Global.powerMenuVisible
    
    // Close on click outside (optional, but good UX)
    // PopupWindow usually handles this if modal, but let's add an overlay or just close on action.
    
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.color: Theme.selection
        border.width: 2
        radius: 10
        
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
                    radius: 10
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: Theme.background
                        font: Theme.mainFont
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
