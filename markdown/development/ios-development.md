# iOS Development

This guide assumes you have already followed the [Starting Development](/development/starting-development.md#common-install-steps) guide

## Initial Install Steps

1. Install Cocoapods dependencies

  ```sh
  cd ios
  pod install
  ```

## Running App

1. Open `.xcworkspace` file located in `./ios` folder

1. Ensure React-Native server is running

   ```sh
   npm run develop
   ```

1. Ensure "Run" scheme in Xcode is set to "Debug"

1. Build/Run in Xcode

## Generating IPA / XCARCHIVE

### Manually

1. Generate updated React Native JS Bundle (run from project root)

   ```sh
   npm run bundle:ios
   ```

1. Open `.xcworkspace` file located in `./ios` folder

1. Ensure "Archive" scheme is set to either "QA" or "Release" depending on desired build type

1. Select "Product" -> "Archive" from Xcode menu bar

### Automated (CI/CD)

This approach uses Fastlane and a few different Ruby gems

1. Install bundler

   ```sh
   gem install bundler
   ```

1. Install dependencies in the `./ios` folder

   ```sh
   bundle install
   ```

1. Generate the QA version of the app

   ```sh
   bundle exec fastlane qa_app  # qa_app, debug_app, release_app
   ```

1. Run tests

   ```sh
   bundle exec fastlane test
   ```

## Next Steps

Try adding a feature - Check out [Adding Features](../adding-features.md) or the `README.md` file located in your `/app` directory
