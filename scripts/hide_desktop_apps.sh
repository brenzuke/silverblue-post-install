#!/usr/bin/env bash

set -euo pipefail

source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/task.sh"

readonly LOCAL_APPS_DIR="${HOME}/.local/share/applications"

readonly APPS_TO_HIDE=(
    "org.freedesktop.MalcontentControl.desktop"
    "org.gnome.DiskUtility.desktop"
    "org.gnome.SystemMonitor.desktop"
    "org.gnome.Tour.desktop"
    "org.gnome.Yelp.desktop"
    "org.mozilla.firefox.desktop"
)

hide_desktop_applications() {
    mkdir -p "${LOCAL_APPS_DIR}"

    for app in "${APPS_TO_HIDE[@]}"; do
        printf '%s\n' \
            "[Desktop Entry]" \
            "Type=Application" \
            "Name=${app%.desktop}" \
            "NoDisplay=true" \
            > "${LOCAL_APPS_DIR}/${app}"
    done
}

run_task "Hiding desktop applications" hide_desktop_applications
