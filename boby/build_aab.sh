#!/bin/bash

# Navigate to the project root
cd "$(dirname "$0")"

# Clean the project
echo "🧹 Cleaning the project..."
./gradlew clean

# Build the release AAB
echo "🚀 Building the release AAB for Amazon Appstore..."
./gradlew bundleRelease

# The AAB will be located at:
AAB_PATH="$(pwd)/build/app/outputs/bundle/release/app-release.aab"

if [ -f "$AAB_PATH" ]; then
    echo "✅ AAB built successfully!"
    echo "📦 Location: $AAB_PATH"
    
    # Copy the AAB to the amazon_release directory
    mkdir -p amazon_release/release
    cp "$AAB_PATH" "amazon_release/release/boby-$(date +%Y%m%d).aab"
    echo "📁 Copied AAB to: amazon_release/release/"
else
    echo "❌ Error: AAB file not found. Build might have failed."
    exit 1
fi
