#!/usr/bin/env bash
set -euo pipefail

echo "Building IPA for sideloading..."

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This build script must be run on macOS (uses xcodebuild)." >&2
  exit 2
fi

PROJECT="Mercury.xcodeproj"
SCHEME="Mercury"
CONFIGURATION="Release"
BUILD_DIR="$PWD/build"
ARCHIVE_PATH="$BUILD_DIR/$SCHEME.xcarchive"
EXPORT_PATH="$BUILD_DIR/export"
IPA_PATH="$EXPORT_PATH/$SCHEME.ipa"
EXPORT_OPTIONS_PLIST="$PWD/scripts/exportOptions.plist"

DEVELOPMENT_TEAM="${DEVELOPMENT_TEAM:-$1:-}"
if [[ -z "$DEVELOPMENT_TEAM" ]]; then
  echo "Provide DEVELOPMENT_TEAM either as env var or first argument." >&2
  echo "Example: DEVELOPMENT_TEAM=ABCDEFG123 ./scripts/build-ipa.sh" >&2
  exit 3
fi

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "Archiving with xcodebuild..."
xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration "$CONFIGURATION" \
  -archivePath "$ARCHIVE_PATH" clean archive DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" CODE_SIGN_STYLE=Automatic

echo "Exporting IPA..."
xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportPath "$EXPORT_PATH" -exportOptionsPlist "$EXPORT_OPTIONS_PLIST"

if [[ -f "$IPA_PATH" ]]; then
  echo "IPA created at: $IPA_PATH"
else
  echo "Failed to create IPA." >&2
  exit 4
fi

echo "Done. Use Sideloadly or AltStore to install the IPA to your device." 
