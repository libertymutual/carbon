import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text } from 'react-native';
import { connect } from 'react-redux';

import * as PresentationConstants from '../../constants/PresentationConstants';

/**
 * Contact Screen
 * @extends {React.Component}
 */
class ContactScreen extends React.Component {

  /**
   * Home Screen Constructor
   * @constructor
   * @param {Object} ...args Arguments passed to the constructor
   */
  constructor(...args) {
    super(...args);

    this._navigateBack = this._navigateBack.bind(this);
  }

  /**
   * Renders the components
   * @override
   * @returns {JSX}
   */
  render() {
    return (<ScrollView>
      <Text style={styles.contactScreenHeader}>{PresentationConstants.CONTACT_WELCOME}</Text>
      <Button
        onPress={this._navigateBack}
        title={PresentationConstants.GO_BACK}
      />
    </ScrollView>);
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
ContactScreen.navigationOptions = {
  title: PresentationConstants.PAGE_TITLE_CONTACT_SCREEN,
};

/**
 * Prop Types
 */
ContactScreen.propTypes = {
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
export default connect(mapStateToProps, mapDispatchToProps)(ContactScreen);

/**
 * Component Styles
 */
const styles = StyleSheet.create({
  contactScreenHeader: {
    margin: 14,
    fontWeight: 'bold',
  },
});
