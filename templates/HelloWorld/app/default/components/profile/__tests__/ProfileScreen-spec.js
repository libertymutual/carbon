
import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import ProfileScreen from '../ProfileScreen';
import { initialState } from '../../../reducers/counterReducer';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);

let store;

describe('ProfileScreen tests', () => {
  beforeEach(() => {
    // Sets up a new store
    store = mockStore({
      counter: initialState
    });
  });

  test('Profile Screen renders correctly', () => {
    const tree = renderer.create(
      <ProfileScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });

});
