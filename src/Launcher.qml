import QtQuick
import Quickshell
import Quickshell.Io
import "."
import "./theme"

PanelWindow {
    id: launcher
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    visible: Global.launcherVisible
    
    // Background dim / click to close
    Rectangle {
        anchors.fill: parent
        color: "#80000000"
        MouseArea {
            anchors.fill: parent
            onClicked: Global.toggleLauncher()
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 600
        height: 400
        color: Theme.background
        border.color: Theme.foreground
        border.width: Theme.borderWidth
        radius: Theme.cornerRadius
        
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            
            // Search Bar
            Rectangle {
                width: parent.width
                height: 40
                color: "transparent"
                
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Theme.bgAlt
                }
                
                Row {
                    anchors.fill: parent
                    spacing: 10
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "search: "
                        color: Theme.accentColor
                        font: Theme.boldFont
                    }

                    TextInput {
                        id: searchInput
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - parent.spacing - 80
                        color: Theme.foreground
                        font: Theme.mainFont
                        verticalAlignment: TextInput.AlignVCenter
                        focus: true
                    }
                }
            }
            
            // App List
            ListView {
                width: parent.width
                height: parent.height - 60
                clip: true
                model: 10 // Placeholder
                delegate: Rectangle {
                    width: parent.width
                    height: 40
                    color: "transparent"
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: "Application " + index
                        color: parent.activeFocus || area.containsMouse ? Theme.accentColor : Theme.foreground
                        font: Theme.mainFont
                    }
                    
                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            console.log("Launch App " + index)
                            Global.toggleLauncher()
                        }
                    }
                }
            }
        }
    }
    
    // Reset focus when opened
    onVisibleChanged: {
        if (visible) searchInput.forceActiveFocus()
        else searchInput.text = ""
    }
}
