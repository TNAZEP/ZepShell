pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.components
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

// Horizontal workspaces for top bar - Waybar style
StyledClippingRect {
    id: root

    required property ShellScreen screen

    readonly property bool onSpecial: (Config.bar.workspaces.perMonitorWorkspaces ? Hypr.monitorFor(screen) : Hypr.focusedMonitor)?.lastIpcObject.specialWorkspace.name !== ""
    readonly property int activeWsId: Config.bar.workspaces.perMonitorWorkspaces ? (Hypr.monitorFor(screen).activeWorkspace?.id ?? 1) : Hypr.activeWsId

    readonly property var occupied: Hypr.workspaces.values.reduce((acc, curr) => {
        acc[curr.id] = curr.lastIpcObject.windows > 0;
        return acc;
    }, {})
    readonly property int groupOffset: Math.floor((activeWsId - 1) / Config.bar.workspaces.shown) * Config.bar.workspaces.shown

    property real blur: onSpecial ? 1 : 0

    implicitWidth: layout.implicitWidth + Appearance.padding.small * 2
    implicitHeight: Config.bar.sizes.innerHeight

    // Transparent background - bar itself has the border
    color: "transparent"
    radius: 0
    border.width: 0

    Item {
        anchors.fill: parent
        scale: root.onSpecial ? 0.8 : 1
        opacity: root.onSpecial ? 0.5 : 1

        layer.enabled: root.blur > 0
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: root.blur
            blurMax: 32
        }

        RowLayout {
            id: layout

            anchors.centerIn: parent
            spacing: 0

            Repeater {
                id: workspaces

                model: Config.bar.workspaces.shown

                HorizontalWorkspace {
                    required property int index

                    ws: index + 1 + root.groupOffset
                    activeWsId: root.activeWsId
                    occupied: root.occupied
                }
            }
        }

        MouseArea {
            anchors.fill: layout
            onClicked: event => {
                const ws = layout.childAt(event.x, event.y).ws;
                if (Hypr.activeWsId !== ws)
                    Hypr.dispatch(`workspace ${ws}`);
                else
                    Hypr.dispatch("togglespecialworkspace special");
            }
        }

        Behavior on scale {
            Anim {}
        }

        Behavior on opacity {
            Anim {}
        }
    }

    Behavior on blur {
        Anim {
            duration: Appearance.anim.durations.small
        }
    }
}

