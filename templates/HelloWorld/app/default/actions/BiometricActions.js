  import * as ActionTypes from '../actions/ActionTypes';

/**
 * Counter related action creators
 */
export default {

  /**
   * Updates the username value
   * @returns {function} A function which dispatches an UPDATE_USERNAME action
   */
  updateUsername(username) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.UPDATE_USERNAME, username });
    };
  },

  /**
   * Updates the password value
   * @returns {function} A function which dispatches an UPDATE_PASSWORD action
   */
  updatePassword(password) {
    return function (dispatch) {
      dispatch({ type: ActionTypes.UPDATE_PASSWORD, password });
    };
  },

  /**
   * Updates state to reflect that credentials have been saved
   * @returns {function} A function which dispatches a SAVE_CREDENTIALS action
   */
  saveCredentials() {
    return function (dispatch) {
      dispatch({ type: ActionTypes.SAVE_CREDENTIALS });
    };
  },

  /**
   * Updates state to reflect that credentials have been saved
   * @returns {function} A function which dispatches a DELETE_CREDENTIALS action
   */
  deleteCredentials() {
    return function (dispatch) {
      dispatch({ type: ActionTypes.DELETE_CREDENTIALS });
    };
  },
};
