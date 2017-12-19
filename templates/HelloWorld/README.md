# App Template

## Getting started

### Build Types

| Build Type | Details | React Native Build Type |
| --- | --- | --- |
| Debug | Used for local development only | Uses RN Server |
| QA | Test build for testing against non prod envs. (This is the type most commonly uploaded to HockeyApp for testing) | Uses RN Bundle |
| Release | Production Candidate of app | Uses RN Bundle |

### Common Install Steps

1) brew install watchman
  * Use `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"` if Homebrew is not already installed

2) npm install -g react-native-cli

3) Install `npm` modules

`npm install` or `yarn install`

4) Run RN server & Lint

`npm run develop` (in project root)

### iOS - Initial Install Steps

1) Install Cocoapods dependencies

```
cd ios
pod install
```

### iOS - Running App (for local development)

1) Open .xcworkspace file located in ./ios folder

2) Ensure React-Native server is running: `npm run develop`

3) Ensure "Run" scheme in Xcode is set to "Debug"

4) Run build in Xcode

### iOS - Generating IPA / XCARCHIVE (for HockeyApp & App Store)

1) Generate updated React Native JS Bundle: `npm run bundle:ios` (from project root)

2) Open .xcworkspace file located in ./ios folder

3) Ensure "Archive" scheme is set to either "QA" or "Release" depending on desired build type

4) Select "Product" -> "Archive" from Xcode menu bar

### Android - Initial Install Steps

N/A

### Android - Running App (for local development)

1) Open ./android folder in Android Studio

2) Ensure React-Native server is running: `npm run develop`

3) Ensure build variant is set to "debug"

4) Run build in Android Studio

### Android - Generating APK (for HockeyApp & App Store)

1) Generate updated React Native JS Bundle: `npm run bundle:android` (from project root)

2) Open ./android folder in Android Studio

3) Ensure build variant is set to either "qa" or "release" depending on desired build type

4) Select "Build" -> "Build APK(s)" from Android Studio menu bar

### Adding a new "Feature"

A feature typically consists of a logically grouped collection of screens / business functionality (e.g. "ID Cards" or "Payments")

The DSS App Template ships with a "default" feature & a "second" feature (to demonstrate navigation / sharing data between features).

For more details on adding additional features, see the README.md located in the /app folder.

### App Platform Dev Mode

This mode is only required when developing enhancements/fixes to the core App Platform code or the base HelloWorld Template. This will typically only be performed by DSS developers as all changes to core platform code should be committed to the dss-app-platform repo.

Any consumers of the DSS App Platform who have feature requests / bug fixes, should reach out via https://forge.lmig.com/issues/servicedesk/customer/portal/329 to have their changes incorporated.

It is __strongly__ advised that consumers of the DSS App Platform __do not__ make changes to the core App Platform code (particularly directly in the node_modules folder) as this will hamper your ability to easily update to future App Platform versions.

If you do require running in "dev mode", see the following instructions: https://wiki.lmig.com/display/PIInternet/DSS+App+Platform+-+Platform+Development+Mode

### Coding Standards
Before committing any code, please ensure you have followed the coding standards outlined here: https://wiki.lmig.com/display/PIInternet/DSS+App+Platform+-+Coding+Standards
(You may wish to replace this link with a link to your own app specific coding standards)

### Project Structure
```
__tests__ - React Native unit tests
android - Android app
app - React Native project code
ios - iOS app
www - Cordova's root
common.js - Common imports for both iOS and Android
index.ios.js - RN's iOS entry point
index.android.js - RN's Android entry point
app.json - Project file???
```
