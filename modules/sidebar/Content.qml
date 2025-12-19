import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Props props
    required property var visibilities

    ColumnLayout {
        id: layout

        anchors.fill: parent
        spacing: Appearance.spacing.normal

        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Minimal flat styling with border
            radius: Appearance.rounding.small
            color: Colours.palette.m3surfaceContainerLow
            border.width: 2
            border.color: Colours.palette.m3outline

            NotifDock {
                props: root.props
                visibilities: root.visibilities
            }
        }

        StyledRect {
            Layout.topMargin: Appearance.padding.large - layout.spacing
            Layout.fillWidth: true
            implicitHeight: 2

            // Minimal flat divider
            color: Colours.palette.m3outline
        }
    }
}
