# Amazon Appstore Release Guide

This directory contains all the necessary files and assets for releasing your app on the Amazon Appstore.

## Directory Structure

```
amazon_release/
├── assets/
│   ├── screenshots/           # Screenshots for different devices
│   ├── feature-graphic/       # Feature graphic (1024x500px)
│   ├── hi-res-icon/           # High-res icon (512x512px)
│   ├── promo-graphic/         # Promo graphic (180x120px)
│   ├── phone-screenshots/     # Phone screenshots (min 1280x720px)
│   ├── seven-inch-screenshots/ # 7" tablet screenshots (min 1280x720px)
│   ├── ten-inch-screenshots/  # 10" tablet screenshots (min 1280x720px)
│   ├── tv-banner/             # TV banner (1920x1080px)
│   ├── tv-screenshots/        # TV screenshots (1920x1080px)
│   └── wear-screenshots/      # Wearable screenshots (320x320px)
└── metadata/                  # App metadata and descriptions
    └── en-US/
        ├── changelogs/        # Version-specific changelogs
        ├── full_description.txt
        └── short_description.txt
```

## Required Assets

1. **App Icon**: 512x512px PNG
2. **Feature Graphic**: 1024x500px PNG
3. **Promo Graphic**: 180x120px PNG
4. **Screenshots**:
   - Phone: At least 3, 1280x720px or larger
   - 7" Tablet: At least 3, 1280x720px or larger
   - 10" Tablet: At least 3, 1280x720px or larger
   - TV: At least 1, 1920x1080px
   - Wear: At least 2, 320x320px

## Building the Release APK

1. Make sure you have the Amazon build variant set up in your `android/app/build.gradle`
2. Run the build script:
   ```bash
   chmod +x build_amazon.sh
   ./build_amazon.sh
   ```
3. The APK will be generated at:
   `android/app/build/outputs/flutter-apk/app-amazon-release.apk`

## Submitting to Amazon Appstore

1. Go to [Amazon Developer Console](https://developer.amazon.com/)
2. Create a new app or select an existing one
3. Fill in all required metadata in the Amazon Developer Console
4. Upload the APK from the build output
5. Upload all required assets from the `amazon_release/assets` directory
6. Complete all required sections in the Amazon Developer Console
7. Submit for review

## Notes

- Make sure to test the APK on an Amazon Fire device before submission
- Check Amazon's [App Submission Guidelines](https://developer.amazon.com/docs/app-submission/overview.html) for the latest requirements
- Update the version code and version name in `pubspec.yaml` before each release
- The app must comply with Amazon's [Content Guidelines](https://developer.amazon.com/docs/app-submission/amazon-appstore-content-policy.html)
