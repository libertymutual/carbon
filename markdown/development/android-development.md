# Android Development

This guide assumes you have already followed the the [Common Install Steps](/development/starting-development.md#common-install-steps)

## Initial Install Steps

N/A

## Running App

1. Open `./android` folder in Android Studio

1. Ensure React-Native server is running
    ```sh
    npm run develop
    ```

1. Ensure build variant is set to `debug`

1. Run build in Android Studio

## Generating APK

1. Open `./android` folder in Android Studio

1. Ensure build variant is set to either "qa" or "release" depending on desired build type

1. Select "Build" -> "Build APK(s)" from Android Studio menu bar

    1. Builds can also be run with `./gradlew build`, which generates all variants.

    1. Run `./gradlew jacocoTestReport` to generate a test report.