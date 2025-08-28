#!/bin/bash


# Get the current version from the Package.swift file
CURRENT_VERSION=$(grep -oE '"[0-9]+\.[0-9]+\.[0-9]+"' Package.swift | tr -d '"')

# Get version from gradle.properties KMP_SDK_VERSION_NAME
VERSION=$(grep '^KMP_SDK_VERSION_NAME=' gradle.properties | cut -d '=' -f2)

# Allow overriding VERSION and CHECKSUM via positional args
# Usage: ./bump-version-package-swift.sh <VERSION> <CHECKSUM>
if [ -n "$1" ]; then VERSION="$1"; fi
if [ -n "$2" ]; then CHECKSUM="$2"; fi

# Validate required variables
if [ -z "$VERSION" ]; then
echo "ERROR: VERSION is not set. Pass as first argument or set KMP_SDK_VERSION_NAME in gradle.properties." >&2
exit 1
fi
if [ -z "$CHECKSUM" ]; then
echo "ERROR: CHECKSUM is not set. Pass as second argument or export CHECKSUM env var." >&2
exit 1
fi

# Replace the current version with the new version in the Package.swift file
sed -i '' -E 's#(url: ")[^"]*(MindboxCommon\.xcframework\.zip)(",)#\1https://github.com/mindbox-cloud/kmp-common-sdk/releases/download/'"$VERSION"'/MindboxCommon.xcframework.zip\3#g' Package.swift
sed -i '' -E 's#(checksum:")[^"]*(")#\1'"$CHECKSUM"'\2#g' Package.swift