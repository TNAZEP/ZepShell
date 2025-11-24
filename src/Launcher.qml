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
                        font: Theme.mainFont
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
