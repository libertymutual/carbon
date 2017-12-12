import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import HomeScreen from '../HomeScreen';
import { initialState } from '../../../reducers/authReducer';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);
let store;

describe('HomeScreen tests', () => {
  beforeEach(() => {
    // Sets up a new store
    store = mockStore({
      auth: initialState
    });
  });

  test('Home Screen renders correctly', () => {
    const tree = renderer.create(
      <HomeScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });

  test('Home Screen renders correctly for logged out scenario', () => {

    // Override the default initialState so isLoggedIn is true
    store = mockStore({
      auth: { isLoggedIn: true }
    });

    const tree = renderer.create(
      <HomeScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });
});
