#!/usr/bin/env bash
set -euo pipefail

IPA="$1"
BUNDLE_ID="${2:-org.litgram.messenger}"

unzip -tq "$IPA"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
unzip -q "$IPA" -d "$WORK"

APP=$(find "$WORK/Payload" -maxdepth 1 -name '*.app' -type d | head -n 1)
test -d "$APP"

ACTUAL=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP/Info.plist")
echo "Bundle ID: $ACTUAL"
test "$ACTUAL" = "$BUNDLE_ID"

test -f "$APP/Info.plist"
