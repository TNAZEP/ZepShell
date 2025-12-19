pragma ComponentBehavior: Bound

import qs.services
import qs.config
import "popouts" as BarPopouts
import "components"
import "components/workspaces"
import Quickshell
import QtQuick
import QtQuick.Layouts

Loader {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property BarPopouts.Wrapper popouts

    readonly property bool isHorizontal: Config.bar.position === "top"

    function closeTray(): void {
        item?.closeTray();
    }

    function checkPopout(pos: real): void {
        item?.checkPopout(pos);
    }

    function handleWheel(pos: real, angleDelta: point): void {
        item?.handleWheel(pos, angleDelta);
    }

    sourceComponent: isHorizontal ? horizontalBar : verticalBar

    Component {
        id: horizontalBar

        HorizontalBar {
            screen: root.screen
            visibilities: root.visibilities
            popouts: root.popouts
        }
    }

    Component {
        id: verticalBar

        VerticalBar {
            screen: root.screen
            visibilities: root.visibilities
            popouts: root.popouts
        }
    }
}
