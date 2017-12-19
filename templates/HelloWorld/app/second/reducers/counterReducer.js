import * as ActionTypes from '../actions/ActionTypes';

/**
 * Initial Reducer State
 */
export const initialState = 0;

/**
 * Reducer handling counter related state
 * @param {Object} state The current reducer state
 * @param {Object} action The action event that has been triggered
 * @returns {Object} The updated state
 */
export default function countReducer(state = initialState, action) {
  switch (action.type) {
    case ActionTypes.INCREMENT:
      return state + 1;
    case ActionTypes.DECREMENT:
      return state - 1;
    default:
      return state;

  }
}
