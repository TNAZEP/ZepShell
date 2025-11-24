pragma Singleton
import QtQuick

QtObject {
    property bool sidePanelVisible: false
    property bool powerMenuVisible: false
    property bool launcherVisible: false

    function toggleSidePanel() { sidePanelVisible = !sidePanelVisible }
    function togglePowerMenu() { powerMenuVisible = !powerMenuVisible }
    function toggleLauncher() { launcherVisible = !launcherVisible }
}
