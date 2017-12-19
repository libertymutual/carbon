import 'react-native';
import React from 'react';
import thunk from 'redux-thunk';
import configureMockStore from 'redux-mock-store';
import CounterActions from '../CounterActions';

describe('CounterActions tests', () => {

  const middlewares = [thunk];
  const mockStore = configureMockStore(middlewares);
  let store;
  let dispatch;

  beforeEach(() => {
    // Sets up a new store
    store = mockStore();
    dispatch = store.dispatch;
  });

  test('increment returns a function', () => {
    var dispatcher = CounterActions.increment();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('increment function dispatches an INCREMENT action', () => {
    var dispatcher = CounterActions.increment();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });

  test('decrement returns a function', () => {
    var dispatcher = CounterActions.decrement();
    expect(typeof dispatcher).toMatchSnapshot();
  });

  test('decrement function dispatches a DECREMENT action', () => {
    var dispatcher = CounterActions.decrement();
    dispatch(dispatcher);
    expect(store.getActions()).toMatchSnapshot();
  });
});
