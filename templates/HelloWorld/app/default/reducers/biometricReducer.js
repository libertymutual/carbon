import * as ActionTypes from '../actions/ActionTypes';

/**
 * Initial Reducer State
 */
export const initialState = {
    username: "TestUsername",
    password: "TestPassword",
    credentialsSaved: false
};

/**
 * Reducer handling auth related state
 * @param {Object} state The current reducer state
 * @param {Object} action The action event that has been triggered
 * @returns {Object} The updated state
 */
export default function biometricReducer(state = initialState, action) {
  switch (action.type) {
    case ActionTypes.UPDATE_USERNAME:
      return { ...state, username: action.username };
    case ActionTypes.UPDATE_PASSWORD:
      return { ...state, password: action.password };  
    case ActionTypes.SAVE_CREDENTIALS:
      return { ...state, credentialsSaved: true };
    case ActionTypes.DELETE_CREDENTIALS:
      return { ...state, credentialsSaved: false };
    default:
      return state;
  }
}
