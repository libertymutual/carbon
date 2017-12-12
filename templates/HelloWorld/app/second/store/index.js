import { applyMiddleware, combineReducers, compose, createStore } from 'redux';
import { autoRehydrate } from 'redux-persist';
import thunk from 'redux-thunk';
import helloWorldReducer from '../reducers/helloWorldReducer';
import counterReducer from '../reducers/counterReducer';

/**
 * Sets up the reducers
 * @param {Object} initialState The initial state of the redux store
 * @returns {Object} Object representing the configured store
 */
export default function configureStore(initialState = {}) {
  // Map of reducers to be combined
  const reducers = {
    counter: counterReducer,
    helloWorld: helloWorldReducer,
  };

  // Configure the store
  const store = {
    ...createStore(
      combineReducers(reducers),
      initialState,
      compose(
        autoRehydrate(),
        applyMiddleware(thunk),
      ),
    ),
  };

  return store;
}
