import Quickshell.Io

JsonObject {
    property Rounding rounding: Rounding {}
    property Spacing spacing: Spacing {}
    property Padding padding: Padding {}
    property FontStuff font: FontStuff {}
    property Anim anim: Anim {}
    property Transparency transparency: Transparency {}

    // Minimal flat rounding - Kanagawa/Waybar inspired
    component Rounding: JsonObject {
        property real scale: 1
        property int small: 2 * scale
        property int normal: 2 * scale
        property int large: 4 * scale
        property int full: 4 * scale
    }

    component Spacing: JsonObject {
        property real scale: 1
        property int small: 4 * scale
        property int smaller: 6 * scale
        property int normal: 8 * scale
        property int larger: 10 * scale
        property int large: 12 * scale
    }

    component Padding: JsonObject {
        property real scale: 1
        property int small: 4 * scale
        property int smaller: 6 * scale
        property int normal: 8 * scale
        property int larger: 10 * scale
        property int large: 12 * scale
    }

    // JetBrainsMono Nerd Font to match Waybar config
    component FontFamily: JsonObject {
        property string sans: "JetBrainsMono Nerd Font"
        property string mono: "JetBrainsMono Nerd Font"
        property string material: "Material Symbols Rounded"
        property string clock: "JetBrainsMono Nerd Font"
    }

    component FontSize: JsonObject {
        property real scale: 1
        property int small: 11 * scale
        property int smaller: 12 * scale
        property int normal: 14 * scale
        property int larger: 16 * scale
        property int large: 18 * scale
        property int extraLarge: 24 * scale
    }

    component FontStuff: JsonObject {
        property FontFamily family: FontFamily {}
        property FontSize size: FontSize {}
    }

    component AnimCurves: JsonObject {
        property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
        property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
    }

    component AnimDurations: JsonObject {
        property real scale: 1
        property int small: 200 * scale
        property int normal: 400 * scale
        property int large: 600 * scale
        property int extraLarge: 1000 * scale
        property int expressiveFastSpatial: 350 * scale
        property int expressiveDefaultSpatial: 500 * scale
        property int expressiveEffects: 200 * scale
    }

    component Anim: JsonObject {
        property AnimCurves curves: AnimCurves {}
        property AnimDurations durations: AnimDurations {}
    }

    component Transparency: JsonObject {
        property bool enabled: false
        property real base: 0.85
        property real layers: 0.4
    }
}
