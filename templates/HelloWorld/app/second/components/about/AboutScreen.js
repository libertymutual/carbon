import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text } from 'react-native';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import * as Constants from '../../constants/Constants';
import * as PresentationConstants from '../../constants/PresentationConstants';
import * as StylingConstants from '../../constants/StylingConstants';
import HelloWorldActions from '../../actions/HelloWorldActions';

/**
 * About Screen
 * @extends {React.Component}
 */
class AboutScreen extends React.Component {

  /**
   * Renders the components
   * @override
   * @returns {JSX}
   */
  render() {
    let welcomeMessage;

    if (this.props.helloWorld.state === Constants.HELLO) {
      welcomeMessage = PresentationConstants.ABOUT_HELLO_WORLD;
    } else {
      welcomeMessage = PresentationConstants.ABOUT_GOODBYE_WORLD;
    }

    return (<ScrollView style={styles.secondFeatureTheme}>
      <Text style={styles.aboutScreenHeader}>{PresentationConstants.ABOUT_WELCOME}</Text>
      <Text style={styles.aboutScreenText}>{welcomeMessage}</Text>
      <Button
        onPress={this._toggleWelcomeMessage}
        title={PresentationConstants.ABOUT_BUTTON_LABEL_TOGGLE}
      />
      <Button
        onPress={this._navigateBack}
        title={PresentationConstants.GO_BACK}
      />
    </ScrollView>);
  }

  /**
   * Toggles the welcome message
   * @private
   */
  _toggleWelcomeMessage = () =>  {
    if (this.props.helloWorld.state === Constants.HELLO) {
      this.props.helloWorldActions.goodbye();
    } else {
      this.props.helloWorldActions.hello();
    }
  }

  /**
   * Navigates back to the previous screen
   * @private
   */
  _navigateBack = () => {
    this.props.navigation.goBack();
  }
}

/**
 * Navigation Options
 */
AboutScreen.navigationOptions = {
  title: PresentationConstants.PAGE_TITLE_ABOUT_SCREEN,
};

/**
 * Prop Types
 */
AboutScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
  helloWorld: PropTypes.object.isRequired,
  helloWorldActions: PropTypes.object.isRequired,
};

/**
 * Maps State To Props
 * @param {Object} state Redux State Object
 * @returns {Object) Object representing the parts of state
 * that the component should subscribe to
 */
function mapStateToProps(state) {
  return {
    helloWorld: state.helloWorld,
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
    helloWorldActions: bindActionCreators(HelloWorldActions, dispatch),
  };
}

/**
 * Default export wrapped in a connect to expose state & actions via props
 */
export default connect(mapStateToProps, mapDispatchToProps)(AboutScreen);

/**
 * Component Styles
 */
const styles = StyleSheet.create({
  aboutScreenHeader: {
    margin: 14,
    fontWeight: 'bold',
  },
  aboutScreenText: {
    margin: 14,
  },
  secondFeatureTheme: {
    backgroundColor: StylingConstants.COLOR_LIGHTBLUE,
  },
});
