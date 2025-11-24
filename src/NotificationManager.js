.pragma library

var notifications = [];

function add(notification) {
    notifications.push(notification);
    console.log("NotificationManager: Added. Count:", notifications.length);
}

function remove(notification) {
    var index = notifications.indexOf(notification);
    if (index !== -1) {
        notifications.splice(index, 1);
        console.log("NotificationManager: Removed. Count:", notifications.length);
        return index;
    }
    console.log("NotificationManager: Remove failed - not found");
    return -1;
}

function get(index) {
    if (index >= 0 && index < notifications.length) {
        return notifications[index];
    }
    return null;
}

function count() {
    return notifications.length;
}

function clearAll() {
    console.log("NotificationManager: Clearing all. Count:", notifications.length);
    // Copy array to avoid modification issues during iteration if callbacks happen synchronously
    var currentList = notifications.slice();

    for (var i = 0; i < currentList.length; i++) {
        var notification = currentList[i];
        if (notification) {
            try {
                console.log("NotificationManager: Dismissing", i);
                notification.dismiss();
            } catch (e) {
                console.log("NotificationManager: Error dismissing:", e);
            }
        }
    }
}
