import 'react-native';
import React from 'react';
import thunk from 'redux-thunk';
import configureMockStore from 'redux-mock-store';
import AuthActions from '../AuthActions';

describe('AuthActions tests', () => {

  const middlewares = [thunk];
  const mockStore = configureMockStore(middlewares);
  let store;
  let dispatch;

  beforeEach(() => {
    // Sets up a new store
    store = mockStore();
    dispatch = store.dispatch;
  });

  test('login returns a function', () => {
    var dispatcher = AuthActions.login();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('login resturs a LOGIN action', () => {
    var dispatcher = AuthActions.login()
    expect(store.getActions()).toMatchSnapshot();
  });

  test('logout returns a function', () => {
    var dispatcher = AuthActions.logout();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('logout function dispatches a LOGOUT action', () => {
    var dispatcher = AuthActions.logout();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updateAuthUrl returns a function', () => {
    var dispatcher = AuthActions.updateAuthUrl();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updateAuthUrl dispatches a AUTH_UPDATE_AUTH_URL action', () => {
    var dispatcher = AuthActions.updateAuthUrl();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updateClientId returns a function', () => {
    var dispatcher = AuthActions.updateClientId();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updateClientId function dispatches a AUTH_UPDATE_CLIENT_ID action', () => {
    var dispatcher = AuthActions.updateClientId();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updateClientSecret returns a function', () => {
    var dispatcher = AuthActions.updateClientSecret();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updateClientSecret function dispatches a AUTH_UPDATE_CLIENT_SECRET action', () => {
    var dispatcher = AuthActions.updateClientId();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updateConfigName returns a function', () => {
    var dispatcher = AuthActions.updateConfigName();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updateConfigName function dispatches a AUTH_UPDATE_CONFIG_NAME action', () => {
    var dispatcher = AuthActions.updateClientId();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updatePassword returns a function', () => {
    var dispatcher = AuthActions.updatePassword();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updatePassword function dispatches a AUTH_UPDATE_PASSWORD action', () => {
    var dispatcher = AuthActions.updatePassword();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updateUsername returns a function', () => {
    var dispatcher = AuthActions.updateUsername();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updateUsername function dispatches a AUTH_UPDATE_USERNAME action', () => {
    var dispatcher = AuthActions.updateUsername();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('updateValidatorId returns a function', () => {
    var dispatcher = AuthActions.updateValidatorId();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('updateValidatorId function dispatches a AUTH_UPDATE_VALIDATOR_ID action', () => {
    var dispatcher = AuthActions.updateValidatorId();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });
});
