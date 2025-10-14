#!/bin/bash

# Reset Dock (remove all icons)
defaults write com.apple.dock persistent-apps -array

# System applications
sys_apps=(
    "/System/Applications/Launchpad.app"
    "/System/Applications/Utilities/Terminal.app"
)

# External applications (those in the Applications path)
apps=(
    "Obsidian"
    "Sublime Merge"
    "Bitwarden"
)

# Add system applications
for app in "${sys_apps[@]}"; do
    if [ -d "$app" ]; then
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
done

# Add external applications from the /Applications path
for app in "${apps[@]}"; do
    app_path="/Applications/$app.app"
    if [ -d "$app_path" ]; then
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
done

# Restart Dock
killall Dock
