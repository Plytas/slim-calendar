#!/bin/bash
# Build a Release copy, install it in /Applications and relaunch it.
set -euo pipefail
cd "$(dirname "$0")"

# Use Xcode even when xcode-select still points at the Command Line Tools.
export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"

xcodegen --quiet
xcodebuild -project SlimCalendar.xcodeproj -scheme SlimCalendar -configuration Release \
    -derivedDataPath build -quiet build

pkill -x SlimCalendar 2>/dev/null || true
while pgrep -x SlimCalendar >/dev/null; do sleep 0.1; done
rm -rf "/Applications/Slim Calendar.app"
cp -R "build/Build/Products/Release/Slim Calendar.app" /Applications/
open "/Applications/Slim Calendar.app"
echo "Installed and launched /Applications/Slim Calendar.app"
