# Platform Development Mode

This mode is only required when developing enhancements/fixes to the core App Platform code or the base HelloWorld Template. This will typically only be performed by DSS developers as all changes to core platform code should be committed to the dss-app-platform repo.

It is strongly advised that consumers of the DSS App Platform do not make changes to the core App Platform code as this will hamper your ability to easily update to future App Platform versions.

#Required Steps

##Common

1. Clone `dss-app-platform `repo
1. `npm install` or `yarn install` from dss-app-platform root
1. `cd templates/HelloWorld`
1. `npm install` or `yarn install`

##iOS Steps
1. Open Terminal, and enter the following commands:
1. If working on:
  1. The HelloWorld template: `export DEV_MODE=1`
  1. Another app which uses the DSS App Platform (e.g. LM app): `export DEV_MODE=2`
1. `cd ios`
1. `pod deintegrate`
1. `pod install`
1. Open .xcworkspace file located in ./ios folder
1. Build/Compile/Run project as normal

##Android Steps
1. Open ./android folder in Android Studio
1. Update the value of PLATFORM_LOCATION_OVERRIDE to:
  1. `1` - If working on the HelloWorld template
  1. `2` - If working on another app which uses the DSS App Platform (e.g. LM app)
    1. Important: If set to 2, ensure that you have cloned the dss-app-platform repo in a folder adjacent to your app repo
1. Sync/Refresh Gradle projects when prompted.
  1. Note: Due to an issue with Android Studio & updating gradle project dirs, you may need to perform the following steps:
    1. Comment out any lines beginning with "include" or "project" from settings.gradle
    1. Sync/Refresh Gradle projects when prompted.
    1. Uncomment those lines
    1. Sync/Refresh Gradle projects when prompted.
1. Build/Compile/Run project as normal
