import 'react-native';
import React from 'react';
import thunk from 'redux-thunk';
import configureMockStore from 'redux-mock-store';
import BiometricActions from '../BiometricActions';

describe('BiometricActions tests', () => {

  const middlewares = [thunk];
  const mockStore = configureMockStore(middlewares);
  let store;
  let dispatch;

  beforeEach(() => {
    // Sets up a new store
    store = mockStore();
    dispatch = store.dispatch;
  });

  test('updateUsername returns a function', () => {
    var dispatcher = BiometricActions.updateUsername();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updateUsername function dispatches an UPDATE_USERNAME action', () => {
    var dispatcher = BiometricActions.updateUsername();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updatePassword returns a function', () => {
    var dispatcher = BiometricActions.updatePassword();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updatePassword function dispatches an UPDATE_PASSWORD action', () => {
    var dispatcher = BiometricActions.updatePassword();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('saveCredentials returns a function', () => {
    var dispatcher = BiometricActions.saveCredentials();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('saveCredentials function dispatches an SAVE_CREDENTIALS action', () => {
    var dispatcher = BiometricActions.saveCredentials();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('deleteCredentials returns a function', () => {
    var dispatcher = BiometricActions.deleteCredentials();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('deleteCredentials function dispatches an DELETE_CREDENTIALS action', () => {
    var dispatcher = BiometricActions.deleteCredentials();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

});
