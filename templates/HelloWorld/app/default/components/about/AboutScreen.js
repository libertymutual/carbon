import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text } from 'react-native';
import { connect } from 'react-redux';

import * as PresentationConstants from '../../constants/PresentationConstants';

/**
 * About Screen
 * @extends {React.Component}
 */
export class AboutScreen extends React.Component {
  /**
   * Renders the components
   * @override
   * @returns {JSX}
   */
  render() {
    return (<ScrollView>
      <Text style={styles.aboutScreenHeader}>{PresentationConstants.ABOUT_WELCOME}</Text>
      <Text style={styles.aboutScreenText}>{PresentationConstants.ABOUT_INTRO}</Text>
      <Button
        onPress={this._navigateBack}
        title={PresentationConstants.GO_BACK}
      />
    </ScrollView>);
  }

  /**
   * Navigates back to the previous screen boop
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
};

/**
 * Maps State To Props
 * @returns {Object) Object representing the parts of state
 * that the component should subscribe to
 */
function mapStateToProps() {
  return {};
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
});
