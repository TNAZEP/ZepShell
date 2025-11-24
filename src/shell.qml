//@ pragma UseQApplication
import QtQuick
import Quickshell
import "./theme"
import "."

ShellRoot {
    
    
    Bar {}
    SidePanel { id: sidePanel }
    PowerMenu { id: powerMenu }
    Launcher { id: launcher }
    NotificationPopup { id: notificationPopup }

    
    Component.onCompleted: {
        console.log("ZepShell started")
    }
}
