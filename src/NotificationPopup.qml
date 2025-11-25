import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "."
import "./theme"

PanelWindow {
    id: popupWindow
    anchors {
        top: true
        right: true
    }
    width: 300
    implicitHeight: content.height + 20
    color: "transparent"
    visible: false // Hidden by default
    
    margins {
        top: 10
        right: 10
    }

    property var currentNotification: null
    
    Timer {
        id: hideTimer
        interval: 5000
        onTriggered: popupWindow.visible = false
    }

    NotificationServer {
        id: notificationServer
    }

    Connections {
        target: notificationServer
        function onNotification(notification) {
            console.log("Popup: Notification received", notification.summary)
            popupWindow.currentNotification = notification
            popupWindow.visible = true
            hideTimer.restart()
        }
    }

    Rectangle {
        id: content
        width: parent.width
        height: column.height + 20
        color: Theme.background
        border.color: Theme.accentColor
        border.width: Theme.borderWidth
        radius: Theme.cornerRadius
        
        Column {
            id: column
            width: parent.width - 20
            anchors.centerIn: parent
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
                            var iconStr = popupWindow.currentNotification ? popupWindow.currentNotification.appIcon : ""
                            if (iconStr && iconStr.toString().indexOf("/") === 0) {
                                return "file://" + iconStr
                            }
                            return iconStr || ""
                        }
                    }
                }
                
                Text {
                    text: popupWindow.currentNotification ? popupWindow.currentNotification.summary : ""
                    color: Theme.foreground
                    font: Theme.boldFont
                    elide: Text.ElideRight
                    width: parent.width - 40
                }
            }
            
            Text {
                text: popupWindow.currentNotification ? popupWindow.currentNotification.body : ""
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
                // Dismiss on click? Or just hide popup?
                // Usually clicking a popup might open the app or dismiss it.
                // For now, let's just hide the popup and maybe dismiss the notification if desired.
                // Let's just hide for now to not interfere with SidePanel history unless requested.
                popupWindow.visible = false
            }
        }
    }
}
