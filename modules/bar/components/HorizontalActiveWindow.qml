pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.utils
import qs.config
import QtQuick
import QtQuick.Layouts

// Horizontal active window display for top bar - Waybar style
Row {
    id: root

    required property var bar
    required property Brightness.Monitor monitor
    property color colour: Colours.palette.m3onSurface

    readonly property int maxWidth: {
        const otherModules = bar.children.filter(c => c.id && c.item !== this && c.id !== "spacer");
        const otherWidth = otherModules.reduce((acc, curr) => acc + (curr.item.nonAnimWidth ?? curr.width), 0);
        return bar.width - otherWidth - bar.spacing * (bar.children.length - 1) - bar.hPadding * 2;
    }
    property Title current: text1

    clip: true
    spacing: Appearance.spacing.small

    MaterialIcon {
        id: icon

        anchors.verticalCenter: parent.verticalCenter

        animate: true
        text: Icons.getAppCategoryIcon(Hypr.activeToplevel?.lastIpcObject.class, "desktop_windows")
        color: root.colour
        font.pointSize: Appearance.font.size.normal
    }

    Item {
        width: Math.min(metrics.advanceWidth, root.maxWidth - icon.width - root.spacing)
        height: text1.implicitHeight

        anchors.verticalCenter: parent.verticalCenter

        Title {
            id: text1
        }

        Title {
            id: text2
        }
    }

    TextMetrics {
        id: metrics

        text: Hypr.activeToplevel?.title ?? qsTr("Desktop")
        font.pointSize: Appearance.font.size.normal
        font.family: Appearance.font.family.mono
        elide: Qt.ElideRight
        elideWidth: root.maxWidth - icon.width - root.spacing

        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = elidedText;
            root.current = next;
        }
        onElideWidthChanged: root.current.text = elidedText
    }

    component Title: StyledText {
        id: text

        font.pointSize: metrics.font.pointSize
        font.family: metrics.font.family
        color: root.colour
        opacity: root.current === this ? 1 : 0

        Behavior on opacity {
            Anim {}
        }
    }
}

