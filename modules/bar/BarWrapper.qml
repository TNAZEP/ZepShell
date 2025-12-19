pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import "popouts" as BarPopouts
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property BarPopouts.Wrapper popouts
    required property bool disabled

    readonly property bool isHorizontal: Config.bar.position === "top"
    readonly property int padding: Math.max(Appearance.padding.smaller, isHorizontal ? 0 : Config.border.thickness)
    readonly property int contentWidth: isHorizontal ? 0 : Config.bar.sizes.innerWidth + padding * 2
    readonly property int contentHeight: isHorizontal ? Config.bar.sizes.innerHeight + Appearance.padding.normal * 2 : 0
    readonly property int exclusiveZone: {
        if (disabled)
            return isHorizontal ? 0 : Config.border.thickness;
        if (isHorizontal)
            return (Config.bar.persistent || visibilities.bar) ? contentHeight : 0;
        return (Config.bar.persistent || visibilities.bar) ? contentWidth : Config.border.thickness;
    }
    readonly property bool shouldBeVisible: !disabled && (Config.bar.persistent || visibilities.bar || isHovered)
    property bool isHovered

    function closeTray(): void {
        content.item?.closeTray();
    }

    function checkPopout(pos: real): void {
        content.item?.checkPopout(pos);
    }

    function handleWheel(pos: real, angleDelta: point): void {
        content.item?.handleWheel(pos, angleDelta);
    }

    visible: isHorizontal ? height > 0 : width > Config.border.thickness
    implicitWidth: isHorizontal ? 0 : Config.border.thickness
    implicitHeight: isHorizontal ? 0 : 0

    states: State {
        name: "visible"
        when: root.shouldBeVisible

        PropertyChanges {
            root.implicitWidth: root.isHorizontal ? 0 : root.contentWidth
            root.implicitHeight: root.isHorizontal ? root.contentHeight : 0
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            Anim {
                target: root
                properties: root.isHorizontal ? "implicitHeight" : "implicitWidth"
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            Anim {
                target: root
                properties: root.isHorizontal ? "implicitHeight" : "implicitWidth"
                easing.bezierCurve: Appearance.anim.curves.emphasized
            }
        }
    ]

    // Waybar-style background for horizontal bar
    Loader {
        id: background
        active: root.isHorizontal && root.shouldBeVisible
        anchors.fill: parent

        sourceComponent: StyledRect {
            anchors.fill: parent
            // Kanagawa dark background
            color: Colours.palette.m3surface
            // 2px border like Waybar
            border.width: 2
            border.color: Colours.palette.m3outline
            radius: 0 // No rounding for Waybar-like flat look
        }
    }

    Loader {
        id: content

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: root.isHorizontal ? parent.right : undefined
        anchors.bottom: root.isHorizontal ? undefined : parent.bottom

        active: root.shouldBeVisible || root.visible

        sourceComponent: Bar {
            width: root.isHorizontal ? root.width : root.contentWidth
            height: root.isHorizontal ? root.contentHeight : root.height
            screen: root.screen
            visibilities: root.visibilities
            popouts: root.popouts
        }
    }
}
