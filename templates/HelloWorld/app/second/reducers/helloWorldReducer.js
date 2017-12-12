import * as ActionTypes from '../actions/ActionTypes';
import * as Constants from '../constants/Constants';

/**
 * Initial Reducer State
 */
export const initialState = {
  state: Constants.HELLO,
};

/**
 * Reducer handling hello world related state
 * @param {Object} state The current reducer state
 * @param {Object} action The action event that has been triggered
 * @returns {Object} The updated state
 */
export default function helloWorldReducer(state = initialState, action) {
  switch (action.type) {
    case ActionTypes.HELLO:
      return { ...state, state: Constants.HELLO };
    case ActionTypes.GOODBYE:
      return { ...state, state: Constants.GOODBYE };
    default:
      return state;
  }
}
