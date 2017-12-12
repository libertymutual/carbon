# App Features

* [Introduction](#introduction)
* [Adding a new Feature](#adding-a-new-feature)
  * [React Native](#react-native)
    * [Common Steps](#common-steps)
    * [iOS Steps](#ios-steps)
    * [Android Steps](#android-steps)
* [Project Structure](#project-structure)

## Introduction

A feature typically consists of a logically grouped collection of screens / business functionality (e.g. "ID Cards" or "Payments")

The DSS App Template ships with a "default" feature & a "second" feature (to demonstrate navigation / sharing data between features).

You may repurpose the "default" feature for your own app (and optionally delete the "second" feature). This is the recommended approach for most use cases.

However if you require additional features, or if you wish to use a different technology (e.g. Cordova, ReactJS, Angular etc.) the instructions below outline the steps required to add an additional feature.

Note: A "Feature" may contain 1 or more "Modules". However most Features will simply contain 1 module.
Features are declared in the iOS Swift code, and in the app.json file (including defining their default/launch module). However by simply registering an additional item in the index.js file of the feature (e.g. /app/default/index.js) you can register additional components which can be navigated to directly. This could potentially be used for deep-linking etc. For clarity, it is recommended to define each module using the naming convention "____Module" (see /app/default/index.js for example)

## Adding a new Feature

### React Native

#### Common Steps

* Copy the existing "default" folder from the /app directory
* Paste the copy into the /app directory and name the folder appropriately (e.g. "**to-do-list**")
* Edit the following values in the index.js file in your feature folder (e.g. /app/**to-do-list**/index.js)
  * AppRegistry.registerComponent('DefaultModule', () => App);
  * (Replacing "DefaultModule" appropriately. e.g. "**ToDoListModule**")
* Edit the dss-app-template/common.js file to import the newly added Module e.g.
  * e.g. import './app/**to-do-list**';
* Edit the dss-app-template/app.json file and add an additional entry to the features array. (Copy an existing feature entry) updating any values as necessary

```json
{
   "name": "ToDoList",
   "config": {"theme": "light"},
   "viewConfig": {
        "name": "ReactNative",
        "config": {
            "bundleURL": "http://localhost:8081/index.ios.bundle?platform=ios",
            "moduleName": "ToDoListModule",
            "initialProperties": {"hello": "I'm an initial property"},
            "launchOptions": null
        }
    }
}
```

#### iOS Steps

* Open the dss-app-template/ios project in XCode
* Expand the HelloWorld/Features group in Xcode
* Create a new Group called "**ToDoList**" (or applicable)
* Create a new file within this Group called "**ToDoListFeature.swift**" (or applicable)
* Copy-Paste the contents of an existing feature (e.g. DefaultFeature.swift)
* Update the following values in your newly created Swift file:
  * class DefaultFeature: ReactNativeFeature, Feature
    * (Replace "DefaultFeature" with "**ToDoListFeature**" (or applicable))
  * var name: String = "Default"
    * (Replace "Default" with "**ToDoList**" (or applicable))
* Open AppDelegate.swift
  * Add a new line to initialize the new Feature e.g.
    * let **toDoListFeature** = **ToDoListFeature**(config: nil)
  * Add this to the FeatureManager initialization e.g.
    * let featureManager = FeatureManager(features: [defaultFeature, secondFeature, **toDoListFeature**], defaultFeature: "Default")

#### Android Steps

* All set! You may now begin editing your React Native app located in dss-app-template/app/**to-do-list**
  * (Don't forget to run "react-native start" from the dss-app-template folder first)
* Note: If you wish to make your new feature the default/launch feature then update the following:
  * Edit the "defaultFeature attribute in the following line in AppDelegate.swift
    * let featureManager = FeatureManager(features: [defaultFeature, secondFeature, **toDoListFeature**], defaultFeature: "**Default**")

#### Cordova

Not yet implemented

## Project structure

```md
-- app
|-- default (The default app feature, using React Native)
|-- second (The second app feature, using React Native)
```
