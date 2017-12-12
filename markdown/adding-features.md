# App Features

## Introduction

A feature typically consists of a logically grouped collection of screens / business functionality (e.g. "To do" or "Payments")

The DSS App Template ships with a "default" feature & a "second" feature (to demonstrate navigation / sharing data between features).

You may repurpose the "default" feature for your own app (and optionally delete the "second" feature). This is the recommended approach for most use cases.

However if you require additional features, or if you wish to use a different technology (e.g. Cordova, ReactJS, Angular etc.) the instructions below outline the steps required to add an additional feature.

Note: A "Feature" may contain 1 or more "Modules". However most Features will simply contain 1 module.
Features are declared in the iOS Swift code, and in the app.json file (including defining their default/launch module). However by simply registering an additional item in the index.js file of the feature (e.g. /app/default/index.js) you can register additional components which can be navigated to directly. This could potentially be used for deep-linking etc. For clarity, it is recommended to define each module using the naming convention "____Module" (see /app/default/index.js for example)

## Adding a new Feature

### React Native

#### Common Steps

1. Copy the existing `default/` folder from the `app/` directory
1. Paste the copy into the `app/` directory and name the folder appropriately (e.g. "**example**")
1. Go to the `index.js` file in your feature folder (e.g. `/app/example/index.js`) and replace `DefaultModule` with the new module name (e.g. `ExampleModule`)

   ```swift
   AppRegistry.registerComponent('DefaultModule', () => App); // old value
   AppRegistry.registerComponent('ExampleModule', () => App); // new value
   ```

1. Edit the `dss-app-template/common.js` file and add a new line to import the newly added Module e.g.

   ```swift
   import './app/example'
   ```

1. Edit the `dss-app-template/app.json` file and add an additional entry to the features array. (Copy an existing feature entry) updating any values as necessary

  ```json
  {
    "name": "Example",
    "config": {"theme": "light"},
    "viewConfig": {
          "name": "ReactNative",
          "config": {
              "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
              "moduleName": "ExampleModule",
              "initialProperties": {"hello": "I'm an initial property"},
              "launchOptions": null
          }
      }
  }
  ```

#### iOS Steps

1. Open the `dss-app-template/ios` project in XCode
1. Expand the `HelloWorld/Features` group in Xcode
1. Create a new Group called `Example` (or applicable)
1. Create a new file within this Group called `ExampleFeature.swift` (or applicable)
1. Copy-Paste the contents of an existing feature (e.g. `DefaultFeature.swift`)
1. Update the following values in your newly created Swift file
    * Replace `DefaultFeature` with **`ExampleFeature`** (or applicable)
    ```swift
    class DefaultFeature: ReactNativeFeature, Feature   // current
    class ExampleFeature: ReactNativeFeature, Feature   // new value
    ```
    * Replace `"Default"` with **`"Example"`** (or applicable)
    ```swift
    var name: String = "Default"  // current
    var name: String = "Example"  // new value
    ```
1. Open `AppDelegate.swift`
    * Add a new line to initialize the new Feature e.g.

    ```swift
    let exampleFeature = ExampleFeature(config: nil)
    ```

    * Add the new feature to the FeatureManager initialization e.g.

    ```swift
    let featureManager = FeatureManager(features: [defaultFeature, secondFeature, 
        exampleFeature], defaultFeature: "Default")
    ```

#### Android Steps

* All set! You may now begin editing your React Native app located in `dss-app-template/app/example`
  * (Don't forget to run `react-native start` from the dss-app-template folder first)
* Note: If you wish to make your new feature the default/launch feature then update the following:
  * Edit the "defaultFeature attribute in the following line in `AppDelegate.swift`
  ```swift
  let featureManager = FeatureManager(features: [defaultFeature, secondFeature, 
      exampleFeature], defaultFeature: "Default")
  ```

#### Cordova

Not yet implemented

## Project structure

```md
-- app/
  |-- default # The default app feature, using React Native
  |-- second  # The second app feature, using React Native
```
