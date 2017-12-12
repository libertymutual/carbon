import React from 'react';
import PropTypes from 'prop-types';
import { Button, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import AuthActions from '../../actions/AuthActions';
import configs from './authConfigs.json';
const { Auth } = require('NativeModules');

const fieldNames = {
  username: "username",
  password: "password",
  authUrl: "auth url",
  clientId: "client Id",
  clientSecret: "client secret",
  validatorId: "validator Id"
};

/**
* Login Screen
* @extends {React.Component}
*/
export class LoginScreen extends React.Component {
  constructor() {
    super()
    this.state = {
      textOutput: "Auth output:",
    }
   this._updateTextOutput()
  }
  render() {
    return (
      <ScrollView>
        <View style={styles.input}>
          <Text style={styles.fieldLabel}>
            {fieldNames.username}
          </Text>
          <TextInput
            style={styles.textInput}
            placeholder={fieldNames.username}
            value={this.props.auth.username}
            onChangeText={(text) => this.props.authActions.updateUsername(text)}
          />
          <Text style={styles.fieldLabel}>
            {fieldNames.password}
          </Text>
          <TextInput
            style={styles.textInput}
            placeholder={fieldNames.password}
            value={this.props.auth.password}
            onChangeText={(text) => this.props.authActions.updatePassword(text)}
          />
          <Text style={styles.fieldLabel}>
            {fieldNames.authUrl}
          </Text>
          <TextInput
            style={styles.textInput}
            placeholder={fieldNames.authUrl}
            value={this.props.auth.authUrl}
          />
          <Text style={styles.fieldLabel}>
            {fieldNames.clientId}
          </Text>
          <TextInput
            style={styles.textInput}
            placeholder={fieldNames.clientId}
            value={this.props.auth.clientId}
          />
          <Text style={styles.fieldLabel}>
            {fieldNames.clientSecret}
          </Text>
          <TextInput
            style={styles.textInput}
            placeholder={fieldNames.clientSecret}
            value={this.props.auth.clientSecret}
          />
          <Text style={styles.fieldLabel}>
            {fieldNames.validatorId}
          </Text>
          <TextInput
            style={styles.textInput}
            placeholder={fieldNames.validatorId}
            value={this.props.auth.validatorId}
          />

        </View>
        <Button
          onPress={this._useDefaultCredentials}
          title={"Load React Native credentials"}
        />
        <Button
          onPress={this._configureAuth}
          title={"Modify native credentials"}
        />
        <Button
          onPress={this._testOauth2}
          title={"Login (test oauth2)"}
        />
        <Button
          onPress={this._configureFromNativeApp}
          title={"Configure from native authConfigs"}
        />
        <Button
          onPress={this._logout}
          title={"Logout"}
        />
        <View style={styles.textOutput}>
          <Text>
            {this.state.textOutput}
          </Text>
        </View>
      </ScrollView>);
  }

  /**
   * Pull the default credentials from the authConfigs.json file.
   */
  _useDefaultCredentials = () => {
    let defaultConfig = configs[0]

    this.props.authActions.updateAuthUrl(defaultConfig.authUrl)
    this.props.authActions.updateConfigName(defaultConfig.name)
    this.props.authActions.updatePassword(defaultConfig.password)
    this.props.authActions.updateClientId(defaultConfig.clientId)
    this.props.authActions.updateClientSecret(defaultConfig.clientSecret)
    this.props.authActions.updateUsername(defaultConfig.username)
    this.props.authActions.updateValidatorId(defaultConfig.validatorId)
  }

  /**
   * Configure the auth module using the entered credentials
   * This overrides the natively loaded credentials
   */
  _configureAuth = () => {
    Auth.configure(
      this.props.auth.configName,
      this.props.auth.authUrl,
      this.props.auth.clientId,
      this.props.auth.clientSecret,
      this.props.auth.validatorId
    );
  }

  /**
   * Login using the username & password entered & retrieve access token.
   */
  _testOauth2 = () => {
    Auth.login(
      this.props.auth.username,
      this.props.auth.password,
    ).then(() => {
      this._updateTextOutput();
    });
  }

  /**
  * Logout the user, this should delete all Token info in the auth module
  */
  _logout = () => {
    Auth.logout().then(() => {
      this._updateTextOutput();
    });
  }

  /**
   * Create an auth configuration from the native app's 'authConfigs.json' file. This file should contain
   * a config with the name that matches the key that is passed in.
   */
  _configureFromNativeApp = () => {
    Auth.configureWithEnvironmentKey("default").then(() => {
      this._updateTextOutput("Auth configured from native app")
    }).catch((error) => {
      let message = "Error configuring from auth file\n" + error.message
      this.setState({ textOutput: message })
    });
  }
  /**
   * Checks the output of the available calls to the Auth module.
   * If the user is logged in, token information & user name & email should be displayed
   * If the user is logged out, then no information should be found.
   */
  _updateTextOutput = (headingText: String = "Auth Module Output:") => {
    Auth.isAuthenticated().then((isAuthenticated) => {
      var output = headingText + "\nIs Authenticated:" + isAuthenticated
      this.setState({ textOutput: output })
      Auth.getAccessToken().then((tokenString) => {
        if (tokenString !== null) {
          output = output + "\nToken Obtained"
        } else {
          output = output + "\nNo Token"
        }
        Auth.getEmail().then((email) => {
          output = output + "\nEmail: " + email
          Auth.getUsername().then((username) => {
            output = output + "\nUsername: " + username
            Auth.getExpiresIn().then((expiresIn) => {
              output = output + "\nExpiresIn: " + expiresIn
              this.setState({ textOutput: output })
            });
          });
        });
      }).catch(error => {
        output = output + "\n" + error.message
        this.setState({ textOutput: output })
      });
    });
  }
}

/**
* Navigation Options
*/
LoginScreen.navigationOptions = {
  title: "Login",
};

/**
* Prop Types
*/
LoginScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

/**
* Maps State To Props
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
export default connect(mapStateToProps, mapDispatchToProps)(LoginScreen);

/**
* Component Styles
*/
const whiteColor = 'white'
const grayColor = 'gray'
const styles = StyleSheet.create({
  input: {
    margin: 20,
  },
  fieldLabel: {
    fontSize: 14,
    marginLeft: 2
  },
  textInput: {
    flex: 3,
    height: 40,
    backgroundColor: whiteColor,
    borderColor: grayColor,
    borderWidth: 1,
    margin: 2,
    marginBottom: 6,
    paddingLeft: 10,
  },
  textOutput: {
    margin: 4,
    padding: 4,
    borderWidth: 1,
  }
});
