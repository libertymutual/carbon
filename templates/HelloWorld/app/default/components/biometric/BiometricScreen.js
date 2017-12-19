import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import * as PresentationConstants from '../../constants/PresentationConstants';
import BiometricActions from '../../actions/BiometricActions';
const { Biometric } = require('NativeModules');

/**
 * Biometric Screen
 * @extends {React.Component}
 */
export class BiometricScreen extends React.Component {
  /**
   * Renders the components
   * @override
   * @returns {JSX}
   */
  render() {
    return (<ScrollView>
      <Text style={styles.biometricScreenHeader}>{PresentationConstants.BIOMETRIC_WELCOME}</Text>
      <Text style={styles.biometricScreenText}>{PresentationConstants.BIOMETRIC_INTRO}</Text>
      <View style={styles.biometricScreenInput}>
        <Text style={styles.biometricTextInputLabel}>{PresentationConstants.BIOMETRIC_USERNAME}</Text>
        <TextInput
          style={styles.biometricScreenTextInput}
          onChangeText={this._usernameChanged}
          value={this.props.biometric.username}
        />
      </View>
      <View style={styles.biometricScreenInput}>
        <Text style={styles.biometricTextInputLabel}>{PresentationConstants.BIOMETRIC_PASSWORD}</Text>
        <TextInput
          style={styles.biometricScreenTextInput}
          onChangeText={this._passwordChanged}
          value={this.props.biometric.password}
        />
      </View>
      <Button
        onPress={this._saveCredentials}
        title={PresentationConstants.BIOMETRIC_BUTTON_LABEL_SAVE_CREDENTIALS}
      />
      <Button
        onPress={this._getCredentials}
        title={PresentationConstants.BIOMETRIC_BUTTON_LABEL_GET_CREDENTIALS}
      />
      <Button
        onPress={this._hasCredentials}
        title={PresentationConstants.BIOMETRIC_BUTTON_LABEL_HAS_CREDENTIALS}
      />
      <Button
        onPress={this._deleteCredentials}
        title={PresentationConstants.BIOMETRIC_BUTTON_LABEL_DELETE_CREDENTIALS}
      />
      <Button
        onPress={this._checkSupported}
        title={PresentationConstants.BIOMETRIC_BUTTON_LABEL_CHECK_SUPPORTED}
      />
      <Button
        onPress={this._getBiometricType}
        title={PresentationConstants.BIOMETRIC_BUTTON_LABEL_GET_BIOMETRIC_TYPE}
      />
      <Button
        onPress={this._navigateBack}
        title={PresentationConstants.GO_BACK}
      />
    </ScrollView>);
  }

  /**
   * Handles username field change
   * @private
   */
  _usernameChanged = (username) => {
    this.props.biometricActions.updateUsername(username)
  }

  /**
   * Handles password field change
   * @private
   */
  _passwordChanged = (password) => {
    this.props.biometricActions.updatePassword(password)
  }

  /**
   * Saves Credentials using Biometric Authentication
   * @private
   */
  _saveCredentials = () => {
    Biometric.saveCredentials(this.props.biometric.username, this.props.biometric.password)
      .then(() => {
        this.props.biometricActions.saveCredentials()
        alert("Credentials were successfully saved");
      })
      .catch((error) => alert(error.message))
  }

  /**
   * Gets Credentials Using Biometric Authentication
   * @private
   */
  _getCredentials = () => {
    const hasCredentials = this.props.biometric.credentialsSaved
    if (hasCredentials) {
      Biometric.getCredentials()
        .then((response) => {
          alert("Username: " + response.username + "\nPassword: " + response.password);
        })
        .catch((error) => alert(error.message))
    }
    else {
      alert("No Credentials Exist")
    }
  }

  /**
   * Checks if credentials have been stored using Biometric Authentication
   * @private
   */
  _hasCredentials = () => {
    Biometric.hasCredentials()
      .then((response) => {
        if (response) {
          alert("Credentials ARE stored on this device");
        }
        else {
          alert("Credentials are NOT stored on this device");
        }
      })
  }

  /**
   * Checks the type of Biometric Authentication available (fingerprint / face)
   * @private
   */
  _getBiometricType = () => {
    Biometric.getBiometricType()
      .then((response) => {
        alert("Biometric Authentication Type Is: " + response);
      })
  }

  /**
   * Deletes credentials using Biometric Authentication
   * @private
   */
  _deleteCredentials = () => {
    Biometric.deleteCredentials()
      .then(() => {
        this.props.biometricActions.deleteCredentials()
        alert("Credentials were successfully deleted");
      })
      .catch((error) => alert(error.message))
  }

  /**
   * Checks if the device supports Biometric Authentication
   * @private
   */
  _checkSupported = () => {
    Biometric.isSupported()
      .then((response) => {
        if (response) {
          alert("Your device DOES support Biometric authentication");
        }
        else {
          alert("Your device DOES NOT support Biometric authentication");
        }
      })
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
BiometricScreen.navigationOptions = {
  title: PresentationConstants.PAGE_TITLE_BIOMETRIC_SCREEN,
};

/**
 * Prop Types
 */
BiometricScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

/**
 * Maps State To Props
 * @returns {Object) Object representing the parts of state
 * that the component should subscribe to
 */
function mapStateToProps(state) {
  return {
    biometric: state.biometric,
  };
}

/**
 * Maps Dispatch Actions To Props
 * @returns {Object) Object representing the actions
  * that should be exposed to the component via props
 */
function mapDispatchToProps(dispatch) {
  return {
    biometricActions: bindActionCreators(BiometricActions, dispatch),
  };
}

/**
 * Default export wrapped in a connect to expose state & actions via props
 */
export default connect(mapStateToProps, mapDispatchToProps)(BiometricScreen);

/**
 * Component Styles
 */
const whiteColor = 'white'
const grayColor = 'gray'
const styles = StyleSheet.create({
  biometricScreenHeader: {
    margin: 14,
    fontWeight: 'bold',
  },
  biometricScreenText: {
    margin: 14,
  },
  biometricScreenInput: {
    flex: 1,
    alignItems: 'center',
    flexDirection: 'row',
    margin: 14,
  },
  biometricTextInputLabel: {
    flex: 1,
    fontWeight: 'bold',
  },
  biometricScreenTextInput: {
    flex: 3,
    height: 40,
    backgroundColor: whiteColor,
    borderColor: grayColor,
    borderWidth: 1,
  },
});
