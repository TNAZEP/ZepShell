import qs.components
import qs.components.effects
import qs.services
import qs.config
import qs.utils
import QtQuick

// OS Icon that opens the launcher on click
Item {
    id: root

    // Need access to visibilities to toggle launcher
    property var visibilities: null

    implicitWidth: icon.implicitSize + Appearance.padding.small * 2
    implicitHeight: icon.implicitSize + Appearance.padding.small * 2

    ColouredIcon {
        id: icon
        anchors.centerIn: parent
        source: SysInfo.osLogo
        implicitSize: Appearance.font.size.large * 1.2
        // Use accent color for OS icon
        colour: Colours.palette.m3primary
    }

    StateLayer {
        anchors.fill: parent
        radius: Appearance.rounding.small

        function onClicked(): void {
            if (root.visibilities) {
                root.visibilities.launcher = !root.visibilities.launcher;
            }
        }
    }
}
