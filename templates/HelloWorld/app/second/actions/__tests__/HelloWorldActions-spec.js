import 'react-native';
import React from 'react';
import thunk from 'redux-thunk';
import configureMockStore from 'redux-mock-store';
import HelloWorldActions from '../HelloWorldActions';

describe('HelloWorldActions tests', () => {

  const middlewares = [thunk];
  const mockStore = configureMockStore(middlewares);
  let store;
  let dispatch;

  beforeEach(() => {
    // Sets up a new store
    store = mockStore();
    dispatch = store.dispatch;
  });

  test('hello returns a function', () => {
    var dispatcher = HelloWorldActions.hello();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('hello function dispatches a HELLO action', () => {
    var dispatcher = HelloWorldActions.hello();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('goodbye returns a function', () => {
    var dispatcher = HelloWorldActions.goodbye();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('goodbye function dispatches a GOODBYE action', () => {
    var dispatcher = HelloWorldActions.goodbye();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });
});
