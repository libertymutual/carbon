import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text } from 'react-native';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as Constants from '../../constants/Constants';
import * as PresentationConstants from '../../constants/PresentationConstants';
import * as NavigationTargets from '../../constants/NavigationTargets';
import AuthActions from '../../actions/AuthActions';
import Utils from '../../util/Utils';
const { EventManager } = require('NativeModules');

/**
 * Home Screen
 * @extends {React.Component}
 */
class HomeScreen extends React.Component {
  /**
   * Renders the components
   * @override
   * @returns {JSX}
   */
  render() {
    const isLoggedIn = this.props.auth.isLoggedIn;
    const loginButtonMessage = isLoggedIn ? PresentationConstants.HOMESCREEN_BUTTON_LABEL_LOGOUT
      : PresentationConstants.HOMESCREEN_BUTTON_LABEL_LOGIN;

    return (<ScrollView>
      <Text style={styles.homeScreenHeader}>{PresentationConstants.HOMESCREEN_WELCOME}</Text>
      <Text style={styles.homeScreenText}>{PresentationConstants.HOMESCREEN_INTRO}</Text>
      {isLoggedIn ? <Button
        onPress={this._navigateToProfileScreen}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_PROFILE}
      /> : null}
      <Button
        onPress={this._navigateToContactScreen}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_CONTACT_US}
      />
      <Button
        onPress={this._navigateToSecondFeature}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_OTHER_FEATURE}
      />
      <Button
        onPress={this._navigateToWebFeature}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_WEB_FEATURE}
      />
      <Button
        onPress={this._navigateToLoginScreen}
        title={loginButtonMessage}
      />
      <Button
        onPress={this._navigateToAboutScreen}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_ABOUT}
      />
      <Button
        onPress={this._navigateToBiometricScreen}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_BIOMETRIC}
      />
      <Button
        onPress={this._getBuildType}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_BUILD_TYPE}
      />
    </ScrollView>);
  }

  /**
   * Navigates to the Profile Screen
   * @private
   */
  _navigateToProfileScreen = () => {
    this.props.navigation.navigate(NavigationTargets.PROFILE);
  }

  /**
   * Navigates to the Contact Screen
   * @private
   */
  _navigateToContactScreen = () => {
    this.props.navigation.navigate(NavigationTargets.CONTACT);
  }

  /**
   * Navigates to the About Screen
   * @private
   */
  _navigateToAboutScreen = () => {
    this.props.navigation.navigate(NavigationTargets.ABOUT);
  }

  /**
   * Navigates to the Biometric Screen
   * @private
   */
  _navigateToBiometricScreen = () => {
    this.props.navigation.navigate(NavigationTargets.BIOMETRIC);
  }

    /**
   * Navigates to the Login Screen
   * @private
   */
  _navigateToLoginScreen = () => {
    this.props.navigation.navigate(NavigationTargets.LOGIN);
  }

    /**
   * Navigates to the Login Screen
   * @private
   */
  _navigateToHomeScreen = () => {
    this.props.navigation.navigate(NavigationTargets.HOME);
  }


  /**
   * Gets the current build type
   * @private
   */
  _getBuildType = () => {
    EventManager.getBuildType().then(buildType => {
      alert("Build Type: " + buildType)
    })
  }

  /**
   * Navigates to the second feature
   * @private
   */
  _navigateToSecondFeature = () => {
    Utils.navigateToFeature(Constants.EXTERNAL_FEATURE_SECOND, {
      moduleName: Constants.EXTERNAL_FEATURE_MODULE_SECOND,
      initialProperties: { hello: 'world' },
    });
  }

  /**
   * Navigates to the web feature
   * @private
   */
  _navigateToWebFeature() {
    Utils.navigateToFeature(Constants.EXTERNAL_FEATURE_WEB, {
      url: "index.html",
    });
  }
}

/**
 * Navigation Options
 */
HomeScreen.navigationOptions = {
  title: PresentationConstants.PAGE_TITLE_HOME_SCREEN,
};

/**
 * Prop Types
 */
HomeScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
  auth: PropTypes.object.isRequired,
  authActions: PropTypes.object.isRequired,
};

/**
 * Maps State To Props
 * @param {Object} state Redux State Object
 * @returns {Object) Object representing the parts of state
 * that the component should subscribe to
 */
function mapStateToProps(state) {
  return {
    auth: state.auth,
  };
}

/**
 * Maps Dispatch Actions To Props
 * @param {function} Dispatch function
 * @returns {Object) Object representing the actions
 * that should be exposed to the component via props
 */
function mapDispatchToProps(dispatch) {
  return {
    authActions: bindActionCreators(AuthActions, dispatch),
  };
}

/**
 * Default export wrapped in a connect to expose state & actions via props
 */
export default connect(mapStateToProps, mapDispatchToProps)(HomeScreen);

/**
 * Component Styles
 */
const styles = StyleSheet.create({
  homeScreenHeader: {
    margin: 14,
    fontWeight: 'bold',
  },
  homeScreenText: {
    margin: 14,
  },
});
