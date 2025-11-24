pragma Singleton
import QtQuick

QtObject {
    // Kanagawa Dragon Palette
    readonly property color background: "#181616" // Dragon Black
    readonly property color foreground: "#c5c9c5" // Dragon White
    readonly property color selection:  "#2D4F67" // Wave Blue 2 (selection)
    readonly property color comment:    "#727169" // Dragon Gray
    readonly property color red:        "#c4746e" // Dragon Red
    readonly property color orange:     "#b6927b" // Dragon Orange
    readonly property color yellow:     "#C8C093" // Old White
    readonly property color blue:       "#8ba4b0" // Dragon Blue
    readonly property color purple:     "#a9a1e1" // Dragon Violet
    readonly property color aqua:       "#8ea4a2" // Dragon Aqua

    readonly property font mainFont: Qt.font({
        family: "JetBrainsMono Nerd Font",
        pixelSize: 13
    })

    readonly property font boldFont: Qt.font({
        family: "JetBrainsMono Nerd Font",
        pixelSize: 13,
        bold: true
    })
}
