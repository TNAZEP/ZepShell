pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.utils
import qs.config
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

// Horizontal status icons for top bar - Waybar style
StyledRect {
    id: root

    property color colour: Colours.palette.m3primary
    readonly property alias items: iconRow

    // Transparent background - bar itself has the border
    color: "transparent"
    radius: 0
    border.width: 0

    clip: true
    implicitWidth: iconRow.implicitWidth + Appearance.padding.normal * 2
    implicitHeight: Config.bar.sizes.innerHeight

    RowLayout {
        id: iconRow

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: Appearance.spacing.smaller

        // Lock keys status
        WrappedLoader {
            name: "lockstatus"
            active: Config.bar.status.showLockStatus && (Hypr.capsLock || Hypr.numLock)

            sourceComponent: Row {
                spacing: Appearance.spacing.smaller / 2

                MaterialIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Hypr.capsLock
                    text: "keyboard_capslock_badge"
                    color: root.colour
                    font.pointSize: Appearance.font.size.normal
                }

                MaterialIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Hypr.numLock
                    text: "looks_one"
                    color: root.colour
                    font.pointSize: Appearance.font.size.normal
                }
            }
        }

        // Audio icon
        WrappedLoader {
            name: "audio"
            active: Config.bar.status.showAudio

            sourceComponent: MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                animate: true
                text: Icons.getVolumeIcon(Audio.volume, Audio.muted)
                color: root.colour
                font.pointSize: Appearance.font.size.normal
            }
        }

        // Microphone icon
        WrappedLoader {
            name: "audio"
            active: Config.bar.status.showMicrophone

            sourceComponent: MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                animate: true
                text: Icons.getMicVolumeIcon(Audio.sourceVolume, Audio.sourceMuted)
                color: root.colour
                font.pointSize: Appearance.font.size.normal
            }
        }

        // Keyboard layout
        WrappedLoader {
            name: "kblayout"
            active: Config.bar.status.showKbLayout

            sourceComponent: StyledText {
                anchors.verticalCenter: parent.verticalCenter
                animate: true
                text: Hypr.kbLayout
                color: root.colour
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.normal
            }
        }

        // Network icon
        WrappedLoader {
            name: "network"
            active: Config.bar.status.showNetwork

            sourceComponent: MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                animate: true
                text: Network.active ? Icons.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
                color: root.colour
                font.pointSize: Appearance.font.size.normal
            }
        }

        // Bluetooth section
        WrappedLoader {
            name: "bluetooth"
            active: Config.bar.status.showBluetooth

            sourceComponent: Row {
                spacing: Appearance.spacing.smaller / 2

                MaterialIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    animate: true
                    text: {
                        if (!Bluetooth.defaultAdapter?.enabled)
                            return "bluetooth_disabled";
                        if (Bluetooth.devices.values.some(d => d.connected))
                            return "bluetooth_connected";
                        return "bluetooth";
                    }
                    color: root.colour
                    font.pointSize: Appearance.font.size.normal
                }

                // Connected bluetooth devices
                Repeater {
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(d => d.state !== BluetoothDeviceState.Disconnected)
                    }

                    MaterialIcon {
                        id: device

                        required property BluetoothDevice modelData

                        anchors.verticalCenter: parent.verticalCenter
                        animate: true
                        text: Icons.getBluetoothIcon(modelData?.icon)
                        color: root.colour
                        fill: 1
                        font.pointSize: Appearance.font.size.normal

                        SequentialAnimation on opacity {
                            running: device.modelData?.state !== BluetoothDeviceState.Connected
                            alwaysRunToEnd: true
                            loops: Animation.Infinite

                            Anim {
                                from: 1
                                to: 0
                                duration: Appearance.anim.durations.large
                                easing.bezierCurve: Appearance.anim.curves.standardAccel
                            }
                            Anim {
                                from: 0
                                to: 1
                                duration: Appearance.anim.durations.large
                                easing.bezierCurve: Appearance.anim.curves.standardDecel
                            }
                        }
                    }
                }
            }
        }

        // Battery icon
        WrappedLoader {
            name: "battery"
            active: Config.bar.status.showBattery

            sourceComponent: MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                animate: true
                text: {
                    if (!UPower.displayDevice.isLaptopBattery) {
                        if (PowerProfiles.profile === PowerProfile.PowerSaver)
                            return "energy_savings_leaf";
                        if (PowerProfiles.profile === PowerProfile.Performance)
                            return "rocket_launch";
                        return "balance";
                    }

                    const perc = UPower.displayDevice.percentage;
                    const charging = [UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged, UPowerDeviceState.PendingCharge].includes(UPower.displayDevice.state);
                    if (perc === 1)
                        return charging ? "battery_charging_full" : "battery_full";
                    let level = Math.floor(perc * 7);
                    if (charging && (level === 4 || level === 1))
                        level--;
                    return charging ? `battery_charging_${(level + 3) * 10}` : `battery_${level}_bar`;
                }
                color: !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? root.colour : Colours.palette.m3error
                fill: 1
                font.pointSize: Appearance.font.size.normal
            }
        }
    }

    component WrappedLoader: Loader {
        required property string name

        Layout.alignment: Qt.AlignVCenter
        asynchronous: true
        visible: active
    }
}

