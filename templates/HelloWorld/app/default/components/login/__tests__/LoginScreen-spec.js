import 'react-native';
import React from 'react';
import ShallowRenderer from 'react-test-renderer/shallow';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import LoginScreen from '../LoginScreen';
import { initialState } from '../../../reducers/authReducer';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);

let store;

describe('Login Screen tests', () => {
  beforeEach(() => {
    // Sets up a new store
    store = mockStore({
      auth: initialState
    });
  });

  test('Login Screen renders correctly', () => {
    const renderer = new ShallowRenderer();
    const tree = renderer.render(
      <LoginScreen store={store} navigation={{}} />
    );
    expect(renderer.getRenderOutput()).toMatchSnapshot();
  });
});
