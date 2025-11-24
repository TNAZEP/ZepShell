import QtQuick
import Quickshell
import Quickshell.Io
import "."
import "./theme"

PanelWindow {
    id: sidePanel
    anchors {
        right: true
        top: true
        bottom: true
    }
    width: 350
    color: "transparent" // Use inner rectangle for background
    visible: Global.sidePanelVisible
    
    margins {
        top: 40
        right: 10
        bottom: 10
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.color: Theme.selection
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            Text {
                text: "Quick Settings"
                color: Theme.foreground
                font: Theme.boldFont
            }
            
            // Toggles Row
            Row {
                spacing: 15
                Repeater {
                    model: ["Wifi", "BT", "DND"]
                    Rectangle {
                        width: 90
                        height: 50
                        color: Theme.selection
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: Theme.foreground
                            font: Theme.mainFont
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: console.log("Toggle " + modelData)
                        }
                    }
                }
            }
            
            // Sliders (Placeholder)
            Column {
                spacing: 10
                width: parent.width
                
                Text { text: "Volume"; color: Theme.foreground; font: Theme.mainFont }
                Rectangle {
                    width: parent.width
                    height: 4
                    color: Theme.comment
                    Rectangle {
                        width: parent.width * 0.5
                        height: parent.height
                        color: Theme.blue
                    }
                }
                
                Text { text: "Brightness"; color: Theme.foreground; font: Theme.mainFont }
                Rectangle {
                    width: parent.width
                    height: 4
                    color: Theme.comment
                    Rectangle {
                        width: parent.width * 0.7
                        height: parent.height
                        color: Theme.yellow
                    }
                }
            }
            
            // Tools Row
            Row {
                spacing: 15
                Repeater {
                    model: ["Screen", "Mixer", "Color"]
                    Rectangle {
                        width: 90
                        height: 50
                        color: Theme.comment
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: Theme.foreground
                            font: Theme.mainFont
                        }
                    }
                }
            }
            
            // Notifications
            Rectangle {
                width: parent.width
                height: 1
                color: Theme.comment
            }
            
            Text {
                text: "Notifications"
                color: Theme.foreground
                font: Theme.boldFont
            }
            
            ListView {
                width: parent.width
                height: 200
                clip: true
                model: 5
                delegate: Rectangle {
                    width: parent.width
                    height: 60
                    color: "transparent"
                    
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: Theme.comment
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Notification " + index
                        color: Theme.foreground
                        font: Theme.mainFont
                    }
                }
            }
        }
    }
}
