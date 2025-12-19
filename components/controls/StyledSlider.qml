import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Templates

Slider {
    id: root

    background: Item {
        StyledRect {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: root.implicitHeight / 3
            anchors.bottomMargin: root.implicitHeight / 3

            implicitWidth: root.handle.x - root.implicitHeight / 6

            color: Colours.palette.m3primary
            // Minimal flat styling
            radius: Appearance.rounding.small
            topRightRadius: 0
            bottomRightRadius: 0
        }

        StyledRect {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.topMargin: root.implicitHeight / 3
            anchors.bottomMargin: root.implicitHeight / 3

            implicitWidth: parent.width - root.handle.x - root.handle.implicitWidth - root.implicitHeight / 6

            // Minimal flat styling
            color: Colours.palette.m3surfaceContainer
            radius: Appearance.rounding.small
            topLeftRadius: 0
            bottomLeftRadius: 0
            border.width: 1
            border.color: Colours.palette.m3outline
        }
    }

    handle: StyledRect {
        x: root.visualPosition * root.availableWidth - implicitWidth / 2

        implicitWidth: root.implicitHeight / 4.5
        implicitHeight: root.implicitHeight

        // Minimal flat styling
        color: Colours.palette.m3primary
        radius: Appearance.rounding.small
        border.width: 2
        border.color: Colours.palette.m3onSurface

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.PointingHandCursor
        }
    }
}
