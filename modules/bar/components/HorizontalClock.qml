pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

// Horizontal clock for top bar - Waybar style
Row {
    id: root

    property color colour: Colours.palette.m3onSurface

    spacing: Appearance.spacing.small
    
    Loader {
        anchors.verticalCenter: parent.verticalCenter

        active: Config.bar.clock.showIcon
        visible: active
        asynchronous: true

        sourceComponent: MaterialIcon {
            text: "schedule"
            color: Colours.palette.m3primary
            font.pointSize: Appearance.font.size.normal
        }
    }

    StyledText {
        id: text

        anchors.verticalCenter: parent.verticalCenter

        // Display time horizontally like Waybar
        text: Time.format(Config.services.useTwelveHourClock ? "hh:mm a" : "HH:mm")
        font.pointSize: Appearance.font.size.normal
        font.family: Appearance.font.family.mono
        color: root.colour
    }
}

