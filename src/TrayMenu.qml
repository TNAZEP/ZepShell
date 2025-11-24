import QtQuick
import Quickshell
import "."
import "./theme"

PopupWindow {
    id: root
    property var menuHandle
    
    width: 200
    height: contentHeight
    color: "transparent"
    
    property real contentHeight: list.contentHeight + 20
    
    // Close on click outside
    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: root.visible = false
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.color: Theme.selection
        border.width: 1
        
        ListView {
            id: list
            anchors.fill: parent
            anchors.margins: 5
            model: menuHandle
            spacing: 2
            
            delegate: Rectangle {
                width: parent.width
                height: 30
                color: "transparent"
                visible: !model.isSeparator
                
                Row {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10
                    
                    Image {
                        width: 16
                        height: 16
                        source: model.icon || ""
                        visible: model.icon !== ""
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: model.text
                        color: Theme.foreground
                        font: Theme.mainFont
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.color = Theme.selection
                    onExited: parent.color = "transparent"
                    onClicked: {
                        if (model.hasChildren) {
                            // Handle submenus (TODO)
                        } else {
                            model.activate() // Assuming activate exists on entry
                            root.visible = false
                        }
                    }
                }
            }
        }
    }
}
