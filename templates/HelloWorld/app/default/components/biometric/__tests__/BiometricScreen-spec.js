
import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import BiometricScreen from '../BiometricScreen';
import { initialState } from '../../../reducers/biometricReducer';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);

let store;

describe('BiometricScreen tests', () => {
  beforeEach(() => {
    // Sets up a new store
    store = mockStore({
      biometric: initialState
    });
  });

  test('BiometricScreen Screen renders correctly', () => {
    const tree = renderer.create(
      <BiometricScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });
});
