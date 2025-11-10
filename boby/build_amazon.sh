#!/bin/bash

# Navigate to the project root
cd "$(dirname "$0")"

# Clean the project
./gradlew clean

# Build the Amazon release APK
./gradlew assembleAmazonRelease

# The APK will be located at:
# android/app/build/outputs/flutter-apk/app-amazon-release.apk

# If you want to install the APK directly to a connected device:
# adb install -r android/app/build/outputs/flutter-apk/app-amazon-release.apk

echo "Amazon APK built successfully!"
echo "Location: android/app/build/outputs/flutter-apk/app-amazon-release.apk"
