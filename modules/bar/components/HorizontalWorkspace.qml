pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick

// Single horizontal workspace item - Waybar style
Item {
    id: root

    required property int ws
    required property int activeWsId
    required property var occupied

    readonly property bool isActive: ws === activeWsId
    readonly property bool isOccupied: occupied[ws] ?? false

    implicitWidth: label.implicitWidth + Appearance.padding.normal * 2
    implicitHeight: Config.bar.sizes.innerHeight

    StyledText {
        id: label

        anchors.centerIn: parent

        text: {
            if (root.isActive && Config.bar.workspaces.activeLabel)
                return Config.bar.workspaces.activeLabel;
            if (root.isOccupied && Config.bar.workspaces.occupiedLabel)
                return Config.bar.workspaces.occupiedLabel;
            if (Config.bar.workspaces.label.trim())
                return Config.bar.workspaces.label;
            return root.ws.toString();
        }
        font.family: Appearance.font.family.mono
        font.pointSize: Appearance.font.size.normal
        font.bold: root.isActive
        // Active workspace uses accent color, others use foreground
        color: root.isActive ? Colours.palette.m3primary : Colours.palette.m3onSurface
    }

    // Hover effect
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color = Qt.alpha(Colours.palette.m3onSurface, 0.1)
            onExited: parent.color = "transparent"
        }
    }
}

