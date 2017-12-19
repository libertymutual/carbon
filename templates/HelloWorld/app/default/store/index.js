import { applyMiddleware, combineReducers, compose, createStore } from 'redux';
import { autoRehydrate } from 'redux-persist';
import thunk from 'redux-thunk';
import authReducer from '../reducers/authReducer';
import counterReducer from '../reducers/counterReducer';
import biometricReducer from '../reducers/biometricReducer';

/**
 * Sets up the reducers
 * @param {Object} initialState The initial state of the redux store
 * @returns {Object} Object representing the configured store
 */
export default function configureStore(initialState = {}) {
  // Map of reducers to be combined
  const reducers = {
    auth: authReducer,
    counter: counterReducer,
    biometric: biometricReducer,
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
