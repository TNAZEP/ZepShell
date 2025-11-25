import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "."
import "./theme"
import "NotificationManager.js" as NotificationManager

PanelWindow {
    id: sidePanel
    anchors {
        right: true
        top: true
        bottom: true
    }
    width: 350
    color: "transparent"
    visible: Global.sidePanelVisible
    
    margins {
        top: 40
        right: 10
        bottom: 10
    }



    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.color: Theme.borderColor
        border.width: Theme.borderWidth
        radius: Theme.cornerRadius

        NotificationServer {
            id: notificationServer
        }
        
        Connections {
            target: notificationServer
            
            function onNotification(notification) {
                console.log("SidePanel: Notification received!", notification)
                
                // Keep notification alive
                notification.tracked = true
                console.log("SidePanel: Set tracked = true")
                
                // Add to manager
                NotificationManager.add(notification)
                
                // Add to model
                notificationModel.append({
                    "summary": notification.summary,
                    "body": notification.body,
                    "appName": notification.appName,
                    "icon": notification.appIcon 
                })
                
                // Connect to closed signal to remove from model and manager
                notification.closed.connect(function() {
                    console.log("SidePanel: Notification closed signal received", notification.summary)
                    
                    // Remove from manager
                    var index = NotificationManager.remove(notification)
                    
                    if (index !== -1) {
                        console.log("SidePanel: Removing notification from model at index", index)
                        // Remove from model
                        notificationModel.remove(index)
                    } else {
                        console.log("SidePanel: Notification not found in manager during close")
                    }
                })
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            Item {
                width: parent.width
                height: 30
                
                Text {
                    text: "Notifications"
                    color: Theme.foreground
                    font: Theme.boldFont
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }
                
                // Clear All Button
                Rectangle {
                    width: 120
                    height: 30
                    color: "transparent"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "[ Clear All ]"
                        color: clearMouse.containsMouse ? Theme.red : Theme.foreground
                        font: Theme.mainFont
                    }
                    
                    MouseArea {
                        id: clearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            NotificationManager.clearAll()
                        }
                    }
                }
            }
            
            ListView {
                id: notificationList
                width: parent.width
                height: parent.height - 60
                clip: true
                spacing: 10
                
                model: ListModel {
                    id: notificationModel
                }

                delegate: Rectangle {
                    width: parent.width
                    height: contentColumn.height + 20
                    color: Theme.background
                    border.width: Theme.borderWidth
                    border.color: Theme.accentColor
                    radius: Theme.cornerRadius
                    
                    Column {
                        id: contentColumn
                        anchors.centerIn: parent
                        width: parent.width - 20
                        spacing: 5
                        
                        Row {
                            width: parent.width
                            spacing: 10
                            
                            Rectangle {
                                width: 24
                                height: 24
                                color: "transparent"
                                IconImage {
                                    anchors.fill: parent
                                    source: {
                                        var iconStr = model.icon || ""
                                        if (iconStr.toString().indexOf("/") === 0) {
                                            return "file://" + iconStr
                                        }
                                        return iconStr
                                    }
                                }
                            }
                            
                            Text {
                                text: model.summary || "No Title"
                                color: Theme.foreground
                                font: Theme.boldFont
                                elide: Text.ElideRight
                                width: parent.width - 40
                            }
                        }
                        
                        Text {
                            text: model.body || ""
                            color: Theme.foreground
                            font: Theme.mainFont
                            wrapMode: Text.Wrap
                            width: parent.width
                            visible: text !== ""
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // Close the notification object using index
                            var notification = NotificationManager.get(index)
                            if (notification) {
                                notification.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}
