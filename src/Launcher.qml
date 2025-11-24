import QtQuick
import Quickshell
import Quickshell.Io
import "."
import "./theme"

PopupWindow {
    id: launcher
    anchors.centerIn: parent
    width: 600
    height: 400
    color: "transparent"
    visible: Global.launcherVisible
    
    // Close when clicking outside
    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: Global.toggleLauncher()
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        radius: 10
        border.color: Theme.selection
        border.width: 2
        
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            // Search Bar
            Rectangle {
                width: parent.width
                height: 40
                color: Theme.comment
                radius: 5
                
                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.margins: 10
                    color: Theme.background
                    font: Theme.mainFont
                    verticalAlignment: TextInput.AlignVCenter
                    focus: true
                    
                    Text {
                        anchors.fill: parent
                        text: "Search..."
                        color: Theme.background
                        opacity: 0.5
                        visible: !searchInput.text && !searchInput.activeFocus
                        verticalAlignment: TextInput.AlignVCenter
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
                    height: 50
                    color: "transparent"
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 10
                        
                        Rectangle {
                            width: 40
                            height: 40
                            color: Theme.blue
                            radius: 5
                        }
                        
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Application " + index
                            color: Theme.foreground
                            font: Theme.mainFont
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Theme.selection
                        onExited: parent.color = "transparent"
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
