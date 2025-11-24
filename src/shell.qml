//@ pragma UseQApplication
import QtQuick
import Quickshell
import "./theme"
import "."

ShellRoot {
    
    // Global signals or properties can be defined here if needed
    // For now, just instantiating the windows
    
    Bar {}
    SidePanel { id: sidePanel }
    PowerMenu { id: powerMenu }
    Launcher { id: launcher }
    NotificationPopup { id: notificationPopup }

    // Helper functions to toggle windows (if they were properties or accessible)
    // Since they are separate windows, we might need a shared state or singleton for visibility control
    // For simplicity, let's assume we can reference them if they are in the same scope or use a State object.
    // Actually, in QuickShell, windows are top-level.
    
    // To make toggling work from Bar, we need a way to communicate.
    // A singleton 'ShellState' would be best.
    
    Component.onCompleted: {
        console.log("ZepShell started")
    }
}
