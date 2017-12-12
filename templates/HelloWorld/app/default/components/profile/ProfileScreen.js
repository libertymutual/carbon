import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text } from 'react-native';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import CounterActions from '../../actions/CounterActions';

import * as PresentationConstants from '../../constants/PresentationConstants';

/**
 * Profile Screen
 * @extends {React.Component}
 */
class ProfileScreen extends React.Component {
  /**
   * Renders the components
   * @override
   * @returns {JSX}
   */
  render() {
    return (<ScrollView>
      <Text style={styles.profileScreenHeader}>{PresentationConstants.PROFILE_WELCOME}</Text>
      <Text style={styles.profileScreenText}>{PresentationConstants.PROFILE_INTRO}</Text>
      <Text
        style={styles.profileScreenText}
      >{PresentationConstants.PROFILE_COUNTER_VALUE}{this.props.counter}</Text>
      <Button
        onPress={this.props.counterActions.increment}
        title={PresentationConstants.PROFILE_INCREMENT_COUNTER}
      />
      <Button
        onPress={this.props.counterActions.decrement}
        title={PresentationConstants.PROFILE_DECREMENT_COUNTER}
      />
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
ProfileScreen.navigationOptions = {
  title: PresentationConstants.PAGE_TITLE_PROFILE_SCREEN,
};

/**
 * Prop Types
 */
ProfileScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
  counter: PropTypes.number.isRequired,
  counterActions: PropTypes.object.isRequired,
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
 * @param {function} Dispatch function
 * @returns {Object) Object representing the actions
 * that should be exposed to the component via props
 */
function mapDispatchToProps(dispatch) {
  return {
    counterActions: bindActionCreators(CounterActions, dispatch),
  };
}

/**
 * Default export wrapped in a connect to expose state & actions via props
 */
export default connect(mapStateToProps, mapDispatchToProps)(ProfileScreen);

/**
 * Component Styles
 */
const styles = StyleSheet.create({
  profileScreenHeader: {
    margin: 14,
    fontWeight: 'bold',
  },
  profileScreenText: {
    margin: 14,
  },
});
