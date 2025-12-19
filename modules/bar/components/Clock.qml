pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick

Column {
    id: root

    // Use foreground color for clock - minimal style
    property color colour: Colours.palette.m3onSurface

    spacing: Appearance.spacing.small

    Loader {
        anchors.horizontalCenter: parent.horizontalCenter

        active: Config.bar.clock.showIcon
        visible: active
        asynchronous: true

        sourceComponent: MaterialIcon {
            text: "schedule"
            color: Colours.palette.m3primary
        }
    }

    StyledText {
        id: text

        anchors.horizontalCenter: parent.horizontalCenter

        horizontalAlignment: StyledText.AlignHCenter
        // Display time in lowercase like Waybar
        text: Time.format(Config.services.useTwelveHourClock ? "hh\nmm\na" : "hh\nmm").toLowerCase()
        font.pointSize: Appearance.font.size.smaller
        font.family: Appearance.font.family.mono
        color: root.colour
    }
}
