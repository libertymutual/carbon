import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text } from 'react-native';
import { connect } from 'react-redux';
import * as Constants from '../../constants/Constants';
import * as PresentationConstants from '../../constants/PresentationConstants';
import * as StylingConstants from '../../constants/StylingConstants';
import * as NavigationTargets from '../../constants/NavigationTargets';
import Utils from '../../util/Utils';

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
    return (<ScrollView style={styles.secondFeatureTheme}>
      <Text style={styles.homeScreenHeader}>{PresentationConstants.HOMESCREEN_WELCOME}</Text>
      <Text style={styles.homeScreenText}>{PresentationConstants.HOMESCREEN_INTRO}</Text>
      <Text
        style={styles.homeScreenText}
      >{PresentationConstants.HOMESCREEN_COUNTER_VALUE}{this.props.counter}</Text>
      <Button
        onPress={this._navigateToAboutScreen}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_ABOUT}
      />
      <Button
        onPress={this._navigateToDefaultFeature}
        title={PresentationConstants.HOMESCREEN_BUTTON_LABEL_BACK_TO_DEFAULT_FEATURE}
      />
    </ScrollView>);
  }

  /**
   * Navigates to the About Screen
   * @private
   */
  _navigateToAboutScreen = () => {
    this.props.navigation.navigate(NavigationTargets.ABOUT);
  }

  /**
   * Navigates to the default feature
   * @private
   */
  _navigateToDefaultFeature = () => {
    Utils.navigateToFeature(Constants.EXTERNAL_FEATURE_DEFAULT, {
      moduleName: Constants.EXTERNAL_FEATURE_MODULE_DEFAULT,
      initialProperties: { hello: 'world' },
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
  counter: PropTypes.number.isRequired,
  navigation: PropTypes.object.isRequired,
};

/**
 * Maps State To Props
 * @param {Object} state Redux State Object
 * @returns {Object) Object representing the parts of state
 * that the component should subscribe to
 */
function mapStateToProps(state) {
  return {
    counter: state.counter,
  };
}

/**
 * Maps Dispatch Actions To Props
 * @returns {Object) Object representing the actions
 * that should be exposed to the component via props
 */
function mapDispatchToProps() {
  return {};
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
  secondFeatureTheme: {
    backgroundColor: StylingConstants.COLOR_LIGHTBLUE,
  },
});
