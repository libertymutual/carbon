import * as ActionTypes from '../actions/ActionTypes';


/**
 * Counter related action creators
 */
export default {

  /**
   * Increments the counter
   * @returns {function} A function which dispatches an INCREMENT action
   */
  increment() {
    return function (dispatch) {
      dispatch({ type: ActionTypes.INCREMENT });
    };
  },

  /**
   * Decrements the counter
   * @returns {function} A function which dispatches a DECREMENT action
   */
  decrement() {
    return function (dispatch) {
      dispatch({ type: ActionTypes.DECREMENT });
    };
  },
};
