import * as ActionTypes from '../actions/ActionTypes';
import { NativeModules } from 'react-native';

const { Auth } = NativeModules;

export type AuthActionsType = {
  login: () => ((Object) => void, () => Object) => {},
logout: () => () => { },
};


/**
 * Auth related action creators
 */
export default {

  /**
   * Logs the user in
   * @returns {function} A function which dispatches a LOGIN action
   */
  login() {
    return (dispatch: Object => void, getState: () => Object) => {
      const username = getState().username;
      const password = getState().password;
      Auth.login(username, password).then((isLoggedIn) => {
        if (isLoggedIn) {
          dispatch({ type: ActionTypes.LOGIN })
        }
      })
    }
  },

  /**
   * Logs the user out
   * @returns {function} A function which dispatches a LOGOUT action
   */
  logout() {
    return function (dispatch) {
      dispatch({ type: ActionTypes.LOGOUT });
    };
  },

  updateAuthUrl(authUrl) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.AUTH_UPDATE_AUTH_URL, authUrl })
    }
  },

  updateClientId(clientId) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.AUTH_UPDATE_CLIENT_ID, clientId })
    }
  },

  updateClientSecret(clientSecret) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.AUTH_UPDATE_CLIENT_SECRET, clientSecret })
    }
  },

  updateConfigName(configName) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.AUTH_UPDATE_CONFIG_NAME, configName })
    }
  },

  updatePassword(password) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.AUTH_UPDATE_PASSWORD, password })
    }
  },

  updateUsername(username) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.AUTH_UPDATE_USERNAME, username })
    }
  },

  updateValidatorId(validatorId) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.AUTH_UPDATE_VALIDATOR_ID, validatorId })
    }
  },
};
