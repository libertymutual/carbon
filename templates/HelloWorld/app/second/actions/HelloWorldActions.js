import * as ActionTypes from '../actions/ActionTypes';

/**
 * Hello World related action creators
 */
export default {

  /**
   * Says hello world
   * @returns {function} A function which dispatches a HELLO action
   */
  hello() {
    return function (dispatch) {
      dispatch({ type: ActionTypes.HELLO });
    };
  },

  /**
   * Says goodbye world
   * @returns {function} A function which dispatches a GOODBYE action
   */
  goodbye() {
    return function (dispatch) {
      dispatch({ type: ActionTypes.GOODBYE });
    };
  },
};
