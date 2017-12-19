import * as ActionTypes from '../actions/ActionTypes';

/**
 * Initial Reducer State
 */
export const initialState = {
  isLoggedIn: false,
  username: "",
  password: "",
  authUrl: "",
  clientId: "",
  clientSecret: "",
  configName: "",
  validatorId: "",
}

/**
 * Reducer handling auth related state
 * @param {Object} state The current reducer state
 * @param {Object} action The action event that has been triggered
 * @returns {Object} The updated state
 */
export default function authReducer(state = initialState, action) {
  switch (action.type) {
    case ActionTypes.LOGIN:
      return { ...state, isLoggedIn: true };
    case ActionTypes.LOGOUT:
      return { ...state, isLoggedIn: false };
    case ActionTypes.AUTH_UPDATE_AUTH_URL:
      return { ...state, authUrl: action.authUrl };
    case ActionTypes.AUTH_UPDATE_CLIENT_ID:
      return { ...state, clientId: action.clientId };
    case ActionTypes.AUTH_UPDATE_CLIENT_SECRET:
      return { ...state, clientSecret: action.clientSecret };
    case ActionTypes.AUTH_UPDATE_CONFIG_NAME:
      return { ...state, configName: action.configName };
    case ActionTypes.AUTH_UPDATE_PASSWORD:
      return { ...state, password: action.password };
    case ActionTypes.AUTH_UPDATE_USERNAME:
      return { ...state, username: action.username };
    case ActionTypes.AUTH_UPDATE_VALIDATOR_ID:
      return { ...state, validatorId: action.validatorId };
    default:
      return state;
  }
}
