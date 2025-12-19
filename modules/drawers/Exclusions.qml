pragma ComponentBehavior: Bound

import qs.components.containers
import qs.config
import Quickshell
import QtQuick

Scope {
    id: root

    required property ShellScreen screen
    required property Item bar

    readonly property bool isHorizontalBar: Config.bar.position === "top"

    // Bar exclusion zone - position changes based on bar position
    ExclusionZone {
        anchors.left: root.isHorizontalBar ? undefined : true
        anchors.top: root.isHorizontalBar ? true : undefined
        exclusiveZone: root.bar.exclusiveZone
    }

    // Only add border exclusions when bar is on the left (vertical mode)
    // When bar is at top, we don't want border around the entire display
    ExclusionZone {
        visible: !root.isHorizontalBar
        anchors.top: true
        exclusiveZone: root.isHorizontalBar ? 0 : Config.border.thickness
    }

    ExclusionZone {
        visible: !root.isHorizontalBar
        anchors.right: true
        exclusiveZone: root.isHorizontalBar ? 0 : Config.border.thickness
    }

    ExclusionZone {
        visible: !root.isHorizontalBar
        anchors.bottom: true
        exclusiveZone: root.isHorizontalBar ? 0 : Config.border.thickness
    }

    component ExclusionZone: StyledWindow {
        screen: root.screen
        name: "border-exclusion"
        exclusiveZone: Config.border.thickness
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1
    }
}
