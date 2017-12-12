const { EventManager } = require('NativeModules');

/**
 * Collection of static util functions
 */
const utils = {

  /**
   * Gets the app version as specified in the version attribute of package.json
   * @returns {String} The current version of the app
   */
  getAppVersion() {
    return process.env.npm_package_version || '1.0.0';
  },

  /**
   * Gets the app name as specified in the name attribute of package.json
   * @returns {String} The name of the app
   */
  getAppName() {
    return process.env.npm_package_name || '';
  },

  /**
   * Gets the app description as specified in the description attribute of package.json
   * @returns {String} The description of the app
   */
  getAppDescription() {
    return process.env.npm_package_description || '';
  },

  /**
   * Navigates to another DSS App Platform Feature
   * @param featureName The name of the feature to navigate to
   * @param options Navigation options
   */
  navigateToFeature(featureName, options) {
    // e.g. EventManager.navigateFromReactNative
    // ('Second', {moduleName: 'Second', initialProperties: {'hello': 'world'}});
    EventManager.navigateFromReactNative(featureName, options);
  },

};

export default utils;
