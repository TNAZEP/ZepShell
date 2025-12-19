pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

// Horizontal tray for top bar - Waybar style
StyledRect {
    id: root

    readonly property alias layout: layout
    readonly property alias items: items
    readonly property alias expandIcon: expandIcon

    readonly property int padding: Config.bar.tray.background ? Appearance.padding.normal : Appearance.padding.small
    readonly property int spacing: Config.bar.tray.background ? Appearance.spacing.small : 0

    property bool expanded

    readonly property real nonAnimWidth: {
        if (!Config.bar.tray.compact)
            return layout.implicitWidth + padding * 2;
        return (expanded ? expandIcon.implicitWidth + layout.implicitWidth + spacing : expandIcon.implicitWidth) + padding * 2;
    }

    clip: true
    visible: width > 0

    implicitWidth: nonAnimWidth
    implicitHeight: Config.bar.sizes.innerHeight

    // Transparent background - bar itself has the border
    color: "transparent"
    radius: 0
    border.width: 0

    Row {
        id: layout

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.padding
        spacing: Appearance.spacing.small

        opacity: root.expanded || !Config.bar.tray.compact ? 1 : 0

        add: Transition {
            Anim {
                properties: "scale"
                from: 0
                to: 1
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
        }

        move: Transition {
            Anim {
                properties: "scale"
                to: 1
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
            Anim {
                properties: "x,y"
            }
        }

        Repeater {
            id: items

            model: SystemTray.items

            TrayItem {}
        }

        Behavior on opacity {
            Anim {}
        }
    }

    Loader {
        id: expandIcon

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        active: Config.bar.tray.compact

        sourceComponent: Item {
            implicitWidth: expandIconInner.implicitWidth - Appearance.padding.small * 2
            implicitHeight: expandIconInner.implicitHeight

            MaterialIcon {
                id: expandIconInner

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Config.bar.tray.background ? Appearance.padding.small : -Appearance.padding.small
                text: "chevron_right"
                font.pointSize: Appearance.font.size.large
                rotation: root.expanded ? 180 : 0

                Behavior on rotation {
                    Anim {}
                }

                Behavior on anchors.rightMargin {
                    Anim {}
                }
            }
        }
    }

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.anim.durations.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
        }
    }
}

