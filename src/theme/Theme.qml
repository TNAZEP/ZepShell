pragma Singleton
import QtQuick

QtObject {
    readonly property color background: "#181616"
    readonly property color foreground: "#c5c9c5"
    readonly property color selection: "#2D4F67"
    readonly property color comment: "#727169"
    readonly property color red: "#c4746e"
    readonly property color orange: "#b6927b"
    readonly property color yellow: "#c4b28a"
    readonly property color green: "#8a9a7b"
    readonly property color blue: "#8ba4b0"
    readonly property color purple: "#a292a3"
    readonly property color cyan: "#8ea4a2"
    
    readonly property font mainFont: Qt.font({
        family: "Sans Serif",
        pixelSize: 14
    })
}
